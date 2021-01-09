


library(tidyverse)
library (here)
library(afex)
library(ggsci)
library(afex)
library("ggsci")
library(emmeans)
library(patchwork)
options(scipen=999) # turn off scientific notations



# -------------------------------------------------------- #
# --------------- Descriptive Statistics ----------------- #
# -------------------------------------------------------- #

data_exp1_orig <- read_csv(here("cleaned_data","cleaned_data_exp1.csv"))


data_exp1 <- data_exp1_orig%>% 
  #mutate_if(is.character, factor) %>%
  mutate(subject= factor(subject), # convert all characters to factor
         group = factor(group),
         stage = factor(stage))



aggregated_data_exp1 <- data_exp1 %>%
  group_by(stage, group) %>%
  mutate(truth_estimate = mean(truth_estimate)) %>%
  ungroup()


# how many participants in total? 131
data_exp1 %>% summarise(n= n_distinct(subject))

# how many participants in each group?
data_exp1 %>% group_by(subject) %>% filter(row_number()==1) %>% ungroup () %>% group_by(group) %>% count()

# base R summary
data_exp1 %>% 
  group_by(subject) %>% 
  filter(row_number()==1) %>% 
  ungroup () %>%
  summary()

# skimr library
data_exp1 %>% 
  group_by(subject) %>% 
  filter(row_number()==1) %>% 
  ungroup () %>% 
  dplyr::select (age, numeracy_total, reasoning_total, openminded_total, thinking_total) %>% 
  skimr::skim()


### Exercise

ghasemi_data <- read_csv(here("cleaned_data","ghasemi_brightness_exp4.csv"))

ghasemi_data %>% summarise(n = n_distinct(participant)) # number of participants:200

ghasemi_data %>% group_by (participant) %>% filter (row_number()==1) %>% group_by (gender) %>% summarise(n= n()) %>% ungroup() # 183 female, 17 male

ghasemi_data %>% dplyr::select (age, cog_ability) %>% skimr::skim() # mean and sd for age and cognitive ability






# -------------------------------------------------------- #
# ---------------------- Analysis ------------------------ #
# -------------------------------------------------------- #



############## ----------- t-test  -------------################

# Is there a difference between groups at the first stage?
data_exp1 %>% 
  group_by(group) %>% 
  filter(stage=='stage1') %>% 
  ungroup () %>%
  t.test(truth_estimate~group, data = ., paired=FALSE)

# Is there a difference between ratings of stage4 and stage7?
data_exp1 %>% 
  filter(stage=='stage4' | stage=='stage7') %>% 
  ungroup () %>%
  t.test(truth_estimate~stage, data = ., paired=TRUE)


# --------- John Back Down  -----------#

john_data <- read_csv(here("cleaned_data","john_backdown_exp2.csv"))


t.test(intelligent~back_down, data = john_data, paired=FALSE)
t.test(confident~back_down, data = john_data, paired=FALSE)



############## ----------- ANOVA  -------------################

aov_m1 <- aov_car (truth_estimate ~ group*stage +
                     Error(subject/stage), data = data_exp1)  

aov_m1 

emmeans(aov_m1, 'group')
emmeans(aov_m1, 'stage')
pairs(emmeans(aov_m1, 'stage'), adjust= 'holm')
emmeans(aov_m1, "group", by= "stage")# interaction
update(pairs(emmeans(aov_m1, "group", by= "stage")), by = NULL, adjust = "holm") # interaction


afex_plot(aov_m1, x = "stage", trace = "group", error='between') + theme_bw()

afex_plot(aov_m1, x = "stage", trace = "group", error='between',
          line_arg = list(size=1.3),
          point_arg = list(size=3.5),
          data_arg = list(size= 2, color= 'grey'),
          data_plot = FALSE,
          mapping = c("linetype", "shape", "color"),
          legend_title = "Group") +
  labs(y = "Truth Likelihhod Estimate", x = "") +
  theme_bw()+ # remove the grey background and grid
  theme(axis.text=element_text(size=13),
        axis.title = element_text(size = 13),
        legend.text=element_text(size=13),
        legend.title=element_text(size=13),
        #legend.position=c(0.8, 0.88),
        legend.position='bottom',
        legend.key.size = unit(1, "cm"),
        legend.background = element_rect(colour = 'black', fill = 'white', linetype='solid'))+
  scale_color_nejm()

