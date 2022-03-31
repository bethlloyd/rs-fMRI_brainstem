rm(list= ls(all.names = TRUE))
gc()

library(ggplot2)
library(dplyr)
library(Hmisc)
library(tidyverse)
library(rstatix)
library(ggpubr)
library(apa)
# ggplot theme
mytheme <- theme(panel.grid.major = element_blank(), 
                 panel.grid.minor = element_blank(),
                 panel.background = element_blank(), 
                 axis.line = element_line(size=0.1, colour = "black"),
                 text = element_text(size=12,colour = "black"),
                 strip.background = element_blank(),
                 axis.title.x=element_blank(), 
                 #axis.text.x=element_blank(), 
                 axis.ticks.x=element_blank(),
                 legend.title = element_blank())

setwd("F:\\NYU_RS_LC\\stats\\template_1st_level_pipelines")
conmap_path <- paste("F:\\NYU_RS_LC\\stats\\template_1st_level_pipelines")

#smooth = c('smoothed', 'unsmoothed')
pup_type ='pup_deriv'
c_pup=pup_type
roi = c("DR_roi", "MR_roi", "VTA_roi", "LC_roi", "SN_roi", "ACC_roi", "OCC_roi", "PONS_roi", "BF_sept_roi", "BF_subl_roi")

p_val = list(numeric())
uber_collect_p <-list()
uber_collect_p <- append(uber_collect_p, list(p_val))

plot_list = list()

smooth = c("smoothed")

