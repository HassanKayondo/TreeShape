########################################################################################################################
#comparing the distributions for the eight statistics between structured and non-structured using two sample
#Kolmogorov-Smirnov test

#clear environment
rm(list=ls())
#importing the datasets for structured populations
structured_set1 <- read.csv("str.csv")
#importing the datasets for non-structured populations
unstructured_set1 <- read.csv("unstr.csv")

#scaling data since in dataset2, trees had varying number of tips
structured_set1 <- as.data.frame(scale(structured_set1, center = apply(structured_set1, 2, min), scale = apply(structured_set1, 2, max) - apply(structured_set1, 2, min)))
unstructured_set1 <- as.data.frame(scale(unstructured_set1, center = apply(unstructured_set1, 2, min), scale = apply(unstructured_set1, 2, max) - apply(unstructured_set1, 2, min)))

#comparing tree statistics between structured and non-structured populations for dataset1
ks.test(structured_set1$Cherries, unstructured_set1$Cherries)
ks.test(structured_set1$colless, unstructured_set1$colless)
ks.test(structured_set1$sackin, unstructured_set1$sackin)
ks.test(structured_set1$total_cophenetic, unstructured_set1$total_cophenetic)
ks.test(structured_set1$ladder, unstructured_set1$ladder)
ks.test(structured_set1$width, unstructured_set1$width)
ks.test(structured_set1$depth, unstructured_set1$depth)
ks.test(structured_set1$wid_dep_ratio, unstructured_set1$wid_dep_ratio)

#comparisons for dataset 2 was done similarly
#############################cucconi two sample test###################################
#Cucconi test
#the codes for Cucconi  have been obtained from https://github.com/tpepler/nonpar/tree/master/R sice the R package "nonpar"
#was not on the R cran

#function for cucconi.teststat
cucconi.teststat <- function(x, y, m = length(x), n = length(y)){
  
  # Calculates the test statistic for the Cucconi two-sample location-scale test
  
  N <- m + n
  S <- rank(c(x, y))[(m + 1):N]
  denom <- sqrt(m * n * (N + 1) * (2 * N + 1) * (8 * N + 11) / 5)
  U <- (6 * sum(S^2) - n * (N + 1) * (2 * N + 1)) / denom
  V <- (6 * sum((N + 1 - S)^2) - n * (N + 1) * (2 * N + 1)) / denom
  rho <- (2 * (N^2 - 4)) / ((2 * N + 1) * (8 * N + 11)) - 1
  C <- (U^2 + V^2 - 2 * rho * U * V) / (2 * (1 - rho^2))
  return(C)
}

#function for cucconi.dist.perm
cucconi.dist.perm <- function(x, y, reps = 1000){
  
  # Computes the distribution of the Cucconi test statistic using random permutations
  
  m <- length(x)
  n <- length(y)
  N <- m + n
  alldata <- c(x, y)
  
  bootFunc <- function(){
    permdata <- alldata[sample(1:N, size = N, replace = FALSE)]
    xperm <- permdata[1:m]
    yperm <- permdata[(m + 1):N]
    return(cucconi.teststat(x = xperm, y = yperm, m = m, n = n))    
  }
  permvals <- replicate(reps, expr = bootFunc())
  
  #  permvals<-rep(NA,times=reps)
  #  for(r in 1:reps){
  #    permdata<-alldata[sample(1:N,size=N,replace=FALSE)]
  #    xperm<-permdata[1:m]
  #    yperm<-permdata[(m+1):N]
  #    permvals[r]<-cucconi.teststat(x=xperm,y=yperm, m=m, n=n)
  #  }
  return(permvals)
}

#function for cucconi.dist.boot

