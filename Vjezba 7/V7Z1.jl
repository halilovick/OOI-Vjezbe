#  Uradili Kerim Halilović 19215, Edna Bašić 19187

function rasporedi(M)
	pom = copy(M)
	x, y = size(M)
	for i ∈ 1:x
		pom[i, :] = pom[i, :] .- minimum(pom[i, :])
	end
	for i ∈ 1:y
		pom[:, i] = pom[:, i] .- minimum(pom[:, i])
	end

	for i in 1:size(pom, 1)
		indexiNula = findall(x -> x == 0, pom[i, :])
		if length(indexiNula) == 1
			# Pronađena jedinstvena nula u redu
			j = indexiNula[1]
			pom[i, :] .= 1
			pom[:, j] .= 1
			pom[i, j] = 0
		end
	end
    for j in 1:size(pom, 2)
		indexiNula = findall(x -> x == 0, pom[:, j])
		if length(indexiNula) == 1
			# Pronađena jedinstvena nula u koloni
			i = indexiNula[1]
			pom[i, :] .= 1
			pom[:, j] .= 1
			pom[i, j] = 0
		end
	end
    pom .= pom .!= 0
    nule = pom .== 0

	display(pom)
	println("Z = ", sum(nule .* M))
	return pom, sum(nule .* M)
end

# Primjer iz postavke laboratorijske vježbe; Z = 52
M = [80 20 23; 31 40 12; 61 1 1]
rasporedi(M)

# Primjer iz postavke laboratorijske vježbe; Z = 175
M = [25 55 40 80; 75 40 60 95; 35 50 120 80; 15 30 55 65];
rasporedi(M)

# Primjer iz Zadataka za samostalan rad; Z = 15
M = [12 3 3 8 13; 8 4 7 5 7; 10 2 10 4 11; 4 6 3 3 6; 9 10 2 5 12]
rasporedi(M)

# Primjer iz Zadataka za samostalan rad; Z = 39
M = [3 21 12 6 10; 8 23 2 5 5; 33 14 13 10 7; 14 21 19 11 11; 9 16 10 15 13]
rasporedi(M)