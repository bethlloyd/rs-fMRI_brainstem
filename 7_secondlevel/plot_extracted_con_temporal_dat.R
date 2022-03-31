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

#smooth = c('smoothed', 'unsmoothed')
day = c('ses-day-1', 'ses-day-2')
#pup_type = c('pup_size', 'pup_deriv')
roi = c("DR_roi", "MR_roi", "VTA_roi", "LC_roi", "SN_roi")

for (c_day in day){

  for (c_roi in roi){
    
  
      
    #make output dir
    output_plots_dir = paste("D:\\NYU_RS_LC\\stats", "temporal_analysis", "smoothed", "pup_size", sep='\\')
    
    # load in data and rename column
    conmap_mod1 <- read.delim(paste(conmap_path, "smoothed", '1_m2_bin', 'groupstats', 
                                      c_day, 'pup_size', 'extract_stat', paste("con_stat_", c_roi, '.csv',  sep = ''), 
                                      sep = '\\'), header = TRUE, sep = ',')
    names(conmap_mod1)[names(conmap_mod1) == 'spmT_0001.nii'] <- 't_m2'
    
    conmap_mod2 <- read.delim(paste(conmap_path, "smoothed", '2_m1_bin', 'groupstats', 
                                      c_day, 'pup_size', 'extract_stat', paste("con_stat_", c_roi, '.csv',  sep = ''), 
                                      sep = '\\'), header = TRUE, sep = ',')
    names(conmap_mod2)[names(conmap_mod2) == 'spmT_0001.nii'] <- 't_m1'
    
    conmap_mod3 <- read.delim(paste(conmap_path, "smoothed", '3_0bin', 'groupstats', 
                                       c_day, 'pup_size', 'extract_stat', paste("con_stat_", c_roi, '.csv',  sep = ''), 
                                       sep = '\\'), header = TRUE, sep = ',')
    names(conmap_mod3)[names(conmap_mod3) == 'spmT_0001.nii'] <- 't_0'
    
    conmap_mod4 <- read.delim(paste(conmap_path, "smoothed", '4_p1_bin', 'groupstats', 
                                      c_day, 'pup_size', 'extract_stat', paste("con_stat_", c_roi, '.csv',  sep = ''), 
                                      sep = '\\'), header = TRUE, sep = ',')
    names(conmap_mod4)[names(conmap_mod4) == 'spmT_0001.nii'] <- 't_p1'
    
    conmap_mod5 <- read.delim(paste(conmap_path, "smoothed", '5_p2_bin', 'groupstats', 
                                      c_day, 'pup_size', 'extract_stat', paste("con_stat_", c_roi, '.csv',  sep = ''), 
                                      sep = '\\'), header = TRUE, sep = ',')
    names(conmap_mod5)[names(conmap_mod5) == 'spmT_0001.nii'] <- 't_p2'
    
    dat_all <- left_join(conmap_mod1, conmap_mod2, by = 'subj')
    dat_all <- left_join(dat_all, conmap_mod3, by = 'subj')
    dat_all <- left_join(dat_all, conmap_mod4, by = 'subj')
    dat_all <- left_join(dat_all, conmap_mod5, by = 'subj')
    
    
    # get data into long format 
    labels = names(dat_all)
    # Select variables
    var_names = c("subj",
                  "t_m2",
                  "t_m1", 
                  "t_0", 
                  "t_p1", 
                  "t_p2")
    
    dat = dat_all[,match(var_names,labels)]
    
    # Make data frame
    df_dat = data.frame(dat)
    
    # Make long data format [ csp_preTlapse:csm_stim_mean ]
    long_dat = tidyr::gather(df_dat, value=Val, key=Names, t_m2:t_p2, factor_key=TRUE)
    
    
    
    names(long_dat)[names(long_dat) == 'Names'] <- 'model'
    names(long_dat)[names(long_dat) == 'Val'] <- 't_stat'
    
    long_dat_fin <- subset(long_dat, !is.na(t_stat))
    
    
    plot1 <- ggplot(data=subset(long_dat_fin, !is.na(t_stat)), aes(x = model, y = t_stat, fill = model)) +
      #geom_point(aes(color=ROI), size=2, alpha=.4) +
      geom_jitter(width = 0.1, aes(color=model), size=2, alpha=.4) + 
      #geom_line(aes(color=session, group=subject), size=.3, color="black", alpha=.4) +
      scale_y_continuous(limits=c(-3, 3)) +
      #scale_y_continuous(limits=c((min(long_dat_fin$con_stat)*1.1), (max(long_dat_fin$con_stat)*1.1))) +
      stat_summary(fun="mean",colour = "black", size = 2,geom = "point") +
      stat_summary(fun.data="mean_se",colour = "black", width=0,size = 1,geom = "errorbar") +
      scale_color_brewer(palette="Dark2") +
      mytheme                 +                                 
      labs(title = "", x = "", y = "t-values")   +
      theme(legend.position = "none") +
      geom_hline(yintercept=0, linetype="dashed", color = "black")
    
    
    ggsave(paste(output_plots_dir, paste("roi_sig_extract_", c_roi, '_', c_day, '.png',  sep = ''), sep='\\'), plot1)
    
    
        
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

