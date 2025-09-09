
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

data<-read.csv("/Users/constanceko/Desktop/ALevelPercentageByCounty.csv")

## Q1. What variables are there in this dataset?

names()

## Q2. Rounded to two decimal places, what is the average percentage of students getting an A* in Mathematics across the UK? 

mean() 


## Q3. Rounded to two decimal places, what is the standard deviation for students getting an A* in Mathematics across the UK? 

sd() 


## Q4. Can you draw a chart with the counties on the X-axis 
## and the percentage of students getting an A* in Mathematics on the Y-axis?


ggplot()


## Q5. Can you draw a chart with the percentage of students getting an A* in Politics on the X-axis 
## and the percentage of students getting an A* in Mathematics on the Y-axis?

ggplot()

# 5.1 Can you add the name of each county?

ggplot()


# 5.2 Where is Durham? Can you highlight the results for Durham in red?

ggplot()


## Q6. Can you draw a chart with all counties on the X-axis and all subjects on the Y-axis?
## Hint: reshape the wide data to the long



###########################################################
################ Part 2: Regression #######################
###########################################################


## Q7. Run a regression where Music is the dependent variable and Politics is the independent variable. 
## To two decimal places, what is the regression coefficient for Politics?

mod1<-lm()




## Q8. Run a regression where Music is the dependent variable and Politics is the independent variable. 
## Using the Residuals vs Leverage plot, which county (or counties) is (are) an  influential outlier(s)?  
## Select all that apply.

plot()


## another way to plot the Cook's Distance using the traditional 4/n criterion (just FYI)


## Outliers are all influential points, but not all influential points are outliers. 
## outliers are badly influenced on the regression line.
## influenced observations are helps form the strong regression line.



## Q9. Run a regression with Music as the dependent variable and Politics as the independent variable.
## From your examination of the diagnostic plots, you've identified an outlier (or outliers) with significant leverage. 
## Remove this outlier (or outliers) from the data (this can be done in R or in Excel - but remember not to overwrite the original data). 
## Re run your model. Rounded to two decimal places, what is the new coefficient for the independent variable? 





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



# >> The Residuals vs Fitted plot indicates that the linearity assumption is violated
# There seems to be an inverse-U relationship between X and Y variable.

# >> If the linearity assumption is breached, the model cannot be interpreted and must be reformulated.

# For the sake of practice we will continue to test the remaining assumptions. 
# However, in reality this would be unnecessary as any linear regression model 
# that breaches the linearity assumption is invalid.





## Q11. Check for heteroscedasticity
## recap of those confusing terminologies: heteroscedasticity VS homoscedasticity 
## hint: plot(model, which = 3)



# >> There is no discernible pattern in the Scale-Location plot, 
# i.e. our data is homoscedastic and the model assumption is met.



## Q12. produce a Q-Q plot to see if the distribution of residuals is close to normal
## hint: plot(model, which = 2)



# >> The Normal Q-Q plot shows some deviation from the normal distribution in the 
# extremes, but the residuals still are normally distributed enough. Therefore, 
# our assumption is met.


## Q13. Draw a histogram of residuals. Does your conclusion hold?
## Think: why we need to draw a histogram here? What are we trying to find? 



## Q14. are there any highly influential observations?
## hint: plot(model, which = 4), plot(model, which = 5)



# plot(model, which = 1): Residuals vs Fitted
# plot(model, which = 2): Normal Q-Q
# plot(model, which = 3): Scale-Location
# plot(model, which = 4): Cook's distance
# plot(model, which = 5): Residuals vs Leverage

