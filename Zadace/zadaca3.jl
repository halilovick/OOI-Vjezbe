using Pkg, JuMP, GLPK

Pkg.add("JuMP")
Pkg.add("GLPK")

m = Model(GLPK.Optimizer)
@variable(m, x1 >= 0)
@variable(m, x2 >= 0)
@variable(m, x3 >= 0)

@objective(m, Max, 17.5x1 + 20x2 + 21.6x3)

@constraint(m, constraint1, x1 + x2 +x3 <= 21.5)
@constraint(m, constraint2, 2.5x1 + 2.5x2 + 2.4x3 <= 10.44)

print(m)
optimize!(m)

println("Rješenja: ")
println("x1 = ", value(x1))
println("x2 = ", value(x2))
println("x3 = ", value(x3))
println("Vrijednost cilja: ")
println(objective_value(m))