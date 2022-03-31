rm(list= ls(all.names = TRUE))
gc()

library(ggplot2)
library(dplyr)
library(Hmisc)
library(tidyverse)

setwd("D:\\NYU_RS_LC\\stats\\native_space_LC")
stats_path <- paste("D:\\NYU_RS_LC\\stats\\native_space_LC")

smooth = c('smoothed', 'unsmoothed')
pup_type = c('pup_size', 'pup_deriv')


for (c_smooth in smooth){
  
  for (c_pup in pup_type){
    
    dat_path = paste(stats_path, c_smooth, c_pup, sep = '\\')
    dat_file = read.delim(paste(dat_path, 'LC_native_space_stat.csv', sep = '\\'), header = TRUE, sep = ',')
    
    # one-way t-tests
    stat.test <- 
      t.test(dat_file$con_stat,
             mu = 0) # Remove details
    
    
    print(paste('p value for t-test ', c_smooth, 'for', c_pup, 'is', stat.test[3][1], sep =" "))

    
    
  }
}
    