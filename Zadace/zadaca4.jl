using Pkg, JuMP, GLPK

Pkg.add("JuMP")
Pkg.add("GLPK")

m = Model(GLPK.Optimizer)
@variable(m, x1 >= 0)
@variable(m, x2 >= 0)

@objective(m, Min, 0.45x1 + 0.49x2)

@constraint(m, constraint1, 0.25x1 + 0.05x2 <= 2)
@constraint(m, constraint2, 0.45x1 + 0.45x2 == 2.07)
@constraint(m, constraint3, 0.58x1 + 0.35x2 >= 2.07)

print(m)
optimize!(m)

println("Rješenja: ")
println("x1 = ", value(x1))
println("x2 = ", value(x2))
println("Vrijednost cilja: ")
println(objective_value(m))