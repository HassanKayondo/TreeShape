#clear environment
rm(list = ls())
#Load packages to be used for analysis
require(caret)
set.seed(145623)
#function to perform classification given a dataset
perform_classification <- function(dataset,model){
  startTime<-Sys.time()
  group<-dataset$group
  test_data<-dataset[1:8]
  pred<-predict(model, test_data, type='raw')
  cm<-confusionMatrix(data=as.factor(pred), reference=as.factor(group), positive="1")
  print(cm$table)
  timeTaken=Sys.time()-startTime
  print(paste0("Time taken is ",timeTaken))
}
#function to combine str and unstr tree statistics data
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

#perform classification on real data
#load pretrained models
svm_rad<-readRDS('svmRadial_model.RDS')
svm_lin<-readRDS('svmLinear_model.RDS')
svm_pol<-readRDS('svmPoly_model.RDS')
dt_mod<-readRDS('rpart_model.RDS')
knn_mod<-readRDS('knn_model.RDS')

########### Load data from real phylogenetic trees
unstructured<-read.csv('subpopn2.csv')
structured<-read.csv('subpopn1_and_subpopn2.csv')
dataset<-combine_datasets(structured, unstructured)

########### Perform the classification using the pretrained models #########
perform_classification(dataset, model = svm_rad)
perform_classification(dataset, model = svm_lin)
perform_classification(dataset, model = svm_pol)
perform_classification(dataset, model = knn_mod)
perform_classification(dataset, model = dt_mod)
