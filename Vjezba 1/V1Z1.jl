using LinearAlgebra, Gtk

function zadatak1()
    println("ZADATAK 1")
    print("a) ")
    println(3*456/23 + 31.54 + 2^6)
    print("b) ")
    println(sin(pi/7)*ℯ^0.3*(2+0.9im))
    print("c) ")
    println(sqrt(2)*log(10))
    print("d) ")
    println((5+3im)/(1.2+4.5im))
    println("")
end

function zadatak2()
    println("ZADATAK 2")
    a = (atan(5)+ℯ^5.6)/3
    b = (sin(pi/3))^(1/15)
    c = (log(15)+1)/23
    d = sin(pi/2)+cos(pi)
    print("a) ")
    println((a+b)*c)
    print("b) ")
    println(acos(b)*asin(c/11))
    print("c) ")
    println(((a-b)^4)/d)
    print("d) ")
    println(c^(1/a)+(0+b*im)/(3+2im))
    println("")
end

function zadatak3()
    A = [1 -4im sqrt(2); log(-1+0im) sin(pi/2) cos(pi/3); asin(0.5) acos(0.8) ℯ^(0.8)]
    T = transpose(A)
    B = T + A
    C = A * T
    D = T * A
    E = det(A)
    F = inv(A)
end

function zadatak4()
    A = zeros(8,9)
    B = ones(7, 5)
    C = Matrix(I, 5, 5)
    D = rand(4, 9)
end

function zadatak5()
    A = [2 7 6; 9 5 1; 4 3 8]
    SumaRedovi = sum(A, dims=2)
    SumaKolone = sum(A, dims=1)
    SumaDijagonala = sum(A, diag(A))
    println(SumaDijagonala)
end

win = GtkWindow("Sample Application", 400, 300)

# Display the window
showall(win)