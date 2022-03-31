rm(list= ls(all.names = TRUE))
gc()

library(ggplot2)
library(dplyr)
library(Hmisc)
library(stats)
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


setwd("F:\\NYU_RS_LC\\stats\\")
intensity_path <- paste("F:\\NYU_RS_LC\\stats\\LC_mask\\intensity_analysis")

# load in data and rename column
intensity_dat <- read.delim(paste(intensity_path, paste('LC_PONS_intensity.csv',sep=""),
                             sep = '\\'), header = TRUE, sep = ',')

# rename columns
colnames(intensity_dat)[2] <- 'LC'
colnames(intensity_dat)[3] <- 'pons'


# get data into long format 
labels = names(intensity_dat)
# Select variables
var_names = c("subj",
              "LC",
              'pons')

dat = intensity_dat[,match(var_names,labels)]

# t-test
t_test<-t.test(dat$LC, dat$pons,
       alternative = c("two.sided"),
       mu = 0, paired = TRUE, var.equal = FALSE,
       conf.level = 0.95)


# Make data frame
df_dat = data.frame(dat)

# Make long data format [ csp_preTlapse:csm_stim_mean ]
long_dat = tidyr::gather(df_dat, value=Val, key=Names, LC:pons, factor_key=TRUE)

names(long_dat)[names(long_dat) == 'Names'] <- 'ROI'
names(long_dat)[names(long_dat) == 'Val'] <- 'intensity'

plot1 <- ggplot(data=long_dat, aes(x = ROI, y = intensity, fill = ROI)) +
  geom_point(aes(color=ROI, group=subj), size=2, alpha=1, position = position_dodge(0.15)) +
  geom_line(aes(color=ROI, group=subj), size=0.02, color="#808080", alpha=1, position = position_dodge(0.15)) +
  #geom_jitter(width = 0.1, aes(color=ROI), size=0.0002, alpha=1) + 
  stat_summary(fun="mean",colour = "black", size = 0.6,geom = "point") +
  stat_summary(fun.data="mean_se",colour = "black", width=0,size = 0.6,geom = "errorbar") +
  scale_colour_manual(values = c("seagreen1", "magenta")) +
  stat_summary(aes(y = intensity,group = 1), fun = mean, geom="line", size=0.6) +
  mytheme                 +                                 
  labs(title = "", x = "", y = "Signal Intensity (A.U.)")   +
  theme(legend.position = "none")
#geom_hline(yintercept=0, linetype="dashed", color = "black")

ggsave(paste(intensity_path, 'plots', paste("intensity_plot.eps",  sep = ''), sep='\\'),  height = 6, width =4, plot1)
  
  

