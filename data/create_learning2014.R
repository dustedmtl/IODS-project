# Sami Itkonen, 2023-11-13
# IODS 2023 Assignment 2: Data Wrangling
# Data source: http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt

# Access the dplyr library
library(dplyr)

# Data Wrangling, part 2
learning2014 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt",
                           sep = "\t", header = T)

dim(learning2014)
summary(learning2014[,56-60])
#View(learning2014[,56-60])

# change the names of columns to lowercase
colnames(learning2014)[57] <- "age"
colnames(learning2014)[58] <- "attitude"
colnames(learning2014)[59] <- "points"

summary(select(learning2014, c('age', 'attitude', 'points', 'gender')))

# The file contains 183 observations of 60 variables.
# The values are distributed between 1 and 5, except for four variables:
#. - Age (17-55)
#. - Attitude (14-50)
#. - Points (0-33)
#. - Gender (M/F)

# Data Wrangling, part 3

keep_columns <- c("gender", "age", "attitude", "points")
learning2014_2 <- select(learning2014, one_of(keep_columns))
# View(learning2014_2)

# questions related to deep, surface and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# select the columns related to deep learning 
deep_columns <- select(learning2014, one_of(deep_questions))
# and create column 'deep' by averaging
learning2014_2$deep <- rowMeans(deep_columns)

# select the columns related to surface learning 
surface_columns <- select(learning2014, one_of(surface_questions))
# and create column 'surf' by averaging
learning2014_2$surf <- rowMeans(surface_columns)

# select the columns related to strategic learning 
strategic_columns <- select(learning2014, one_of(strategic_questions))
# and create column 'stra' by averaging
learning2014_2$stra <- rowMeans(strategic_columns)

learning2014_2 <- filter(learning2014_2, points > 0)
#View(learning2014_2)


# Data Wrangling, part 4
library(tidyverse)
setwd("~/Desktop/studies/phd/phd302/IODS-project")

write_csv(learning2014_2, 'data/learning2014.csv')

lr2 <- read_csv('data/learning2014.csv')
head(lr2)
