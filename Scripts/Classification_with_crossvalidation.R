#Load packages to be used for analysis
require(e1071)
require(caret)
require(rpart)
require(pROC)

#clear the environment
rm(list = ls())

#set working directory
setwd("~/Dropbox/BDTree Simulation & Publication/Data")

#load data for structured population
structured_set1 <- read.csv("tree_stats_structured_set1_new.csv")
structured_set2 <- read.csv("tree_stats_structured_set2_new.csv")
structured_set3 <- read.csv("tree_stats_structured_set3_new.csv")
structured_set1 <- as.data.frame(scale(structured_set1, center = apply(structured_set1, 2, min), scale = apply(structured_set1, 2, max) - apply(structured_set1, 2, min)))
structured_set2 <- as.data.frame(scale(structured_set2, center = apply(structured_set2, 2, min), scale = apply(structured_set2, 2, max) - apply(structured_set2, 2, min)))
structured_set3 <- as.data.frame(scale(structured_set3, center = apply(structured_set3, 2, min), scale = apply(structured_set3, 2, max) - apply(structured_set3, 2, min)))
structured_set1$group<-"1"
structured_set2$group<-"1"
structured_set3$group<-"1"

#load data for un-structured population
unstructured_set1 <- read.csv("tree_stats_unstructured_set1_new.csv")
unstructured_set2 <- read.csv("tree_stats_unstructured_set2_new.csv")
unstructured_set3 <- read.csv("tree_stats_unstructured_set3_new.csv")
unstructured_set1 <- as.data.frame(scale(unstructured_set1, center = apply(unstructured_set1, 2, min), scale = apply(unstructured_set1, 2, max) - apply(unstructured_set1, 2, min)))
unstructured_set2 <- as.data.frame(scale(unstructured_set2, center = apply(unstructured_set2, 2, min), scale = apply(unstructured_set2, 2, max) - apply(unstructured_set2, 2, min)))
unstructured_set3 <- as.data.frame(scale(unstructured_set3, center = apply(unstructured_set3, 2, min), scale = apply(unstructured_set3, 2, max) - apply(unstructured_set3, 2, min)))
unstructured_set1$group<-"0"
unstructured_set2$group<-"0"
unstructured_set3$group<-"0"

#combining the data sets of structured and non-structured
combined1<-rbind(structured_set1, unstructured_set1)
combined2<-rbind(structured_set2, unstructured_set2)
combined3<-rbind(structured_set3, unstructured_set3)

#we will perform the classification on dataset at a time

#CHANGE THE DATASET HERE combined1, combined2 and combined3
dataset<-combined3

#Use the caret cross validation implementation. We use 10-fold cross validation
train.control <- trainControl(method = "cv",number = 10,savePredictions = T)

################# KNN model ######################
set.seed(14413)
knn_model <- train(group ~ ., data=dataset, trControl=train.control, method="knn")
knn_model
cm_knn<-confusionMatrix(knn_model)
sensitivity_knn<-cm_knn$table[1,1]/(cm_knn$table[1,1]+cm_knn$table[2,1]) 
#sensitivity=no. of true tve/(no. of true +ve + no. of false -ve), we took o to be tve & 1 -ve
specificity_knn<-cm_knn$table[2,2]/(cm_knn$table[2,2]+cm_knn$table[1,2]) 
#specificity=no. of true -ve/(no of true -ve + no. of false +ve) 
accuracy_knn<-(cm_knn$table[1,1]+cm_knn$table[2,2])/100 #accuracy is % of those correctly classified
#Compute area under ROC curve 
pred<-predict(knn_model) #obtain predictions made over the cv
roc(as.numeric(pred), as.numeric(dataset$group))

########################### SVM-Radial ###########################
set.seed(145623)
svmRadialmodel<-train(group ~ ., data=dataset, trControl=train.control, method="svmRadial")
svmRadialmodel
cm_svm_radial<-confusionMatrix(svmRadialmodel)
sensitivity_svm_radial<-cm_svm_radial$table[1,1]/(cm_svm_radial$table[1,1]+cm_svm_radial$table[2,1]) 
specificity_svm_radial<-cm_svm_radial$table[2,2]/(cm_svm_radial$table[2,2]+cm_svm_radial$table[1,2]) 
accuracy_svm_radial<-(cm_svm_radial$table[1,1]+cm_svm_radial$table[2,2])/100
#Compute area under ROC curve 
pred<-predict(svmRadialmodel)
roc(as.numeric(pred), as.numeric(dataset$group))

########################### SVM-Linear ###########################
set.seed(121123)
svmLinearmodel<-train(group ~ ., data=dataset, trControl=train.control, method="svmLinear")
svmLinearmodel
cm_svm_linear<-confusionMatrix(svmLinearmodel)
sensitivity_svm_linear<-cm_svm_linear$table[1,1]/(cm_svm_linear$table[1,1]+cm_svm_linear$table[2,1]) 
specificity_svm_linear<-cm_svm_linear$table[2,2]/(cm_svm_linear$table[2,2]+cm_svm_linear$table[1,2]) 
accuracy_svm_linear<-(cm_svm_linear$table[1,1]+cm_svm_linear$table[2,2])/100
#Compute area under ROC curve 
pred<-predict(svmLinearmodel)
roc(as.numeric(pred), as.numeric(dataset$group))

########################### SVM-Polynomial ###########################
set.seed(771123)
svmPolymodel<-train(group ~ ., data=dataset, trControl=train.control, method="svmPoly")
svmPolymodel
cm_svm_poly<-confusionMatrix(svmPolymodel)
sensitivity_svm_poly<-cm_svm_poly$table[1,1]/(cm_svm_poly$table[1,1]+cm_svm_poly$table[2,1]) 
specificity_svm_poly<-cm_svm_poly$table[2,2]/(cm_svm_poly$table[2,2]+cm_svm_poly$table[1,2]) 
accuracy_svm_poly<-(cm_svm_poly$table[1,1]+cm_svm_poly$table[2,2])/100
#Compute area under ROC curve 
pred<-predict(svmPolymodel)
roc(as.numeric(pred), as.numeric(dataset$group))

########################### Decision Trees ###########################
set.seed(991123)
DTmodel<-train(group ~ ., data=dataset, trControl=train.control, method="rpart")
DTmodel
cm_dt<-confusionMatrix(DTmodel)
sensitivity_dt<-cm_dt$table[1,1]/(cm_dt$table[1,1]+cm_dt$table[2,1]) 
specificity_dt<-cm_dt$table[2,2]/(cm_dt$table[2,2]+cm_dt$table[1,2]) 
accuracy_dt<-(cm_dt$table[1,1]+cm_dt$table[2,2])/100
#Compute area under ROC curve 
pred<-predict(DTmodel)
roc(as.numeric(pred), as.numeric(dataset$group))

