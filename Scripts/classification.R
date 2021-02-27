#clear environment
rm(list = ls())
#Load packages to be used for analysis
require(e1071)
require(caret)
require(rpart)
require(pROC)
set.seed(145623)
#function to perform classification given a dataset
perform_classification <- function(dataset, mtd, save_model=F){
  print(paste0("==========Performing classification using ", mtd, "=============="))
  startTime<-Sys.time()
  #Use the caret cross validation implementation. We use 10-fold cross validation
  train.control <- trainControl(method = "cv",number = 10,savePredictions = T)
  #get size of dataset
  n<-50#dim(dataset)[1]/2
  model <- train(group ~ ., data=dataset, trControl=train.control, method=mtd)
  print(model)
  cm<-confusionMatrix(model, positive = "1")
  print(cm)
  sens<-cm$table[1,1]/(cm$table[1,1]+cm$table[2,1]) 
  print(paste0("Sensitivity=",sens))
  #sensitivity=no. of true tve/(no. of true +ve + no. of false -ve), we took o to be tve & 1 -ve
  spec<-cm$table[2,2]/(cm$table[2,2]+cm$table[1,2]) 
  print(paste0("Specificity=",spec))
  #specificity=no. of true -ve/(no of true -ve + no. of false +ve) 
  acc<-(cm$table[1,1]+cm$table[2,2])/100 #accuracy is % of those correctly classified
  print(paste0("Accuracy=",acc))
  #Compute area under ROC curve 
  pred<-predict(model) #obtain predictions made over the cv
  print(roc(as.numeric(pred), as.numeric(dataset$group)))
  timeTaken<-Sys.time()-startTime
  print(paste0("Time taken for buiding ",mtd, "-model"))
  print(timeTaken)
  if(save_model){
    fileName=paste0(mtd,"_model.RDS")
    saveRDS(model, fileName)
    print(paste0("Model saved to file as ",fileName))
  }
}
#function to combine str and unstr tree statistics
combine_datasets<-function(structured, unstructured){
  structured <- as.data.frame(scale(structured, center = apply(structured, 2, min), 
                                    scale = apply(structured, 2, max) - apply(structured, 2, min)))
  structured$group<-"1"
  unstructured <- as.data.frame(scale(unstructured, center = apply(unstructured, 2, min), 
                                      scale = apply(unstructured, 2, max) - apply(unstructured, 2, min)))
  unstructured$group<-"0"
  #combining the data sets of structured and non-structured
  dataset<-rbind(structured, unstructured)
  return(dataset)
}

# import tree statistic data for simulated trees ###########
unstructured1<-read.csv('baseline_subpopn1.csv')
unstructured2<-read.csv('baseline_subpopn2.csv')
unstructured<-rbind(unstructured1[1:250,], unstructured2[1:250,])
structured<-read.csv('baseline_str_stats.csv')

#Use different ML methods to classify data as str or unstr
dataset<-combine_datasets(structured, unstructured)
mtds<-c("knn","svmRadial","svmPoly","svmLinear","rpart")
for (mtd in mtds) {
  perform_classification(dataset = dataset, mtd = mtd, save_model = F)
}

