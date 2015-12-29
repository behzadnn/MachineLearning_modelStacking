#Model stacking:
library(ISLR);data(Wage)
library(ggplot2);library(caret)
Wage<-subset(Wage,seelct=-c(logwage))
#let's create a building dataset and validation set.
inBuild<-createDataPartition(y=Wage$wage, p=0.7, list=FALSE)