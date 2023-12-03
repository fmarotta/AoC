vents <- readLines("input.txt")
vents_coords <- t(sapply(vents, function(v) as.numeric(strsplit(v, " |,")[[1]][c(1, 2, 4, 5)]))) + 1 # convert to 1-based

h_or_v_vents_coords <- vents_coords[vents_coords[, 1] == vents_coords[, 3] | vents_coords[, 2] == vents_coords[, 4], ]

board <- matrix(0, nrow = max(c(vents_coords[, 2], vents_coords[, 4])), ncol = max(c(vents_coords[, 1], vents_coords[, 3])))
for (i in 1:nrow(h_or_v_vents_coords)) {
    v <- h_or_v_vents_coords[i, ]
    board[v[1]:v[3], v[2]:v[4]] <- board[v[1]:v[3], v[2]:v[4]] + 1
}
cat("The answer to part one is", sum(board >= 2), "\n")

board <- matrix(0, nrow = max(c(vents_coords[, 2], vents_coords[, 4])), ncol = max(c(vents_coords[, 1], vents_coords[, 3])))
for (i in 1:nrow(vents_coords)) {
    v <- vents_coords[i, ]
    for (j in seq_len(max(abs(v[3] - v[1]) + 1, abs(v[4] - v[2]) + 1))) {
        board[v[1] + sign(v[3] - v[1]) * (j - 1), v[2] + sign(v[4] - v[2]) * (j - 1)] <- board[v[1] + sign(v[3] - v[1]) * (j - 1), v[2] + sign(v[4] - v[2]) * (j - 1)] + 1
    }
}
cat("The answer to part two is", sum(board >= 2), "\n")

