rm(list= ls(all.names = TRUE))
gc()

library(ggplot2)
library(dplyr)
library(Hmisc)
library(ggplot2) # makes graphs
library(dplyr)
library(psych)
library(plyr)
library(ggpubr)
library(psycho)
library(rlist)
library(tidyverse)
library(data.table)
library(lme4)
# ggplot theme
mytheme <- theme(panel.grid.major = element_blank(), 
                 panel.grid.minor = element_blank(),
                 panel.background = element_blank(), 
                 axis.line = element_line(size=1, colour = "black"),
                 text = element_text(size=26,colour = "black"),
                 strip.background = element_blank(),
                 #axis.title.x=element_blank(), 
                 #axis.text.x=element_blank(), 
                 axis.ticks.x=element_blank(),
                 legend.title = element_blank())

setwd("E:\\NYU_RS_LC\\stats\\BS_correlations")
XCorr_path <- paste("E:\\NYU_RS_LC\\stats\\BS_correlations\\smoothed\\group_stats_Xspect")


pup_type = c('pup_size')
rois = c("LC", "VTA", "SN", "ACC", "DR", "MR", "BF", "OCC")


rm(TOTAL_df)
total_ROIs = list(subj=character(),
                  roi=character(),
                  lag=factor(),
                  CC_both = numeric())
uber_tota_ROIs = list()
uber_tota_ROIs <- append(uber_tota_ROIs, list(total_ROIs))

setEPS()                                             # Set postscript arguments
postscript(paste(XCorr_path, "group_XspectPLOTS_cortex.eps",  sep='\\'),  width=6, height=4)  
par(mfrow=c(2,4),
    oma = c(5,4,0,0) + 0.8,
    mar = c(0,0,1,1) + 0.5)
