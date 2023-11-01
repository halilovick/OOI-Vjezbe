using LinearAlgebra
function rijesi_simplex(A, b, c)
    # Provjera ulaznih parametara
    if (isnothing(A) || isnothing(b) || isnothing(c) || size(A, 1) != size(c, 2) || size(A, 1) != size(b, 1))
        error("Pogresni ulazni parametri")
    end

    # Inicijalizacija simplex table
    nizBaza = Array{Float64}(b)
    push!(nizBaza, 0)
    simplexTabela = hcat(nizBaza, vcat(A, c))
    pomocnePromjenjive = vcat(Matrix(I, size(A, 1), size(b, 1)), zeros(1, size(A, 1)))
    simplexTabela = hcat(simplexTabela, pomocnePromjenjive)
    varijableX = Array{Float64,1}()

    while (true)
        if (simplex_algoritam(simplexTabela) == -1)
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

function simplex_algoritam(simplex)
    maxElementRed = 0
    maxElementKolona = 0
    brojacKolona = 1
    kolona = 0
    n = 0

    for n in simplex[size(simplex, 1), 2:end]
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

    maxElementKolona = findmax(simplex[1:end-1, kolona])[1]
    if (maxElementKolona <= 0)
        return -1
    end

    t = 100000000
    t_indeks = 0
    i = 1
    while (i <= size(simplex, 1) - 1)
        if (simplex[i, 1] / simplex[i, kolona] < t && simplex[i, 1] / simplex[i, kolona] >= 0)
            t = simplex[i, 1] / simplex[i, kolona]
            t_indeks = i
        end
        i = i + 1
    end

    pivot = simplex[t_indeks, kolona]

    for i in axes(simplex, 1)
        if (i == t_indeks)
            for j in axes(simplex, 2)
                simplex[i, j] = simplex[i, j] * (1 / pivot)
            end
        end
    end

    for i in axes(simplex, 1)
        el = simplex[i, kolona]
        if (i != t_indeks)
            for j in axes(simplex, 2)
                simplex[i, j] = simplex[i, j] - (el * simplex[t_indeks, j])
            end
        end
    end
    
    return simplex
end

c = [3 1]
A = [0.5 0.3; 0.1 0.2]
b = [150; 60]
# c = [1000 3000]
# A = [6 9; 2 1]
# b = [100; 20]
optimalnoZ, vrijednostiX = rijesi_simplex(A, b, c);
println("Optimalna vrijednost funkcije cilja Z: ", optimalnoZ)
println("Vrijednosti varijabli x: ")
for i = 1:size(vrijednostiX, 1)
    println("x", i, "=", round(vrijednostiX[i]))
end