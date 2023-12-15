# Uradili Kerim Halilović 19215, Edna Bašić 19187

function general_simplex(goal, c, A, b, csigns, vsigns)
    if any(map(isnothing, [goal, A, b, c, csigns, vsigns]))
        return NaN, 0, 0, 0, 0, 5
    end
    #broj redova
    m = size(b, 1)

    #broj kolona
    n = size(c, 1)

    status = 0;

    promjenjive = 0
    #indeksi u matrici A koji se dodaju
    jednakoPromjenjive = Vector{Int32}()
    promjenjiveManjeJednako = Vector{Int32}()

    #provjera ispravnosti dimenzija 
    if (m != size(A, 1) || n != size(A, 2))
        return NaN, 0, 0, 0, 0, 5
    end

    #provjera da li ima negativnih slobodnih koeficijenata
    for i in 1:m
        if b[i] < 0
            println("Problem ima neograniceno rjesenje (u beskonacnosti)")
            return Inf, 0, 0, 0, 0, 3
        end
    end


    i = 1
    while i != n + 1
        if vsigns[i] == 0
            push!(jednakoPromjenjive, n + 1 + length(jednakoPromjenjive))
            c = vcat(c, -1)
            novaKolona = Float64[]
            for j in 1:m
                push!(novaKolona, A[j, i] * -1)
            end
            A = hcat(A, novaKolona)
        elseif vsigns[i] == -1
            j = 1
            for j in 1:m
                A[j, i] *= -1
                push!(promjenjiveManjeJednako, i)
            end
        end
        i += 1
    end

    simplex = hcat(b, A)

    #d je baza
    d = Vector{Int32}()

    #vektor svih vjestackih promjenjivih
    vjestackePromjenjive = Vector{Int32}()
    #vektor svih vjestackih promjenjivih
    dopunskePromjenjive = Vector{Int32}()

    i = 1
    ogranicenja = size(csigns, 1)
    brDopunskih = 0
    brVjestackih = 0
    trebaVratiti = 0
    for i in 1:ogranicenja
        if csigns[i] == 1
            promjenjive += 2
            brVjestackih += 1
            brDopunskih += 1
        elseif csigns[i] == 0
            promjenjive += 1
            brVjestackih += 1
            trebaVratiti += 1
        else
            promjenjive += 1
            brDopunskih += 1
        end
    end

    i = 1
    for i in 1:brVjestackih
        push!(vjestackePromjenjive, n + brDopunskih + i)
    end
    i = 1
    for i in 1:brDopunskih
        push!(dopunskePromjenjive, n + i)
    end

    i = 1
    vj = 1
    dop = 1
    for i in 1:ogranicenja
        if csigns[i] == 1
            push!(d, vjestackePromjenjive[vj])
            vj += 1
            dop += 1
        elseif csigns[i] == 0
            push!(d, vjestackePromjenjive[vj])
            vj += 1
        else
            push!(d, dopunskePromjenjive[dop])
            dop += 1
        end
    end

    # kreiranje matrice sa desne strane matrice A
    jedinicna = zeros(m, promjenjive)
    i = 1

    dop = 1
    j = 1
    for i in 1:m
        if csigns[i] == 0
            jedinicna[i, brDopunskih+j] = 1
            j += 1
        elseif csigns[i] == 1
            jedinicna[i, brDopunskih+j] = 1
            jedinicna[i, dop] = -1
            dop += 1
            j += 1
        elseif csigns[i] == -1
            jedinicna[i, dop] = 1
            dop += 1
        end
    end

    simplex = hcat(simplex, jedinicna)

    #formiranje predzadnjeg reda u matrici
    M = Vector{Float64}()
    for j in 1:n+1
        i = 1
        suma = 0
        for i in 1:m
            if csigns[i] == 1 || csigns[i] == 0
                suma += simplex[i, j]
            end
        end
        push!(M, suma)
    end

    #pravimo ostatak predzadnjeg reda gdje je element -1 ako odgovara novoj promjenjivoj koja učestvuje u bilo kojem ograničenju znaka <=
    j = n + 2
    while j != promjenjive + n + 2 + size(jednakoPromjenjive, 1)
        i = 1
        ima = 0
        for i in 1:m
            if simplex[i, j] == -1
                ima = 1
            end
        end
        push!(M, ima == 1 ? -1 : 0)
        j += 1
    end

    M = hcat(M)
    M = transpose(M)
    simplex = vcat(simplex, M)

    #ubacivanje bazu u matricu
    push!(d, 0)
    simplex = hcat(d, simplex)

    #formiranje posljednjeg reda matrice
    i = 1
    for i in 1:promjenjive
        push!(c, 0)
    end

    #pretvaranje c-a iz vektora u red za matricu
    c = hcat(c)
    c = transpose(c)
    zadnjiRed = Vector{Float64}()
    push!(zadnjiRed, 0)
    push!(zadnjiRed, 0)

    #zadnjiRed pretvaramo iz vektora u red za matricu
    zadnjiRed = hcat(zadnjiRed)
    zadnjiRed = transpose(zadnjiRed)
    zadnjiRed = hcat(zadnjiRed, c)
    if (goal == "min")
        zadnjiRed = zadnjiRed .* (-1)
    end
    simplex = vcat(simplex, zadnjiRed)
    mnoziM = true

    #beskonacna petlja koja ima uslove svog prekida, unutar nje se izvrsava cijeli algoritam
    while (1 == 1)
        #maksimalni koef c
        maxk = 0
        maxl = 0
        kolona = 3

        #trazenje najveceg ci
        i = 3
        while (i != n + promjenjive + 3)
            if (simplex[m+1, i] > maxk)
                maxk = simplex[m+1, i]
                maxl = simplex[m+2, i]
                kolona = i
            elseif (simplex[m+1, i] == maxk)
                if (simplex[m+2, i] > maxl)
                    maxk = simplex[m+1, i]
                    maxl = simplex[m+2, i]
                    kolona = i
                end
            end
            i = i + 1
        end
        i = 1
        if (size(vjestackePromjenjive, 1) != 0)
            while (i != m + 1)
                j = 1
                while (j != size(vjestackePromjenjive, 1))
                    if (simplex[i, 1] == vjestackePromjenjive[j])
                        if (maxk == 0)
                            mnoziM = false
                            k = 3
                            while (k != n + promjenjive + 3)
                                if (simplex[m+2, i] > maxk)
                                    maxk = simplex[m+2, k]
                                    kolona = k
                                end
                                k = k + 1
                            end
                        end
                    end
                    j = j + 1
                end
                i = i + 1
            end
        end
        # ako je maximalni ci 0 algoritam terminira
        if (maxk == 0 && maxl == 0) # nema nijedan pozitivan
            # ako je neka vjestacka promjenjiva u bazi, problem nema rjesenje
            # nije nadjeno ako je neka vjestacka u bazi
            i = 1
            while (i != m + 1)
                j = 1
                while (j != size(vjestackePromjenjive, 1) + 1)
                    if (simplex[i, 1] == vjestackePromjenjive[j])
                        println("Problem nema rjesenja.")
                        return NaN, 0, 0, 0, 0, 4
                    end
                    j = j + 1
                end
                i = i + 1
            end

            #degenerirano rjesenje ako je neka bazna promjenjiva 0
            i = 1
            while (i != m + 1)
                if (simplex[i, 2] == 0)
                    println("Rjesenje je degenerirano")
                    status = 1
                end
                i = i + 1
            end

            #nije jedinstveno ako za neku od nebaznih promjenjivih imamo koeficijent cq jednako 0
            jedinstveno = true
            j = 3
            while (j != size(simplex, 2) + 1)
                bazna = false
                vjestacka = false
                i = 1
                while (i != m + 1)
                    if (simplex[i, 1] == j - 2)
                        bazna = true
                        break
                    end
                    i = i + 1
                end
                if (bazna == false && simplex[m+2, j] == 0)
                    k = 1
                    while (k != size(vjestackePromjenjive, 1) + 1)
                        if (vjestackePromjenjive[k] == j - 2)
                            vjestacka = true
                            break
                        end
                        k = k + 1
                    end
                    if (vjestacka == false)
                        jedinstveno = false
                        println("Rjesenje nije jedinstveno")
                        status = 2
                        break
                    end
                end
                j = j + 1
            end
            if (jedinstveno == true)
                println("Rjesenje je jedinstveno")
            end

            if (size(promjenjiveManjeJednako, 1) > 0)
                i = 1
                while (i != size(promjenjiveManjeJednako, 1) + 1)
                    j = 1
                    while (j != m + 1)
                        if (simplex[j, 1] == promjenjiveManjeJednako[j])
                            simplex[j, 2] = (-1) * simplex[j, 2]
                            break
                        end
                        j = j + 1
                    end
                    i = i + 1
                end
            end
            ispisani = Vector{Int32}()
            xPairs = Pair{Int32,Float64}[]
            baza = Pair{String,Int32}[]
            i = 1
            while (i != m + 1)
                baza = push!(baza, Pair("x", Int(simplex[i, 1])))
                i = i + 1
            end
            println("Rjesenja:")
            i = 1
            while (i != m + 1)
                println("x$(Int(simplex[i, 1])) = $(simplex[i, 2])")
                push!(ispisani, simplex[i, 1])
                xPairs = push!(xPairs, Pair(simplex[i, 1], simplex[i, 2]))
                i += 1
            end
            i = 1
            while (i != brDopunskih + n + trebaVratiti + 1)
                if !(i in ispisani)
                    println("x$(Int(i)) = 0")
                    push!(ispisani, i)
                    xPairs = push!(xPairs, Pair(i, 0))
                end
                i += 1
            end
            rjesenje = simplex[m+2, 2]
            if (goal == "max")
                rjesenje = rjesenje * (-1)
            end
            println("Vrijednost funkcije cilja iznosi: ", rjesenje)
            print("Baza optimalnog rjesenja je B = (")
            i = 1
            while (i != m + 1)
                print("x$(Int(simplex[i, 1]))")
                if (i != m)
                    print(", ")
                end
                i = i + 1
            end
            println(")")
            sortiraniParovi = sort(xPairs, by=x -> x.first)
            xevi = [pair[2] for pair in sortiraniParovi]
            X = xevi[1:n]
            Xd = xevi[(n+1):end]
            yoni = simplex[end, 3:end]
            for i in 1:length(yoni)-brVjestackih
                if yoni[i] != 0
                    yoni[i] *= -1
                end
            end
            Yd = yoni[1:n]
            Y = yoni[(n+1):n+brDopunskih+trebaVratiti]
            return rjesenje, X, Xd, Y, Yd, status
        end
        # trazenje pivota u koloni
        minimum = 1
        j = 1
        # uzima prvi dozvoljen kolicnik za minimum
        while (j != m + 1)
            if (simplex[j, kolona] > 0)
                minimum = j
                break
            end
            j = j + 1
        end
        j = 1
        postojiPozitivan = 0
        while (j != m + 1)
            if (simplex[j, kolona] > 0)
                postojiPozitivan = 1
                if (simplex[j, 2] / simplex[j, kolona] < simplex[minimum, 2] / simplex[minimum, kolona])
                    minimum = j
                end
            end
            j = j + 1
        end
        # ako nema nijedan pozitivan ai, rjesenje je beskonacno i algoritam terminira
        if (postojiPozitivan == 0)
            println("Ima beskonačno mnogo rješenja.")
            return Inf, 0, 0, 0, 0, 3
        end
        pivot = simplex[minimum, kolona]
        k = 1 / pivot
        # mnozimo sa k pivot red
        i = 2
        while (i != n + promjenjive + 3)
            simplex[minimum, i] = simplex[minimum, i] * k
            i = i + 1
        end
        # Transformacija ostalih redova
        i = 1
        while i != m + 3
            if i != minimum
                l = simplex[i, kolona] * (-1)
                j = 2

                if mnoziM == false && i == m + 1
                    i += 1
                    continue
                end

                while j != n + promjenjive + 3
                    simplex[i, j] = simplex[minimum, j] * l + simplex[i, j]
                    if abs(simplex[i, j]) < 1e-08
                        simplex[i, j] = 0
                    end
                    j += 1
                end
            end
            i += 1
        end
        #ubacivanje promjenjive u bazu
        simplex[minimum, 1] = kolona - 2
    end
