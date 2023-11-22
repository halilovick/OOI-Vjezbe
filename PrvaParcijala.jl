using Pkg, JuMP, GLPK

Pkg.add("JuMP")
Pkg.add("GLPK")

m = Model(GLPK.Optimizer)
@variable(m, x1 >= 0)
@variable(m, x2 >= 0)
@variable(m, x3 >= 0)

@objective(m, Max, 8x1+16x2+29x3)

@constraint(m, constraint1, x1+3x2+5x3<=40)
@constraint(m, constraint2, x1+2x2+3x3<=30)
@constraint(m, constraint3, 3x1+8x2+14x3<=100)

print(m)
optimize!(m)

# Ocitavanje statusa
println("Status:", primal_status(m))
println("Status:", termination_status(m))

# Primjer ocitavanja i primalnih i dualnih promjenljivih
println("Rješenja: ")
println("x1 = ", value(x1))
println("x2 = ", value(x2))
println("x3 = ", value(x3))
println("x4 = ", -1*(40- value(constraint1)))
println("x5 = ", -1*(30- value(constraint2)))
println("x6 = ", -1*(100- value(constraint3)))
println("Vrijednost cilja: ")
println(objective_value(m))
println("y1 = ", dual(constraint1))
println("y2 = ", dual(constraint2))
println("y3 = ", dual(constraint3))
println("y4 = ", dual(LowerBoundRef(x1)))
println("y5 = ", dual(LowerBoundRef(x2)))
println("y6 = ", dual(LowerBoundRef(x3)))