########################################################################################################################
#comparing the distributions for the eight statistics between structured and non-structured using two sample
#Kolmogorov-Smirnov test

#set the working directory where the datasets arwe saved.
setwd("~/Dropbox/BDTree Simulation & Publication/Data")

#clear environment
rm(list=ls())

#importing the datasets for structured populations
structured_set1 <- read.csv("tree_stats_structured_set1_new.csv")
structured_set2 <- read.csv("tree_stats_structured_set2_new.csv")
structured_set3 <- read.csv("tree_stats_structured_set3_new.csv")

#importing the datasets for non-structured populations
unstructured_set1 <- read.csv("tree_stats_unstructured_set1_new.csv")
unstructured_set2 <- read.csv("tree_stats_unstructured_set2_new.csv")
unstructured_set3 <- read.csv("tree_stats_unstructured_set3_new.csv")

#comparing tree statistics between structured and non-structured populations for dataset1
ks.test(structured_set1$Cherries, unstructured_set1$Cherries)
ks.test(structured_set1$colless, unstructured_set1$colless)
ks.test(structured_set1$sackin, unstructured_set1$sackin)
ks.test(structured_set1$total_cophenetic, unstructured_set1$total_cophenetic)
ks.test(structured_set1$ladder, unstructured_set1$ladder)
ks.test(structured_set1$width, unstructured_set1$width)
ks.test(structured_set1$depth, unstructured_set1$depth)
ks.test(structured_set1$wid_dep_ratio, unstructured_set1$wid_dep_ratio)

#comparisons for datasets 2 and 3 were done similarly