end

# Z, niz = rijesi_simplex("max", [4 6 3; 1 1.5 3; 3 1 0], [48; 24; 24], [1, 12, 10], [-1; -1; -1], [1; 1; 1]) # Tutorijal 1 Zadatak 2

# Z, niz = rijesi_simplex("max", [1 0 2; 2 2 1; 0 1 0], [1000; 2500; 400], [3000, 2000, 1000], [0; 0; 0], [1; 1; 1]) # Tutorijal 1 Zadatak 4 - Potpuno vjestacka baza

# Z, niz = rijesi_simplex("max", [0.5 0.3;0.1 0.2],[150;60],[3,1],[-1;-1],[1;1]) # Jedinstveno rjesenje

# Z, niz = rijesi_simplex("max", [2 1;4 -5],[20;10],[3,2],[1;-1],[1;1]) # Beskonacno mnogo rjesenja

# Z, niz = rijesi_simplex("min", [1 1; 2 1; 1 1; 2 1], [10;15;20;25], [2,3],[-1;-1;1;1], [1; 1]) # Nema rjesenja 

#**********************************************************************
#test3
#Z=38;  X=(0.66 0 0.33 0) Xd(0 0 0.3 0.16); Y(2 0.12 0 0) Yd(0 36 0 34); status(0)
#goal="min";
#c=[32, 56, 50, 60];
#A=[1 1 1 1; 250 150 400 200; 0 0 0 1; 0 1 1 0];
#b=[1; 300; 0.3; 0.5] 
#csigns=[0; 1; -1; -1;] 
#vsigns=[1; 1; 1; 1;] 
#Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)

