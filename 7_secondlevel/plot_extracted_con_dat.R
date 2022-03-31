rm(list= ls(all.names = TRUE))
gc()

library(ggplot2)
library(dplyr)
library(Hmisc)

# ggplot theme
mytheme <- theme(panel.grid.major = element_blank(), 
                 panel.grid.minor = element_blank(),
                 panel.background = element_blank(), 
                 axis.line = element_line(size=1, colour = "black"),
                 text = element_text(size=14,colour = "black"),
                 strip.background = element_blank(),
                 axis.title.x=element_blank(), 
                 #axis.text.x=element_blank(), 
                 axis.ticks.x=element_blank(),
                 legend.title = element_blank())

setwd("D:\\NYU_RS_LC\\stats\\template_1st_level_pipelines")
conmap_path <- paste("D:\\NYU_RS_LC\\stats\\template_1st_level_pipelines")

smooth = c('smoothed', 'unsmoothed')
day = c('ses-day-1', 'ses-day-2')
pup_type = c('pup_size', 'pup_deriv')

for (c_sm in smooth){
  for (c_day in day){
    for (c_pup in pup_type){
      
      #make output dir
      output_plots_dir = paste("D:\\NYU_RS_LC\\stats", "ROI_analysis", c_sm, c_pup, sep='\\')
      
      # load in data and rename column
      conmap_DR_roi <- read.delim(paste(conmap_path, c_sm, 'DR_roi', 'groupstats', 
                                        c_day, c_pup, 'extract_stat', 'con_stat.csv', 
                                        sep = '\\'), header = TRUE, sep = ',')
      names(conmap_DR_roi)[names(conmap_DR_roi) == 'con0001_stat'] <- 'DR'
      
      conmap_MR_roi <- read.delim(paste(conmap_path, c_sm, 'MR_roi', 'groupstats', 
                                        c_day, c_pup, 'extract_stat', 'con_stat.csv', 
                                        sep = '\\'), header = TRUE, sep = ',')
      names(conmap_MR_roi)[names(conmap_MR_roi) == 'con0001_stat'] <- 'MR'
      
      conmap_VTA_roi <- read.delim(paste(conmap_path, c_sm, 'VTA_roi', 'groupstats', 
                                         c_day, c_pup, 'extract_stat', 'con_stat.csv', 
                                         sep = '\\'), header = TRUE, sep = ',')
      names(conmap_VTA_roi)[names(conmap_VTA_roi) == 'con0001_stat'] <- 'VTA'
      
      conmap_SN_roi <- read.delim(paste(conmap_path, c_sm, 'SN_roi', 'groupstats', 
                                        c_day, c_pup, 'extract_stat', 'con_stat.csv', 
                                        sep = '\\'), header = TRUE, sep = ',')
      names(conmap_SN_roi)[names(conmap_SN_roi) == 'con0001_stat'] <- 'SN'
      
      conmap_LC_roi <- read.delim(paste(conmap_path, c_sm, 'LC_roi', 'groupstats', 
                                        c_day, c_pup, 'extract_stat', 'con_stat.csv', 
                                        sep = '\\'), header = TRUE, sep = ',')
      names(conmap_LC_roi)[names(conmap_LC_roi) == 'con0001_stat'] <- 'LC'
      
      dat_all <- left_join(conmap_DR_roi, conmap_MR_roi, by = 'subj')
      dat_all <- left_join(dat_all, conmap_VTA_roi, by = 'subj')
      dat_all <- left_join(dat_all, conmap_SN_roi, by = 'subj')
      dat_all <- left_join(dat_all, conmap_LC_roi, by = 'subj')
      
      
      # get data into long format 
      labels = names(dat_all)
      # Select variables
      var_names = c("subj",
                    "DR",
                    "MR", 
                    "VTA", 
                    "SN", 
                    "LC")
      
      dat = dat_all[,match(var_names,labels)]
      
      # Make data frame
      df_dat = data.frame(dat)
      
      # Make long data format [ csp_preTlapse:csm_stim_mean ]
      long_dat = tidyr::gather(df_dat, value=Val, key=Names, DR:LC, factor_key=TRUE)
      
      
      
      names(long_dat)[names(long_dat) == 'Names'] <- 'ROI'
      names(long_dat)[names(long_dat) == 'Val'] <- 'con_stat'
      
      long_dat_fin <- subset(long_dat, !is.na(con_stat))
      
      
      plot1 <- ggplot(data=subset(long_dat_fin, !is.na(con_stat)), aes(x = ROI, y = con_stat, fill = ROI)) +
      #geom_point(aes(color=ROI), size=2, alpha=.4) +
      geom_jitter(width = 0.1, aes(color=ROI), size=2, alpha=.4) + 
      #geom_line(aes(color=session, group=subject), size=.3, color="black", alpha=.4) +
      scale_y_continuous(limits=c(-2, 2)) +
      #scale_y_continuous(limits=c((min(long_dat_fin$con_stat)*1.1), (max(long_dat_fin$con_stat)*1.1))) +
        stat_summary(fun="mean",colour = "black", size = 2,geom = "point") +
        stat_summary(fun.data="mean_se",colour = "black", width=0,size = 1,geom = "errorbar") +
      scale_color_brewer(palette="Dark2") +
      mytheme                 +                                 
      labs(title = "", x = "", y = "t-values")   +
      theme(legend.position = "none") +
      geom_hline(yintercept=0, linetype="dashed", color = "black")
      
      
      ggsave(paste(output_plots_dir, paste("roi_sig_extract_", c_day, '.png',  sep = ''), sep='\\'), plot1)

      
      
      
    }
  }
}



# smooth, d1, size -0.003 --> 0.002
# smooth, d2, size -0.10 --> 0.30
# smooth, d1, deriv -0.4 --> 0.4
# smooth, d2, deriv -0.4 --> 0.2

# unsmooth, d1, size -0.1 --> 0.2
# unsmooth, d2, size -0.2 --> 0.4
# unsmooth, d1, deriv -0.6 --> 0.6 
# unsmooth, d2, deriv -0.5 --> 0.5

