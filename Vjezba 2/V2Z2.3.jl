using Pkg, JuMP, GLPK

#  Uradili Kerim Halilović 19215, Edna Bašić 19187
#  Primjer sa zadataka za samostalan rad
#  Za pravilnu ishranu potrebno je unositi minimalno po 10 jedinica hranljivih komponeneta A i B. Trenutno
#  je moguće nabaviti samo dva prehrambena proizvoda P1 i P2. Proizvod P1 sadrži po dvije jedinice
#  komponente A i B po jednoj količinskoj jedinici proizvoda P1. Proizvod P2 sadrži četiri jedinice
#  komponenete A i šest jedinica komponente B po jednoj količinskoj jedinici proizvoda P2. Jedinične cijena
#  proizvoda su tri novčane jedinice za P1 i pet novčanih jedinica za P2. Potrebno je napraviti plan ishrane,
#  odnosno nabavke prehrambenih proizvoda, koji će uz najmanje troškove zadovoljiti specificirane potrebe.

Pkg.add("JuMP")
Pkg.add("GLPK")

m = Model(GLPK.Optimizer)
@variable(m, x1 >= 0)
@variable(m, x2 >= 0)

@objective(m, Min, 3x1 + 5x2)

@constraint(m, constraint1, 2x1 + 4x2 >= 10)
@constraint(m, constraint2, 2x1 + 6x2 >= 10)

print(m)
optimize!(m)

println("Rješenja: ")
println("x1 = ", value(x1))
println("x2 = ", value(x2))
println("Vrijednost cilja: ")
println(objective_value(m))