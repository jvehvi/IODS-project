# title: "6: Analysis of longitudinal data"
# author: "Jussi Vehviläinen"
# date: "2022-12-07"

# Access the packages dplyr and tidyr
library(dplyr)
library(tidyr)

# Data wrangling

# Read needed files to R
# BPRS
bprs <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", header =TRUE)
# Study dataframe
dim(bprs)
str(bprs)
head(bprs)
summary(bprs)

#rats
rats <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", header =TRUE)
# Study dataframe
dim(rats)
str(rats)
head(rats)
summary(rats)

# Edit dataframes
## BPRS

### Turn Categorial variables to factors
bprs$treatment = factor(bprs$treatment)
bprs$subject <- factor(bprs$subject)

### Convert to long form
bprsl <-  pivot_longer(bprs, cols = -c(treatment, subject),
          names_to = "weeks", values_to = "bprs") %>%
          arrange(weeks) # order by weeks variable

### Study new long form table
dim(bprsl)
str(bprsl)
summary(bprsl)
unique(bprsl$weeks)

### Extract the week number
bprsl <-  bprsl %>% 
  mutate(week = as.integer(substr(weeks,5, 6)))
unique(bprsl$week)

### STUDY NEW LONG DATAFRAME - Glimpse & Summary
glimpse(bprsl)
summary(bprsl)

## rats

### Turn Categorial variables to factors
rats$Group = factor(rats$Group)
rats$ID = factor(rats$ID)

### Convert to long form
ratsl <- pivot_longer(rats, cols = -c(ID, Group),
        names_to = "time_variables", values_to = "rats") %>%
        arrange(time_variables) # order by weeks variable

### Study new long form table
dim(ratsl)
str(ratsl)
summary(ratsl)
unique(ratsl$time_variables)

### Extract the time_variable number
ratsl <-  ratsl %>% 
  mutate(time_variable = as.integer(substr(time_variables,3, 4)))
unique(ratsl$time_variable)

### STUDY NEW LONG DATAFRAME - Glimpse & Summary
glimpse(ratsl)
summary(ratsl)


## Save tables in .txt format
write.table(bprsl, "BPRSL.txt")
write.table(ratsl, "ratsl.txt")
