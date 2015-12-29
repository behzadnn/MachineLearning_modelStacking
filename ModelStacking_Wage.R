#Model stacking:
library(ISLR);data(Wage)
library(ggplot2);library(caret)
Wage<-subset(Wage,select=-c(logwage))
#let's create a building dataset and validation set.
inBuild<-createDataPartition(y=Wage$wage, p=0.7, list=FALSE)
validation<-Wage[-inBuild,];buildData<-Wage[inBuild,]
InTrain<-createDataPartition(y=buildData$wage, p=0.7, list=FALSE)
training<-buildData[InTrain,];testing<-buildData[-InTrain,]
dim(validation);dim(training);dim(testing)
#first model using linear regession:
mod1<-train(wage~.,method="glm",data=training)
#Second model using random forests:
mod2<-train(wage~.,method="rf",data=training, trcontrol=trainControl(method="cv"),number=3)

#now let's compare the results of predictions using the two models:
pred1<-predict(mod1,testing);pred2<-predict(mod2,testing)
qplot(pred1,pred2,colour=wage,data=testing)
#we can now combine the models:
predDF<-data.frame(pred1,pred2, wage=testing$wage)
combModFit<-train(wage~.,method="gam",data=predDF)
combPred<-predict(combModFit,testing)
#Now let's see how much does it improve the results:
sqrt(sum((pred1-testing$wage)^2))
sqrt(sum((pred2-testing$wage)^2))
sqrt(sum((combPred-testing$wage)^2))

