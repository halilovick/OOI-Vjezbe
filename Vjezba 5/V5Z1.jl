# Uradili Kerim Halilović 19215, Edna Bašić 19187

function rijesi_simplex(goal, A, b, c, csigns, vsigns)
    if any(map(isnothing, [goal, A, b, c, csigns, vsigns]))
        return 0,0
    end
    #broj redova
    m = size(b, 1)

    #broj kolona
    n = size(c, 1)

    promjenjive = 0
    #indeksi u matrici A koji se dodaju
    jednakoPromjenjive = Vector{Int32}()
    promjenjiveManjeJednako = Vector{Int32}()

    #provjera ispravnosti dimenzija 
    if (m != size(A, 1) || n != size(A, 2))
        return 0,0
    end

    #provjera da li ima negativnih slobodnih koeficijenata
    for i in 1:m
        if b[i] < 0
            println("Problem ima neograniceno rjesenje (u beskonacnosti)")
            return 0,0
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
            jedinicna[i, brDopunskih + j] = 1
            j += 1
        elseif csigns[i] == 1
            jedinicna[i, brDopunskih + j] = 1
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
                        return 0,0
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
            return rjesenje, xevi
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
            return 0,0
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

Z, niz = rijesi_simplex("min", [1 1 1 1;250 150 400 200;0 0 0 1;0 1 1 0], [1; 300; 0.3; 0.5], [32, 56, 50, 60], [0; 1; -1; -1], [1; 1; 1; 1]);


println(Z);
println(niz);