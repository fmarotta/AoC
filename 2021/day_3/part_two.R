report <- readLines("input.txt")
report_matrix <- sapply(strsplit(report, ""), t)
report_matrix <- apply(report_matrix, 1, as.numeric)

binary_to_decimal <- function(binary) {
    sum(sapply(seq_along(binary), function(i) binary[i] * 2^(length(binary) - i)))
}

oxygen <- report_matrix
col <- 1
while (nrow(oxygen) > 1) {
    if (mean(oxygen[, col]) >= .5)
        oxygen <- oxygen[oxygen[, col] == 1, , drop = F]
    else
        oxygen <- oxygen[oxygen[, col] == 0, , drop = F]
    col <- col + 1
}

CO2 <- report_matrix
col <- 1
while (nrow(CO2) > 1) {
    if (mean(CO2[, col]) >= .5)
        CO2 <- CO2[CO2[, col] == 0, , drop = F]
    else
        CO2 <- CO2[CO2[, col] == 1, , drop = F]
    col <- col + 1
}

binary_to_decimal(oxygen) * binary_to_decimal(CO2)
