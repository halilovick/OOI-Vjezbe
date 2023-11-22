using LinearAlgebra

#  Uradili Kerim Halilović 19215, Edna Bašić 19187

# Upada u beskonacnu petlju za iste vrijednosti, testirati nule u tabeli (navodno) (0.8/1b)

function rijesi_simplex(A, b, c)
    if (isnothing(A) || isnothing(b) || isnothing(c) || size(A, 2) != size(c, 2) || size(A, 1) != size(b, 1))
        error("Pogresni ulazni parametri")
    end

    nizBaza = Array{Float64}(b)
    push!(nizBaza, 0)
    simplexTabela = hcat(nizBaza, vcat(A, c))
    pomocnePromjenjive = vcat(Matrix(I, size(A, 1), size(b, 1)), zeros(1, size(A, 1)))
    simplexTabela = hcat(simplexTabela, pomocnePromjenjive)
    varijableX = Array{Float64,1}()

    while (true)
        if (algoritam(simplexTabela) == -1)
            break
        end
    end

    for i in axes(simplexTabela, 2)[2:end]
        nijeUBazi = false
        for j in axes(simplexTabela, 1)[1:end-1]
            nulaIspodJedan = true
            if (simplexTabela[j, i] == 1)
                for k in axes(simplexTabela, 1)[1:end-1]
                    if (k != j && simplexTabela[k, i] != 0)
                        nulaIspodJedan = false
                    end
                end
                if (nulaIspodJedan)
                    push!(varijableX, simplexTabela[j, 1])
                    nijeUBazi = true
                    j = size(simplexTabela, 1) - 1
                end
            end
            if (!nijeUBazi && simplexTabela[j, i] != 0)
                nijeUBazi = true
                push!(varijableX, 0)
            end
        end
    end

    Z = simplexTabela[size(simplexTabela, 1), 1] * (-1)

    display(simplexTabela)
    return Z, varijableX
end

function algoritam(simplexTabela)
    maxElementRed = 0
    maxElementKolona = 0
    brojacKolona = 1
    kolona = 0
    n = 0

    for n in simplexTabela[size(simplexTabela, 1), 2:end]
        if (n > maxElementRed)
            maxElementRed = n
            kolona = brojacKolona
        end
        brojacKolona = brojacKolona + 1
    end

    if (maxElementRed <= 0)
        return -1
    end

    kolona = kolona + 1
    maxElementKolona = findmax(simplexTabela[1:end-1, kolona])[1]

    if (maxElementKolona <= 0)
        return -1
    end

    t = 100000000
    t_indeks = 0
    i = 1
    
    while (i <= size(simplexTabela, 1) - 1)
        if (simplexTabela[i, 1] / simplexTabela[i, kolona] < t && simplexTabela[i, 1] / simplexTabela[i, kolona] >= 0)
            t = simplexTabela[i, 1] / simplexTabela[i, kolona]
            t_indeks = i
        end
        i = i + 1
    end

    pivot = simplexTabela[t_indeks, kolona]

    for i in axes(simplexTabela, 1)
        if (i == t_indeks)
            for j in axes(simplexTabela, 2)
                simplexTabela[i, j] = (1 / pivot) * simplexTabela[i, j]
            end
        end
    end

    for i in axes(simplexTabela, 1)
        element = simplexTabela[i, kolona]
        if (i != t_indeks)
            for j in axes(simplexTabela, 2)
                simplexTabela[i, j] = simplexTabela[i, j] - (element * simplexTabela[t_indeks, j])
            end
        end
    end

    return simplexTabela
end

#  Primjer sa predavanja, strana 38

c = [3 1]
A = [0.5 0.3; 0.1 0.2]
b = [150; 60]
Z, nizX = rijesi_simplex(A, b, c);
println("Vrijednost funkcije cilja Z: ", Z)
println("Vrijednosti varijabli x: ")
for i in eachindex(nizX)
    println("x", i, " = ", round(nizX[i]; digits = 2))
end
println("")

#  Primjer sa predavanja, strana 39

c = [800 1000]
A = [30 16; 14 19; 11 26; 0 1]
b = [22800; 14100; 15950; 550]
Z, nizX = rijesi_simplex(A, b, c);
println("Vrijednost funkcije cilja Z: ", Z)
println("Vrijednosti varijabli x: ")
for i in eachindex(nizX)
    println("x", i, " = ", round(nizX[i]; digits = 2))
end
println("")

#  Primjer iz zadataka za samostalan rad, strana 4

c = [8 16 29]
A = [3 8 14; 1 3 5; 1 2 3]
b = [100; 40; 30;]
Z, nizX = rijesi_simplex(A, b, c);
println("Vrijednost funkcije cilja Z: ", Z)
println("Vrijednosti varijabli x: ")
for i in eachindex(nizX)
    println("x", i, " = ", round(nizX[i]; digits = 2))
end
println("")