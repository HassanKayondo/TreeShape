
#set the working directory where the datasets are saved
#Drawing Confusion matrices and ROC for svm radial and svm polynomial for only dataset 3
rm(list=ls())
structured_set3 <- read.csv("tree_stats_structured_set3_new.csv")
unstructured_set3 <- read.csv("tree_stats_unstructured_set3_new.csv")

#Scaling the datasets 
structured_set3 <- as.data.frame(scale(structured_set3, center = apply(structured_set3, 2, min), scale = apply(structured_set3, 2, max) - apply(structured_set3, 2, min)))
unstructured_set3 <- as.data.frame(scale(unstructured_set3, center = apply(unstructured_set3, 2, min), scale = apply(unstructured_set3, 2, max) - apply(unstructured_set3, 2, min)))

#labelling strucured as 1 and non-structured as 0
structured_set3$group<-"1"
unstructured_set3$group<-"0"

#combining the data sets of structured and non-structured
combined3<-rbind(structured_set3, unstructured_set3)

#head(combined3)

#spliting dataset 3 into training and testing

set.seed(11211)
ind = sample(2, nrow(combined3), replace = TRUE, prob=c(0.7, 0.3))
trainset = combined3[ind == 1,]
testset = combined3[ind == 2,]

####################################################################################
#Support vector machine classification
library(e1071) #package for svm classification

#tuning the parameters for svm radial model
set.seed(222113)
tune_svm_radial = tune(svm, factor(group)~., data=trainset, kernel="radial",
                ranges=list(cost = c(0.1,1,10,100,1000,10000,100000), gamma = c(0,0.000001,0.001,0.1,0.5,1,2,3,4)))

#fitting svm radial classification model
set.seed(44113)
svmfit_radial=svm(factor(group)~., data=trainset, kernel="radial", 
                 gamma=tune_svm_radial$best.parameters$gamma, cost=tune_svm_radial$best.parameters$cost, decision.values=TRUE)

#ROC curves
library(ROCR)
library(ggplot2)
library(ggplotify)
#function for drawing ROC
rocplot = function(pred, truth, ...){
  predob = prediction(pred, truth)
  perf = performance(predob, "tpr", "fpr")
  plot(perf,...)}

#making predictions on the test dataset
fitted_svm_radial = attributes(predict(svmfit_radial, testset[,1:8], 
                                      decision.values = TRUE))$decision.values
#ROC plot
rocplot(fitted_svm_radial, factor(testset[, 9]), col = "red")

#converting roc to ggplot oject
plot_roc_radial<-as.ggplot(~rocplot(fitted_svm_radial, factor(testset[, 9]), col = "red"))

################################## SVM Polynomial

#tuning the parameters for svm polynomial model
set.seed(22277331)
tune_svm_polynomial=tune(svm, factor(group)~., data=trainset, kernel="polynomial",
                       ranges=list(cost = c(0.1,1,10,100,1000,10000,100000), gamma = c(0,0.000001,0.001,0.1,0.5,1,2,3,4)))

#fitting svm polynomial classification model
set.seed(441133)
svmfit_polynomial=svm(factor(group)~., data=trainset, kernel="polynomial", 
                  gamma=tune_svm_polynomial$best.parameters$gamma, cost=tune_svm_polynomial$best.parameters$cost, decision.values=TRUE)

#making predictions on the test dataset
fitted_svm_polynomial = attributes(predict(svmfit_polynomial, testset[,1:8], 
                                       decision.values = TRUE))$decision.values
#ROC plot
rocplot(fitted_svm_polynomial, factor(testset[, 9]), col = "red")

#converting roc to ggplot oject

plot_roc_polynomial<-as.ggplot(~rocplot(fitted_svm_polynomial, factor(testset[, 9]), col = "red"))

########################################################

#Drawing confusion matrices
library(caret)    #package for drawing confusion matrix
#using the tuned parameters for the svm radial and polynomial above

#svm radial
set.seed(221122)
model_svm_radial.tuned=svm(factor(group)~., data=trainset, kernel="radial", 
                           gamma=tune_svm_radial$best.parameters$gamma, cost=tune_svm_radial$best.parameters$cost)

svm_radial.tuned.pred=predict(model_svm_radial.tuned, testset[, 1:8])
svm_radial.tuned.table=table(svm_radial.tuned.pred, testset$group)
cm_radial<-confusionMatrix(svm_radial.tuned.table)

Actual <- factor(c(0, 0, 1, 1))
Predicted <- factor(c(0, 1, 0, 1))
Y <- c(cm_radial$table[1,1], cm_radial$table[2,1], cm_radial$table[1,2], cm_radial$table[2,2]) #these values are obtained from Confusion matrix
df <- data.frame(Actual, Predicted, Y)
cmplot_radial<-ggplot(data =  df, mapping = aes(x = Actual, y = Predicted)) +
  geom_tile(aes(fill = Y), colour = "white") +
  geom_text(aes(label = sprintf("%1.0f", Y)), vjust = 1) +
  scale_fill_gradient(low = "lightsteelblue2", high = "lightyellow2") +
  theme_bw() + theme(legend.position = "none")

#confusion matrix for svm polynomial
set.seed(611433)
model_svm_polynomial.tuned=svm(factor(group)~., data=trainset, kernel="polynomial", 
                               gamma=tune_svm_polynomial$best.parameters$gamma, cost=tune_svm_polynomial$best.parameters$cost)

svm_polynomial.tuned.pred=predict(model_svm_polynomial.tuned, testset[,1:8])
svm_polynomial.tuned.table=table(svm_polynomial.tuned.pred, testset$group)
cm_polynomial=confusionMatrix(svm_polynomial.tuned.table)

Z <- c(cm_polynomial$table[1,1], cm_polynomial$table[2,1], cm_polynomial$table[1,2], cm_polynomial$table[2,2]) #these values are obtained from Confusion matrix for cm_polynomial
df_new <- data.frame(Actual, Predicted, Z)
cmplot_polynomial<-ggplot(data =  df_new, mapping = aes(x = Actual, y = Predicted)) +
  geom_tile(aes(fill = Z), colour = "white") +
  geom_text(aes(label = sprintf("%1.0f", Z)), vjust = 1) +
  scale_fill_gradient(low = "lightsteelblue2", high = "lightyellow2") +
  theme_bw() + theme(legend.position = "none")

############################################################################
####comining the plots and adjusting the resolution
####

library(ggpubr) #package that has ggarrange function

png("cm_roc_res300.png", units = "px", width=1600, height=1600, res=300)
ggarrange(plot_roc_radial, plot_roc_polynomial, cmplot_radial,cmplot_polynomial, ncol = 2, nrow =2, labels="AUTO",common.legend = FALSE) 
dev.off()





