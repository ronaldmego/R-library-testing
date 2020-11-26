# ============================
# Example 1: data prep chunk
# ============================

# Re-list the packages your code uses
# You don't need to list knitr unless that is required for reproducing your work
###library(alrtools)
library(tidyverse)

# Notice that I've put a big banner comment at the beginning of this
# Since I am including it in the appendix, I want the reader to be
# able to know what section of the report the code applies to

# If you are using functions the reader may not have seen before
# it's not a bad idea to preface them with the package they come from.
# readr was loaded as part of the tidyverse
# So the "namespacing" is not required, only helpful
###boston <- readr::read_csv('crime-training-data_modified.csv')

# ============================
# Example 2: data prep chunk
# ============================

###mod1 <- lm(medv ~ age + rm, data = boston)
###par(mfrow = c(2, 2))
plot(cars)

# ============================
# Example 3: `kable` output
# ============================

# This shows a table of response variable versus rounded room counts
# But, it's not pretty
###tbl <- table(boston$target, round(boston$rm, 0))
print(cars)





## # ============================
## # Example 5: code for the reader
## # ============================
## ###library(tree)
## ###tree1 <- tree::tree(medv ~ ., data = boston)
## ###par(mfrow = c(1, 1))
## ###plot(tree1, type = 'uniform')
## ###text(tree1, pretty = 5, col = 'blue', cex = 0.8)
