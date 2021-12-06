depths <- as.numeric(readLines("input.txt"))
depths_window <- depths[-((length(depths)-1):length(depths))] +
    depths[-c(1, length(depths))] +
    depths[-(1:2)]
sum(depths_window[-1] - depths_window[-length(depths_window)] > 0)
