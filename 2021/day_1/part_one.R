#!/usr/bin/env Rscript --vanilla

depths <- as.numeric(readLines("input.txt"))
sum(depths[-1] - depths[-length(depths)] > 0)
