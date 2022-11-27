# title: "4: Data wrangling for the next week"
# author: "Jussi Vehviläinen"
# date: "2022-11-20"
# output: html_document

# Libraries

library(readr)
library(boot)
library(tidyverse)

### Main code ###

hd <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv")
# Check dimensions
dim(hd)
# Summarise table
summary(hd)
# Print head and tail of the data
head(df)
tail(df)
# Check colnames
colnames(hd)
# Save new colnames
# The data combines several indicators from most countries in the world

Country name ="Country" 

# Health and knowledge
catch=c("Human Development Index (HDI)" ,"Gross National Income (GNI) per capita", "Life expectancy at Birth", 
        "Expected Years of Education", "Maternal mortality ratio","Adolescent birth rate",
        "Percetange of female representatives in parliament", 
        "Population with Secondary Education (Female)",
        "Population with Secondary Education (Male)",
        "Labour Force Participation Rate (Female)" ,
        "Labour Force Participation Rate (Male)",
        "Gender Inequality Index (GII)")
change=c("HDI","GNI","Life.Exp","Edu.Exp","Mat.Mor","Ado.Birth","Parli.F","Edu2.F","Edu2.M","Labo.F","Labo.M","GII") 

for (i in 1:length(catch)) {
  for (j in 1:ncol(hd)) {
    colnames(hd)[j]<-ifelse(colnames(hd)[j]==catch[i], colnames(hd)[j]<-change[i], colnames(hd)[j]<-colnames(hd)[j])
  }
}


"Edu2.FM" = Edu2.F / Edu2.M
"Labo.FM" = Labo2.F / Labo2.M
gii <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv", na = "..")
# Check dimensions
dim(gii)
# Check colnames
colnames(gii)
# Summarise table
summary(gii)
# Print head and tail of the data
head(gii)
tail(gii)
