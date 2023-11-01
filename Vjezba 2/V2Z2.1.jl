using JuMP, GLPK

#  Uradili Kerim Halilović 19215, Edna Bašić 19187
#  Primjer sa zadataka za samostalan rad
#  Kompanija za proizvodnju stakla proizvodi visokokvalitetne staklene proizvode i namjerava pokrenuti
#  proizvodnju dva nova proizvoda. Proizvodi se prave u tri različita odjeljka u kojem provode određeno
#  vrijeme. Prvi proizvod treba odjeljak 1 i odjeljak 3 i to 1 h i 3 h respektivno. Drugi proizvod treba 2 h
#  odjeljak 2 i isto toliko odjeljak 3. Zbog zauzetosti odjeljaka usljed pravljenja ostalih proizvoda, odjeljak 1
#  ima 4 slobodna sata, odjeljak 2 ima 12 slobodnih sati i odjeljak 3 ima 18 slobodnih sati. Svi proizvedeni
#  novi proizvodi mogu se prodati a cijena prvog iznosi 3 KM, a drugog 5 KM po komadu. Odrediti
#  optimalni plan proizvodnje da bi se ostvarila najveća zarada.

m = Model(GLPK.Optimizer)

@variable(m, x1 >= 0)
@variable(m, x2 >= 0)

@objective(m, Max, 3x1 + 5x2)

@constraint(m, constraint1, 1x1 <= 4)
@constraint(m, constraint2, 2x2 <= 12)
@constraint(m, constraint3, 3x1 + 2x2 <= 18)

print(m)
optimize!(m)
termination_status(m)
println("Rjesenja:")
println("x1 = ", value(x1))
println("x2 = ", value(x2))
println("Vrijednost cilja:")
println(objective_value(m))
