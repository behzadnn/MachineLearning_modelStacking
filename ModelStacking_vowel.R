#Model stacking:
library(ElemStatLearn)
data(vowel.train)
data(vowel.test) 
vowel.train$y<-as.factor(vowel.train$y)
vowel.test$y<-as.factor(vowel.test$y)
#Wage<-subset(Wage,select=-c(logwage))
#let's create a building dataset and validation set.
#inBuild<-createDataPartition(y=Wage$wage, p=0.7, list=FALSE)
###validation<-Wage[-inBuild,];buildData<-Wage[inBuild,]
##InTrain<-createDataPartition(y=buildData$wage, p=0.7, list=FALSE)
#training<-buildData[InTrain,];testing<-buildData[-InTrain,]
dim(vowel.train);dim(vowel.test)
#first model using linear regession:
mod1<-train(y ~.,method="gbm",data=vowel.train)
#Second model using random forests:
mod2<-train(y~.,method="rf",data=vowel.train, trcontrol=trainControl(method="cv"),number=3)
#now let's compare the results of predictions using the two models:
pred_gbm<-predict(mod1,vowel.test);pred_RF<-predict(mod2,vowel.test)
qplot(pred_gbm,pred_RF,colour=y,data=vowel.test)
pred_agreed<-pred_gbm[pred_gbm==pred_RF]
results_rf<-confusionMatrix(pred_RF,vowel.test$y)
results_gbm<-confusionMatrix(pred_gbm,vowel.test$y)
results_agreed<-confusionMatrix(pred_agreed,vowel.test$y[pred_gbm==pred_RF])


