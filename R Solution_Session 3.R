
#  EDUC47410_2023/24
#  Secondary Data in Education Research (23/24)
#  Dr Yiyang Gao, 25 Jan 2024


###########################################################
################ Part 1: Data preparation #################
###########################################################


install.packages(c("dplyr", "ggplot2", "tidyr"))
library(ggplot2)
library(dplyr)
library(tidyr)

## Load the data on A level grades. 
## Each column has the percentage of students getting an A* in the given subject by county.

data<-read.csv("/Users/constanceko/Desktop/EDUC47410/ALevelPercentageByCounty.csv")

## Q1. What variables are there in this dataset?

names(data)

## Q2. Rounded to two decimal places, what is the average percentage of students getting an A* in Mathematics across the UK? 

mean(data$Mathematics) 


## Q3. Rounded to two decimal places, what is the standard deviation for students getting an A* in Mathematics across the UK? 

sd(data$Mathematics) 


## Q4. Can you draw a chart with the counties on the X-axis 
## and the percentage of students getting an A* in Mathematics on the Y-axis?


ggplot(data, aes(x = County, y = Mathematics)) +
  geom_point() +
  coord_flip() + # Flip the X and Y axis
  theme_bw()  # Choose a built-in theme for aesthetic purposes


## Q5. Can you draw a chart with the percentage of students getting an A* in Politics on the X-axis 
## and the percentage of students getting an A* in Mathematics on the Y-axis?

ggplot(data, aes(x = Politics, y = Mathematics)) +
  geom_point() +
  theme_bw()

# 5.1 Can you add the name of each county?

ggplot(data, aes(x = Politics, y = Mathematics)) +
  geom_point() +
  geom_text(aes(label = County), vjust = -1, hjust = 0.5, size = 3) +
  theme_bw()

# 5.2 Where is Durham? Can you highlight the results for Durham in red?

ggplot(data, aes(x = Politics, y = Mathematics)) +
  geom_point() +
  geom_text(data = subset(data, County != "Durham"), aes(label = County), 
            vjust = -1, hjust = 0.5, size = 3, color = "black") +
  geom_text(data = subset(data, County == "Durham"), aes(label = County), 
            vjust = -1, hjust = 0.5, size = 3, color = "red") +
  theme_bw()


## Q6. Can you draw a chart with all counties on the X-axis and all subjects on the Y-axis?
## Hint: reshape the wide data to the long


data2 <- pivot_longer(data, cols = c(Sociology, Mathematics, Politics, Music), 
                        names_to = "Subject", values_to = "Value")

names(data2)


ggplot(data2, aes(x = County, y = Value, group = Subject, color = Subject)) +
  geom_point() +
  geom_line(linetype = "dashed")+
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
  

# Finalise it
data2 %>%
  filter(Subject == "Politics" | Subject == "Mathematics") %>% # Only look at two subjects
  ggplot(aes(x = County, y = Value, group = Subject, color = Subject)) +
  geom_point() +
  geom_line(linetype = "dashed")+
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) + # rotate for a full display
  theme(legend.position = "bottom") + # move the legend to the bottom
  labs(x = "", y = "% of A* students") + # remove and add labels
  ggtitle("% of A* students across counties and subjects") # add a title




# Maybe reorder the Y-axis by the value of Mathematics?
data2 %>%
  filter(Subject == "Mathematics") %>%
  arrange(desc(Value)) %>% # Arrange counties by descending average value
  mutate(County = factor(County, levels = unique(County))) %>% # Reorder County based on Value
  ggplot(aes(x = County, y = Value)) +
  geom_point(color = "red") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1), # Rotate for a full display
        legend.position = "bottom") + # Move the legend to the bottom
  labs(x = "", y = "% of A* students") + # Remove and add labels
  ggtitle("% of A* students in Mathematics across counties") # Add a title


###########################################################
################ Part 2: Regression #######################
###########################################################


