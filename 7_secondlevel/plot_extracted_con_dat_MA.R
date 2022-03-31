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
                 text = element_text(size=34,colour = "black"),
                 strip.background = element_blank(),
                 axis.title.x=element_blank(), 
                 #axis.text.x=element_blank(), 
                 axis.ticks.x=element_blank(),
                 legend.title = element_blank())

setwd("F:\\NYU_RS_LC\\stats\\template_1st_level_pipelines")
conmap_path <- paste("F:\\NYU_RS_LC\\stats\\template_1st_level_pipelines")

#smooth = c('smoothed', 'unsmoothed')
pup_type = c('pup_size', 'pup_deriv')
roi = c("DR_roi", "MR_roi", "VTA_roi", "LC_roi", "SN_roi")
p_val = list(numeric())
uber_collect_p <-list()
uber_collect_p <- append(uber_collect_p, list(p_val))
for (c_pup in pup_type){
  
  
    
  
  
  #make output dir
  output_plots_dir = paste("F:\\NYU_RS_LC\\stats", "main_analysis", "smoothed", c_pup, sep='\\')
  
  # load in data and rename column
  conmap_mod1 <- read.delim(paste(conmap_path, "smoothed", 'DR_roi', 'groupstats', 
                                  c_pup, 'extract_stat', paste("con_stat_DR_roi_", c_pup, '.csv',  sep = ''), 
                                  sep = '\\'), header = TRUE, sep = ',')
  names(conmap_mod1)[names(conmap_mod1) == 'spmT_0001.nii'] <- 'DR'
  
  conmap_mod2 <- read.delim(paste(conmap_path, "smoothed", 'MR_roi', 'groupstats', 
                                  c_pup, 'extract_stat', paste("con_stat_MR_roi_", c_pup, '.csv',  sep = ''), 
                                  sep = '\\'), header = TRUE, sep = ',')
  names(conmap_mod2)[names(conmap_mod2) == 'spmT_0001.nii'] <- 'MR'
  
  conmap_mod3 <- read.delim(paste(conmap_path, "smoothed", 'VTA_roi', 'groupstats', 
                                  c_pup, 'extract_stat', paste("con_stat_VTA_roi_", c_pup, '.csv',  sep = ''),  
                                  sep = '\\'), header = TRUE, sep = ',')
  names(conmap_mod3)[names(conmap_mod3) == 'spmT_0001.nii'] <- 'VTA'
  
  conmap_mod4 <- read.delim(paste(conmap_path, "smoothed", 'LC_roi', 'groupstats', 
                                  c_pup, 'extract_stat', paste("con_stat_LC_roi_", c_pup, '.csv',  sep = ''),
                                  sep = '\\'), header = TRUE, sep = ',')
  names(conmap_mod4)[names(conmap_mod4) == 'spmT_0001.nii'] <- 'LC'
  
  conmap_mod5 <- read.delim(paste(conmap_path, "smoothed", 'SN_roi', 'groupstats', 
                                  c_pup, 'extract_stat', paste("con_stat_SN_roi_", c_pup, '.csv',  sep = ''),
                                  sep = '\\'), header = TRUE, sep = ',')
  names(conmap_mod5)[names(conmap_mod5) == 'spmT_0001.nii'] <- 'SN'
  
  conmap_mod6 <- read.delim(paste(conmap_path, "smoothed", 'ACC_roi', 'groupstats', 
                                  c_pup, 'extract_stat', paste("con_stat_ACC_roi_", c_pup, '.csv',  sep = ''),
                                  sep = '\\'), header = TRUE, sep = ',')
  names(conmap_mod6)[names(conmap_mod6) == 'spmT_0001.nii'] <- 'ACC'
  
  conmap_mod7 <- read.delim(paste(conmap_path, "smoothed", 'OCC_roi', 'groupstats', 
                                  c_pup, 'extract_stat', paste("con_stat_OCC_roi_", c_pup, '.csv',  sep = ''),
                                  sep = '\\'), header = TRUE, sep = ',')
  names(conmap_mod7)[names(conmap_mod7) == 'spmT_0001.nii'] <- 'OCC'
  
  conmap_mod8 <- read.delim(paste(conmap_path, "smoothed", 'BF_sept_roi', 'groupstats', 
                                  c_pup, 'extract_stat', paste("con_stat_BF_sept_roi_", c_pup, '.csv',  sep = ''),
                                  sep = '\\'), header = TRUE, sep = ',')
  names(conmap_mod8)[names(conmap_mod8) == 'spmT_0001.nii'] <- 'BF_sept'
  
  conmap_mod9 <- read.delim(paste(conmap_path, "smoothed", 'BF_subl_roi', 'groupstats', 
                                  c_pup, 'extract_stat', paste("con_stat_BF_subl_roi_", c_pup, '.csv',  sep = ''),
                                  sep = '\\'), header = TRUE, sep = ',')
  names(conmap_mod9)[names(conmap_mod9) == 'spmT_0001.nii'] <- 'BF_subl'
  
  dat_all <- left_join(conmap_mod1, conmap_mod2, by = 'subj')
  dat_all <- left_join(dat_all, conmap_mod3, by = 'subj')
  dat_all <- left_join(dat_all, conmap_mod4, by = 'subj')
  dat_all <- left_join(dat_all, conmap_mod5, by = 'subj')
  dat_all <- left_join(dat_all, conmap_mod6, by = 'subj')
  dat_all <- left_join(dat_all, conmap_mod7, by = 'subj')
  dat_all <- left_join(dat_all, conmap_mod8, by = 'subj')
  dat_all <- left_join(dat_all, conmap_mod9, by = 'subj')
  
  # rename BF 
  names(dat_all)[names(dat_all) == "BF_subl"] <- "BF"
  
  # get data into long format 
  labels = names(dat_all)
  # Select variables
  var_names = c("subj",
                "DR",
                "MR", 
                "VTA", 
                "LC", 
                "SN", 
                "ACC",
                "OCC", 
                "BF_sept", 
                "BF")
  
  dat = dat_all[,match(var_names,labels)]
  
  # Make data frame
  df_dat = data.frame(dat)
  
  
  
  # Make long data format [ csp_preTlapse:csm_stim_mean ]
  long_dat = tidyr::gather(df_dat, value=Val, key=Names, DR:BF, factor_key=TRUE)
  
  
  
  names(long_dat)[names(long_dat) == 'Names'] <- 'ROI'
  names(long_dat)[names(long_dat) == 'Val'] <- 't_stat'
  
  long_dat_fin <- subset(long_dat, !is.na(t_stat))
  
  # do not select the BF_sept --> 
  long_dat_fin <-  subset(long_dat_fin, ROI != "BF_sept")
  
  P_mods = c("DR",
             "MR", 
             "VTA", 
             "LC", 
             "SN", 
             "ACC",
             "OCC",
             "BF")

  i = 1
  print(paste(c_pup))
  for (c_mod in P_mods) { 
    
    dat_model = subset(long_dat_fin, ROI == c_mod)
    
    stat.test_p1 <- 
      t.test(dat_model$t_stat,
             mu = 0) # Remove details
    
    #t_apa(stat.test_p1)
    
    print(paste('p value for t-test model roi ', c_mod, 'is', t_apa(stat.test_p1), sep =" "))
    p_val$p_value <- as.numeric(as.character(unlist(stat.test_p1[3][1])))
    print(unlist(stat.test_p1[3][1]))
    
    uber_collect_p <- append(uber_collect_p, unlist(stat.test_p1[3][1]))
    i <- i + 1
  } 
  
  
  
  
  plot1 <- long_dat_fin %>%
    mutate(ROI = fct_relevel(ROI, "LC", "VTA", "SN", "DR", "MR", "BF", "ACC", "OCC")) %>%
    ggplot(aes(x = ROI, y = t_stat, fill = ROI)) +
    #geom_point(aes(color=ROI), size=2, alpha=.4) +
    geom_jitter(width = 0.1, aes(color=ROI), size=2) + 
    #geom_line(aes(color=session, group=subject), size=.3, color="black", alpha=.4) +
    scale_y_continuous(limits=c(-3.5,3.5)) +
    #scale_y_continuous(limits=c((min(long_dat_fin$con_stat)*1.1), (max(long_dat_fin$con_stat)*1.1))) +
    stat_summary(fun="mean",colour = "black", size = 2,geom = "point") +
    stat_summary(fun.data="mean_se",colour = "black", width=0,size = 1,geom = "errorbar") +
    scale_color_brewer(palette="Dark2") +
    mytheme                 +                                 
    labs(title = "", x = "", y = "t-values")   +
    theme(legend.position = "none") +
    geom_hline(yintercept=0, linetype="dashed", color = "black") +
    geom_violin(alpha = 0, aes(color=ROI, fill = ROI))
  
  print(plot1)
  ggsave(paste(output_plots_dir, paste("roi_sig_extract.eps",  sep = ''), sep='\\'),width = 9, height = 8, plot1)
  

   
  
}


P_mods
corr_p_val  = unlist(uber_collect_p)
p.adjust(corr_p_val, method = "fdr", n = length(corr_p_val))
