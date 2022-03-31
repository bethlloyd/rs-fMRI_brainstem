rm(list= ls(all.names = TRUE))
gc()

library(ggplot2)
library(dplyr)
library(Hmisc)
library(tidyverse)
library(apa)
library(corrplot)
library(RColorBrewer)
library(matlab)
library(psych)

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
dat_path <- paste("F:\\NYU_RS_LC\\stats\\BS_correlations\\group_stats")

dat_type = 'denoised_unsmoothed'

day = c('day1', 'day2')


p_val = list(numeric())
uber_collect_p <-list()
uber_collect_p <- append(uber_collect_p, list(p_val))

r_val = list(numeric())
uber_collect_r <-list()
uber_collect_r <- append(uber_collect_r, list(r_val))



# load in data and rename column
BS_corr_dat_day1 <- read.delim(paste(dat_path, dat_type, paste('day1_BS_partial_PONS_correlations.csv',sep=""),
                             sep = '\\'), header = TRUE, sep = ',')
BS_corr_dat_day2 <- read.delim(paste(dat_path, dat_type, paste('day2_BS_partial_PONS_correlations.csv',sep=""),
                                sep = '\\'), header = TRUE, sep = ',')


# get data into long format 
labels = names(BS_corr_dat_day1)
# Select variables
var_names = c("subj",
              "LC_VTA",
              'LC_SN',
              "LC_DR", 
              "LC_MR", 
              "VTA_SN", 
              "VTA_DR", 
              "VTA_MR",
              "SN_DR",
              "SN_MR",
              "DR_MR",
              "LC_BF",
              "VTA_BF",
              "SN_BF",
              "DR_BF",
              "MR_BF")

dat_day1 = BS_corr_dat_day1[,match(var_names,labels)]
dat_day2 = BS_corr_dat_day2[,match(var_names,labels)]

# Make data frame
df_dat_day1 = data.frame(dat_day1)
df_dat_day2 = data.frame(dat_day2)


# Make long data format [ csp_preTlapse:csm_stim_mean ]
long_dat_day1 = tidyr::gather(df_dat_day1, value=Val, key=Names, LC_VTA:MR_BF, factor_key=TRUE)
names(long_dat_day1)[names(long_dat_day1) == 'Names'] <- 'BS_ROIs'
names(long_dat_day1)[names(long_dat_day1) == 'Val'] <- 'r_value_day1'
long_dat_day2 = tidyr::gather(df_dat_day2, value=Val, key=Names, LC_VTA:MR_BF, factor_key=TRUE)
names(long_dat_day2)[names(long_dat_day2) == 'Names'] <- 'BS_ROIs'
names(long_dat_day2)[names(long_dat_day2) == 'Val'] <- 'r_value_day2'

day_both_days <- left_join(long_dat_day1, long_dat_day2, by = c('subj', 'BS_ROIs'))

day_both_days$r_values_average <- rowMeans(day_both_days[3:4], na.rm=TRUE)
average_corr <- describeBy(day_both_days$r_values_average, group = list(day_both_days$BS_ROIs), mat = TRUE, na.rm=TRUE)

write.csv(average_corr, paste(dat_path, 'average_corr.csv'))


day_both_days$fisher_z <- fisherz(day_both_days$r_values_average)
# group by correlation- 
long_dat_summary <- describeBy(r_values_average ~ BS_ROIs, mat = TRUE, data= day_both_days)


# ANOVA
m1 = afex::aov_ez("subj", "fisher_z", 
                  day_both_days, 
                  within = c("BS_ROIs"))
anova_apa(m1)

# T-tests

P_mods = c("LC_VTA",
           'LC_SN',
           "LC_DR", 
           "LC_MR", 
           "VTA_SN", 
           "VTA_DR", 
           "VTA_MR",
           "SN_DR",
           "SN_MR",
           "DR_MR",
           "LC_BF",
           "VTA_BF",
           "SN_BF",
           "DR_BF",
           "MR_BF")
i = 1

for (c_mod in P_mods) { 
  
  dat_model = subset(day_both_days, BS_ROIs == c_mod)
  
  # one-way t-tests
  stat.test_p1 <- 
    t.test(dat_model$fisher_z,
           mu = 0) # Remove details
  
  #t_apa(stat.test_p1)
  
  print(paste('p value for t-test correlation', c_mod, 'is', t_apa(stat.test_p1), sep =" "))
  p_val$p_value <- as.numeric(as.character(unlist(stat.test_p1[3][1])))
  uber_collect_p <- append(uber_collect_p, list(p_val))
  
} 




# bind p-vals and correct for number of tests (per pupil dynamic)
df_pval <- as.data.frame(unlist(uber_collect_p))
df_pval_corr <- p.adjust(df_pval$`unlist(uber_collect_p)`, method = "fdr", n = length(df_pval$`unlist(uber_collect_p)`))

day_both_days$BS_ROIs <- as.factor(day_both_days$BS_ROIs)

