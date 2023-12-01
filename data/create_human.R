# Sami Itkonen, 2023-12-01
# IODS 2023 Assignment 5: Data Wrangling

# Technical notes for the data:
# https://hdr.undp.org/system/files/documents/technical-notes-calculating-human-development-indices.pdf

# The data set contains variables related to Human Development Index (HDI) and Gender Inequality Index (GII).

library(readr)
hd <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv")
gii <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv", na = "..")

# 3. Summaries and exploration

str(hd)
summary(hd)

# 195 countries, 8 variables

# The HDI calculation takes into account:
#  - life expectancy
#  - expected amount education
#  - per capita GNI

str(gii)
summary(gii)

# 195 countries, 10 variables

# The GII calculation takes into account:
#  - infant mortality
#  - female empowerment
#  - labour participation rates

# 4. Rename columns according to this file
# https://github.com/KimmoVehkalahti/Helsinki-Open-Data-Science/blob/master/datasets/human_meta.txt

names(hd)[3:8] = c("HDI", "Life.Exp", "Edu.Exp", "Edu.Mean", "GNI", "GNI.Minus")
names(hd)[1] = "HDI.Rank"
names(gii)[3:10] = c("GII", "Mat.Mor", "Ado.Birth", "Parli.F", "Edu2.F", "Edu2.M", "Labo.F", "Labo.M")
names(gii)[1] = "GII.Rank"

# 5. Create male/female ratios for education and labour participation
gii <- mutate(gii, Edu2.FM = Edu2.F / Edu2.M)
gii <- mutate(gii, Labo.FM = Labo.F / Labo.M)

# 6. Join the datasets to "human"

human = inner_join(hd, gii, by = c("Country"))
str(human)

# 195 countries, 19 variables

# 2. Keep only selected columns
keep <- c("Country", "Edu2.FM", "Labo.FM", "Life.Exp", "Edu.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")
human1 <- select(human, one_of(keep))

# 3. Filter out rows with missing values
human1 <- filter(human1, complete.cases(human1))

# 4. Filter out rows relating to regions
last <- nrow(human1) - 7
human1 <- human1[1:last, ]

# 155 rows, 9 variables
# The data still looks expected
summary(human1)
str(human1)

# Save the file
library(tidyverse)

setwd("~/Desktop/studies/phd/phd302/IODS-project")
write_csv(human, 'data/human_data.csv')

# 5. Save updated file (I chose to not overwrite the original)
write_csv(human1, 'data/human_data_2.csv')

