
# ---------------ggplot2------------------
# Before starting the ggplot, lets try a visualization using a function from the Base R
# the plot() function shows the association of each variable against the other one in a data
# handy for data with few number of variables to see if there are any patterns
library(tidyverse)
library(here)


exam_data<- read_csv(here::here("cleaned_data", "exam_data.csv"))


plot(exam_data)
plot(x = exam_data$Anxiety, y = exam_data$Exam)

# the code also works without writing x and y, however, writing them is strongly recommended
plot(exam_data$Anxiety, exam_data$Exam)

library(ggplot2)


# ggplot, the gg in ggplot stands for grammar of graphics
# grammar of graphics basically says any graphical representation of data, can be produced by a series of layers
# You can think of a layer as a plastic transparency

# Lets draw the same plot using ggplot
# Always, mention the data we are going to work with
ggplot(data = exam_data, aes(x = Exam, y = Anxiety))

# aes: aes which stands for aesthetics is a relationship between a variable in your dataset and an aspect of 
# of the plot that is going to visually convey the information to the reader

# Visual elements are known as geoms (short for 'geometric objects') in ggplot 2
# When we define a layer, we have to tell R what geom we want displayed on that layer (do we want a bar, line dot, etc.?)

ggplot(data = exam_data, aes(x = Exam, y = Anxiety))+ geom_point()

# below show the "Aesthetics" part of the help page and explain it mate
?geom_point

# So, lets try some of them here like shape and size
# be careful with the + sign, if you clink enter for the next part of the code, the + sign should not go to the next line

ggplot(data = exam_data, aes(x = Exam, y = Anxiety))+
  geom_point(size = 2, shape = 8)


# the current plot is not very informative about the patterns for each gender

ggplot(data = exam_data, aes(x = Exam, y = Anxiety, color = Gender))+
  geom_point(size = 2, shape = 10)

ggplot(data = exam_data, aes(x = Exam, y = Anxiety, color = Gender, shape = Gender))+
  geom_point(size = 2, shape = 10)

# Question: why the above code doesn't make any change?

ggplot(data = exam_data, aes(x = Exam, y = Anxiety, color = Gender, shape = Gender))+
  geom_point(size = 2)


# Can assign the first layer to a variable to reduce the length of codes for next layers
My_graph <- ggplot(data = exam_data, aes(x = Exam, y = Anxiety))

My_graph + geom_point()


## lets add a line to the current graph

My_graph + geom_point() + geom_smooth()

# aesthetics can be set for all layers of the plot (i.e., defined in the plot as a whole) or can be set individually for each geom in a plot

My_graph + geom_point(aes(color = Gender)) + geom_smooth()

My_graph + geom_point(aes(color = Gender)) + geom_smooth(aes(color = Gender))



# The shaded area around the line is the 95% confidence interval around the line.
# We can switch this off by  adding se = F (which is short for 'standard error = False')

My_graph + geom_point() + geom_smooth(se = F)

# what if we want our line to be a direct line?
My_graph + geom_point() + geom_smooth(se = F, method = lm)

# How to change the labels of x and y axes?
My_graph + geom_point() + geom_smooth(se = F, method = lm) +
  labs(x = "Exam scores %", y = "Anxiety scores")


# Histogram and bar charts
# Histograms are used to show distributions of variables while bar charts are used to compare variables. 
# Histograms plot quantitative data with ranges of the data grouped into bins or intervals while bar charts plot categorical data.

ggplot(data = exam_data, aes(x = Anxiety, y = Exam )) + geom_histogram()
# the code above gives an error as geom_histogram can only have x or y axis in its aes()

ggplot(data = exam_data, aes(x = Anxiety)) + geom_histogram()

ggplot(data = exam_data, aes(y = Anxiety)) + geom_histogram()

ggplot(data = exam_data, aes(x = Anxiety)) + geom_histogram(bins = 31)

ggplot(data = exam_data, aes(x = Anxiety)) + geom_histogram(bins = 31, fill = "green")

ggplot(data = exam_data, aes(x = Anxiety)) + geom_histogram(bins = 31, fill = "green", col = "red")





# lets stop using the My_graph variable and write the whole code from the start again for a bar chart

ggplot(data = exam_data, aes(x = Sleep_quality))+
  geom_bar()

# Because we want to plot a summary of the data (the mean) rather than the raw scores themselves, we have to use a stat.

ggplot(data = exam_data, aes(x = Sleep_quality, y = Exam, fill = Gender))+
  geom_bar(stat = "summary", fun = "mean")


ggplot(data = exam_data, aes(x = Sleep_quality, y = Exam, fill = Gender))+
  geom_bar(stat = "summary", fun = "mean", position = "dodge")


