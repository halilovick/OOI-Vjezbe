using LinearAlgebra;

function nadji_pocetno_SZU(C, I, O)
    m, n = size(C)
    sumaI = sum(I)
	sumaO = sum(O)

    if (sumaI > sumaO)
		O = [O sumaI - sumaO]
		C = [C zeros(m, 1)]
		n = n + 1
	elseif (sumaI < sumaO)
		I = [I; sumaO - sumaI]
		C = [C; zeros(1, n)]
		m = m + 1
	end

    A = zeros(m, n)
    i = 1
    j = 1
    while i <= m && j <= n
        if I[i, 1] < O[1, j]
            A[i, j] = I[i, 1]
            O[1, j] = O[1, j] - I[i, 1]
            I[i, 1] = 0
            i = i + 1
        elseif I[i, 1] > O[1, j]
            A[i, j] = O[1, j]
            I[i, 1] = I[i, 1] - O[1, j]
            O[1, j] = 0
            j = j + 1
        else
            A[i, j] = I[i, 1]
            I[i, 1] = 0
            O[1, j] = 0
            j = j + 1
            if !(i == m && j == n + 1)
                A[i, j] = -1
            end
            i = i + 1
        end
    end
    return A, C
end

function transport(C, S, P)
    matTransporta, c = nadji_pocetno_SZU(C, S, P)
    while true
        u = transpose(ones(Int64, size(matTransporta, 1)) .* Inf64)
        v = transpose(ones(Int64, size(matTransporta, 2)) .* Inf64)

        iWalker = 1
        jWalker = 1
        
        check = falses(size(matTransporta, 1) * size(matTransporta, 2))

        u[1] = 0
        while any(t -> t == Inf, u) || any(t -> t == Inf, v)
 		    count=1;
 		    for i in 1:size(matTransporta,1)
 			    for j in 1:size(matTransporta,2)
                    if matTransporta[i, j] != 0
                        if !check[count]
                            if v[j] != Inf && u[i] == Inf
                                u[i] = c[i, j] - v[j]
                            elseif u[i] == Inf && v[j] != Inf
                                v[j] = c[i, j] - u[i]
                            end
                            deleteat!(check, count)
                            insert!(check, count, true)
                        else
                            deleteat!(check, count)
                            insert!(check, count, true)
                        end
                    end
                    count = count + 1
                end
            end
        end

        while (!(count(t -> t == Inf64, u) == 0 && count(t -> t == Inf64, v) == 0))
            #usmjeravanje kretanja
            if jWalker == size(matTransporta,2) + 1
                jWalker = 1
                iWalker = iWalker + 1
            end
            if iWalker == size(matTransporta,1) + 1
                iWalker = 1
                jWalker = 1
            end
            #dodjela dualnim promjenjivim
            i = iWalker
            j = jWalker
            if matTransporta[i, j] != 0
                if u[i] == Inf64 && v[j] == Inf64
                    u[i] = 0
                    v[j] = c[i, j] - u[i]
                elseif u[i] == Inf64
                    u[i] = c[i, j] - v[j]
                elseif v[j] == Inf64
                    v[j] = c[i, j] - u[i]
                end
            end
            jWalker = jWalker + 1
        end
        #korekcija matTransporta
        relativniKoeficijenti = ones(Int64, size(c, 1), size(c, 2)) .* Inf64
        najmanjiKoeficijent = Inf
        pozicijaI = 0
        pozicijaJ = 0
        for i in 1:size(relativniKoeficijenti, 1)
            for j in 1:size(relativniKoeficijenti, 2)
                if matTransporta[i, j] == 0
                    var = c[i, j] - u[i] - v[j]
                    relativniKoeficijenti[i, j] = var
                    if najmanjiKoeficijent > var
                        najmanjiKoeficijent = var
                        pozicijaI = i
                        pozicijaJ = j
                    end
                end
            end
        end
        if najmanjiKoeficijent >= 0
            Z = 0
            T = matTransporta .* c
            for x in T
                if x <= 0
                    continue
                end
                Z = Z + x
            end
            return convert(Matrix{Int64},matTransporta), convert(Int64,Z)
        end
        #pronalazak odgovarajuce konture
        stekKretanja = Array{Int64}(undef, 0, 2)
        stekZalutalihPutanja = Array{Int64}(undef, 0, 2)
        iWalker = pozicijaI #pamte posljednje elemente steka tj. kordinate
        jWalker = pozicijaJ
        smjerGoreDolje = 1
        smjerDesnoLijevo = 0
        stekKretanja = [stekKretanja; iWalker jWalker]
        while true

            pronadjenRed = false

            if smjerGoreDolje == 1
                kraj = size(matTransporta, 1)
                for i in 1:kraj
                    if !(i in transpose(stekZalutalihPutanja[:, 1])) && iWalker != i && matTransporta[i, jWalker] != 0
                        stekKretanja = [stekKretanja; i jWalker]
                        pronadjenRed = true
                        iWalker = i
                        break
                    end
                end

                smjerGoreDolje = 0
                smjerDesnoLijevo = 1
            end
            #rikverc ako je pogresan put, tj. nema se gdje vise kretati
            if !pronadjenRed
                if size(stekZalutalihPutanja,1) == 0 
                    stekZalutalihPutanja = [stekZalutalihPutanja; transpose(stekKretanja[size(stekKretanja, 1), :])]
                else
                    stekZalutalihPutanja = [stekZalutalihPutanja; transpose(stekKretanja[size(stekKretanja, 1), :])]
                end
                iWalker = stekKretanja[size(stekKretanja, 1)-1, 1]
                jWalker = stekKretanja[size(stekKretanja, 1)-1, 2]
                stekKretanja = stekKretanja[1:size(stekKretanja, 1)-1, :]
            end

            if size(stekKretanja, 1) > 1 && stekKretanja[1, 1] == stekKretanja[size(stekKretanja, 1), 1]
                break
            end

            pronadjenaKolona = false

            if smjerDesnoLijevo == 1

                kraj = size(matTransporta, 2)

                for j in 1:kraj

                    if !(j in stekZalutalihPutanja[:, 2]) && jWalker != j && matTransporta[iWalker, j] != 0
                        stekKretanja = [stekKretanja; iWalker j]
                        pronadjenaKolona = true
                        jWalker = j
                        break
                    end
                end

                smjerGoreDolje = 1
                smjerDesnoLijevo = 0
            end
            #rikverc ako je pogresan put, tj. nema se gdje vise kretati
            if !pronadjenaKolona
                if size(stekZalutalihPutanja,1) == 0
                    #println(stekKretanja[size(stekKretanja, 1), :]) 
                    stekZalutalihPutanja = [stekZalutalihPutanja; transpose(stekKretanja[size(stekKretanja, 1), :])]
                else
                    stekZalutalihPutanja = [stekZalutalihPutanja; transpose(stekKretanja[size(stekKretanja, 1), :])]
                end
                iWalker = stekKretanja[size(stekKretanja, 1)-1, 1]
                jWalker = stekKretanja[size(stekKretanja, 1)-1, 2]
                stekKretanja = stekKretanja[1:size(stekKretanja, 1)-1, :]
                #smjerGoreDolje = 0
                #smjerDesnoLijevo = 1
            end
        end
        #pronalazimo najmanji trasport
        delta = Inf
        for i in 1:size(stekKretanja, 1)
            if i%2 == 0 && matTransporta[stekKretanja[i, 1], stekKretanja[i, 2]] < delta && matTransporta[stekKretanja[i, 1], stekKretanja[i, 2]] > 0
                delta = matTransporta[stekKretanja[i, 1], stekKretanja[i, 2]]
            end
        end
        #premjestamo transporte duz konture
        znak = true
        for i in 1:size(stekKretanja, 1)
            if znak
                if matTransporta[stekKretanja[i, 1], stekKretanja[i, 2]] == -1
                    matTransporta[stekKretanja[i, 1], stekKretanja[i, 2]] = delta
                else
                    matTransporta[stekKretanja[i, 1], stekKretanja[i, 2]] = matTransporta[stekKretanja[i, 1], stekKretanja[i, 2]] + delta
                end
            else
                matTransporta[stekKretanja[i, 1], stekKretanja[i, 2]] = matTransporta[stekKretanja[i, 1], stekKretanja[i, 2]] - delta
            end
            znak = !znak
        end
    end
