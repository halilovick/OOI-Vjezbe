#  Uradili Kerim Halilović 19215, Edna Bašić 19187 

function cpm(A, P, T)
	noviP = split.(P, ",")
	P = []
	for i in 1:length(novi)
		push!(P, String.(strip.((noviP[i])[:])))
	end
	cvorovi = zeros(length(A), 4)
	for i in 1:length(A)
		if P[i][1] != "-"
			najveci = 0
			for cvor in P[i]
				redni = findfirst(x -> x == cvor, A)
				najveci = maximum(cvorovi[redni, 2] for cvor in P[i])
			end
			cvorovi[i, 1] = najveci
			cvorovi[i, 2] = T[i] + najveci
		else
			cvorovi[i, 1] = 0
			cvorovi[i, 2] = T[i]
		end
	end
	indeksNK = argmax(cvorovi[:, 2])
	cvorovi[indeksNK, 3:4] .= cvorovi[indeksNK, 1:2]

	for i in 1:length(A)
		found = any(any(x -> x == A[i], P[k]) for k in 1:length(P))
		if !found && A[i] != A[indeksNK]
			cvorovi[i, 3] = cvorovi[indeksNK, 4] - T[i]
			cvorovi[i, 4] = cvorovi[indeksNK, 4]
		end
	end

	for i in length(A):-1:1
		for j in 1:length(P[i])
			cvor = P[i][j]
			for k in 1:length(A)
				if cvor == A[k]
					if cvorovi[k, 3] == 0 || cvorovi[k, 3] > cvorovi[i, 3]
						cvorovi[k, 3] = cvorovi[i, 3] - T[k]
						cvorovi[k, 4] = cvorovi[i, 3]
						break
					end
				end
			end
		end
	end

	Z = sum(T[(cvorovi[:, 1].==cvorovi[:, 3]).&(cvorovi[:, 2].==cvorovi[:, 4])])
	put = join(A[(cvorovi[:, 1].==cvorovi[:, 3]).&(cvorovi[:, 2].==cvorovi[:, 4])], "-")

	return Z, put
end

A = ["A", "B", "C", "D", "E", "F", "G", "H", "I"]
P = [" - ", " - ", " - ", "C", "A", "A", "B, D", "E", "F, G"]
T = [3, 3, 2, 2, 4, 1, 4, 1, 4]
Z, put = cpm(A, P, T)
println("Z = ", Z, ", Put: ", put);

A = ["A", "B", "C", "D", "E", "F", "G"]
P = [" - ", " - ", " - ", "B", "C", "B, D", "B, F"]
T = [8, 6, 15, 7, 5, 6, 8]
Z, put = cpm(A, P, T)
println("Z = ", Z, ", Put: ", put);

A = ["A", "B", "C", "D", "E", "F", "G", "H"]
P = [" - ", " - ", " - ", "C", "B", "C, A", "D", "G"]
T = [5, 7, 10, 13, 5, 5, 4, 8]
Z, put = cpm(A, P, T)
println("Z = ", Z, ", Put: ", put);