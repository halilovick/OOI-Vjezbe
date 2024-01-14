using Pkg
using JuMP
using GLPK
using DelimitedFiles
Pkg.add("GLPK")
Pkg.add("JuMP")
Pkg.add("DelimitedFiles")

#  Uradili Kerim Halilović 19215, Edna Bašić 19187 

function max_flow(C)
	m = Model(GLPK.Optimizer)
	n = size(C, 1)

	@variable(m, t[1:n, 1:n] >= 0, Int)
	@objective(m, Max, sum(t[1, j] for j in 2:n))
	@constraint(m, [sum(t[:, k]) for k in 2:n-1] .== [sum(t[k, :]) for k in 2:n-1])
	@constraint(m, t .<= C)
	optimize!(m)

	X = value.(t)
	V = objective_value(m)

	println("X =\n")
	writedlm(stdout, X)
	println("\n\nV =\n\n   ", V)
	return X, V
end

C = [
	0 3 0 3 0 0 0 0;
	0 0 4 0 0 0 0 0;
	0 0 0 1 2 0 0 0;
	0 0 0 0 2 6 0 0;
	0 1 0 0 0 0 0 1;
	0 0 0 0 2 0 9 0;
	0 0 0 0 3 0 0 5;
	0 0 0 0 0 0 0 0
];

X, V = max_flow(C);