using JuMP, GLPK

#  Uradili Kerim Halilović 19215, Edna Bašić 19187
#  Primjer sa predavanja, strana 5
#  Neko preduzeće plasira na trţište dvije vrste mljevene kafe K1 i K2. Očekivana zarada je 3
#  novčane jedinice (skraćeno n.j.) po kilogramu za kafu K1 (tj. 3 n.j./kg), a 2 n.j./kg za kafu K2. Pogon
#  za prţenje kafe je na raspolaganju 150 sati sedmično, a pogon za mljevenje kafe 60 sati sedmično.
#  Utrošeni sati za prţenje i mljevenje po kilogramu proizvoda dati su u sljedećoj tabeli

m = Model(GLPK.Optimizer)

@variable(m, x1 >= 0)
@variable(m, x2 >= 0)
@variable(m, x3 >= 0)

@objective(m, Max, 3x1 + 2x2)

@constraint(m, constraint1, 0.5x1 + 0.3x2 <= 150)
@constraint(m, constraint2, 0.1x1 + 0.2x2 <= 60)

print(m)
optimize!(m)
termination_status(m)
println("Rjesenja:")
println("x1 = ", value(x1))
println("x2 = ", value(x2))
println("Vrijednost cilja:")
println(objective_value(m))