for (c_pup in pup_type){
  # create empty df
  mat = matrix(ncol = 0, nrow = 0)
  df_uber=data.frame(mat)
  
  for (c_roi in roi){
    print(c_pup)
    print(c_roi)
    
    #make output dir
    output_plots_dir = paste("F:\\NYU_RS_LC\\stats", "TTP", smooth, c_pup, sep='\\')
    
    # load in data and rename column
    conmap_mod1 <- read.delim(paste(conmap_path, smooth, 'P1', 'groupstats', 
                                    c_pup, 'extract_stat', paste("con_stat_P1_", c_roi, '_', c_pup, '.csv',  sep = ''), 
                                    sep = '\\'), header = TRUE, sep = ',')
    names(conmap_mod1)[names(conmap_mod1) == 'spmT_0001.nii'] <- 'P1'
    
    conmap_mod2 <- read.delim(paste(conmap_path, smooth, 'P2', 'groupstats', 
                                    c_pup, 'extract_stat', paste("con_stat_P2_", c_roi, '_', c_pup, '.csv',  sep = ''), 
                                    sep = '\\'), header = TRUE, sep = ',')
    names(conmap_mod2)[names(conmap_mod2) == 'spmT_0001.nii'] <- 'P2'
    
    conmap_mod3 <- read.delim(paste(conmap_path, smooth, 'P3', 'groupstats', 
                                    c_pup, 'extract_stat', paste("con_stat_p3_", c_roi, '_', c_pup, '.csv',  sep = ''),  
                                    sep = '\\'), header = TRUE, sep = ',')
    names(conmap_mod3)[names(conmap_mod3) == 'spmT_0001.nii'] <- 'P3'
    
    conmap_mod4 <- read.delim(paste(conmap_path, smooth, 'P4', 'groupstats', 
                                    c_pup, 'extract_stat', paste("con_stat_P4_", c_roi, '_', c_pup, '.csv',  sep = ''),
                                    sep = '\\'), header = TRUE, sep = ',')
    names(conmap_mod4)[names(conmap_mod4) == 'spmT_0001.nii'] <- 'P4'
    
    conmap_mod5 <- read.delim(paste(conmap_path, smooth, 'P5', 'groupstats', 
                                    c_pup, 'extract_stat', paste("con_stat_P5_", c_roi, '_', c_pup, '.csv',  sep = ''),
                                    sep = '\\'), header = TRUE, sep = ',')
    names(conmap_mod5)[names(conmap_mod5) == 'spmT_0001.nii'] <- 'P5'
    
    conmap_mod6 <- read.delim(paste(conmap_path, smooth, 'P6', 'groupstats', 
                                    c_pup, 'extract_stat', paste("con_stat_P6_", c_roi, '_', c_pup, '.csv',  sep = ''),
                                    sep = '\\'), header = TRUE, sep = ',')
    names(conmap_mod6)[names(conmap_mod6) == 'spmT_0001.nii'] <- 'P6'
    
    
    dat_all <- left_join(conmap_mod1, conmap_mod2, by = 'subj')
    dat_all <- left_join(dat_all, conmap_mod3, by = 'subj')
    dat_all <- left_join(dat_all, conmap_mod4, by = 'subj')
    dat_all <- left_join(dat_all, conmap_mod5, by = 'subj')
    dat_all <- left_join(dat_all, conmap_mod6, by = 'subj')
    
    # get data into long format 
    labels = names(dat_all)
    # Select variables
    var_names = c("subj",
                  "P1",
                  "P2", 
                  "P3", 
                  "P4", 
                  "P5",
                  "P6")
    
    dat = dat_all[,match(var_names,labels)]
    
    # Make data frame
    df_dat = data.frame(dat)
    
    # Make long data format [ csp_preTlapse:csm_stim_mean ]
    long_dat = tidyr::gather(df_dat, value=Val, key=Names, P1:P6, factor_key=TRUE)
    
    
    
    names(long_dat)[names(long_dat) == 'Names'] <- 'model'
    names(long_dat)[names(long_dat) == 'Val'] <- 't_stat'
    
    long_dat_fin <- subset(long_dat, !is.na(t_stat))
    # prep data for appending ROIs 
    long_dat_fin$ROI <- replicate(length(long_dat_fin$subj), c_roi)
    df_uber <- rbind(df_uber, long_dat_fin)
    
    long_dat_fin <- long_dat_fin %>% 
    mutate(TTPmod = case_when(
      model == 'P1' ~ 1,
      model == 'P2' ~ 2,
      model == 'P3' ~ 3,
      model == 'P4' ~ 4,
      model == 'P5' ~ 5,
      model == 'P6' ~ 6))
    
    
    #=======================================================================================#
    
     
    # -------- Testing for linear or quatratic model
    # Linear:    Y=b0 + b1(TTPmod) 
    # Quadratic: Y=b0 + b1(TTPmod) + b2Z
    # Z = TTPmod^2
   # long_dat_fin$Z <- long_dat_fin$TTPmod^2
    
    # linear model: 
    #lin_mod <- lm(long_dat_fin$t_stat ~ long_dat_fin$TTPmod)
    #summary_lin <- summary(lin_mod)
    # quadratic model:
    #quad_mod <- lm(long_dat_fin$t_stat ~ long_dat_fin$TTPmod + long_dat_fin$Z)
    #summary_quad <- summary(quad_mod)
    
    #print(paste('Linear regression results', c_roi, c_pup, 'is', summary_lin[9], sep =" "))
    #print(summary_lin)
    #print(paste('quadratic regression results', c_roi, c_pup, 'is', summary_quad[9], sep =" "))
    #print(summary_quad)
    
    #------------- ANOVAS 
    # check for main effect of model on T-stat
    m1 = afex::aov_ez("subj", "t_stat", 
                      long_dat_fin, 
                      within = c("model"))
    paste('anova for model FOR ', c_roi, ' is:')
    summary(m1)
    anova_apa(m1)
   
    
    
    #-------------- follow up t-test 
    
    # Pairwise comparisons between models
    # Paired t-test is used because we have repeated measures by time
    # stat.test <- long_dat_fin %>%
    #   pairwise_t_test(
    #     t_stat ~ model, paired = TRUE, 
    #     p.adjust.method = "b"
    #   ) %>%
    #   select(-df, -statistic, -p) # Remove details
    # stat.test
    

    
    P1_dat <- subset(long_dat_fin, model == 'P1')
    P2_dat <- subset(long_dat_fin, model == 'P2')
    P3_dat <- subset(long_dat_fin, model == 'P3')
    P4_dat <- subset(long_dat_fin, model == 'P4')
    P5_dat <- subset(long_dat_fin, model == 'P5')
    P6_dat <- subset(long_dat_fin, model == 'P6')
    
    
    P_mods = c('P1', 'P2', 'P3', 'P4', 'P5', 'P6')
    i = 1
    print(paste(c_roi, c_pup))
    for (c_mod in P_mods) { 
      
      dat_model = subset(long_dat_fin, model == c_mod)
      
     # one-way t-tests
      stat.test_p1 <- 
        t.test(dat_model$t_stat,
          mu = 0) # Remove details
      
      #t_apa(stat.test_p1)

      #print(paste('p value for t-test model P', i, 'is', t_apa(stat.test_p1), sep =" "))
      p_val$p_value <- as.numeric(as.character(unlist(stat.test_p1[3][1])))
      uber_collect_p <- append(uber_collect_p, list(p_val))
      
      i <- i + 1
    } 
    

    
    if (c_roi == 'LC_roi') {
      colour_plot = '#00C1AA'
    } else if (c_roi == 'VTA_roi') {
      colour_plot = '#ED8141' 
    } else if (c_roi == 'SN_roi') {
      colour_plot = '#9590FF' 
    } else if (c_roi == 'DR_roi') {
      colour_plot = '#FF62BC' 
    } else if (c_roi == 'MR_roi') {
      colour_plot = '#FF62BC' 
    } else if (c_roi == 'BF_subl_roi') {
      colour_plot = 'yellow'
    } else if (c_roi == 'ACC_roi') {
      colour_plot = '#FFB547FF'
    } else if (c_roi == 'OCC_roi') {
      colour_plot = 'tan3'
    } else if (c_roi == 'PONS_roi') {
      colour_plot = 'grey'
    }
    
    long_dat_fin$TTPmod <- as.factor(long_dat_fin$TTPmod)
    
    # change mod names 
    long_dat_fin <- long_dat_fin %>% 
      mutate(model = case_when(
        model == 'P1'  ~ '1',
        model == 'P2' ~ '2',
        model == 'P3' ~ '3',
        model == 'P4' ~ '4',
        model == 'P5' ~ '5',
        model == 'P6' ~ '6'))
    
    plot1 <- ggplot(data=subset(long_dat_fin, !is.na(t_stat)), aes(x = model, y = t_stat)) +
      #geom_point(aes(color=ROI), size=2, alpha=.4) +
      geom_jitter(width = 0.05, size=0.0002, alpha=1, color = '#808080') + 
      #geom_line(data = fortify(quad_mod), aes(x = long_dat_fin$TTPmod, y = .fitted)) +
      #geom_line() + 
      #geom_line(aes(color=session, group=subj), size=.3, color="black", alpha=.4) +
      scale_y_continuous(limits=c(-3, 3)) +
      #scale_x_discrete()(limits  = c(1, 6)) +
      #scale_y_continuous(limits=c((min(long_dat_fin$con_stat)*1.1), (max(long_dat_fin$con_stat)*1.1))) +
      stat_summary(fun="mean",colour = "black", size = 0.6,geom = "point") +
      stat_summary(fun.data="mean_se",colour = "black", width=0,size = 0.6,geom = "errorbar") +
      scale_colour_manual(values = colour_plot) +
      mytheme                 +                                 
      labs(title = "", x = "", y = "")   +
      theme(legend.position = "none") +
      geom_hline(yintercept=0, linetype="dashed", color = "black", size = 0.1) +
      geom_violin(alpha = 0, color='black', size = 0.2) 
    

      
    # # Add statistical test p-values
    # stat.test <- stat.test %>% add_xy_position(x = "model")
    # plot1 + stat_pvalue_manual(
    #   stat.test, label = "p.adj.signif", 
    #   step.increase = 0.03
    # )
    # plot1 + stat_pvalue_manual(
    #   stat.test, label = "p.adj.signif", 
    #   step.increase = 0.08, hide.ns = TRUE, tip.length = 0
    # )
    # 
      
    #ggplot(long_dat_fin, aes(x=TTPmod, y = t_stat)) +
    #geom_point() +
    #geom_line(data = fortify(quad_mod), aes(x = long_dat_fin$TTPmod, y = .fitted))
    #facet_wrap(~ subj)
      
      
    #print(plot1)
    ggsave(paste(output_plots_dir, paste("roi_sig_extract_", c_roi, '.eps',  sep = ''), sep='\\'), height = 2, width = 1.5, plot1)
    
   # as.data.frame(uber_collect_p)

    
    
    
  }    
  
  # layout.matrix <- matrix(c(1,2,3,4,5,6,7,8,9,10), nrow = 2, ncol = 5)
  # 
  # layout(mat = layout.matrix,
  #        heights = c(2, 2,2,2,2), # Heights of the two rows
  #        widths = c(2, 2,2,2,2)) # Widths of the two columns
  # 
  # layout.show(10)
  # 
  # 
  # #pdf(paste(output_plots_dir,"all_Rois_plots.pdf", sep = "\\"))
  # par(mfrow=c(2,5))
  # for (i in 1:length(plot_list)) {
  #   par(mfrow=c(2,5))
  #   plot(plot_list[[i]])
  # }
  # #dev.off()
  
  
  
  
  # bind p-vals and correct for number of tests (per pupil dynamic)
  df_pval <- as.data.frame(unlist(uber_collect_p))
  df_pval_corr <- p.adjust(df_pval$`unlist(uber_collect_p)`, method = "fdr", n = length(df_pval$`unlist(uber_collect_p)`))
  
  
  # run Giant ANOVA with main effects: ROI & Time 
  #------------- ANOVAS 
  # check for main effect of model on T-stat
  m2 = afex::aov_ez("subj", "t_stat", 
                    df_uber, 
                    within = c("ROI", "model"))
  summary(m2)
  
  
}


