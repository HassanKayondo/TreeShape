#Box plots for the tree statistics
#set the working directory where datasets are saved
rm(list=ls())   
#Libraries
library(ggplot2)
#install.packages("ggpubr")
library(ggpubr)
theme_set(theme_pubr())

#Read in datasets for non-structured populations 
unstr_set1 <- read.csv("unstr.csv", header=TRUE) 
# Read in datasets for structured populations 
str_set1 <- read.csv("str.csv", header=TRUE)    

#Scaling the datasets 
#str_set1<-as.data.frame(scale(str_set1, center = apply(str_set1, 2, min), scale = apply(str_set1, 2, max) - apply(str_set1, 2, min)))
#unstr_set1<-as.data.frame(scale(unstr_set1, center = apply(unstr_set1, 2, min), scale = apply(unstr_set1, 2, max) - apply(unstr_set1, 2, min)))

####################################################################################

#appending groups to the data sets as str (structured population) and unstr (non-structured)
str_set1$group <-'str'
unstr_set1$group <-'unstr'
#combinig data frames from the same set of simulation
set1 <-rbind(str_set1, unstr_set1)

#tail(set2)

#Drawing box plots for tree statistics for dataset 2


# boxplot for number of cherries for dataset 2
box_cher_set2=ggplot(set2,aes(x=group,y=Cherries)) +
  geom_boxplot(aes(fill=group), outlier.colour = "purple") +
  stat_summary(fun=mean, geom="point",colour="darkred", size=2) +
  #stat_summary(fun.data = fun_mean, geom="text", vjust=-0.7)
  theme_bw()+theme(legend.position = "none")+ylab("Cherries")+xlab("Population structure") +
  theme(axis.title.x = element_blank(),axis.text.x=element_blank())

# boxplot for Colless for dataset 2      
box_coll_set2=ggplot(set2,aes(x=group,y=colless)) +
  geom_boxplot(aes(fill=group), outlier.colour = "purple") +
  stat_summary(fun=mean, geom="point",colour="darkred", size=2) +
  #stat_summary(fun.data = fun_mean, geom="text", vjust=-0.7)+
  theme_bw()+theme(legend.position = "none")+ylab("Colless")+xlab("Population structure") +
  theme(axis.title.x = element_blank(),axis.text.x=element_blank())

# boxplot for Sackin for dataset 2
box_sac_set2=ggplot(set2,aes(x=group,y=sackin)) +
  geom_boxplot(aes(fill=group), outlier.colour = "purple") +
  stat_summary(fun=mean, geom="point",colour="darkred", size=2) +
  theme_bw()+theme(legend.position = "none")+ylab("Sackin")+xlab("Population structure") +
  theme(axis.title.x = element_blank(),axis.text.x=element_blank())

# boxplot for Total cophenetic for dataset 2
box_cop_set2=ggplot(set2,aes(x=group,y=total_cophenetic)) +
  geom_boxplot(aes(fill=group), outlier.colour = "purple") +
  stat_summary(fun=mean, geom="point",colour="darkred", size=2) +
  #stat_summary(fun.data = fun_mean, geom="text", vjust=-0.7)
  theme_bw()+theme(legend.position = "none")+ylab("Cophen")+xlab("Population structure") +
  theme(axis.title.x = element_blank(),axis.text.x=element_blank()) + coord_cartesian(ylim = c(80000, 500000))  

# boxplot for ladder for dataset 2
box_lad_set2=ggplot(set2,aes(x=group,y=ladder)) +
  geom_boxplot(aes(fill=group), outlier.colour = "purple") +
  stat_summary(fun=mean, geom="point",colour="darkred", size=2) +
  #stat_summary(fun.data = fun_mean, geom="text", vjust=-0.7)
  theme_bw()+theme(legend.position = "none")+ylab("Ladder")+xlab("Population structure") +
  theme(axis.title.x = element_blank(),axis.text.x=element_blank())

# boxplot for width for dataset 2
box_width_set2=ggplot(set2,aes(x=group,y=width)) +
  geom_boxplot(aes(fill=group), outlier.colour = "purple") +
  stat_summary(fun=mean, geom="point",colour="darkred", size=2) +
  #stat_summary(fun.data = fun_mean, geom="text", vjust=-0.7)
  theme_bw()+theme(legend.position = "none")+ylab("Width")+xlab("Population structure") +
  theme(axis.title.x = element_blank(),axis.text.x=element_blank())

# boxplot for depth for dataset 2
box_depth_set2=ggplot(set2,aes(x=group,y=depth)) +
  geom_boxplot(aes(fill=group), outlier.colour = "purple") +
  stat_summary(fun=mean, geom="point",colour="darkred", size=2) +
  #stat_summary(fun.data = fun_mean, geom="text", vjust=-0.7)
  theme_bw()+theme(legend.position = "none")+ylab("Depth")+xlab("Population structure") +
  theme(axis.title.x = element_blank(),axis.text.x=element_blank())

# boxplot for width to depth ratio for dataset 2
box_wdr_set2=ggplot(set2,aes(x=group,y=wid_dep_ratio)) +
  geom_boxplot(aes(fill=group), outlier.colour = "purple") +
  stat_summary(fun=mean, geom="point",colour="darkred", size=2) +
  #stat_summary(fun.data = fun_mean, geom="text", vjust=-0.7)
  theme_bw()+theme(legend.position = "none")+ylab("Wid to dep")+xlab("Population structure") +
  theme(axis.title.x = element_blank(),axis.text.x=element_blank()) 

#Combining all the eight tree statistics in a single plot and adjusting the resolution

png("figure_box2_unscaled2_300dpi.png", units = "px", width=1600, height=1600, res=300)
ggarrange(box_cher_set2, box_coll_set2, box_sac_set2, box_cop_set2, box_lad_set2, box_width_set2, box_depth_set2, box_wdr_set2,
          
          ncol = 2, nrow =4, labels="AUTO",common.legend = TRUE) 
dev.off()

#Similarly, boxplots for datasets 2  were done by adjusting accordingly.


