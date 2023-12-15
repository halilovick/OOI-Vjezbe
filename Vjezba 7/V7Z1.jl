function rasporedi(M)
    pom = copy(M)
    x, y = size(M)
    for i = 1:x
        pom[i, :] = pom[i, :] .- minimum(pom[i, :])
    end
    for i = 1:y
        pom[:, i] = pom[:, i] .- minimum(pom[:, i])
    end

    #ovo ce da stavi keca na sva mjesta gdje se nalazi nula u matrici
    nule = pom .== 0


    while (any(x -> x > 1, sum(nule, dims=1)) || any(x -> x > 1, sum(nule, dims=2)))
        for i = 1:x
            if (sum(nule[i, :]) > 1)
                continue
            else
                #nadje red gdje ima samo jedna nula i zamijeni sve tadasnje nule za 1 a tu
                #1 za nulu jer je to to
                vrijednost, pozicija = findmax(nule[i, :])
                nule[:, pozicija] = zeros(x)
                nule[i, pozicija] = 1
            end
        end

        for i = 1:y
            if (sum(nule[:, i]) > 1)
                continue
            else
                #ovo isto za kolone ko gore za redove
                vrijednost, pozicija = findmax(nule[:, i])
                nule[pozicija, :] = zeros(y)'
                nule[pozicija, i] = 1
            end
        end
    end

    return nule, sum(nule .* M)
end


M = [80 20 23; 31 40 12; 61 1 1]

rasporedi(M)