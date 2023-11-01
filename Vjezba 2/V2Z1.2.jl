using JuMP, GLPK

#  Uradili Kerim Halilović 19215, Edna Bašić 19187
#  Primjer sa predavanja, strana 5
#  Planira se proizvodnja tri tipa detrdţenta D1, D2 i D3. Sa trgovačkom mreţom je dogovorena
#  isporuka tačno 100 kg detrdţenta bez obzira na tip. Za uvoz odgovarajućeg repromaterijala planirano
#  su sredstva u iznosu od 110 $. Po jednom kilogramu detrdţenta, za proizvodnju detrdţenata D1, D2 i
#  D3 treba nabaviti repromaterijala u vrijednosti 2 $, 1.5 $ odnosno 0.5 $. TakoĎer je planirano da se za
#  proizvodnju uposle radnici sa angaţmanom od ukupno barem 120 radnih sati, pri čemu je za
#  proizvodnju jednog kilograma detrdţenata D1, D2 i D3 potrebno uloţiti respektivno 2 sata, 1 sat
#  odnosno 1 sat. Prodajna cijena detrdţenata D1, D2 i D3 po kilogramu respektivno iznosi 10 KM, 5 KM
#  odnosno 8 KM. Formirati matematski model iz kojeg se moţe odrediti koliko treba proizvesti svakog
#  od tipova detrdţenata da se pri tome ostvari maksimalna moguća zarada

m = Model(GLPK.Optimizer)

@variable(m, x1 >= 0)
@variable(m, x2 >= 0)
@variable(m, x3 >= 0)

@objective(m, Max, 10x1 + 5x2 + 8x3)

@constraint(m, constraint1, x1 + x2 + x3 == 100)
@constraint(m, constraint2, 2x1 + 1.5x2 + 0.5x3 <= 110)
@constraint(m, constraint3, 2x1 + x2 + x3 >= 120)

print(m)
optimize!(m)
termination_status(m)
println("Rjesenja:")
println("x1 = ", value(x1))
println("x2 = ", value(x2))
println("Vrijednost cilja:")
println(objective_value(m))