#**********************************************************************
#dual prethodnog problema
#test4
#Z=38; X(2 0.12 0 0) Xd(0 36 0 34); Y=(0.66 0 0.33 0) Yd(0 0 0.3 0.16);  status(0)
#goal="max";
#c=[1, 300, -0.3, -0.5];
#A=[1 250 0 0;1 150 0 -1;1 400 0 -1;1 200 -1 0];
#b=[32; 56;  50;  60] 
#csigns=[-1; -1; -1; -1] 
#vsigns=[0; 1; 1; 1] 
#Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)

#**********************************************************************
#test5
#Z=Inf; Problem ima neograniceno rjesenje (u beskonacnosti); status(3)
#goal="max";
#c=[1, 1];
#A=[-2 1;-1 2];
#b=[-1; 4] 
#csigns=[-1; 1] 
#vsigns=[1; 1] 
#Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)

#**********************************************************************
#test6
#Z=Nan; Dopustiva oblast ne postoji; status(4)
#goal="max";
#c=[1, 2];
#A=[1 1; 3 3];
#b=[2; 4] 
#csigns=[1; -1] 
#vsigns=[1; 1] 
#Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)


#**********************************************************************
#test7
#Z=12*10^6; X(2500 1000) Xd(1500 0 0 2000); Y(0 2000 0 0) Yd(0 0); status(2)
#Z=12*10^6; X(2000 2000) ; status(2)
#goal="max";
#c=[4000, 2000];
#A=[3 3;2 1;1 0;0 1];
#b=[12000; 6000; 2500; 3000] 
#csigns=[-1; -1; -1; -1] 
#vsigns=[1; 1] 
#Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)

