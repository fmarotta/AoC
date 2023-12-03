draws <- as.numeric(strsplit(readLines("input.txt", n = 1), ",")[[1]])
boards <- readLines("input.txt")[-(1:2)]
n_boards <- sum(boards == "") + 1
boards_split <- lapply(1:n_boards, function(i) boards[(6 * (i - 1) + 1):(6 * i - 1)])
boards_list <- lapply(boards_split, function(b) sapply(trimws(b), function(r) as.numeric(strsplit(r, " +")[[1]])))

marks_list <- lapply(boards_list, function(i) matrix(rep(0, 25), nrow = 5))

mark_board <- function(board, marks, number) {
    if (number %in% board)
        marks[which(board == number, arr.ind = T)] <- 1
    return(marks)
}

check_win <- function(marks) {
    any(rowSums(marks) == 5) || any(rowSums(t(marks)) == 5)
}

score_board <- function(board, marks, number) {
    sum(board * (1 - marks)) * number
}

for (n in draws) {
    marks_list <- lapply(seq_along(marks_list), function(i) {
        mark_board(boards_list[[i]], marks_list[[i]], n)
    })
    wins <- sapply(marks_list, check_win)
    if (any(wins == 1)) {
        winning_board <- which(wins == 1)
        cat("The answer to part one is",
            score_board(boards_list[[winning_board]], marks_list[[winning_board]], n), "\n")
        break
    }
}


marks_list <- lapply(boards_list, function(i) matrix(rep(0, 25), nrow = 5))
for (n in draws) {
    marks_list <- lapply(seq_along(marks_list), function(i) {
        mark_board(boards_list[[i]], marks_list[[i]], n)
    })
    wins <- sapply(marks_list, check_win)
    if (any(wins == 1)) {
        winning_board <- which(wins == 1)
        if (length(boards_list) > 1) {
            boards_list <- boards_list[-winning_board]
            marks_list <- marks_list[-winning_board]
        } else {
            cat("The answer to part two is",
                score_board(boards_list[[1]], marks_list[[1]], n), "\n")
            break
        }
    }
}
