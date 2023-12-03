#!/usr/bin/env Rscript --vanilla

# Part 1

input <- readLines("input.txt")
lantern <- as.numeric(strsplit(input, ",")[[1]])

for (i in 1:80) {
    newfish <- sum(lantern == 0)
    lantern <- c(lantern, rep(9, newfish))
    lantern[lantern == 0] <- 7
    lantern <- lantern - 1
}

length(lantern)

# Part 2
lantern <- list(c(3, 4, 3, 1, 2))

for (i in 1:80) {
    newfish <- sum(sapply(lantern, function(l) sum(l == 0)))
    lantern <- c(lantern, list(rep(9, newfish)))
    lantern <- lapply(lantern, function(l) {
        l[l == 0] <- 7
        l <- l - 1
        l
    })
    print(i)
}
sum(sapply(lantern, length))

# Existing fish will give rise to floor((256 - fish - 1) / 7) fishes. E.g.
# the first fish, which starts at 3, will give rise to
# floor((256 - 3 - 1) / 7) = 36 fishes.
# One after day 4+7 = 11, one after day 18, one at round 25, and so on.
# The new fish appears when the timer for that its father is 6; thus, we
# first need time for the timer to reach 6 (4 days), then we give rise
# to a fish every 7 days. Sanity check: suppose there are 11 days
# instead of 256. Then this fish gives rise to 7/7=1 fish, which is
# correct.

# If a new fish is born at round x, if we exclude the two extra days, it
# would be born with a timer of 6, like its father. As soon as it
# reaches 6 again (after 7 days), it gives rise to another fish. Sanity
# check: suppose that the fish is born at time 11 with a counter of 6.
# Suppose also that there are 18 days. According to the algorithm, this
# fish would give rise to (18-11)/7=1 fish, which is correct.

# Now let us consider the 2 days "penalty". A fish born at day x would
# give rise to max(0, floor((256-x-9)/7)) + max(0, 256-x-9).

# Okay, but how can we code this? We still need to keep track of the day
# when each new fish is born.

# If a fish gives birth 36 times, how many times will its son give
# birth? Let's suppose again that the two day penalty doesn't exist.
# Then, when the parent is at 6, the son is at 6 as well. If the parent
# gives rise to 36, the first son gives rise to 35; the grandson to 34,
# and so on. If there is only one fish in the beginning, the total
# number of fish is 1 + 36 + 35 + ... + 1

# If we add the two days, what happens? We should remove 1 from the
# reproductive rate of each son (not of the father), and add it back if
# there are 9 days.

# After the first parent makes a baby fish, there is one fish every 9
# days. Father makes a baby; father is at 6, baby 1 at 8. After 9 days,
# baby 1 makes a baby; baby 1 is at 6, baby 2 is at 8. After 9 days,
# baby 2 makes a baby, and so on.

# In the meantime, father and babies continue to give rise to babies
# every 7 days after the first time. So, after father makes a baby,
# after 7 days there is a baby, after 14 days another one, and so on.
# For baby 1, it's like he's having babies every 7 days, but as if he
# has 9 fewer days to live.

# Let's consider one (not founder) fish which starts with a counter
# of x and has n days left. It would give rise to floor((n-9)/7) fishes.
# Its first son is has (n-9) days left and would give rise to
# floor((n-9-9)/7) fishes.

# Okay, so the founder, which starts at x, gives rise to
# floor((256-x-1)/7) babies; let n=256-x-1. The first son makes
# floor((n-9)/7) babies, the second floor((n-9-9)/7) babies, and so on.
# We then need to add floor((256-x-1)/9) back, because we didn't
# consider the first son of a non-founder fish.

# The first son of the founder makes (n-8)/7 babies

# If we have one fish (the founder), there is a son every 7 turns; when
# we have two fishes, there is a son every

calculate_babies <- function(initial_counter, days_left) {
    babies <- 0
    # Contribution of the founder
    babies <- babies + floor((days_left - initial_counter) / 7) + as.numeric(days_left >= initial_counter)
    cat("The founder made",
        floor((days_left - initial_counter) / 7) + (days_left >= initial_counter),
        "babies.\n")
    # Contribution of the adult fish
    n = days_left - initial_counter
    while (n > 8) {
        babies <- babies + floor((n - 8) / 7)
        n <- n - 8
    }
    # Contribution of the newborn fish
    babies <- babies + floor((days_left - initial_counter) / 8)
    cat("The newborn fish made",
        floor((days_left - initial_counter) / 8),
        "babies.\n")
    babies
}

calculate_babies(2, 18)

lantern <- c(3, 4, 3, 1, 2)
sum(sapply(lantern, calculate_babies, 80))