#**********************************************************************
#test8
#Z=18; X(0 2) Xd(0 0); Y(0 4.5) Yd(1.5 0); status(1)
#Z=18; X(0 2) Xd(0 0); Y(1.5 1.5) Yd(0 0); status(1)
#goal="max";
#c=[3, 9];
#A=[1 4;1 2];
#b=[8; 4] 
#csigns=[-1; -1] 
#vsigns=[1; 1] 
#Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)

#**********************************************************************
#test1 - Obicni simpleks za max (Zadaca)
# Z=942.86 X(171.42, 214.28) Xd(0, 0) Y(5.71, 1.43) Yd(0, 0) status(0)
#Z,X,Xd,Y,Yd,status=general_simplex("max", [3, 2], [0.5 0.3; 0.1 0.2], [150; 60], [-1; -1], [1; 1]);

#**********************************************************************
#test2 - Obicni simpleks za min, vještacke promjenjive (Zadaca)
# Z=265.71 X(3.43, 4.29) Xd(0.14, 0.12, 0, 0) Y(0, 0, 71.43, 42.86) Yd(0, 0) status(0)
#Z,X,Xd,Y,Yd,status=general_simplex("min", [40, 30], [0.1 0; 0 0.1; 0.5 0.3; 0.1 0.2], [0.2; 0.3; 3; 1.2], [1; 1; 1;1], [1; 1]);

#**********************************************************************
#test3 - Simpleks gdje ogranicenja imaju razlicite znakove jednakosti, jedinstveno rješenje (Zadaca)
# Z=880 X(40, 0, 60) Xd(0, 20, 0) Y(1.33, 0, 7.33) Yd(0, 4.33, 0) status(1)
#Z,X,Xd,Y,Yd,status=general_simplex("max", [10, 5, 8], [1 1 1; 2 1.5 0.5; 2 1 1], [100; 110; 120], [0; -1; 1], [1; 1; 1]); 

#**********************************************************************
#test4 - Simpleks koji nema rješenja (Zadaca)
# Z=NaN status(4)
#Z,X,Xd,Y,Yd,status=general_simplex("max", [2, 3], [4 2; -2 -3; 5 -2], [8; 5; 10], [1; 1; 1], [1; 1]);

#**********************************************************************
#test5 - Simpleks sa beskonacno rješenja (Zadaca)
# Z=Inf status(2)
# PROVJERITI STATUS AKO IMA BESKONACNO RJESENJA
Z,X,Xd,Y,Yd,status=general_simplex("max", [3, 2], [2 -1; 4 -2], [4; 8], [1; 1], [1; 1]); 

#**********************************************************************
#test6 - jedinstveno rješenje sva ogranicenja su sa znakom jednakosti (Zadaca)
# Z=300 X(1, 0, 3) Xd(0, 20, 0) Y(400, -100) Yd(0, 400, 0) status(0)
#Z,X,Xd,Y,Yd,status=general_simplex("max", [100, 300, 200], [1 2 1; 3 1 2], [4; 9], [0; 0], [1; 1; 1]);

#**********************************************************************
#test7 - oblast nije ogranicenja rješenje u besk (Zadaca)
# Z=Inf status(3)
#Z,X,Xd,Y,Yd,status=general_simplex("max", [2, 5], [-0.5 1; -0.25 1], [20; 100],[-1; -1], [ 1; 1]);

println(Z);
println(X);
println(Xd);
println(Y);
println(Yd);
println(status);