## Q7. Run a regression where Music is the dependent variable and Politics is the independent variable. 
## To two decimal places, what is the regression coefficient for Politics?

mod1<-lm(Music~Politics,data=data)
summary(mod1) # 0.10



# How Pr>|t| is calculated?

t_stat <- 0.437
df <- 45
alpha <- 0.05
p_value <- 2 * (1 - pt(abs(t_stat), df))
print(p_value)



# t_stat <- 0.437
# This sets the variable t_stat to the value of 0.437, 
# which represents the t-statistic calculated from a statistical test. 
# The t-statistic is the result of dividing the estimated coefficient by its standard error.

# df <- 45: This sets the variable df to 45, 
# representing the degrees of freedom for the t-distribution. 
# In a regression context, degrees of freedom are usually calculated 
# as the number of observations minus the number of parameters estimated 
# (e.g., the number of independent variables plus one for the intercept).

# alpha <- 0.05: This sets the significance level alpha to 0.05. 
# The significance level is the threshold used to determine whether 
# the p-value indicates a statistically significant result. 
# A common choice is 0.05, which corresponds to a 5% chance of 
# rejecting the null hypothesis when it is actually true (Type I error).


# p_value <- 2 * (1 - pt(abs(t_stat), df)): 
# This line calculates the p-value. 
# The function pt is the cumulative distribution function (CDF) 
# for the t-distribution in R, which returns the probability that 
# a t-distributed random variable would be less than abs(t_stat) given df degrees of freedom. 
# Since the t-test is a two-tailed test (we are interested in whether 
# the t-statistic is significantly different from zero in either direction),
# we subtract this value from 1 to get the tail probability above the a
# bsolute value of t_stat and then multiply by 2 to get the total probability 
# for both tails of the distribution.

# The p-value represents the probability of obtaining a t-statistic 
# as extreme as, or more extreme than, the one calculated from your data, 
# under the assumption that the null hypothesis is true. 
# A small p-value (typically less than or equal to 0.05) indicates strong evidence 
# against the null hypothesis, so it is rejected, 
# and the result is considered statistically significant. 
# Conversely, a large p-value suggests weak evidence against the null hypothesis, 
# so it is not rejected.




## Q8. Run a regression where Music is the dependent variable and Politics is the independent variable. 
## Using the Residuals vs Leverage plot, which county (or counties) is (are) an  influential outlier(s)?  
## Select all that apply.

plot(mod1)
data$County[20] #Herefordshire
data$County[22] #Isle of Wight 
data$County[40] #Surrey


## another way to plot the Cook's Distance using the traditional 4/n criterion (just FYI)

mod2<-lm(Music~Politics,data=data)
summary(mod2)
cooksd <- cooks.distance(mod2)
sample_size <- nrow(data)
plot(cooksd, pch="*", cex=2, main="Influential Obs by Cooks distance")  # plot cook's distance
abline(h = 4/sample_size, col="red")  # add cutoff line
text(x=1:length(cooksd)+1, y=cooksd, labels=ifelse(cooksd>4/sample_size, names(cooksd),""), col="red")  # add labels


## Outliers are all influential points, but not all influential points are outliers. 
## outliers are badly influenced on the regression line.
## influenced observations are helps form the strong regression line.






## Q9. Run a regression with Music as the dependent variable and Politics as the independent variable.
## From your examination of the diagnostic plots, you've identified an outlier (or outliers) with significant leverage. 
## Remove this outlier (or outliers) from the data (this can be done in R or in Excel - but remember not to overwrite the original data). 
## Re run your model. Rounded to two decimal places, what is the new coefficient for the independent variable? 

data2 <-data[-22,]
mod2 <-lm(Music~Politics,data=data2)
summary(mod2) # 0.52


## Another way to compare models with and without outliers (just FYI)
# find influential row numbers
influential <- as.numeric(names(cooksd)[(cooksd > (4/sample_size))])
influential
# Alternatively, you can try to remove the top x outliers to have a look
top_x_outlier <- 4
influential <- as.numeric(names(sort(cooksd, decreasing = TRUE)[1:top_x_outlier]))
influential

