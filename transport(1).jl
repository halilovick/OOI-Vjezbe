
function nadji_pocetno_SZU(C, I, O)
	m, n = size(C)
	sumaI = sum(I)
	sumaO = sum(O)

	if (sumaI > sumaO)
		O = [O; sumaI - sumaO]
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

	while (i <= m && j <= n)
		if (I[i] > O[j])
			A[i, j] = O[j]
			I[i] -= O[j]
			O[j] = 0
			j += 1

		elseif (I[i] < O[j])
			A[i, j] = I[i]
			O[j] -= I[i]
			I[i] = 0
			i += 1

		else
			A[i, j] = I[i]
			I[i] = 0
			O[j] = 0
			j += 1
			if (j <= n)
				A[i, j] = -1
			end
			i += 1
		end
	end

	Z = 0;
	for i = 1:m
		for j = 1:n
			if (A[i, j] != -1)
				Z += A[i, j] * C[i, j]
			end
		end
	end

	return A, Z
end

#return true oznacava kraj algoritma (nadjenu konturu)
#u tom slucaju samo odmotavaj rekurziju u potpunosti
#return false oznacava da taj put ne moze dalje
#u tom slucaju treba nastaviti testirati ostale puteve
function kontura_rekurz(tekuceRjesenje, smjer, trenutnoPolje, put, pocetnoPolje)
    if trenutnoPolje != pocetnoPolje
        if smjer == "H" && trenutnoPolje[1] == pocetnoPolje[1]
            return true
        elseif smjer == "V" && trenutnoPolje[2] == pocetnoPolje[2]
            return true
        end
    end

    if smjer == "V"
        gdjeMozeVertikalno = findall(el -> el != 0, tekuceRjesenje[:, trenutnoPolje[2]])
        filter!(el -> el != trenutnoPolje[1], gdjeMozeVertikalno)

        if isempty(gdjeMozeVertikalno)
            return false
        end

        for i in eachindex(gdjeMozeVertikalno)
            novoPolje = CartesianIndex(gdjeMozeVertikalno[i], trenutnoPolje[2])

            nadjenNoviPut = kontura_rekurz(tekuceRjesenje, "H", novoPolje, put, pocetnoPolje)
            if nadjenNoviPut != false
                push!(put, novoPolje)
                return true
            end
            
        end

    elseif smjer == "H"
        gdjeMozeHorizontalno = findall(el -> el != 0, tekuceRjesenje[trenutnoPolje[1], :])
        filter!(el -> el != trenutnoPolje[2], gdjeMozeHorizontalno)

        if isempty(gdjeMozeHorizontalno)
            return false
        end

        for i in eachindex(gdjeMozeHorizontalno)

            novoPolje = CartesianIndex(trenutnoPolje[1], gdjeMozeHorizontalno[i])
            nadjenNoviPut = kontura_rekurz(tekuceRjesenje, "V", novoPolje, put, pocetnoPolje)

            if nadjenNoviPut != false
                push!(put, novoPolje)
                return true
            end

        end
    end

    return false

end

brojModiPoziva = 1

