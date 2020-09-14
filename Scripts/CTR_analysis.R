#Cherry to tip ration (CTR)
rm(list=ls())
#investigating cherries to tip ratio CTR

#reading data into R environment for structured trees
data_str_tree_100_tips <- read.csv("CTR_structured_100_tips_1_tree.csv", header=TRUE)
no_tips=100
no_cherries_norm=data_str_tree_100_tips$Cherries #normalized number of cherries 
no_cherries_unnorm=(no_tips*no_cherries_norm)/2 #non-normalized number of cherries
CTR = no_cherries_unnorm/no_tips #Cherry to tip ratio
R_0= CTR/(1-3*CTR) #formula for R0 using cherry to tip ratio
R_0

#adjust accordingly lines 7,8 and 9 to obtain R0 for other trees with different tips

#reading data into R environment for non structured trees
data_non_str_tree_100_tips <- read.csv("CTR_nonstructured_100_tips_1_tree.csv", header=TRUE)
no_tips=100
no_cherries_norm=data_non_str_tree_100_tips$Cherries  # normalized number of cherries 
no_cherries_unnorm=(no_tips*no_cherries_norm)/2 #non-normalized number of cherries
CTR = no_cherries_unnorm/no_tips
R_0= CTR/(1-3*CTR)
R_0

#adjust accordingly lines 18,19 and 20 to obtain R0 for other trees with different number tips