using Pkg, JuMP, GLPK

Pkg.add("JuMP")
Pkg.add("GLPK")

m = Model(GLPK.Optimizer)
@variable(m, x1 >= 0)
@variable(m, x2 >= 0)
@variable(m, x3 >= 0)

@objective(m, Max, -4470x1 - 4760x2 - 4820x3)

@constraint(m, constraint1, -13x1 - 27x2 - 14x3 <= -51)
@constraint(m, constraint2, -20x1 - 27x2 - 7x3 <= -52)
@constraint(m, constraint3, -20x1 - 24x2 - 20x3 <= -66)
@constraint(m, constraint4, -6x1 - 6x2 - 23x3 <= -92)

print(m)
optimize!(m)

# Ocitavanje statusa
println("Status:", primal_status(m))
println("Status:", termination_status(m))

# Primjer ocitavanja i primalnih i dualnih promjenljivih, provjeriti množenje sa -1 u zavisnosti od znaka/Min/Maxa
println("Rješenja: ")
println("x1 = ", value(x1))
println("x2 = ", value(x2))
println("x3 = ", value(x3))
println("x4 = ", (-51 - value(constraint1)))
println("x5 = ", (-52 - value(constraint2)))
println("x6 = ", (-66 - value(constraint3)))
println("x7 = ", (-92 - value(constraint4)))
println("Vrijednost cilja: ")
println(objective_value(m))
println("y1 = ", dual(constraint1))
println("y2 = ", dual(constraint2))
println("y3 = ", dual(constraint3))
println("y4 = ", dual(constraint4))
println("y5 = ", -1 * (dual(LowerBoundRef(x1))))
println("y6 = ", -1 * (dual(LowerBoundRef(x2))))
println("y7 = ", -1 * (dual(LowerBoundRef(x3))))