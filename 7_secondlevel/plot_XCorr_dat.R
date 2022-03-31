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
library(apa)

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
XCorr_path <- paste("E:\\NYU_RS_LC\\stats\\BS_correlations\\smoothed\\group_stats_Xcorr")


pup_type = c('pup_deriv')
roi = c("ACC", "OCC")
rois = c("LC", "VTA", "SN", "ACC", "DR", "MR", "BF_subl", "OCC")


p_val = list(numeric())
uber_collect_p <-list()
uber_collect_p <- append(uber_collect_p, list(p_val))


for (c_pup in pup_type){
  rm(TOTAL_df)
  total_ROIs = list(subj=character(),
                    roi=character(),
                    lag=factor(),
                    CC_both = numeric())
  uber_tota_ROIs = list()
  uber_tota_ROIs <- append(uber_tota_ROIs, list(total_ROIs))
  
  setEPS()                                             # Set postscript arguments
  postscript(paste(XCorr_path, "pup_deriv_group_XcorrPLOTS_cortex.pdf",  sep='\\'),  width=6, height=4)  
  par(mfrow=c(2,4),
      oma = c(5,4,0,0) + 0.8,
      mar = c(0,0,1,1) + 0.5)
  i=0
  for (c_roi in rois){
    i + 1
    print(c_roi)
    
    #make output dir
    output_plots_dir = paste(XCorr_path, c_pup, 'plots', sep='\\')
    dir.create(file.path(output_plots_dir), showWarnings = FALSE)

    
    # load in data and rename column
    day1 <- read.delim(paste(XCorr_path, c_pup, paste("XCorr_stat_ses-day1_", c_roi, '.csv',  sep = ''), 
                                    sep = '\\'), header = TRUE, sep = ',')
    names(day1)[names(day1) == 'CC'] <- 'CC_D1'
    day2 <- read.delim(paste(XCorr_path, c_pup, paste("XCorr_stat_ses-day2_", c_roi, '.csv',  sep = ''), 
                             sep = '\\'), header = TRUE, sep = ',')
    names(day2)[names(day2) == 'CC'] <- 'CC_D2'
    
   
    
    day1$lag <-as.factor(day1$lag)
    day2$lag <-as.factor(day2$lag)
    


    
    dat_all <- left_join(day1, day2, by = c('subj', 'lag'))
    dat_all$CC_ave =  rowMeans(dat_all[3:4], na.rm = TRUE)
    dat_all$ROI <- as.character(c_roi)
    dat_all$subj <- as.character(dat_all$subj)
    

    
    
    # get data into long format 
    labels = names(dat_all)
    # Select variables
    var_names = c("subj",
                  "lag",
                  "CC_D1", 
                  "CC_D2", 
                  "CC_ave", 
                  "ROI")
    
    dat = dat_all[,match(var_names,labels)]
    
    # Make data frame
    long_dat = data.frame(dat)
    
    # Make long data format [ csp_preTlapse:csm_stim_mean ]
    #long_dat = tidyr::gather(df_dat, value=Val, key=Names, P1:P6, factor_key=TRUE)
    
    
    
    names(long_dat)[names(long_dat) == 'CC_D1'] <- 'CC_day1'
    names(long_dat)[names(long_dat) == 'CC_D2'] <- 'CC_day2'
    names(long_dat)[names(long_dat) == 'CC_ave'] <- 'CC_both'
    
#    long_dat<-long_dat %>%
#      group_by(subj) %>%
#      mutate(corrected_corr = CC_both - mean(CC_both))
    
    P_mods = c("-4",
               '-3',
               "-2", 
               "-1", 
               "0", 
               "1", 
               "2",
               "3",
               "4")
    for (c_mod in P_mods) { 
      
      dat_model = subset(long_dat, lag == c_mod)
      
      # one-way t-tests
      stat.test_p1 <- 
        t.test(dat_model$CC_both,
               mu = 0) # Remove details
      
      #t_apa(stat.test_p1)
      
      print(paste('p value for Z corr at lag ', c_mod, 'is', t_apa(stat.test_p1), sep =" "))
      p_val$p_value <- as.numeric(as.character(unlist(stat.test_p1[3][1])))
      uber_collect_p <- append(uber_collect_p, list(p_val))
      
    } 
    
    

#    long_dat <- long_dat %>% 
#    mutate(lag = case_when(
#      lag == -3 ~ 't-3',
#      lag == -2 ~ 't-2',
#      lag == -1 ~ 't-1',
#      lag == 0 ~ 't',
#      lag == 1 ~ 't+1',
#      lag == 2 ~ 't+2',
#      lag == 3 ~ 't+3'))
    


    
    
    total_ROIs$subj <- long_dat$subj
    total_ROIs$roi <- long_dat$ROI
    total_ROIs$lag <- long_dat$lag
    total_ROIs$CC_both <- long_dat$CC_both
    
    uber_tota_ROIs <- append(uber_tota_ROIs, list(total_ROIs))
    
    total_ROIs_uber <- append(total_ROIs, long_dat)
    long_dat_fin <- subset(long_dat, !is.na(CC_both))
    
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
    } else if (c_roi == 'BF_subl') {
      colour_plot = 'goldenrod1'
    } else if (c_roi == 'ACC') {
      colour_plot = 'tan3'
    } else if (c_roi == 'OCC') {
      colour_plot = 'grey'
    }
    
    # plot1 <- long_dat_fin %>%
    #  # mutate(lag = fct_relevel(lag, "t-3", "t-2", "t-1", "t", "t+1", "t+2", "t+3")) %>%
    #   ggplot(aes(x = lag, y = corrected_corr)) +
    #   #geom_point(aes(color=ROI), size=2, alpha=.4) +
    #   geom_jitter(width = 0.1,  aes(color=colour_plot), size=2, alpha=0.4) + 
    #   #geom_line(aes(color=session, group=subject), size=.3, color="black", alpha=.4) +
    #   #scale_y_continuous(limits=c(-3, 3)) +
    #   #scale_y_continuous(limits=c((min(long_dat_fin$con_stat)*1.1), (max(long_dat_fin$con_stat)*1.1))) +
    #   stat_summary(fun="mean",colour = "black", size = 2,geom = "point") +
    #   stat_summary(fun.data="mean_se",colour = "black", width=0,size = 1,geom = "errorbar") +
    #   scale_colour_manual(values = colour_plot) +
    #   mytheme                 +                                 
    #   labs(title = "", x = "", y = "")   +
    #   theme(legend.position = "none") +
    #   geom_hline(yintercept=0, linetype="dashed", color = "black") +
    #   ylim(-0.50, 0.50) +
    #   geom_violin(alpha = 0, aes(color=colour_plot))
    # 
    # print(plot1)
    # ggsave(paste(output_plots_dir, paste("CrossCorr_", c_roi, '.png',  sep = ''), sep='\\'), plot1)
    
    
    AVE_long_dat_fin <- describeBy(long_dat_fin$CC_both, group = list(long_dat_fin$lag), mat = TRUE)
    names(AVE_long_dat_fin)[c(2)] <- c("lag")
    AVE_long_dat_fin$corr_max <- AVE_long_dat_fin$mean + AVE_long_dat_fin$se
    AVE_long_dat_fin$corr_min <- AVE_long_dat_fin$mean - AVE_long_dat_fin$se
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
    x1  = factor(AVE_long_dat_fin$lag, levels=c(-4,-3,-2,-1, 0, 1, 2, 3, 4))
  
    
    if (i == 4 | 8) {
      with(AVE_long_dat_fin, 
           plot(
             lag, mean, type="l",
             ylim = c(-0.10, 0.10),
             xlab = "",
             ylab = "",
             main=c_roi,
             panel.first=polygon(c(lag,rev(lag)), c(ses[,1],rev(ses[,2])), 
                                 border=NA, 
                                 grid(NULL, NULL),
                                 col=colour_plot)))
      
    } else {
      with(AVE_long_dat_fin, 
           plot(
             lag, mean, type="l",
             ylim = c(-0.04, 0.04),
             xlab = "",
             ylab = "",
             main=c_roi,
             panel.first=polygon(c(lag,rev(lag)), c(ses[,1],rev(ses[,2])), 
                                 border=NA, 
                                 grid(NULL, NULL),
                                 col=colour_plot)))
    }
    
    
    abline(a=NULL, b=NULL, h=NULL, v=NULL)
    abline(h=0, col="black",lwd=1, lty=2)
    abline(v=0, col="black", lwd=1, lty=2)
  }    
  title(xlab = "lag (s)",
        ylab = "Cross-correlation (normalized)",
        outer = TRUE, line = 3)
 
  dev.off()
  
  
}


# bind p-vals and correct for number of tests (per pupil dynamic)
df_pval <- as.data.frame(unlist(uber_collect_p))
df_pval_corr <- p.adjust(df_pval$`unlist(uber_collect_p)`, method = "fdr", n = length(df_pval$`unlist(uber_collect_p)`))

