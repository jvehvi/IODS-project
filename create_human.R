# title: "4: Data wrangling for the next week"
# author: "Jussi Vehviläinen"
# date: "2022-11-20"
# output: html_document

# Libraries

library(readr)
library(boot)
library(tidyverse)

### Main code ###

# Read files
hd <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv")

gii <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv", na = "..")

# Check dimensions
dim(hd)
dim(gii)

# Summarise table
summary(hd)
summary(gii)

# Print head and tail of the data
head(df)
tail(df)

head(gii)
tail(gii)

# Check colnames
colnames(hd)
colnames(gii)
# EDIT COLNAMES:

# First edit just gii specific variable names
catch_gii <-c("Population with Secondary Education (Female)",
              "Population with Secondary Education (Male)",
              "Labour Force Participation Rate (Female)" ,
              "Labour Force Participation Rate (Male)")

change_gii <- c("Labo.F","Labo.M", "Edu2.F","Edu2.M")

# Then loop with two vectors
for (i in 1:length(catch_gii)) {
  colnames(gii)<- gsub(x = colnames(gii), pattern = catch_gii[i], replacement = change_gii[i], fixed = TRUE) 
}

# Remove possible endings inside ()
remove_one="\\s*\\([^\\)]+\\)"

colnames(hd)<- gsub(x = colnames(hd), pattern = remove_one, replacement = "") 
colnames(gii)<- gsub(x = colnames(gii), pattern = remove_one, replacement = "") 

# Things to be replaced)
  
catch=c("Gross National Income per Capita", "Life Expectancy at Birth", "Expected Years of Education",
        "Mean Years of Education", "Maternal Mortality Ratio", "Adolescent Birth Rate","Human Development Index",
        "Percent Representation in Parliament","per Capita Rank Minus")
  
# Replacers 
change=c("GNI","Life.Exp","Edu.Exp","Edu.Mean","Mat.Mor","Ado.Birth","HDI","Parli.F"," - ") 

# Then loop with two vectors
for (i in 1:length(catch)) {
  colnames(hd)<- gsub(x = colnames(hd), pattern = catch[i], replacement = change[i])
  colnames(gii)<- gsub(x = colnames(gii), pattern = catch[i], replacement = change[i]) 
}


gii<- mutate(gii, Edu2.FM = Edu2.F / Edu2.M)
gii<- mutate(gii, Labo.FM = Labo.F / Labo.M)

head(as.data.frame(gii))

df <- merge(hd, gii, by="Country")

write.csv2(df, "human_data.tsv")
