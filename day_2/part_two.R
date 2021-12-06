moves <- read.table("input.txt", col.names = c("command", "value"))
aim <- cumsum(ifelse(moves$command == "down", moves$value, ifelse(moves$command == "up", - moves$value, 0)))
h <- sum(moves[moves$command == "forward", "value"])
d <- sum(moves[moves$command == "forward", "value"] * aim[moves$command == "forward"])
h * d