newdata <- data[-influential, ]

plot1 <- ggplot(data = data, aes(x = Politics, y = Music)) +
  geom_point() + 
  geom_smooth(method = lm) +
  ggtitle("Before")
plot2 <- ggplot(data = newdata, aes(x = Politics, y = Music)) +
  geom_point() +
  geom_smooth(method = lm) +
  ggtitle("After")
gridExtra::grid.arrange(plot1, plot2, ncol=2)



# Load the necessary packages and print the two models
library(stargazer)
# fit another model with y = music, x = maths


mod3 <- lm(Music~Mathematics,data=data)

# Now use stargazer to create a table
stargazer(mod1,mod3, type = "text", 
          title = "OLS Regression Results", 
          header = FALSE, 
          intercept.bottom = FALSE,
          single.row = TRUE,
          no.space = TRUE,
          digits = 3)


# Use stargazer to create a table and save it as an HTML file
stargazer(mod1,mod3, type = "html", 
          out = "regression_output.html",
          title = "OLS Regression Results", 
          single.row = TRUE, 
          digits = 3)

# After running this code, you'll get an HTML file named "regression_output.html"
# You can open this file in any web browser, and from there you can copy the table into Word.
# Alternatively, you can open the HTML file directly in Word.



###########################################################
################ Part 3: Diagnostic plots #################
###########################################################

# You ran a linear regression analysis and the stats software spit out a bunch of numbers. 
# The results were significant (or not). 
# You might think that you're done with analysis. No, not yet. 
# After running a regression analysis, you should check if the model works well for data.

# Residuals could show how poorly a model represents data. 
# Residuals are leftover of the outcome variable after fitting a model (predictors) 
# to data and they could reveal unexplained patterns in the data by the fitted model. 



## Q10. Generate diagnostic plots and verify the linearity assumption
## recap: what is the linearity assumption? 
## hint: plot(model, which = 1)

plot(mod2, which = 1)

# >> The Residuals vs Fitted plot indicates that the linearity assumption is violated
# There seems to be an inverse-U relationship between X and Y variable.

# >> If the linearity assumption is breached, the model cannot be interpreted and must be reformulated.

# For the sake of practice we will continue to test the remaining assumptions. 
# However, in reality this would be unnecessary as any linear regression model 
# that breaches the linearity assumption is invalid.



## Q11. Check for heteroscedasticity
## recap of those confusing terminologies: heteroscedasticity VS homoscedasticity 
## hint: plot(model, which = 3)


plot(mod2, which = 3)

# >> There is no discernible pattern in the Scale-Location plot, 
# i.e. our data is homoscedastic and the model assumption is met.



## Q12. produce a Q-Q plot to see if the distribution of residuals is close to normal
## hint: plot(model, which = 2)
plot(mod2, which = 2)

# >> The Normal Q-Q plot shows some deviation from the normal distribution in the 
# extremes, but the residuals still are normally distributed enough. Therefore, 
# our assumption is met.


## Q13. Draw a histogram of residuals. Does your conclusion hold?
## Think: why we need to draw a histogram here? What are we trying to find? 

hist(mod2$residuals)


ggplot() + 
  geom_histogram(aes(x=mod2$residuals))

## Q14. are there any highly influential observations?
## hint: plot(model, which = 4), plot(model, which = 5)

plot(mod2, which = 4)
plot(mod2, which = 5)

## if you want to look at four plots at once rather than one by one...

plot(mod2, which=c(1, 2, 3, 4, 5))
# or simply...
plot(mod2)

# plot(model, which = 1): Residuals vs Fitted
# plot(model, which = 2): Normal Q-Q
# plot(model, which = 3): Scale-Location
# plot(model, which = 4): Cook's distance
# plot(model, which = 5): Residuals vs Leverage

