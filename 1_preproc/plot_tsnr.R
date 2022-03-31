rm(list= ls(all.names = TRUE))
gc()

library(ggplot2)
library(dplyr)
library(Hmisc)
library(tidyverse)
# ggplot theme
mytheme <- theme(panel.grid.major = element_blank(), 
                 panel.grid.minor = element_blank(),
                 panel.background = element_blank(), 
                 axis.line = element_line(size=1, colour = "black"),
                 text = element_text(size=22,colour = "black"),
                 strip.background = element_blank(),
                 axis.title.x=element_blank(), 
                 #axis.text.x=element_blank(), 
                 axis.ticks.x=element_blank(),
                 legend.title = element_blank())


setwd("E:\\NYU_RS_LC\\stats\\")
tsnr_path <- paste("E:\\NYU_RS_LC\\stats\\tsnr\\groupstats")

day = c('ses-day1', 'ses-day2')

for (c_day in day){
  # load in data and rename column
  TSNR_dat <- read.delim(paste(tsnr_path, c_day, paste('tSNR.csv',sep=""),
                                    sep = '\\'), header = TRUE, sep = ',')
  
  TSNR_dat <- subset(TSNR_dat, subj != 'MRI_FCWML044' & subj != 'MRI_FCWML145')
 # rename columns
  colnames(TSNR_dat)[2] <- 'LC'
  colnames(TSNR_dat)[3] <- 'DR'
  colnames(TSNR_dat)[4] <- 'MR'
  colnames(TSNR_dat)[5] <- 'VTA'
  colnames(TSNR_dat)[6] <- 'SN'
  colnames(TSNR_dat)[7] <- 'BF'
  colnames(TSNR_dat)[8] <- 'ACC'
  colnames(TSNR_dat)[9] <- 'OCC'
  
  # get data into long format 
  labels = names(TSNR_dat)
  # Select variables
  var_names = c("subj",
                "LC",
                'DR',
                "MR", 
                "VTA", 
                "SN",
                "BF",
                "OCC", 
                "ACC")
  
  dat = TSNR_dat[,match(var_names,labels)]
  
  # Make data frame
  df_dat = data.frame(dat)
  
  # Make long data format [ csp_preTlapse:csm_stim_mean ]
  long_dat = tidyr::gather(df_dat, value=Val, key=Names, LC:ACC, factor_key=TRUE)
  
  names(long_dat)[names(long_dat) == 'Names'] <- 'ROI'
  names(long_dat)[names(long_dat) == 'Val'] <- 'tSNR'
  
  long_dat$ROI <- as.factor(long_dat$ROI)
  
  long_dat_summary <- describeBy(long_dat$tSNR, 
                                 group = list(long_dat$ROI), mat = TRUE)
  
  plot1 <-subset(long_dat, !is.na(tSNR)) %>%
    mutate(ROI = fct_relevel(ROI, "LC", "VTA", "SN", "DR", "MR", "BF", "ACC", "OCC")) %>%
    ggplot(aes(x = ROI, y = tSNR, fill = ROI)) +
    #geom_point(aes(color=ROI), size=2, alpha=.4) +
    geom_jitter(width = 0.1, aes(color=ROI), size=2, alpha=1) + 
    #geom_line(aes(color=session, group=subject), size=.3, color="black", alpha=.4) +
    scale_y_continuous(limits=c(0, 120)) +
    #scale_y_continuous(limits=c((min(long_dat_fin$con_stat)*1.1), (max(long_dat_fin$con_stat)*1.1))) +
    stat_summary(fun="mean",colour = "black", size = 4,geom = "point", alpha=1) +
    stat_summary(fun.data="mean_se",colour = "black", width=0,size = 1,geom = "errorbar", alpha=1) +
    scale_color_brewer(palette="Dark2") +
    mytheme                 +                                 
    labs(title = "", x = "", y = "tSNR")   +
    theme(legend.position = "none") 
  
  ggsave(paste(tsnr_path, 'plots', paste("tSNR_", c_day, '.eps',  sep = ''), sep='\\'),  height = 6, width = 4,plot1)
  
  
}
