# Sami Itkonen, 2023-11-20
# IODS 2023 Assignment 3: Data Wrangling
# Data source: http://www.archive.ics.uci.edu/dataset/320/student+performance

library(dplyr)

math <- read.table('data/student-mat.csv', sep=";", header=TRUE)
por <- read.table('data/student-por.csv', sep=";", header=TRUE)

# math: mathematics students
# por: portuguese students

dim(math)
dim(por)

colnames(por)
colnames(math)

# The data files have same number of columns with the same names.
# However, fewer students took the Portuguese classes.

# mat: 395 x 33
# por: 649 x 33

# Columns that differ in the two datasets, specifically:
# G1: first period grade 
# G2: second period grade 
# G3: final grade 
# failures: number of past class failures
# paid: extra paid classes
# abscences: number of school absences
free_cols = c("failures", "paid", "absences", "G1", "G2", "G3")

# Join the two data sets according to these columns
join_cols <- setdiff(colnames(por), free_cols)

math_por <- inner_join(math, por, by = join_cols)

# The free columns have been duplicated.
colnames(math_por)

# The data has a variety of categorical and numeric data.
glimpse(math_por)

# Create a new de-deduplicated data set
alc <- select(math_por, all_of(join_cols))

# for every column name not used for joining...
for (col_name in free_cols) {
  # select two columns from 'math_por' with the same original name
  two_cols <- select(math_por, starts_with(col_name))
  # select the first column vector of those two columns
  first_col <- select(two_cols, 1)[[1]]
  
  # then, enter the if-else structure!
  # if that first column vector is numeric...
  if(is.numeric(first_col)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[col_name] <- round(rowMeans(two_cols))
  } else { # else (if the first column vector was not numeric)...
    # add the first column vector to the alc data frame
    alc[col_name] <- first_col
  }
}

glimpse(alc)

# Create average and high alcohol usage columns
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)
alc <- mutate(alc, high_use = alc_use > 2)

# We have 370 observations and the new alcohol usage column look like the have expected data.
glimpse(alc)

# Save the file
library(tidyverse)

setwd("~/Desktop/studies/phd/phd302/IODS-project")
write_csv(alc, 'data/alc_data.csv')
