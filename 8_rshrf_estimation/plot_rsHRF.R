# Author: Beth Lloyd
rm(list= ls(all.names = TRUE))
gc()

# libraries
library(ggplot2) # makes graphs
library(dplyr)
library(psych)
library(plyr)
library(ggpubr)
library(psycho)
library(rlist)
library(tidyverse)
library(data.table)
library(heemod)
library(phonTools)
library(ggsci)
library(apa)
library(rstatix)
library(Hmisc)
# ggplot theme
mytheme <- theme(panel.grid.major = element_blank(), 
                 panel.grid.minor = element_blank(),
                 panel.background = element_blank(), 
                 axis.line = element_line(size=1, colour = "black"),
                 text = element_text(size=30,colour = "black"),
                 strip.background = element_blank())
                 #axis.title.x=element_blank(), 
                 #axis.text.x=element_blank(), 
                 #axis.ticks.x=element_blank(),
                 #legend.title = element_blank())
# -----------------------------------------------------------------------------------------------------

# SET PATHS

#home comp
setwd("F:\\NYU_RS_LC\\stats")
homepath = "F:\\NYU_RS_LC\\stats\\rsHRF"

basisfunc = c('1_canonical')#, '2_gammafuncs')
bf=basisfunc
for (bf in basisfunc) { 

  datapath = paste(homepath, 'groupstats', bf, sep =   "\\")
  save_folder = paste(homepath, 'groupstats', bf, 'plots\\', sep =   "\\")
  #which_day = c("day1", "day2")
  #i<-0
  
  #bothDays_dat = c()
  #bothDays_dat_TTP = c()
  #for (day_dat in which_day) { 
    #i<-i+1
    
    # stack both days: 
    # rsHRF_datad1  <- (paste(datapath, 'rsHRF_day1.csv', sep = '\\'))
    # rsHRF_datad2  <- (paste(datapath, 'rsHRF_day2.csv', sep = '\\'))
    # rsHRF_datad1 <- read.csv(rsHRF_datad1, header = TRUE, sep = ',')
    # rsHRF_datad1 <- as.data.frame(rsHRF_datad1)
    # rsHRF_datad2 <- read.csv(rsHRF_datad2, header = TRUE, sep = ',')
    # rsHRF_datad2 <- as.data.frame(rsHRF_datad2)
    #--- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    #----PLOT HRF------------------------------------------
    #--- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    
    
    # #input data 
    # if (i == 1) {
    #   rsHRF_data  <- (paste(datapath, 'rsHRF_day1.csv', sep = '\\'))
    # } else if (i ==2) {
    #   rsHRF_data  <- (paste(datapath, 'rsHRF_day2.csv', sep = '\\'))
    # }
  rsHRF_data  <- (paste(datapath, 'rsHRF_both_days.csv', sep = '\\'))
  rsHRF_data <- read.csv(rsHRF_data, header = TRUE, sep = ',')
  rsHRF_data <- as.data.frame(rsHRF_data)
  
  names(rsHRF_data)[names(rsHRF_data) == "BF_subl_roi"] <- "BF_roi"

  # Get info
  labels = names(rsHRF_data)
  # Select variables
  var_names = c("subj",
                "time",
                "DR_roi",
                "MR_roi",
                "VTA_roi",
                "ACC_roi",
                "LC_roi",
                "SN_roi", 
                "OCC_roi",
                "BF_sept_roi",
                "BF_roi")
  dat = rsHRF_data[,match(var_names,labels)]
  
  # Make data frame
  df_dat = data.frame(dat)
  
  # Make long data format [ csp_preTlapse:csm_stim_mean ]
  long_dat = tidyr::gather(df_dat, value=Val, key=Names, DR_roi:BF_roi, factor_key=TRUE)
  
  
  # Add variables and change names 
  names(long_dat) = c("subj","time", "ROI","signal")
  long_dat$ROI <- str_sub(long_dat$ROI, 1, -5)
  #have to do this:
  long_dat$time <- as.character(long_dat$time)
  long_dat$time <- as.numeric(long_dat$time)
  long_dat$time <- as.factor(long_dat$time)
  long_dat$ROI <- as.factor(long_dat$ROI)
  
  # add column session: 
  #long_dat$session <- rep(i, times=length(long_dat$subj))
  
  #bothDays_dat <- bind_rows(bothDays_dat, long_dat)

  #long_dat_sum <- aggregate(long_dat$signal,list(long_dat$time, long_dat$ROI), mean)
  long_dat_sum <- describeBy(long_dat$signal, 
                               group = list(long_dat$time, long_dat$ROI), mat = TRUE)
  names(long_dat_sum)[c(2:3)] <- c("time", "ROI")
  
  
  # create 2 extra variables: ymin and ymax (mean +/- the standard error)
  long_dat_sum$sig_max <- long_dat_sum$mean + long_dat_sum$se
  long_dat_sum$sig_min <- long_dat_sum$mean - long_dat_sum$se
  
  long_dat_sum$time <- as.character(long_dat_sum$time)
  long_dat_sum$time <- as.numeric(long_dat_sum$time)
  
  
  # do not select the BF_sept --> 
  long_dat_sum <-  subset(long_dat_sum, ROI != "BF_sept")
  
  
  ## Plot timcourse - aggregate 
  g1 <-long_dat_sum %>%
    mutate(ROI = fct_relevel(ROI, "LC", "VTA", "SN", "DR", "MR", "BF", "ACC", "OCC")) %>%
    ggplot(aes(x=time,y= mean, color = ROI, fill=ROI)) +
    geom_line(aes(color=ROI), size = 0.2) + 
    #geom_ribbon(aes(ymin=sig_min, ymax=sig_max), alpha=0.2, colour = NA) + 
    mytheme +
    ylab("Normalised BOLD response") +
    xlab("time (s)")  +
    scale_color_brewer(palette="Dark2") +
    #scale_colour_manual(values = c(green_col,grey_col)) +
    scale_x_continuous(limits=c(0,20))+
    #scale_linetype_manual(values=c("solid", "solid"))+
    theme(legend.title=element_blank()) +
    labs(title = "")+
    geom_hline(yintercept=0, linetype="dashed", color = "black", size = 0.2) +
    theme(legend.position = c(0.8, 0.8))
  
  #ggsave(paste(save_folder,"overlayed_HRF_", bf, "_", day_dat, ".png", sep=""), g1, width = 8, height = 4)
  ggsave(paste(save_folder,"overlayed_HRF_", bf, "_both_days.eps", sep=""), g1, width = 8, height = 4)
  
  long_dat$time <- as.character(long_dat$time)
  long_dat$time <- as.numeric(long_dat$time)
  long_dat$subj <- substr(long_dat$subj, nchar(long_dat$subj) - 3 + 1, nchar(long_dat$subj))
  long_dat$subj <- as.factor(long_dat$subj)
  
  
  ## Plot timcourse - facet wrap 
  g2 <-long_dat %>%
    mutate(ROI = fct_relevel(ROI, "LC", "VTA", "SN", "DR", "MR", "BF", "ACC", "OCC")) %>%
    ggplot(aes(x=time,y= signal, color = ROI)) +
    geom_line(aes(color=ROI), size = 0.8) + 
    #geom_ribbon(alpha=0.2) + 
    mytheme +
    ylab("Normalised BOLD response") +
    xlab("time (s)")  +
    scale_color_brewer(palette="Dark2") +
    scale_y_continuous(breaks = c(0,1))+
    scale_x_continuous(breaks = c(0,15, 30))+
    #scale_linetype_manual(values=c("solid", "solid"))+
    theme(legend.title=element_blank()) +
    labs(title = "") + 
    facet_wrap(~subj)+
    geom_hline(yintercept=0, linetype="dashed", color = "black")
  
  #ggsave(paste(save_folder,"subj_overlayed_HRF_", bf, "_", day_dat, ".png", sep=""), g2, width = 10, height = 8)
  #ggsave(paste(save_folder,"subj_overlayed_HRF_", bf, "_both_days.eps", sep=""), g2, width = 15, height = 10)
  
  ## Plot timcourse - facet wrap 
  g3 <-long_dat %>%
    mutate(ROI = fct_relevel(ROI, "LC", "VTA", "SN", "DR", "MR", "BF", "ACC", "OCC")) %>%
    ggplot(aes(x=time,y= signal, color = subj)) +
    geom_line(aes(color=subj), size = 0.8) + 
    #geom_ribbon(alpha=0.2) + 
    mytheme +
    ylab("Normalised BOLD response") +
    xlab("time (s)")  +
    scale_color_brewer(palette="Dark2") +
    #scale_linetype_manual(values=c("solid", "solid"))+
    #scale_y_continuous(limits=c(-0.2,1.2))+
    theme(legend.title=element_blank()) +
    labs(title = "") + 
    facet_wrap(~ROI) +
    theme(legend.position = "none") +
    geom_hline(yintercept=0, linetype="dashed", color = "black")
  
  g3a <- g3 + stat_summary(aes(group=ROI), fun.y=mean, geom="line", colour="black", size=1)
  #ggsave(paste(save_folder,"ROI_overlayed_HRF_", bf, "_", day_dat, ".png", sep=""), g3a, width = 8, height = 8)
  #ggsave(paste(save_folder,"ROI_overlayed_HRF_", bf, "_both_days.png", sep=""), g3a, width = 8, height = 8)
  
  #--- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
  #----PLOT TIME TO PEAK------------------------------------------
  #--- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
  
  
  #input data
  if (i == 1) {
    TTP_data  <- (paste(datapath, 'rsHRF_TTP_day1.csv', sep = '\\'))
  } else if (i ==2) {
    TTP_data  <- (paste(datapath, 'rsHRF_TTP_day2.csv', sep = '\\'))
  }
  
  TTP_data  <- (paste(datapath, 'rsHRF_TTP_both_days.csv', sep = '\\'))
  TTP_data <- read.csv(TTP_data, header = TRUE, sep = ',')
  TTP_data <- as.data.frame(TTP_data)
  
  
  # rename BF 
  names(TTP_data)[names(TTP_data) == "BF_subl_roi"] <- "BF_roi"
  
  
  # Get info
  labels = names(TTP_data)
  # Select variables
  var_names = c("subj",
                "DR_roi",
                "MR_roi",
                "VTA_roi",
                "ACC_roi",
                "LC_roi",
                "SN_roi", 
                "OCC_roi",
                "BF_sept_roi",
                "BF_roi")
  dat = TTP_data[,match(var_names,labels)]
  
  # Make data frame
  df_dat = data.frame(dat)
  
  # Make long data format [ csp_preTlapse:csm_stim_mean ]
  long_dat = tidyr::gather(df_dat, value=Val, key=Names, DR_roi:BF_roi, factor_key=TRUE)
  
  # Add variables and change names 
  names(long_dat) = c("subj", "ROI","time")
  long_dat$ROI <- str_sub(long_dat$ROI, 1, -5)
  
  
  # exclude subj 44 and 145
  long_dat <- subset(long_dat, subj != 'MRI_FCWML044')
  long_dat <- subset(long_dat, subj != 'MRI_FCWML145')
  
  # do not select the BF_sept --> 
  long_dat <-  subset(long_dat, ROI != "BF_sept")
  
  # add column session: 
  #long_dat$session <- rep(i, times=length(long_dat$subj))
  
  #bothDays_dat_TTP <- bind_rows(bothDays_dat_TTP, long_dat)
  #bothDays_dat_TTP$time <- as.numeric(bothDays_dat_TTP$time)
  #bothDays_dat_TTP$session <- as.factor(bothDays_dat_TTP$session)
  #ROIs = c('LC', 'VTA', 'SN', 'DR', 'MR', 'ACC', 'OCC')
  
  # for (roi in ROIs) {
  #   roi_dat = subset(bothDays_dat_TTP, ROI == roi)
  # 
  #   
  #   mod <- lm(roi_dat$time ~ roi_dat$session)
  #   print(paste('model summary for ', roi))
  #   print(summary(mod))
  # 
  #   
  #   plot_1 <- ggplot(data=roi_dat, aes(x = session, y = time, fill = session)) +
  #     #geom_point(aes(color=ROI), size=2, alpha=.4) +
  #     geom_jitter(width = 0.1, aes(color=session), size=2, alpha=.4) + 
  #     geom_line(aes(color=session, group=subj), size=.3, color="black", alpha=.2) +
  #     stat_summary(fun="mean",colour = "black", size = 2,geom = "point") +
  #     stat_summary(fun.data="mean_se",colour = "black", width=0,size = 1,geom = "errorbar") +
  #     scale_colour_manual(values = c("seagreen", "tomato3")) +
  #     stat_summary(aes(y = time,group = 1), fun = mean, geom="line", size=1) +
  #     mytheme                 +                                 
  #     labs(title = "", x = "session", y = "time-to-peak (s)")   +
  #     theme(legend.position = "none")
  #   
  #   ggsave(paste(save_folder,"ROI_TTP_", roi, "_compare_days.png", sep=""), plot_1, width = 4, height = 5)
  #   
  #   
  # }
  
  
  
  
  # check TTP for differences 
  
  # descriptive statistics:
  long_dat %>%
    group_by(ROI) %>%
    summarise_at(vars(time), list(name = mean))

  #------------- ANOVAS 
  # check for main effect of model on T-stat
  m1 = afex::aov_ez("subj", "time", 
                    long_dat, 
                    within = c("ROI"))
  summary(m1)
  
  
  
  #-------------- follow up t-test 
  
  # Pairwise comparisons between models
  # Paired t-test is used because we have repeated measures by time
  stat.test <- long_dat %>%
    pairwise_t_test(
      time ~ ROI, paired = TRUE,
      p.adjust.method = "fdr"
    ) %>%
    select(-df, -statistic, -p) # Remove details
  stat.test
  
 
  g4 <- long_dat %>%
    mutate(ROI = fct_relevel(ROI, "LC", "VTA", "SN", "DR", "MR", "BF", "ACC", "OCC")) %>%
    ggplot(aes(x = ROI, y = time, fill = ROI)) +
    #geom_point(aes(color=ROI), size=2, alpha=.4) +
    geom_jitter(width = 0.1, aes(color=ROI), size=1.5, alpha=1) + 
    #geom_line(aes(color=session, group=subject), size=.3, color="black", alpha=.4) +
    scale_y_continuous(limits=c(3, 8.3)) +
    #scale_y_continuous(limits=c((min(long_dat_fin$con_stat)*1.1), (max(long_dat_fin$con_stat)*1.1))) +
    stat_summary(fun="mean",colour = "black", size = 4,geom = "point") +
    stat_summary(fun.data =mean_se,colour = "black", width=0,size = 1,geom = "errorbar") +
    scale_color_brewer(palette="Dark2") +
    mytheme                 +                                 
    labs(title = "", x = "", y = "time to peak (s)")   +
    theme(legend.position = "none") 
    #geom_violin(alpha = 0, aes(color=ROI, fill = ROI))

  
  
  #geom_hline(yintercept=0, linetype="dashed", color = "black")
  #ggsave(paste(save_folder,"ROI_TTP_", bf, "_", day_dat, ".png", sep=""), g4, width = 8, height = 8)
  ggsave(paste(save_folder,"ROI_TTP_", bf, "_both_days.eps", sep=""), g4, width = 6, height = 5)
    
  
  # group by ROI and get the median TTP for each ROI 
  median_split <- describeBy(long_dat$time,
             group = list(long_dat$ROI), mat = TRUE)
  names(median_split[1]) <- "ROI" 
  
  ACC_median<- subset(median_split, group1 == 'ACC')
  DR_median<- subset(median_split, group1 == 'DR')
  LC_median<- subset(median_split, group1 == 'LC')
  MR_median<- subset(median_split, group1 == 'MR')
  OCC_median<- subset(median_split, group1 == 'OCC')
  SN_median<- subset(median_split, group1 == 'SN')
  VTA_median<- subset(median_split, group1 == 'VTA')
  
  #get the dataset of each ROI and compare with the median TTP 
  ACC_dat<- subset(long_dat, ROI == 'ACC')
  DR_dat<- subset(long_dat, ROI == 'DR')
  LC_dat<- subset(long_dat, ROI == 'LC')
  MR_dat<- subset(long_dat, ROI == 'MR')
  OCC_dat<- subset(long_dat, ROI == 'OCC')
  SN_dat<- subset(long_dat, ROI == 'SN')
  VTA_dat<- subset(long_dat, ROI == 'VTA')
  
  
  
  subj_high_ACC <- c()
  subj_low_ACC <- c()
  count=1
  for (i in ACC_dat$subj){
    if (ACC_dat$time[count] > ACC_median$median){
      subj_high_ACC <- c(subj_high_ACC, i)
    } else if (ACC_dat$time[count] <= ACC_median$median){
      subj_low_ACC <- c(subj_low_ACC, i)
    }
    count = count + 1
  }
  
  

  subj_high_LC <- c()
  subj_low_LC <- c()
  count=1
  for (i in LC_dat$subj){
    if (LC_dat$time[count] > LC_median$median){
      subj_high_LC <- c(subj_high_LC, i)
    } else if (LC_dat$time[count] <= LC_median$median){
      subj_low_LC <- c(subj_low_LC, i)
    }
    count = count + 1
  }
  
  
  
  
  # plots over both days

  bothDays_dat$time <- as.character(bothDays_dat$time)
  bothDays_dat$time <- as.numeric(bothDays_dat$time)
  bothDays_dat$subj <- substr(bothDays_dat$subj, nchar(bothDays_dat$subj) - 3 + 1, nchar(bothDays_dat$subj))
  bothDays_dat$subj <- as.factor(bothDays_dat$subj)

  bothDays_dat$session <- as.factor(bothDays_dat$session)

  
  # subset 6 subjects
  bothDays_dat_6subj <- subset(bothDays_dat, 
                               subj == "162" | subj == "011" | subj == "015" | subj == "255" | subj == "320" | subj == "328")
  bothDays_dat_werid_subjs <- subset(bothDays_dat, 
                               subj == "042" | subj == "104" | subj == "158")
  
  roi <- c("DR", "MR", "VTA", "ACC", "LC", "SN",  "OCC")
 
  for (i in roi) {

    dat_roi <- subset(bothDays_dat_werid_subjs, ROI == i)

    ## Plot timcourse - facet wrap
    g_roi <- dat_roi %>%
      ggplot(aes(x=time,y= signal, color = session)) +
      geom_line(aes(color=session), size = 0.8) +
      #geom_ribbon(alpha=0.2) +
      mytheme +
      ylab("Normalised BOLD response") +
      xlab("time (s)")  +
      scale_colour_manual(values = c('indianred1','seagreen')) +
      #scale_y_continuous(limits=c(-0.2,1.2))+
      #scale_linetype_manual(values=c("solid", "solid"))+
      #theme(legend.title=element_blank()) +
      labs(title = "") +
      facet_wrap(~subj)+
      geom_hline(yintercept=0, linetype="dashed", color = "black")
    
   
    ggsave(paste(save_folder,"bothDays_offsubjs_", i, ".png", sep=""), g_roi, width = 8, height = 8)
  }
}








