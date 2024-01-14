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
    mat_transport, cost_matrix = nadji_pocetno_SZU(C, S, P)

    while true
        u = transpose(ones(Int64, size(mat_transport, 1)) .* Inf64)
        v = transpose(ones(Int64, size(mat_transport, 2)) .* Inf64)

        i_walker = 1
        j_walker = 1

        checked_positions = falses(size(mat_transport, 1) * size(mat_transport, 2))

        u[1] = 0
        while any(t -> t == Inf, u) || any(t -> t == Inf, v)
            count = 1
            for i in 1:size(mat_transport, 1)
                for j in 1:size(mat_transport, 2)
                    if mat_transport[i, j] != 0
                        if !checked_positions[count]
                            if v[j] != Inf && u[i] == Inf
                                u[i] = cost_matrix[i, j] - v[j]
                                checked_positions[count] = true
                            elseif u[i] != Inf && v[j] == Inf
                                v[j] = cost_matrix[i, j] - u[i]
                                checked_positions[count] = true
                            end
                        else
                            checked_positions[count] = true
                        end
                    end
                    count += 1
                end
            end
        end

        while any(isequal(Inf64, t) for t in u) || any(isequal(Inf64, t) for t in v)
            if j_walker == size(mat_transport, 2) + 1
                j_walker = 1
                i_walker += 1
            end

            if i_walker == size(mat_transport, 1) + 1
                i_walker = 1
                j_walker = 1
            end

            i, j = i_walker, j_walker

            if mat_transport[i, j] != 0
                if u[i] == Inf64 && v[j] == Inf64
                    u[i] = 0
                    v[j] = cost_matrix[i, j] - u[i]
                elseif v[j] == Inf64
                    v[j] = cost_matrix[i, j] - u[i]
                elseif u[i] == Inf64
                    u[i] = cost_matrix[i, j] - v[j]
                end
            end

            j_walker += 1
        end

        relative_coefficients = ones(Int64, size(cost_matrix, 1), size(cost_matrix, 2)) .* Inf64
        min_coefficient = Inf
        position_i, position_j = 0, 0

        for i in 1:size(relative_coefficients, 1), j in 1:size(relative_coefficients, 2)
            if mat_transport[i, j] == 0
                var = cost_matrix[i, j] - u[i] - v[j]
                relative_coefficients[i, j] = var
                if min_coefficient > var
                    min_coefficient = var
                    position_i, position_j = i, j
                end
            end
        end

        if min_coefficient >= 0
            total_cost = sum(max(0, x) for x in mat_transport .* cost_matrix)
            return convert(Matrix{Int64}, mat_transport), convert(Int64, total_cost)
        end

        movement_stack = Array{Int64}(undef, 0, 2)
        stray_paths_stack = Array{Int64}(undef, 0, 2)
        i_walker, j_walker = position_i, position_j
        move_up_down, move_right_left = 1, 0
        movement_stack = [movement_stack; i_walker j_walker]

        while true
            found_row = false

            if move_up_down == 1
                end_position = size(mat_transport, 1)

                for i in 1:end_position
                    if !(i in stray_paths_stack[:, 1]) && i_walker != i && mat_transport[i, j_walker] != 0
                        movement_stack = [movement_stack; i j_walker]
                        found_row = true
                        i_walker = i
                        break
                    end
                end

                move_up_down, move_right_left = 0, 1
            end

            if !found_row
                if size(stray_paths_stack, 1) == 0
                    stray_paths_stack = [stray_paths_stack; transpose(movement_stack[end, :])]
                else
                    stray_paths_stack = [stray_paths_stack; transpose(movement_stack[end, :])]
                end
                i_walker, j_walker = movement_stack[end-1, 1], movement_stack[end-1, 2]
                movement_stack = movement_stack[1:end-1, :]
            end

            if size(movement_stack, 1) > 1 && movement_stack[1, 1] == movement_stack[end, 1]
                break
            end

            found_column = false

            if move_right_left == 1
                end_position = size(mat_transport, 2)

                for j in 1:end_position
                    if !(j in stray_paths_stack[:, 2]) && j_walker != j && mat_transport[i_walker, j] != 0
                        movement_stack = [movement_stack; i_walker j]
                        found_column = true
                        j_walker = j
                        break
                    end
                end

                move_up_down, move_right_left = 1, 0
            end

            if !found_column
                if size(stray_paths_stack, 1) == 0
                    stray_paths_stack = [stray_paths_stack; transpose(movement_stack[end, :])]
                else
                    stray_paths_stack = [stray_paths_stack; transpose(movement_stack[end, :])]
                end
                i_walker, j_walker = movement_stack[end-1, 1], movement_stack[end-1, 2]
                movement_stack = movement_stack[1:end-1, :]
            end
        end

        delta = Inf
        for i in 1:size(movement_stack, 1)
            if i % 2 == 0 && mat_transport[movement_stack[i, 1], movement_stack[i, 2]] < delta && mat_transport[movement_stack[i, 1], movement_stack[i, 2]] > 0
                delta = mat_transport[movement_stack[i, 1], movement_stack[i, 2]]
            end
        end

        sign = true
        for i in 1:size(movement_stack, 1)
            current_element = mat_transport[movement_stack[i, 1], movement_stack[i, 2]]

            if sign
                mat_transport[movement_stack[i, 1], movement_stack[i, 2]] = (current_element == -1) ? delta : current_element + delta
            else
                mat_transport[movement_stack[i, 1], movement_stack[i, 2]] = current_element - delta
            end

            sign = !sign
		end
	end
end

#primjer iz knjige
#X = 0 20 0 0 20 0 20 0 30 0 0 0 V = 430

#C = [8 9 4 6; 6 8 5 3; 5 6 7 4;];
#S = [100 120 140];
#P = [90 125 80 65];
#X, V = transport(C, transpose(S), P)
#for i in 1:size(X, 1)
#    for j in 1:size(X, 2)
#        print(X[i, j])
#        print("  ")
#    end
#    println()
#end
#println(V)

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

C = [30 28 3 10 25; 27 4 11 2 17; 5 12 1 22 8; 13 21 19 15 23];
S = [200 150 250 400];
P = [90 170 220 330 190];
X, V = transport(C, transpose(S), P)
for i in 1:size(X, 1)
	for j in 1:size(X, 2)
		print(X[i, j])
		print("  ")
	end
	println()
end
println(V)