
#Box plots for the tree statistics
#set the working directory where datasets are saved
rm(list=ls())
#Libraries
library(ggplot2)
#install.packages("ggpubr")
library(ggpubr)
theme_set(theme_pubr())

#Read in datasets for non-structured populations 
unstr_set1 <- read.csv("tree_stats_unstructured_set1_new.csv", header=TRUE) 
unstr_set2 <- read.csv("tree_stats_unstructured_set2_new.csv", header=TRUE)
unstr_set3 <- read.csv("tree_stats_unstructured_set3_new.csv", header=TRUE)

# Read in datasets for structured populations 
str_set1 <- read.csv("tree_stats_structured_set1_new.csv", header=TRUE)    
str_set2 <- read.csv("tree_stats_structured_set2_new.csv", header=TRUE)
str_set3 <- read.csv("tree_stats_structured_set3_new.csv", header=TRUE)
#head(str_set2)

####################################################################################

#appending groups to the data sets as str (structured population) and unstr (non-structured)
str_set1$group <-'str'
str_set2$group <-'str'
str_set3$group <-'str'
unstr_set1$group <-'unstr'
unstr_set2$group <-'unstr'
unstr_set3$group <-'unstr'

#combinig data frames from the same set of simulation
set1 <-rbind(str_set1, unstr_set1)
set2 <-rbind(str_set2, unstr_set2)
set3 <-rbind(str_set3, unstr_set3)
#tail(set3)

#Drawing box plots for tree statistics for dataset 1


# boxplot for number of cherries for dataset 1
box_cher_set1=ggplot(set1,aes(x=group,y=Cherries)) +
  geom_boxplot(aes(fill=group), outlier.colour = "purple") +
  stat_summary(fun=mean, geom="point",colour="darkred", size=2) +
  #stat_summary(fun.data = fun_mean, geom="text", vjust=-0.7)
  theme_bw()+theme(legend.position = "none")+ylab("Cherries")+xlab("Population structure") +
  theme(axis.title.x = element_blank(),axis.text.x=element_blank())

# boxplot for Colless for dataset 1      
box_coll_set1=ggplot(set1,aes(x=group,y=colless)) +
  geom_boxplot(aes(fill=group), outlier.colour = "purple") +
  stat_summary(fun=mean, geom="point",colour="darkred", size=2) +
  #stat_summary(fun.data = fun_mean, geom="text", vjust=-0.7)+
  theme_bw()+theme(legend.position = "none")+ylab("Colless")+xlab("Population structure") +
  theme(axis.title.x = element_blank(),axis.text.x=element_blank())

# boxplot for Sackin for dataset 1
box_sac_set1=ggplot(set1,aes(x=group,y=sackin)) +
  geom_boxplot(aes(fill=group), outlier.colour = "purple") +
  stat_summary(fun=mean, geom="point",colour="darkred", size=2) +
  theme_bw()+theme(legend.position = "none")+ylab("Sackin")+xlab("Population structure") +
  theme(axis.title.x = element_blank(),axis.text.x=element_blank())

# boxplot for Total cophenetic for dataset 1
box_cop_set1=ggplot(set1,aes(x=group,y=total_cophenetic)) +
  geom_boxplot(aes(fill=group), outlier.colour = "purple") +
  stat_summary(fun=mean, geom="point",colour="darkred", size=2) +
  #stat_summary(fun.data = fun_mean, geom="text", vjust=-0.7)
  theme_bw()+theme(legend.position = "none")+ylab("Cophen")+xlab("Population structure") +
  theme(axis.title.x = element_blank(),axis.text.x=element_blank())  

# boxplot for ladder for dataset 1
box_lad_set1=ggplot(set1,aes(x=group,y=ladder)) +
  geom_boxplot(aes(fill=group), outlier.colour = "purple") +
  stat_summary(fun=mean, geom="point",colour="darkred", size=2) +
  #stat_summary(fun.data = fun_mean, geom="text", vjust=-0.7)
  theme_bw()+theme(legend.position = "none")+ylab("Ladder")+xlab("Population structure") +
  theme(axis.title.x = element_blank(),axis.text.x=element_blank())

# boxplot for width for dataset 1
box_width_set1=ggplot(set1,aes(x=group,y=width)) +
  geom_boxplot(aes(fill=group), outlier.colour = "purple") +
  stat_summary(fun=mean, geom="point",colour="darkred", size=2) +
  #stat_summary(fun.data = fun_mean, geom="text", vjust=-0.7)
  theme_bw()+theme(legend.position = "none")+ylab("Width")+xlab("Population structure") +
  theme(axis.title.x = element_blank(),axis.text.x=element_blank())

# boxplot for depth for dataset 1
box_depth_set1=ggplot(set1,aes(x=group,y=depth)) +
  geom_boxplot(aes(fill=group), outlier.colour = "purple") +
  stat_summary(fun=mean, geom="point",colour="darkred", size=2) +
  #stat_summary(fun.data = fun_mean, geom="text", vjust=-0.7)
  theme_bw()+theme(legend.position = "none")+ylab("Depth")+xlab("Population structure") +
  theme(axis.title.x = element_blank(),axis.text.x=element_blank())

# boxplot for width to depth ratio for dataset 1
box_wdr_set1=ggplot(set1,aes(x=group,y=wid_dep_ratio)) +
  geom_boxplot(aes(fill=group), outlier.colour = "purple") +
  stat_summary(fun=mean, geom="point",colour="darkred", size=2) +
  #stat_summary(fun.data = fun_mean, geom="text", vjust=-0.7)
  theme_bw()+theme(legend.position = "none")+ylab("Wid to dep")+xlab("Population structure") +
  theme(axis.title.x = element_blank(),axis.text.x=element_blank()) 

#Combining all the eight tree statistics in a single plot and adjusting the resolution

png("figure_box1_300dpi.png", units = "px", width=1600, height=1600, res=300)
ggarrange(box_cher_set1, box_coll_set1, box_sac_set1, box_cop_set1, box_lad_set1, box_width_set1, box_depth_set1, box_wdr_set1,
          
          ncol = 2, nrow =4, labels="AUTO",common.legend = TRUE) 
dev.off()

#Similarly, boxplots for datasets 2 and 3 were done by adjusting accordingly.


