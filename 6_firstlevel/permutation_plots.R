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
                 text = element_text(size=28,colour = "black"),
                 strip.background = element_blank(),
                 #axis.title.x=element_blank(), 
                 #axis.text.x=element_blank(), 
                 axis.ticks.x=element_blank(),
                 legend.title = element_blank())

setwd("D:\\NYU_RS_LC\\stats\\main_analysis\\permutation\\")
perm_path <- paste("F:\\NYU_RS_LC\\stats\\native_space_LC")


pup_type = c('pup_size', 'pup_deriv')


p_val = list(numeric())
uber_collect_p <-list()
uber_collect_p <- append(uber_collect_p, list(p_val))


#make output dir
output_plots_dir = perm_path

# load in data and rename column
day1_s <- read.delim(paste(perm_path,'unsmoothed', 'pup_size', 'day1_z_scores_permutation_LC_NATIVE.csv', 
                         sep = '\\'), header = TRUE, sep = ',')
day2_s <- read.delim(paste(perm_path,'unsmoothed', 'pup_size', 'day2_z_scores_permutation_LC_NATIVE.csv', 
                         sep = '\\'), header = TRUE, sep = ',')
day1_d <- read.delim(paste(perm_path,'unsmoothed', 'pup_deriv', 'day1_z_scores_permutation_LC_NATIVE.csv', 
                            sep = '\\'), header = TRUE, sep = ',')
day2_d <- read.delim(paste(perm_path,'unsmoothed', 'pup_deriv','day2_z_scores_permutation_LC_NATIVE.csv', 
                            sep = '\\'), header = TRUE, sep = ',')


both_days_s = left_join(day1_s, day2_s,by = c('subj'))
both_days_s$size <- rowMeans(both_days_s[2:3], na.rm=TRUE)
both_days_s <- both_days_s[c('subj', 'size')]


both_days_d = left_join(day1_d, day2_d,by = c('subj'))
both_days_d$derivative <- rowMeans(both_days_d[2:3], na.rm=TRUE)
both_days_d <- both_days_d[c('subj', 'derivative')]

both_days_s_d = left_join(both_days_s, both_days_d,by = c('subj'))



# get data into long format 
labels = names(both_days_s_d)
# Select variables
var_names = c("subj",
              "size",
              "derivative")



dat = both_days_s_d[,match(var_names,labels)]

# Make data frame
df_dat = data.frame(dat)

# Make long data format [ csp_preTlapse:csm_stim_mean ]
long_dat = tidyr::gather(df_dat, value=Val, key=Names, size:derivative, factor_key=TRUE)

names(long_dat)[names(long_dat) == 'Names'] <- 'type'
names(long_dat)[names(long_dat) == 'Val'] <- 't_stat'



P_roi = c('size', 'derivative')
i = 1
for (c_roi in P_roi) { 
  
  dat_model = subset(long_dat, type == c_roi)
  
  # one-way t-tests
  stat.test_p1 <- 
    t.test(dat_model$t_stat,
           mu = 0) # Remove details
  
  #t_apa(stat.test_p1)
  
  print(paste('p value for t-test ', c_roi, 'is', t_apa(stat.test_p1), sep =" "))
  p_val$p_value <- as.numeric(as.character(unlist(stat.test_p1[3][1])))
  uber_collect_p <- append(uber_collect_p, list(p_val))
  
  i <- i + 1
} 



# bind p-vals and correct for number of tests (per pupil dynamic)
# df_pval <- as.data.frame(unlist(uber_collect_p))
# df_pval_corr <- p.adjust(df_pval$`unlist(uber_collect_p)`, method = "fdr", n = length(df_pval$`unlist(uber_collect_p)`))

plot1 <- long_dat %>%
  ggplot(aes(x = type, y = t_stat, fill = type)) +
  geom_jitter(width = 0.1, aes(color=type), size=2, alpha=1) + 
  stat_summary(fun="mean",colour = "black", size = 2,geom = "point") +
  stat_summary(fun.data="mean_se",colour = "black", width=0,size = 1,geom = "errorbar") +
  scale_y_continuous(limits=c(-3.5,3.5)) +
  #scale_y_continuous(limits=c((min(long_dat_fin$con_stat)*1.1), (max(long_dat_fin$con_stat)*1.1))) +
  #stat_summary(fun="mean",colour = "black", size = 2,geom = "point") +
  #stat_summary(fun.data="mean_se",colour = "black", width=0,size = 1,geom = "errorbar") +
  scale_color_brewer(palette="Dark2") +
  mytheme                 +                                 
  labs(title = "", x = "", y = "permutation test z-score")   +
  theme(legend.position = "none") +
  geom_hline(yintercept=0, linetype="dashed", color = "black") 
  #geom_hline(yintercept=1.645, linetype="dashed", color = "blue") +
  #geom_hline(yintercept=-1.645, linetype="dashed", color = "blue")

  
ggsave(paste(perm_path, '//plots', paste('permutation_result_unsmoothed.eps',  sep = ''), sep='\\'), width = 4, height = 6, plot1)
