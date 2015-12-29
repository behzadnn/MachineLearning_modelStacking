#Model stacking:
library(caret)
library(gbm)
set.seed(3433)
library(AppliedPredictiveModeling)
data(AlzheimerDisease)
adData = data.frame(diagnosis,predictors)
inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training = adData[ inTrain,]
testing = adData[-inTrain,]
dim(training);dim(testing)
#first model using linear regession:
set.seed(62433) 
mod_rf<-train(diagnosis ~.,method="rf",data=training,trcontrol=trainControl(method="cv"),number=3)
mod_gbm<-train(diagnosis~.,method="gbm",data=training)
mod_ida<-train(diagnosis~.,method="lda",data=training)

pred_rf<-predict(mod_rf,testing)
pred_gbm<-predict(mod_gbm,testing)
pred_ida<-predict(mod_ida,testing)

predDF<-data.frame(pred_rf,pred_gbm,pred_ida,diagnosis=testing$diagnosis)
combModFit<-train(diagnosis~.,method="rf",data=predDF)
#now let's compare the results of predictions using the two models:
pred_combined<-predict(combModFit,testing)

results_rf<-confusionMatrix(pred_RF,testing$diagnosis)
results_gbm<-confusionMatrix(pred_gbm,testing$diagnosis)
results_ida<-confusionMatrix(pred_ida,testing$diagnosis)
results_stacked<-confusionMatrix(pred_combined,testing$diagnosis)


