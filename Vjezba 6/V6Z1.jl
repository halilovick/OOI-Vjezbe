using LinearAlgebra

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

	Z = sum(A .* C)

	return A, Z
end

# Primjer 1 (Poglavlje 5, strana 6)
C = [8 9 4 6; 6 9 5 3; 5 6 7 4]
I = [100; 120; 140]
O = [90; 125; 80; 65]

A, Z = nadji_pocetno_SZU(C, I, O)
display(A)
println("Z = ", Z)

# Primjer 2 (Tutorijal 3, slide 14)
C = [8 18 16 9 10; 10 12 10 3 15; 12 15 7 16 4]
I = [90; 50; 80]
O = [30; 50; 40; 70; 30]

A, Z = nadji_pocetno_SZU(C, I, O)
display(A)
println("Z = ", Z)

# Primjer 3 (Zadaci za samostalan rad, Zadatak 1)
C = [10 12 0; 8 4 3; 6 9 4; 7 8 5]
I = [20; 30; 20; 10]
O = [40; 10; 30]

A, Z = nadji_pocetno_SZU(C, I, O)
display(A)
println("Z = ", Z)