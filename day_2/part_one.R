moves <- read.table("input.txt")
h <- sum(moves$V2[moves$V1 == "forward"])
d <- sum(moves$V2[moves$V1 == "down"]) - sum(moves$V2[moves$V1 == "up"])
h * d
