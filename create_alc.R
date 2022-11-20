# title: "3: Logistic regression"
# author: "Jussi Vehviläinen"
# date: "2022-11-20"
# output: html_document

# Libraries

library(readr)
library(boot)
library(tidyverse)

### Main code ###

setwd("E:/Open science course 2022/IODS-project")

# Bring needed files

student_por <- as.data.frame(read_delim("Data/create_alc/student-por.csv", 
                                        delim = ";", escape_double = FALSE, trim_ws = TRUE))
student_mat <- as.data.frame(read_delim("Data/create_alc/student-mat.csv", 
                                        delim = ";", escape_double = FALSE, trim_ws = TRUE))

# Build vector of columns which differs between tables

# give the columns that vary in the two data sets
free_cols<-c("failures", "paid", "absences", "G1", "G2","G3")

# Select cols not in free_cols vector
join_cols <- colnames(por)[!(colnames(por) %in% free_cols)]

# join the two data sets by the selected identifiers, 
# let's specify suffix so that we can next easily remove duplicate rows from data.frame
sufferit<-c("", ".mat")

math_por <- inner_join(student_mat, student_por, by = join_cols, suffix = sufferit)

# Dimensions
dim(math_por)

# Summary
summary(math_por)

# create a new data frame with only the joined columns
df_2 <- select(math_por, all_of(join_cols))

# Add means to new columns by looping length of free columns
for (i in 1:length(free_cols)) {
  col_name<- free_cols[i]
  if (is.numeric(math_por[,col_name])) {
    a<-rowMeans(select(math_por, starts_with(col_name)))
    df_2[col_name]<-a
  } 
  else {
    df_2[col_name]<- math_por[,colnames(math_por) %in% col_name]
  }
}

# Add new column alc_use which sohws mean of weekday and weekend alcohol consumption 
df_2$alc_use<-rowMeans(df_2[colnames(df_2) %in% c("Dalc","Walc")])
# Use latest information to group student according use. > 2 == TRUE and means high use, and viceversa
# <= 2 is FALSE and means less use
df_2$high_use<- NA
df_2$high_use[df_2$alc_use > 2] <- TRUE
df_2$high_use[df_2$alc_use <= 2] <- FALSE

write_csv(df_2, paste0(getwd(),"/Data/wrangled_student_mat_por.csv"))
          