plot1 <-subset(day_both_days, !is.na(fisher_z)) %>%
  ggplot(aes(x = BS_ROIs, y = fisher_z, fill = BS_ROIs)) +
  #geom_point(aes(color=ROI), size=2, alpha=.4) +
  geom_jitter(width = 0.1, aes(color=BS_ROIs), size=2, alpha=.4) + 
  #geom_line(aes(color=session, group=subject), size=.3, color="black", alpha=.4) +
  scale_y_continuous(limits=c(-1, 1)) +
  #scale_y_continuous(limits=c((min(long_dat_fin$con_stat)*1.1), (max(long_dat_fin$con_stat)*1.1))) +
  stat_summary(fun="mean",colour = "black", size = 2,geom = "point") +
  stat_summary(fun.data="mean_se",colour = "black", width=0,size = 1,geom = "errorbar") +
  #scale_color_brewer(palette="Dark2") +
  mytheme                 +                                 
  labs(title = "", x = "", y = "Fisher Z correlation coefficient")   +
  theme(legend.position = "none") +
  geom_hline(yintercept=0, linetype="dashed", color = "black")

ggsave(paste(dat_path, dat_type, 'plots', paste("BS_correlations_both_days.png",  sep = ''), sep='\\'),  height = 6, width = 12, plot1)


# make correlation matrix 
mat_arr <- array(dim=c(6,6))
mat_arr[1,1] = 1 # LC-LC
mat_arr[2,1] = long_dat_summary$mean[1] # VTA-LC
mat_arr[1,2] = long_dat_summary$mean[1] # VTA-LC

mat_arr[3,1] = long_dat_summary$mean[2] # SN-LC
mat_arr[1,3] = long_dat_summary$mean[2] # SN-LC

mat_arr[4,1] = long_dat_summary$mean[3] # DR-LC
mat_arr[1,4] = long_dat_summary$mean[3] # DR-LC

mat_arr[5,1] = long_dat_summary$mean[4] # MR-LC
mat_arr[1,5] = long_dat_summary$mean[4] # MR-LC

mat_arr[2,2] = 1 # VTA-VTA
mat_arr[3,2] = long_dat_summary$mean[5] # SN-VTA
mat_arr[2,3] = long_dat_summary$mean[5] # SN-VTA

mat_arr[4,2] = long_dat_summary$mean[6] # DR-VTA
mat_arr[2,4] = long_dat_summary$mean[6] # DR-VTA

mat_arr[5,2] = long_dat_summary$mean[7] # MR-VTA
mat_arr[2,5] = long_dat_summary$mean[7] # MR-VTA

mat_arr[3,3] = 1 # SN-SN
mat_arr[4,3] = long_dat_summary$mean[8] # DR-SN
mat_arr[3,4] = long_dat_summary$mean[8] # DR-SN

mat_arr[5,3] = long_dat_summary$mean[9] # MR-SN
mat_arr[3,5] = long_dat_summary$mean[9] # MR-SN

mat_arr[4,4] = 1 # DR-DR
mat_arr[5,4] = long_dat_summary$mean[10] # MR-DR
mat_arr[4,5] = long_dat_summary$mean[10] # MR-DR

mat_arr[5,5] = 1 # MR-MR
mat_arr[6,1] = long_dat_summary$mean[11] # LC-BF
mat_arr[1,6] = long_dat_summary$mean[11] # LC-BF

mat_arr[6,2] = long_dat_summary$mean[12] # VTA_BF
mat_arr[2,6] = long_dat_summary$mean[12] # VTA_BF

mat_arr[6,3] = long_dat_summary$mean[13] # SN_BF
mat_arr[3,6] = long_dat_summary$mean[13] # SN_BF

mat_arr[6,4] = long_dat_summary$mean[14] # DR_BF
mat_arr[4,6] = long_dat_summary$mean[14] # DR_BF

mat_arr[6,5] = long_dat_summary$mean[15] # MR_BF
mat_arr[5,6] = long_dat_summary$mean[15] # MR_BF
mat_arr[6,6] = 1 # BF-BF



COL2(diverging = c("RdBu", "BrBG", "PiYG", "PRGn", "PuOr", "RdYlBu"), n = 200)



rownames(mat_arr) <- c("LC", "VTA", "SN", "DR", "MR", "BF")
colnames(mat_arr) <- c("LC", "VTA", "SN", "DR", "MR", "BF")

col <- colorRampPalette(c("black","firebrick4","red", "tan2", "red","brown", "black"))
mat_arr<-as.matrix(mat_arr)

png(height=1800, width=1800, file=paste(dat_path, dat_type, 'plots', paste("BS_correlations_matrix_circles.png"), sep="\\"), type = "cairo")
corrplot(mat_arr, type="lower",cl.lim = c(0,1),
         col = col(40),tl.col="black", tl.srt=45)
dev.off()

png(height=1800, width=1800, file=paste(dat_path, dat_type, 'plots', paste("BS_correlations_matrix_filled.pdf"), sep="\\"), type = "cairo")
corrplot(mat_arr, type="lower", method = 'color',cl.lim = c(0,1),
         col = col(150),tl.col="black", tl.srt=45)
dev.off()


png(height=1800, width=1800, file=paste(dat_path, dat_type, 'plots', paste("BS_correlations_matrix_rect.png"), sep="\\"), type = "cairo")
mat1=corrplot(mat_arr, type="lower",method = 'square',cl.lim = c(0,1),
         tl.col="black", tl.srt=45, col = col(40), na.rm = T)
dev.off()