afex_plot(aov_m1, x = "stage", trace = "group", error='between',
          line_arg = list(size=1.3),
          point_arg = list(size=3.5),
          data_arg = list(size= 1, color= 'grey'),
          data_geom = geom_violin,
          mapping = c("linetype", "shape", "fill"),
          legend_title = "Group") +
  labs(y = "Truth Likelihhod Estimate", x = "") +
  theme_bw()+ # remove the grey background and grid
  theme(axis.text=element_text(size=13),
        axis.title = element_text(size = 13),
        legend.text=element_text(size=13),
        legend.title=element_text(size=13),
        legend.position='bottom',
        legend.key.size = unit(1, "cm"),
        legend.background = element_rect(colour = 'black', fill = 'white', linetype='solid'))+
  scale_color_d3() +
  scale_fill_d3()


afex_plot(aov_m1, x = "stage", trace = "group", error='between',
          line_arg = list(size=1),
          point_arg = list(size=3.5),
          data_arg = list(size= 1, color= 'grey', width=.4),
          data_geom = geom_boxplot,
          mapping = c("linetype", "shape", "fill"),
          legend_title = "Group") +
  labs(y = "Truth Likelihhod Estimate", x = "") +
  theme_bw()+ # remove the grey background and grid
  theme(axis.text=element_text(size=13),
        axis.title = element_text(size = 13),
        legend.text=element_text(size=13),
        legend.title=element_text(size=13),
        legend.position='bottom',
        legend.key.size = unit(1, "cm"),
        legend.background = element_rect(colour = 'black', fill = 'white', linetype='solid'))+
  scale_color_simpsons() +
  scale_fill_simpsons()


# --------- Rotello Shooter Bias  -----------#

# load the general data file
rotello_data <- read_csv(here("cleaned_data","rotello_shooter_exp1.csv"))

# Analyses that assume a linear ROC: ANOVA
rotello_aov <- aov_car (resp ~ target*prime +
                          Error(subject/target*prime), data = rotello_data)

rotello_aov
knitr::kable(nice(rotello_aov))



############## ----------- Correlation  -------------################

cor_data_exp1 <- data_exp1 %>% 
  pivot_wider(names_from = stage, values_from = truth_estimate) %>%
  group_by(subject) %>%
  mutate(persuasion_index= stage2+ stage3+ stage4 - stage1,
         dissuasion_index= (101-stage5) + (101-stage6) + (101-stage7) - (101-stage4)) %>%
  ungroup()%>%
  dplyr::select(persuasion_index,dissuasion_index,openminded_total,numeracy_total,thinking_total,reasoning_total)

#-- Base R:
cor(cor_data_exp1, method = "pearson",  use = "complete.obs")

#-- Psych library:
cor_data_exp1 %>% 
  psych::pairs.panels(method = "pearson", hist.col = "#00AFBB", density = T, ellipses = F, stars = T)

#-- Correlation library:
# install.packages("devtools")
# devtools::install_github("easystats/correlation")
#library("correlation")
correlation::correlation(cor_data_exp1) %>% summary()

#-- apaTables library:
cor_data_exp1 %>% 
  apaTables::apa.cor.table(filename="./outputs/CorMatrix.doc", show.conf.interval=T)



#--------- Pennycook AOTE  -----------#

pennycook_data <- read_csv(here("cleaned_data","pennycook_aote_exp1.csv")) 


# If your data contain missing values, use the following R code to handle missing values by case-wise deletion.
cor(pennycook_data, method = "pearson",  use = "complete.obs")

#library(psych)
pennycook_data %>% 
  psych::pairs.panels(method = "pearson", hist.col = "#00AFBB", density = T, ellipses = F, stars = T)


correlation::correlation(pennycook_data) %>% summary()

# install.packages("apaTables",dep=T)
#library(apaTables)
pennycook_data %>% 
  apaTables::apa.cor.table(filename="./outputs/CorMatrix3.doc", show.conf.interval=T)



###### Multiple Regression

exp1_reg=lm(persuasion_index ~ openminded_total+ numeracy_total+ thinking_total+ reasoning_total,
                  data=cor_data_exp1)
summary(exp1_reg)
broom::tidy(exp1_reg)



#--------- Trémolière Climate Literacy  -----------#

Tremoliere_data <- read_csv(here("cleaned_data","tremoliere_data_exp1.csv"))


# Multiple linear regression with variation in R square in 4 steps
Tremoliere_reg=lm(Climato ~ Age+ Gender+ Education+ BeliefInSciencetotal+ Literacy+ Numtotal+ CognitiveReflection,
                  data=Tremoliere_data)

broom::tidy(Tremoliere_reg)
broom::glance(Tremoliere_reg)