cucconi.dist.boot <- function(x, y, reps = 10000){
  
  # Computes the distribution of the Cucconi test statistic using bootstrap sampling
  
  m <- length(x)
  n <- length(y)
  x.s <- (x - mean(x)) / sd(x) # standardise the x-values
  y.s <- (y - mean(y)) / sd(y) # standardise the y-values
  
  bootFunc <- function(){
    xboot <- x.s[sample(1:m, size = m, replace = TRUE)]
    yboot <- y.s[sample(1:n, size = n, replace = TRUE)]
    return(cucconi.teststat(x = xboot, y = yboot, m = m, n = n))
  }
  bootvals <- replicate(reps, expr = bootFunc())
  
  #  bootvals <- rep(NA,times=reps)
  #  for(r in 1:reps){
  #    xboot<-x.s[sample(1:m,size=m,replace=TRUE)]
  #    yboot<-y.s[sample(1:n,size=n,replace=TRUE)]
  #    bootvals[r]<-cucconi.teststat(x=xboot,y=yboot, m=m, n=n)
  #  }
  return(bootvals)
}

cucconi.test <- function(x, y, method = c("permutation", "bootstrap")){
  
  # Implementation of the Cucconi test for the two-sample location-scale problem
  # A permutation/bootstrap distribution of the test statistic (C) under the
  # null hypothesis is used to calculate the p-value.
  # Reference: Marozzi (2013), p. 1302-1303
  
  m <- length(x)
  n <- length(y)
  C <- cucconi.teststat(x = x, y = y, m = m, n = n)
  
  if(method[1] == "permutation"){
    h0dist <- cucconi.dist.perm(x = x, y = y)
  }
  
  if(method[1] == "bootstrap"){
    h0dist <- cucconi.dist.boot(x = x, y = y)
  }
  
  p.value <- length(h0dist[h0dist >= C]) / length(h0dist)
  
  cat("\nCucconi two-sample location-scale test\n")
  cat("\nNull hypothesis: The locations and scales of the two population distributions are equal.\n")
  cat("Alternative hypothesis: The locations and/or scales of the two population distributions differ.\n")
  cat(paste("\nC = ", round(C, 3), ", p-value = ", round(p.value, 4), "\n\n", sep=""))
  
  return(list(C = C,
              method = method[1],
              p.value = p.value))
}

#computing cucconi.test for tree statistics for structured and those
#from a non-structured one
cucconi.test(x=structured_set1$depth, y=unstructured_set1$depth,method="permutation")

#That was done for all tree eight statistics statistics and the second dataset

###################################Podgor-Gastwirth PG Test ####################
## Padgor-Test was obtained from https://github.com/tpepler/nonpar/blob/master/R/podgast.test.R

podgast.test <- function(x, y){
  # Podgor-Gastwirth two-sample location-scale test as described in Marozzi (2013) p.1301
  # The p-value is the asymptotic p-value from an F-distribution with 2 and (N-3) degrees of freedom
  
  m <- length(x)
  n <- length(y)
  N <- m + n
  Ivec <- c(rep(1, times = m), rep(0, times = n))
  Svec <- rank(c(x, y))
  Svec2 <- Svec^2
  Smat <- as.matrix(cbind(Int = rep(1, times = N), Svec, Svec2))
  bvec <- solve(t(Smat) %*% Smat) %*% (t(Smat) %*% Ivec)
  numer <- (t(bvec) %*% t(Smat) %*% Ivec - m^2 / N) / 2
  denom <- (m - t(bvec) %*% t(Smat) %*% Ivec) / (N - 3)
  PGstat <- numer / denom
  p.value <- pf(PGstat, df1 = 2, df2 = (N - 3), lower.tail = FALSE)
  
  cat("\nPodgor-Gastwirth two-sample location-scale test\n")
  cat("\nNull hypothesis: The locations and scales of the two population distributions are equal.\n")
  cat("Alternative hypothesis: The locations and/or scales of the two population distributions differ.\n")
  cat(paste("\nStatistic = ", round(PGstat, 3), ", p-value = ", round(p.value, 4), "\n\n", sep=""))
  
  return(list(statistic = PGstat,
              p.value = p.value))
}

podgast.test(x=structured_set1$depth, y=unstructured_set1$depth)

#Line 179 was repeated while varying a dataset or a tree statistics for all the 8 tree statistics
# and the two datasets.






