i=0
for (c_roi in rois){
  i + 1
  print(c_roi)
  
  #make output dir
  output_plots_dir = paste(XCorr_path, pup_type, 'plots', sep='\\')
  dir.create(file.path(output_plots_dir), showWarnings = FALSE)
  
  
  # load in data and rename column
  day1 <- read.delim(paste(XCorr_path, pup_type, paste("XSpect_stat_ses-day1_", c_roi, '.csv',  sep = ''), 
                           sep = '\\'), header = TRUE, sep = ',')
  names(day1)[c(1:3)] <- c("subj", "freq", "power")
  day2 <- read.delim(paste(XCorr_path, pup_type, paste("XSpect_stat_ses-day2_", c_roi, '.csv',  sep = ''), 
                           sep = '\\'), header = TRUE, sep = ',')
  names(day2)[c(1:3)] <- c("subj", "freq", "power")
  
  
  day1$freq <-as.factor(day1$freq)
  day2$freq <-as.factor(day2$freq)
  
  
  
  
  dat_all <- left_join(day1, day2, by = c('subj', 'freq'))
  dat_all$power_ave =  rowMeans(dat_all[3:4], na.rm = TRUE)
  dat_all$ROI <- as.character(c_roi)
  dat_all$subj <- as.character(dat_all$subj)
  
  
  
  
  # get data into long format 
  labels = names(dat_all)
  # Select variables
  var_names = c("subj",
                "freq",
                "power.x", 
                "power.y", 
                "power_ave", 
                "ROI")
  
  dat = dat_all[,match(var_names,labels)]
  
  # Make data frame
  long_dat = data.frame(dat)
  
  # Make long data format [ csp_preTlapse:csm_stim_mean ]
  #long_dat = tidyr::gather(df_dat, value=Val, key=Names, P1:P6, factor_key=TRUE)
  
  
  
  names(long_dat)[names(long_dat) == 'power.x'] <- 'power_day1'
  names(long_dat)[names(long_dat) == 'power.y'] <- 'power_day2'
  names(long_dat)[names(long_dat) == 'power_ave'] <- 'power_ave'
  
  long_dat<-long_dat %>%
    group_by(subj) %>%
    mutate(corrected_power = power_ave - mean(power_ave))
  


  
  if (c_roi == 'LC') {
    colour_plot = '#00C1AA'
  } else if (c_roi == 'VTA') {
    colour_plot = '#ED8141' 
  } else if (c_roi == 'SN') {
    colour_plot = '#9590FF' 
  } else if (c_roi == 'DR') {
    colour_plot = '#FF62BC' 
  } else if (c_roi == 'MR') {
    colour_plot = '#5BB300'
  } else if (c_roi == 'BF') {
    colour_plot = 'goldenrod1'
  } else if (c_roi == 'ACC') {
    colour_plot = 'tan3'
  } else if (c_roi == 'OCC') {
    colour_plot = 'grey'
  }
  
 
  
  long_dat <- subset(long_dat, !is.na(corrected_power))
  AVE_long_dat_fin <- describeBy(long_dat$corrected_power, group = list(long_dat$freq), mat = TRUE)
  names(AVE_long_dat_fin)[c(2)] <- c("freq")
  
  # AVE_long_dat_fin$lag <- as.factor(AVE_long_dat_fin$lag)
  # 
  # AVE_long_dat_fin$lag <- as.numeric(AVE_long_dat_fin$lag)
  # AVE_long_dat_fin <- AVE_long_dat_fin %>% 
  #   mutate(lag_plot = case_when(
  #     lag == 1 ~ -4,
  #     lag == 2 ~ -3,
  #     lag == 3 ~ -2,
  #     lag == 4 ~ -1,
  #     lag == 5 ~ 0,
  #     lag == 6 ~ 1,
  #     lag == 7 ~ 2,
  #     lag == 8 ~ 3,
  #     lag == 9 ~ 4))
  
  # Make cross corr plots here!
  ses <- AVE_long_dat_fin$mean + outer(AVE_long_dat_fin$se, c(1,-1))

  
  
  with(AVE_long_dat_fin, 
       plot(
         freq, mean, type="l",
         ylim = c(-0.02, 0.02),
         xlab = "",
         ylab = "",
         main=c_roi,
         panel.first=polygon(c(freq,rev(freq)), c(ses[,1],rev(ses[,2])), 
                             border=NA, 
                             grid(NULL, NULL),
                             col=colour_plot)))
    
  
  # abline(a=NULL, b=NULL, h=NULL, v=NULL)
  # abline(h=0, col="black",lwd=1, lty=2)
  # abline(v=0, col="black", lwd=1, lty=2)
}    
title(xlab = "Frequency (Hz)",
      ylab = "Magnitude-squared coherence (A.U.)",
      outer = TRUE, line = 3)

dev.off()


TOTAL_df <- bind_rows(uber_tota_ROIs)
TOTAL_df$roi <- as.factor(TOTAL_df$roi)
TOTAL_df$lag <- as.numeric(TOTAL_df$lag)
# create 2 extra variables: ymin and ymax (mean +/- the standard error)

AVE_TOTAL_df <- describeBy(TOTAL_df$CC_both, group = list(TOTAL_df$roi, TOTAL_df$lag), mat = TRUE)
names(AVE_TOTAL_df)[c(2:3)] <- c("ROI", "lag")
AVE_TOTAL_df$corr_max <- AVE_TOTAL_df$mean + AVE_TOTAL_df$se
AVE_TOTAL_df$corr_min <- AVE_TOTAL_df$mean - AVE_TOTAL_df$se
AVE_TOTAL_df$ROI <- as.factor(AVE_TOTAL_df$ROI)
AVE_TOTAL_df$lag <- as.factor(AVE_TOTAL_df$lag)
#AVE_TOTAL_df$time <- as.numeric(AVE_TOTAL_df$lag)

AVE_TOTAL_df$lag <- as.numeric(AVE_TOTAL_df$lag)
AVE_TOTAL_df <- AVE_TOTAL_df %>% 
  mutate(lag_plot = case_when(
    lag == 1 ~ -4,
    lag == 2 ~ -3,
    lag == 3 ~ -2,
    lag == 4 ~ -1,
    lag == 5 ~ 0,
    lag == 6 ~ 1,
    lag == 7 ~ 2,
    lag == 8 ~ 3,
    lag == 9 ~ 4))

