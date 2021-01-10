

library(tidyverse)
library (here)
options(scipen=999) # turn off scientific notations


# read the raw data
raw_data <- read_csv(here("raw_data","raw_data_exp1.csv"))

# Exercise: read the UNICEF data
unicef_data <- read_csv(here("cleaned_data","unicef_u5mr.csv"))


head(raw_data)

# Pick 3 columns
selected_data <- select(raw_data, subject, age, gender)

# Pick male participants
filtered_data_male <- filter(raw_data, gender == "Male")
filtered_data_male_and_greater25 <- filter(raw_data, gender == "Male" & age > 25 )
filtered_data_male_or_greater25 <- filter(raw_data, gender == "Male" | age > 25 )

# order participants based on their age
arranged_data <- arrange(raw_data, age)
arranged_data_descending <- arrange(raw_data, desc(age))

# Create a column to show if the participant has finished the task or not
mutated_data <- mutate (raw_data, finished= case_when(progress==100~ "Yes",T~ "No"))

# summarize participants age and sd:
summarised_data <- summarise(raw_data, mean= mean(age, na.rm=T))

# pipe functions %>%
raw_data %>% 
  summarise(., mean= mean(age, na.rm=T))

raw_data %>% 
  summarise(mean= mean(age, na.rm=T))

# calculate the mean of younger than 25 participants only
raw_data %>% 
  filter (age < 25) %>%
  summarise(mean= mean(age, na.rm=T),
            sd= sd (age, na.rm=T))

# calculate the mean of younger than 25 participants only for each gender separately
raw_data %>% 
  filter (age < 25) %>%
  group_by(gender) %>%
  summarise(mean= mean(age, na.rm=T),
            sd= sd (age, na.rm=T)) %>%
  ungroup ()

# exercise1: Create a column to show if participant is older than 23 or not and then calculate 
#reasoning ability (`reasoning_total`) mean for each group separately
raw_data %>%
  mutate(age_group = case_when(age > 23 ~ "greater than 23", T~ "younger than 23")) %>%
  group_by(age_group) %>%
  summarise(reasoning_total = mean(reasoning_total, na.rm=T))

# exercise2: add the open_mindedness total score (sum) to the dataframe and then convert subject column to factor
mutated_openmind_data <- raw_data %>%
  mutate(openminded_total= openminded1+openminded2+openminded3+openminded4+
                           openminded5+openminded6+openminded7+openminded8) %>%
  mutate(subject= factor(subject))

str(mutated_openmind_data)


# pivoting your data
long_data <- raw_data %>%
  select(subject, stage1_simple:stage7_simple,stage1_complex:stage7_complex) %>%
  pivot_longer(cols = c(stage1_simple:stage7_complex), names_to = 'stage', values_to = 'truth_estimate')

wide_data <- long_data %>%
  pivot_wider(names_from = stage, values_from= truth_estimate)
  

# Exercise: pivot
library(janitor)
head(unicef_data)
colnames(unicef_data)

unicef_data_cleaned <- unicef_data %>%
  clean_names()

head(unicef_data_cleaned)
colnames(unicef_data_cleaned) 

# backtick `
unicef_long_data <- unicef_data_cleaned %>% 
  pivot_longer(cols = c(u5mr_1950:u5mr_2015), names_to = 'year', values_to = 'u5mr')
unicef_wideg_data <- unicef_long_data %>% 
  pivot_wider(names_from = 'year', values_from = 'u5mr')


  
cleaned_data <- raw_data %>% 
  filter(progress == 100) %>% # filter out unfinished participants
  select(-end_date, -status,-ip_address, -duration_in_seconds, -recorded_date:-user_language) %>% #remove some useless columns
  # create a total score for our questionnaire
  mutate(openminded_total= openminded1+openminded2+openminded3+openminded4+openminded5+openminded6+openminded7+openminded8) %>%
  mutate(thinking1= case_when(thinking1==4~ 1,T~0),
         thinking2= case_when(thinking2==10~ 1,T~0),
         thinking3= case_when(thinking3==39~ 1,T~0),
         thinking_total= thinking1 + thinking2 + thinking3) %>%
  select(-thinking1:-openminded8) %>%
  # make our dataframe long
  pivot_longer(cols = c(stage1_simple:stage7_simple,stage1_complex:stage7_complex),names_to = 'stage',values_to = 'truth_estimate') %>% 
  #pivot_wider(names_from = stage, values_from= truth_estimate) # this code change our dataframe back to wide
  filter(!is.na(truth_estimate)) %>% #remove rows with truth_estimate == NA
  mutate(stage= gsub("_.*", "", stage)) %>%
  rename(consent= consent_form) # rename a columns
         

str(cleaned_data)
dim(cleaned_data)

write_csv(cleaned_data, here("cleaned_data","cleaned_data_exp1.csv"))