end

#primjer iz knjige
#X = 0 20 0 0 20 0 20 0 30 0 0 0 V = 430

#primjer sa postavke zadatka
#X = 0 20 0 0 20 0 20 0 30 0 0 0 V = 430
#C = [3 2 10; 5 8 12; 4 10 5; 7 15 10];
#S = [20 50 60 10];
#P = [20 40 30];
#X, V = transport(C, transpose(S), P)

#for i in 1:size(X, 1)
#   for j in 1:size(X, 2)
#        print(X[i, j])
#        print("  ")
#    end
#    println()
#end
#println(V)
#primjer zadatka sa samostalnog rada automobili
#C = [30 28 3 10 25; 27 4 11 2 17; 5 12 1 22 8; 13 21 19 15 23];
#S = [200 150 250 400];
#P = [90 170 220 330 190];
#X, V = transport(C, transpose(S), P)

#for i in 1:size(X, 1)
#    for j in 1:size(X, 2)
#        print(X[i, j])
#        print("  ")
#    end
#    println()
#end
#println(V)

C=[3 2 10; 5 8 12; 4 10 5; 7 15 10]
S=[20 50 60 10]
P=[20 40 30]
X,V=transport(C, transpose(S), P)
for i in 1:size(X, 1)
    for j in 1:size(X, 2)
        print(X[i, j])
        print("  ")
    end
    println()
    end
println(V)