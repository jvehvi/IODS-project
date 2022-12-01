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

#################################################################################################
# this part also in start of chapter5.rmd

# Read file to R-environment
human_data<-read.table("human_data.tsv", header=TRUE, sep=";", dec=",")


# EDIT Gender Inequality Index column
colnames(human_data)[colnames(human_data)=="Gender Inequality Index"]<-"GII"

# Libraries
library(dplyr)

# Change GNI col to numeric by mutate
human_data$GNI<-human_data %>%
  dplyr:::select(GNI) %>%
  mutate(GNI =as.numeric(GNI))


# Exclude unneeded variables
keep <- c("Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")
human_data.subset <- human_data[,keep]

# Editing previous way 'GNI' make the column to class 'dataframe'. This would be problematic in plots
# so lets' changed it back to really numeric
human_data.subset$GNI<-as.numeric(unlist(human_data.subset$GNI))

# Remove rows with all NA
human_data.subset<-human_data.subset[rowSums(is.na(human_data.subset))!= ncol(human_data.subset),]
dim(human_data.subset)

# Seems that there isn't any complete NA rows
# Lets' remove rows that contains even one NA
human_data.subset<-human_data.subset[complete.cases(as.matrix(human_data.subset)), ]
dim(human_data.subset)

# After subsetting there are 162/195 observations which haven't had any missing variables

# Next we should remove observations related to region
# to find out which, unique values of Country column should be taken

paste(unique(human_data.subset$Country),collapse=', ')

# From the print:
regions<-c("South Africa","South Asia","Latin America and the Caribbean","Europe and Central Asia","East Asia and the Pacific","World","Sub-Saharan Africa")

# Subset regions from the human_data
human_data.subset <- subset(human_data.subset, !(Country %in% regions))

# We can check by dimensions and unique values that correct rows has been removed
dim(human_data.subset)

# add country to rownames
rownames(human_data.subset) <- human_data.subset$Country

human_data.subset <- human_data.subset[,!(colnames(human_data.subset) %in% c('Country'))]

# Check dimensions, should be 155 x 8
dim(human_data.subset)

write.csv2(human_data.subset, "human_data_30112022.tsv", row.names=TRUE)