using Pkg, JuMP, GLPK

Pkg.add("JuMP")
Pkg.add("GLPK")

m = Model(GLPK.Optimizer)
@variable(m, x1 >= 0)
@variable(m, x2 >= 0)

@objective(m, Min, -8x1 - 7x2)

@constraint(m, constraint1, 4x1 + x2 <= 4)
@constraint(m, constraint2, 9x1 + 6x2 <= 2)
@constraint(m, constraint3, 5x1 + 9x2 <= 7)

print(m)
optimize!(m)

println("Rješenja: ")
println("x1 = ", value(x1))
println("x2 = ", value(x2))
println("Vrijednost cilja: ")
println(objective_value(m))