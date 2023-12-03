report <- readLines("input.txt")

gamma_binary <- as.numeric(apply(sapply(strsplit(report, ""), t), 1, function(r) mean(as.numeric(r))) > .5)
epsilon_binary <- as.numeric(apply(sapply(strsplit(report, ""), t), 1, function(r) mean(as.numeric(r))) < .5)

gamma <- sum(sapply(seq_along(gamma_binary), function(i) gamma_binary[i]*2^(length(gamma_binary) - i)))
epsilon <- sum(sapply(seq_along(epsilon_binary), function(i) epsilon_binary[i] * 2^(length(epsilon_binary) - i)))

gamma * epsilon