function modi_rekurz(tekuceRjesenje, cijene)
    global brojModiPoziva
    if brojModiPoziva == 50
        throw(ArgumentError("Da nije previse rekurzija u modiju!?"))
    end
    brojModiPoziva += 1

    u = fill(typemin(Int), size(tekuceRjesenje, 1))
    v = fill(typemin(Int), size(tekuceRjesenje, 2))
    u[1] = 0

    brojacWhilePetljeZaDegeneraciju = 0
    while !(all(el -> el != typemin(Int), u) && all(el -> el != typemin(Int), v))
        if brojacWhilePetljeZaDegeneraciju == 20
            #za nase dimenzionalnosti problema mozemo tvrditi da ima degeneracije
            #ako nakon 20 iteracija ne nadje sve u i v
            gdjeUbacitiEpsilonKolona = findfirst(el -> el == typemin(Int), v)
            gdjeUbacitiEpsilonRed = findfirst(el -> el == 0, tekuceRjesenje[:, gdjeUbacitiEpsilonKolona])

            tekuceRjesenje[gdjeUbacitiEpsilonRed, gdjeUbacitiEpsilonKolona] = -1
			brojacWhilePetljeZaDegeneraciju = 0
        end
        brojacWhilePetljeZaDegeneraciju += 1
        for i in 1:size(tekuceRjesenje, 1)
            for j in 1:size(tekuceRjesenje, 2)
                if tekuceRjesenje[i,j] != 0
                    if u[i] == typemin(Int) && v[j] != typemin(Int)
                        u[i] = cijene[i,j] - v[j]
                    elseif u[i] != typemin(Int) && v[j] == typemin(Int)
                        v[j] = cijene[i,j] - u[i]
                    end
                end
            end
        end
    end

    d = fill(typemax(Int), (size(u, 1), size(v, 1)))
    for i in 1:size(u, 1)
        for j in 1:size(v, 1)
            if tekuceRjesenje[i,j] == 0
                d[i,j] = cijene[i,j] - u[i] - v[j]
            end
        end
    end

    if all(el -> el >= 0, d)
        return nothing
    end

    minimalnoD = argmin(d)

    put = Array{CartesianIndex{2}, 1}()
    nadjenaKontura = kontura_rekurz(tekuceRjesenje, "H", minimalnoD, put, minimalnoD)

    if nadjenaKontura == false
        #nema puta nikakvog, belaj veliki
        throw(ArgumentError("Nema nikakvog puta!"))
    end

    push!(put, minimalnoD)

    reverse!(put)

    elementiKojiSeOduzimaju = Array{Int, 1}()

    for i in 2:2:length(put)
        push!(elementiKojiSeOduzimaju, tekuceRjesenje[put[i]])
    end

    kolicinaNovogTransporta = findmin(elementiKojiSeOduzimaju)

    tekuceRjesenje[put[1]] = kolicinaNovogTransporta[1]

    if kolicinaNovogTransporta[1] != -1
        for i in 3:2:length(put)
            if tekuceRjesenje[put[i]] == -1
                tekuceRjesenje[put[i]] = 0
            end

            tekuceRjesenje[put[i]] += kolicinaNovogTransporta[1]
        end
    end

    for i in 2:2:length(put)
        if kolicinaNovogTransporta[1] == -1
            if tekuceRjesenje[put[i]] == -1
                tekuceRjesenje[put[i]] = 0
            end
        else
            tekuceRjesenje[put[i]] -= kolicinaNovogTransporta[1]
        end
    end

    modi_rekurz(tekuceRjesenje, cijene)
end

function transport(cijene, skladista, potrosaci)
    pocetnoRjesenje, cijene = nadji_pocetno_SZU(cijene, skladista, potrosaci)

    tekuceRjesenje = copy(pocetnoRjesenje)
    modi_rekurz(tekuceRjesenje, cijene)
    finalnoRjesenje = copy(tekuceRjesenje)

    finalniIznos = 0
    for i in 1:size(finalnoRjesenje, 1)
        for j in 1:size(finalnoRjesenje, 2)
            if finalnoRjesenje[i, j] != 0
                finalniIznos += finalnoRjesenje[i, j] * cijene[i, j]
            end
        end
    end

    println("X = ")
    for i in 1:size(finalnoRjesenje, 1)
        for j in 1:size(finalnoRjesenje, 2)
            print(string(finalnoRjesenje[i, j]), "\t")
        end
        println()
    end

    println("\n")
    println("V = $finalniIznos")


    return finalnoRjesenje, finalniIznos
end

using Test

#@testset "Testovi za zadacu 8" begin
# 	@test transport([8 9 4 6; 6 9 5 3; 5 6 7 4],[100,120,140], [90,125,80,65]) == ([0 20 80 0; 55 0 0 65; 35 105 0 0], 1830)
#    @test transport([12 16 17; 12 17 18; 14 5 4; 12 7 6; 19 15 12],[33; 47; 52; 42; 39], [66; 50; 52])  == ([19 0 0 14; 47 0 0 0; 0 50 2 0; 0 0 42 0; 0 0 8 31], 1398)
#    @test transport([3 10 4 2 3; 7 5 8 4 10; 5 8 15 7 12; 10 12 10 8 4; 7 1 1 6 5], [200; 200; 150; 200; 250], [100; 200; 400; 200; 100]) == ([0 0 150 50 0; 0 150 0 50 0; 100 50 0 0 0; 0 0 0 100 100; 0 0 250 0 0], 4000)
#end

println("aaa")

C=[3 2 10;5 8 12;4 10 5;7 15 10]
S=[20; 50; 60; 10]; P=[20; 40; 30]
X,V=transport(C,S,P);
