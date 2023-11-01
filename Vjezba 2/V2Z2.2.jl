using Pkg, JuMP, GLPK

#  Uradili Kerim Halilović 19215, Edna Bašić 19187
#  Primjer sa zadataka za samostalan rad
#  Kompanija za proizvodnju slatkiša proizvodi visokokvalitetne čokoladne proizvode i namjerava pokrenuti 
#  proizvodnju dva nova slatkiša. Proizvodi se prave u tri različita odjeljka u kojem provode određeno
#  vrijeme. Prvi proizvod zahtijeva 1 h proizvodnje u odjeljku 1 i 3 h proizvodnje u odjeljku 3 po jednom
#  komadu. Drugi proizvod zahtijeva 1 h proizvodnje u odjeljku 2 i 2 h proizvodnje u odjeljku 3 po jedom
#  komadu. Odjeljak 1 ima na raspolaganju 3 slobodna sata, odjeljak 2 ima 6 slobodnih sati i odjeljak 3 ima
#  18 slobodnih sati. Svi proizvedeni novi proizvodi mogu se prodati a cijena prvog iznosi 2 KM, a drugog
#  4 KM po komadu.

Pkg.add("JuMP")
Pkg.add("GLPK")

m = Model(GLPK.Optimizer)
@variable(m, x1 >= 0)
@variable(m, x2 >= 0)

@objective(m, Max, 2x1 + 4x2)

@constraint(m, constraint1, 1x1 <= 3)
@constraint(m, constraint2, 1x2 <= 6)
@constraint(m, constraint3, 3x1 + 2x2 <= 18)

print(m)
optimize!(m)

println("Rješenja: ")
println("x1 = ", value(x1))
println("x2 = ", value(x2))
println("Vrijednost cilja: ")
println(objective_value(m))