# the other way to get the same plot that the code above gives, is using the stat_summary function that takes the following general form: 
#stat_summary(function = x, geom = y)
ggplot(data = exam_data, aes(x = Sleep_quality, y = Exam, fill = Gender))+
  stat_summary(fun = mean, geom = "bar", position = "dodge")


# How to combine multiple plots? We can use the patchwork package.

library(patchwork)

# Lets assign our graphs to new names

p1 = My_graph + geom_point(aes(color = Gender)) + geom_smooth()

p2 = ggplot(data = exam_data, aes(x = Anxiety)) + geom_histogram(bins = 31)

p3 = ggplot(data = exam_data, aes(x = Sleep_quality, y = Exam, fill = Gender))+
  stat_summary(fun = mean, geom = "bar", position = "dodge")

p4 = My_graph + geom_point() + geom_smooth(se = F, method = lm) +
  labs(x = "Exam scores %", y = "Anxiety scores")

combined = p1 + p2+ p3 + p4 + plot_layout(nrow = 4, byrow = F)

combined

p1 | p2 / p3 / p4

p1 | p2 / (p3 / p4)



# ggsave() function, which is a versatile exporting function that can export as PostScript (.eps/.ps), tex (pictex), pdf, jpeg, tiff, png, bmp, svg and wmf
# (in Windows only). In its basic form, the structure of the function is very simple: ggsave(plot_name, filename)

ggsave(combined, filename = here("outputs", "combined.png"), dpi=300)








# -------------------------------------------------------- #
# ----------------- Data Visualization ------------------- #
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


barplot_exp1 <- aggregated_data_exp1 %>%
  ggplot(aes(x=stage, y= truth_estimate, fill=group)) +
  geom_bar(stat = "identity", position= "dodge")+
  labs (x= '', y= "Truth Likelihhod Estimate") + 
  theme_bw() + 
  scale_fill_jama() 

#ggsave(barplot_exp1, filename = here("outputs","barplot_exp1.png"), dpi=300)


barplot_facet_exp1 <- aggregated_data_exp1 %>%
  ggplot(aes(x=group, y= truth_estimate, fill=stage)) +
  geom_bar(stat = "identity", position= "dodge")+
  labs (x= '', y= "Truth Likelihhod Estimate") + 
  theme_bw() + 
  theme(legend.position = "none",
        axis.text=element_text(size=11),
        axis.title = element_text(size = 12)) +
  facet_wrap(~stage)+
  scale_fill_jco() 

#ggsave(barplot_facet_exp1, filename = here("outputs","barplot_facet_exp1.png"), dpi=300)


lineplot_exp1 <- aggregated_data_exp1 %>%
  ggplot(aes(x=factor(stage), y= truth_estimate, group= group, color= group)) +
  geom_line(aes(linetype= group)) +
  geom_point(size= 5)+
  labs (x= '', y= "Truth Likelihhod Estimate") + 
  theme_classic() +
  theme(legend.position = "bottom",
        axis.text=element_text(size=11),
        axis.title = element_text(size = 12)) +
  scale_color_nejm() 

#ggsave(lineplot_exp1, filename = here("outputs","lineplot_exp1.png"), dpi=300)


violinplot_exp1 <- data_exp1 %>%
  ggplot(aes(x=factor(stage), y= truth_estimate, fill= group)) +
  geom_violin()+
  labs (x= '', y= "Truth Likelihhod Estimate") + 
  theme_bw() + 
  theme(legend.position = "bottom",
        axis.text=element_text(size=11)) +
  scale_fill_d3() 

#ggsave(violinplot_exp1, filename = here("outputs","violinplot_exp1.png"), dpi=300)


boxplot_exp1 <- data_exp1 %>%
  ggplot(aes(x=factor(stage), y= truth_estimate, fill= group)) +
  geom_boxplot()+
  #geom_point(position = position_dodge(width=0.75), alpha= .5)+
  labs (x= '', y= "Truth Likelihhod Estimate") + 
  theme_bw() + 
  theme(legend.position = "bottom",
        axis.text=element_text(size=11)) +
  scale_fill_simpsons() 

#ggsave(boxplot_exp1, filename = here("outputs","boxplot_exp1.png"), dpi=300)


boxplot_facet_exp1 <- data_exp1 %>%
  ggplot(aes(x=factor(stage), y= truth_estimate, fill= group)) +
  geom_boxplot()+
  labs (x= '', y= "Truth Likelihhod Estimate") + 
  theme_bw() + 
  theme(legend.position = "bottom",
        axis.text=element_text(size=11),
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
  facet_wrap(~group)+
  scale_color_simpsons() 


#ggsave(boxplot_facet_exp1, filename = here("outputs","boxplot_facet_exp1.png"), dpi=300)


combined_plot_exp1 <- (barplot_facet_exp1+lineplot_exp1) / (violinplot_exp1+boxplot_exp1)
#ggsave(combined_plot_exp1, filename = here("outputs","combined_plot_exp1.png"), dpi=300)



