using Pkg: Pkg;
Pkg.add("Infinity");
using Infinity;

#  Uradili Kerim Halilović 19215, Edna Bašić 19187

function najkraci_put(M)
	m, n = size(M)

	putevi = Inf * ones(Float64, m, n)
	putevi[1, 1] = 0
	putevi[1, n] = 0

	f = zeros(Int64, m)
	vektor = zeros(Int64, m)
	vektor[1] = 1

	varijabla = 0
	k = 2
	for j in 2:n
		suma = Inf
		for i in 1:j-1
			if (M[i, j] != 0)
				varijabla = f[i] + M[i, j]
				if (varijabla <= suma)
					suma = varijabla
					vektor[k] = i
				end
			end
		end
		putevi[vektor[k], j] = suma
		f[j] = suma
		putevi[j, n] = f[j]
		k += 1
	end

	return hcat(1:m, f, vektor)
end

M = [0 1 3 0 0 0; 0 0 2 3 0 0; 0 0 0 -4 9 0; 0 0 0 0 1 2; 0 0 0 0 0 2; 0 0 0 0 0 0]
putevi = najkraci_put(M);
println(M)
print(putevi)

M = [0 6 0 2 0 0; 0 0 3 3 1 0; 0 0 0 4 0 3; 0 0 0 0 1 0; 0 0 0 0 0 2; 0 0 0 0 0 0]
putevi = najkraci_put(M);
println(M)
print(putevi)


M = [0 16 11 7 4 1; 16 0 5 10 13 15; 11 5 0 4 8 3; 7 10 4 0 3 6; 4 13 8 3 0 2; 1 15 3 6 2 0]
putevi = najkraci_put(M);
println(M)
print(putevi)
