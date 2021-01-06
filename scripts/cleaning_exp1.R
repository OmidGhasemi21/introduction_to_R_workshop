
#########################

# Argumentation and persuasion (2020): Experiment 1 (data cleaning)
# Omidreza.ghasemi@hdr.mq.edu.au
#########################


library(tidyverse)
library(janitor)
library (here)
library(afex)
library(knitr)
library(ggsci)
options(scipen=999) # turn off scientific notations


# read the raw data
raw_data <- read_csv(here("raw_data","raw_argumentative_exp1.csv"))

head(raw_data)


cleaned_data <- raw_data %>% 
  filter(progress == 100) %>% # filter out unfinished participants
  select(-end_date, -status,-ip_address, -duration_in_seconds, -recorded_date:-user_language) %>% #remove some useless columns
  mutate(openminded_total= openminded1+openminded2+openminded3+openminded4+openminded5+openminded6+openminded7+openminded8) %>%# create a total score for our questionnaire
  mutate(thinking1= case_when(thinking1=='4'~ 1,T~0),
         thinking2= case_when(thinking2=='10'~ 1,T~0),
         thinking3= case_when(thinking3=='39'~ 1,T~0),
         thinking_total= thinking1 + thinking2 + thinking3) %>%
  select(-thinking1:-openminded8) %>%
  pivot_longer(cols = c(stage1_simple:stage7_simple,stage1_complex:stage7_complex),names_to = 'stage',values_to = 'truth_estimate') %>% # make our dataframe long
  #pivot_wider(names_from = stage, values_from= truth_estimate) # this code change our dataframe back to wide
  filter(!is.na(truth_estimate)) %>% #remove rows with truth_estimate == NA
  mutate(stage= gsub("_.*", "", stage)) %>%
  rename(consent= consent_form) %>% # rename a column
  #mutate_if(is.character, factor) %>%
  mutate(subject= factor(subject), # convert all characters to factor
         group = factor(group),
         stage = factor(stage))
         
  
str(cleaned_data)
dim(cleaned_data)

write_csv(cleaned_data, here("cleaned_data","argumentative_exp1.csv"))

