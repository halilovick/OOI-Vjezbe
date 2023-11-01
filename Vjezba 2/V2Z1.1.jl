using JuMP, GLPK

#  Uradili Kerim Halilović 19215, Edna Bašić 19187
#  Primjer sa predavanja, strana 5
#  Potrebno je obezbijediti vitaminsku terapiju koja će sadrţavati četiri vrste vitamina V1, V2,
#  V3 i V4. Na raspolaganju su dvije vrste vitaminskih sirupa S1 i S2 čije su cijene 40 n.j./g i 30 n.j./g
#  respektivno. Vitaminski koktel mora sadrţavati najmanje 0.2 g, 0.3 g, 3 g i 1.2 g vitamina V1, V2, V3 i
#  V4 respektivno. Sljedeća tabela pokazuje sastav pojedinih vitamina u obje vrste vitaminskih sirup

m = Model(GLPK.Optimizer)

@variable(m, x1 >= 0)
@variable(m, x2 >= 0)

@objective(m, Min, 40x1 + 30x2)

@constraint(m, constraint1, 0.1x1 >= 0.2)
@constraint(m, constraint2, 0.1x2 >= 0.3)
@constraint(m, constraint3, 0.5x1 + 0.3x2 >= 3)
@constraint(m, constraint4, 0.1x1 + 0.2x2 >= 1.2)

print(m)
optimize!(m)
termination_status(m)
println("Rjesenja:")
println("x1 = ", value(x1))
println("x2 = ", value(x2))
println("Vrijednost cilja:")
println(objective_value(m))