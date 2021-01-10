

#########################

# Introduction to R
# mahdi.mazidisharafabadi@research.uwa.edu.au
#########################



library(tidyverse)


# R as a calculator

10 + 10

4 ^ 2

(250 / 500) * 100

# For mathematical purposes, be careful of the order in which R executes the commands.


# is used to write comments

# R is a bit flexible with spacing (but no spacing in the name of variables and words)

10+10

10                 +           10


# R can sometimes tell that you're not finished yet

10 +
  
# How to create a variable? Variable assignment using <- and =
# Note that R is case sensitive for everything
 
pay <- 250

month = 12

pay * month

salary <- pay * month


# Few points in naming variables and vectors: use short, informative words, keep same method (e.g., not using capital words, use only _ or . ).


# functions: is a set of statements combined together to perform a specific task. When we use a block of code repeatedly, we can convert it to a function. To write a function, first, you need to *define* it:

my_multiplier <- function(a,b){
  result = a * b
  return (result)
}

# This code do nothing. To get a result, you need to *call* it:
my_multiplier (a=2, b=4)

# We can set a default value for our arguments
my_multiplier2 <- function(a,b=4){
  result = a * b
  return (result)
}

my_multiplier2 (a=2)


# Fortunately, you do not need to write everything from scratch. R has lots of built-in functions that you can use:
round(54.6787)

# When you write a function, it shows them some help they can get
round(54.5787, digits = 2)

?round


# Will see many functions in the rest of the workshop

# Part B ----

rm(month)

# Basic Data Types in R (also called atomic vector types)

# function class() is used to show what is the type of a variable

# 1- Logical   TRUE, FALSE     can be abbreviated as T, F  they has to be capital, 'true' is not a logical data
class(TRUE)
class(F)

# 2- Numeric   all numbers e.g. 5,  10.5,  11,37;  a special type of numeric is "integer" which is numbers without decimal
# Integers are always numeric, but numeric is not always integer
class(2)
class(13.46)


# 3- Character    text for example, "I love R"    or   "4" or    "4.5"
class("ha ha ha ha")
class("56.6")
class("TRUE")


# Can we change the type of data in a variable? 
# the function as. 
as.numeric(TRUE)

as.character(4)

as.numeric("4.5")

as.numeric("Hello")






# Data Structures in R

# Vectors: 
# Vector: when there are more than one number or letter stored. Use the combine function c() for that.

sale <- c(1, 2, 3,4, 5, 6, 7, 8, 9, 10) # also sale <- c(1:10)

sale <- c(1:10)

sale * sale

# subsetting a vector
days <- c("Saturday", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday")

days[2]
days[-2]

days[c(2, 3, 4)]

# Question: Create a vector named "my_vector" with numbers from 0 to 1000 in it
my_vector <- (0:1000)

mean(my_vector)
median(my_vector)
min(my_vector)
range(my_vector)
class(my_vector)
sum(my_vector)
sd(my_vector)

# list: allows you to gather a variety of objects under one name (that is, the name of the list) in an ordered way. These objects can be matrices, vectors, data frames, even other list

my_list = list(sale, 1, 3, 4:7, "HELLO", "hello", FALSE)

my_list

# factor: Factors store the vector along with the distinct values of the elements in the vector as labels. The labels are always character irrespective of whether it is numeric or character.

# variable gender with 20 "male" entries and
# 30 "female" entries

gender <- c("male", "male", "male", "female", " female", "female")
gender <- factor(gender)

# stores gender as 20 1s and 30 2s and associates
# 1=female, 2=male internally (alphabetically)
# R now treats gender as a nominal (categorical) variable

summary(gender)

# Question: why when we ran the above function i.e. summary(), it showed three and not two levels of the data?


# Question: create a gender factor with 30 male and 40 females (hint: use the rep() function)
gender <- c(rep("male",30), rep("female", 40))
gender <- factor(gender)

# There are two types of categorical variables: nominal and ordinal.
# how to create ordered factors (when the variable is nominal and values can be ordered). We should add two additional arguments to the factor() function: ordered = TRUE, and levels = c("level1", "level2".). For example, we have a vector that shows participants' education level.
edu<-c(3,2,3,4,1,2,2,3,4)

education<-factor(edu, ordered = TRUE)

levels(education) <- c("Primary school","high school","College","Uni graduated")

education


#We have a factor with `patient` and `control` values. Here, the first level is control and the second level is patient. Change the order of levels, so patient would be the first level:

health_status <- factor(c(rep('patient',5),rep('control',7)))
health_status

health_status_reordered <- factor(health_status, levels = c('patient','control'))
health_status_reordered

health_status_relabeled <- factor(health_status, levels = c('patient','control'), labels = c('Patient','Control'))
health_status_relabeled


# Matrices
# All columns in a matrix must have the same mode(numeric, character, etc.) and the same length.
# It can be created using a vector input to the matrix function.

my_matrix = matrix(c(1,2,3,4,5,6,7,8,9), nrow = 3, ncol = 3)

my_matrix


# Data frames: (two-dimensional objects) can hold numeric, character or logical values. Within a column all elements have the same data type, but different columns can be of different data type.

# lets create a dataframe
id <- c(1:200)
group <- c(rep("Psychotherapy", 100), rep("Medication", 100))
response <- c(rnorm(100, mean = 30, sd = 5),
             rnorm(100, mean = 25, sd = 5))

my_dataframe <-data.frame(Patient = id,
                          Treatment = group,
                          Response = response)



# We also could have done the below

my_dataframe <-data.frame(Patient = c(1:200),
                          Treatment = c(rep("Psychotherapy", 100), rep("Medication", 100)),
                          Response = c(rnorm(100, mean = 30, sd = 5),
                                       rnorm(100, mean = 25, sd = 5)))

str(my_dataframe)
summary(my_dataframe)


# in large data sets, the function head() enables you to show the first observations of a data frames. Similarly, the function tail() prints out the last observations in your data set.
head(my_dataframe)
tail(my_dataframe)

# similar to vectors and matrices, brackets [] are used to selects data from rows and columns in data.frames
my_dataframe[35, 3]

# Question: how to get all columns, but only for the first 10 participants.

my_dataframe[1:10, ]

# Question2: How to get only the Response column for all participants?

my_dataframe[ , 3]

# another easier way for selecting particular items is using their names that is more helpful than number of the rows in large data sets
my_dataframe[ , "Response"]

my_dataframe$Response
my_dataframe[35:50,2:3]























