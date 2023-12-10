# Sami Itkonen, 2023-12-10
# IODS 2023 Assignment 6: Longitudinal data

# There are two data sets:
# 1. Data on (medical) treatments for human subjects
# 2. Data on rats' diets

library(readr)
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt",
                   sep =" ", header = T)

RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt",
                   header = TRUE, sep = '\t')

# 1. Summaries and exploration

str(BPRS)
summary(BPRS)

# For human subjects:
# - the treatment data is either 1 or 2.
# - there are 20 subjects
# - there are varying values for 1+8 weeks of treatment effectiveness from 20 to 75

str(RATS)
summary(RATS)

# For rat subjects:
# - there are 16 individuals
# - there are 3 groups (diet)
# - there are varying values for 1+10 weeks of diet effectiveness from 225 to 628

# 2. Categorical variables to factors

# Factor treatment & subject
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)

# Factor ID and Group
RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

# 3. Long form data

BPRSL <-  pivot_longer(BPRS, cols=-c(treatment,subject),names_to = "weeks",values_to = "bprs") %>% arrange(weeks)
BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(weeks,5,5)))

RATSL <- pivot_longer(RATS, cols=-c(ID,Group), names_to = "WD",values_to = "Weight") %>%
  mutate(Time = as.integer(substr(WD,3,4))) %>% arrange(Time)

# 4. Serious look

str(BPRSL)
summary(BPRSL)

dim(BPRS)
dim(BPRSL)
# The "long form" converts the each of the data points for a single individual to a row. 
# Whereas we before had 40 rows, we now have 9 times as many rows (for 8 weeks of treatment + initial condition).

str(RATSL)
summary(RATSL)

dim(RATS)
dim(RATSL)
# For rats, we similarly have 11 as many rows (initial + 10 weeks of diet).

# Save the files
library(tidyverse)

setwd("~/Desktop/studies/phd/phd302/IODS-project")
write_csv(BPRSL, 'data/BPRSL_data.csv')
write_csv(RATSL, 'data/RATSL_data.csv')