AVE_TOTAL_df_CORT <- subset(AVE_TOTAL_df, ROI == 'ACC' | ROI =='OCC')
AVE_TOTAL_df_BS <- subset(AVE_TOTAL_df, ROI == 'LC' | ROI =='VTA' | ROI == 'SN' | ROI == 'MR' | ROI == 'DR'| ROI == "BF_subl")

gg2 <- AVE_TOTAL_df_BS %>%
  #mutate(lag = fct_relevel(lag, "t-3", "t-2", "t-1", "t", "t+1", "t+2", "t+3")) %>%
  mutate(ROI = fct_relevel(ROI,  "LC", "VTA", "SN", "DR", "MR", "BF_subl")) %>%
  ggplot(aes(x=lag_plot,y= mean,  ymin=corr_min, ymax=corr_max, color = ROI)) +
  geom_point(aes(color=ROI), size=0.6, alpha=1) + 
  geom_line(aes(color=ROI, group=ROI), size=0.6,  alpha=1) +
  geom_errorbar(aes(ymin=corr_min, ymax=corr_max), width=0,
                position=position_dodge(0)) +
  #stat_summary(fun.data="mean_se",colour = "black", width=0,size = 1,geom = "errorbar") +
  #stat_summary(fun="mean",colour = "black", size = 2,geom = "point") +
  mytheme +
  ylab("Cross-correlation (normalized)") +
  xlab("lag (s)")  +
  scale_color_brewer(palette="Dark2") +
  geom_hline(yintercept=0, linetype="dashed", color = "black") +
  geom_vline(xintercept=0, linetype="dashed", color = "black") +
  #scale_linetype_manual(values=c("solid", "dotted", "solid", "dotted"))+
  scale_x_continuous(breaks = c(-4,-3,-2,-1, 0, 1, 2, 3, 4),
                     labels =c('-8s', '-6s', '-4s', '-2s', '0s', '+2s', '+4s', '+6s', '+8s'))+
  theme(legend.title=element_blank())

ggsave(paste(output_plots_dir, paste("ave_CrossCorr_BS_", c_pup, '.eps',  sep = ''), sep='\\'), width = 8, height = 6, gg2)


gg3 <- AVE_TOTAL_df_CORT %>%
  #mutate(lag = fct_relevel(lag, "t-3", "t-2", "t-1", "t", "t+1", "t+2", "t+3")) %>%
  mutate(ROI = fct_relevel(ROI,  "ACC", "OCC")) %>%
  ggplot(aes(x=lag_plot,y= mean,  ymin=corr_min, ymax=corr_max, color = ROI)) +
  geom_point(aes(color=ROI), size=0.6, alpha=1) + 
  geom_line(aes(color=ROI, group=ROI), size=0.6,  alpha=1) +
  geom_errorbar(aes(ymin=corr_min, ymax=corr_max), width=0,
                position=position_dodge(0)) +
  #stat_summary(fun.data="mean_se",colour = "black", width=0,size = 1,geom = "errorbar") +
  #stat_summary(fun="mean",colour = "black", size = 2,geom = "point") +
  mytheme +
  scale_colour_manual(values = c("#FFB547FF", "tan3")) +
  ylab("Cross-correlation (normalized)") +
  xlab("lag (s)")  +
  geom_hline(yintercept=0, linetype="dashed", color = "black") +
  geom_vline(xintercept=0, linetype="dashed", color = "black") +
  #scale_linetype_manual(values=c("solid", "dotted", "solid", "dotted"))+
  scale_x_continuous(breaks = c(-4,-3,-2,-1, 0, 1, 2, 3, 4),
                     labels =c('-8s', '-6s', '-4s', '-2s', '0s', '+2s', '+4s', '+6s', '+8s'))+
  theme(legend.title=element_blank())

ggsave(paste(output_plots_dir, paste("ave_CrossCorr_CORT_", c_pup, '.eps',  sep = ''), sep='\\'), width = 8, height = 6, gg3)

