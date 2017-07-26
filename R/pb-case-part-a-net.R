##################################################################################################
# File        : pb-case-part-b-net.R  <--- this should be the exact name of THIS document
# Author      : Kristina Tobio & Bob Freeman 
# Created     : 02 Dec 2016
# Modified    : 25 July 2017
# Description : .R file for Part A of the PB Case
##################################################################################################
# setup environment for R and script below
install.packages('tidyverse', dependencies = TRUE)
install.packages('Hmisc')
library('tidyverse')
library('Hmisc')

# this clears R's data memory so new data can be loaded
#clear 
rm(list = ls())

# this creates a log file, which will record all of the commands and outputs from this .do file 
# log files should be placed in a folder named "logs" in your directory 
sink(file = paste0("./logs/pb-case-a_", Sys.Date(),".log"), append = FALSE, type = c("output", "message"), split = TRUE)

#install.packages("readstata13")
library("readstata13")

# data should be placed in a folder named "data" in your directory 
#PA_pilgrimA_data <- read.dta13("data/PA_pilgrimA_data.dta")
#save("PA_pilgrimA_data", file = "data/PA_pilgrimA_data.Rdata")


# The following command reads the PA_Store24B_data data frame, previously saved to file in the 
# "store24-prep.r" script.

load("data/PA_pilgrimA_data.Rdata")

# base R to show structure of datafram
str(PA_pilgrimA_data)
# nicer function from Hmisc to show info
contents(PA_pilgrimA_data)

# displays summary statistics for all variables
summary(PA_pilgrimA_data)

# WALKING THROUGH THE STATISTICS REVIEW

# PART 1: EXPLORE PROFIT
# calculating the 95% confidence interval for average (mean) customer profitability in 1999
#std <- sd(PA_pilgrimA_data$profit_99)/sqrt(length(PA_pilgrimA_data$profit_99))
summary(PA_pilgrimA_data$profit_99)
t.test(PA_pilgrimA_data$profit_99)

#PART 2: COMPARE PROFITABILITY OF ONLINE AND OFFLINE CUSTOMERS
#the online_99 variable is a dummy variable, which equals 1 if a customer is online and equals 0 if a customer is offline
#the bysort command allows us to compare the average profitability of online and offline customers
#bysort online_99: sum profit_99
#create a subset of only online_99==0
PA_pilgrimA_data.online0 = subset(PA_pilgrimA_data, PA_pilgrimA_data$online_99 == 0 )
#create a subset of only online_99==1
PA_pilgrimA_data.online1 = subset(PA_pilgrimA_data, PA_pilgrimA_data$online_99 == 1 )

summary(PA_pilgrimA_data.online0$profit_99)
summary(PA_pilgrimA_data.online1$profit_99)


#is the difference between the mean profitability for online and offline customers significant?
#we can test this in two ways, a t-test and a regression:
#t-test
#ttest profit_99, by(online_99)

t.test(PA_pilgrimA_data.online0$profit_99, PA_pilgrimA_data.online1$profit_99)

#regression
#regress profit_99 online_99
Regression = lm(PA_pilgrimA_data$profit_99 ~ PA_pilgrimA_data$online_99)
summary(Regression)

#PART 3: MANAGING MISSING DATA
#regression controlling for age
#regress profit_99 online_99 age_99
Regression = lm(PA_pilgrimA_data$profit_99 ~ PA_pilgrimA_data$online_99 + PA_pilgrimA_data$age_99)
summary(Regression)

#when we add age_99 to our regression, we see there are fewer observations in our regression
#it seems that some of our customers are missing age data.
#~= means "not equal", so this command counts the observations where age_99 is not missing 
sum(!is.na(PA_pilgrimA_data$age_99)) 
sum(is.na(PA_pilgrimA_data$age_99)) 

#Testing for Bias
#generate a new dummy variable that equals 1 if age_99 is not missing, and 0 if age_99 is missing
#generate age_99_Exists=1 if age_99~=.
age_99_exists <- as.numeric(!is.na(PA_pilgrimA_data$age_99))

#compare the average profitability of customers where age data is and isn't missing
PA_pilgrimA_data.agemissing = subset(PA_pilgrimA_data, age_99_exists == 0 )
PA_pilgrimA_data.agenotmissing = subset(PA_pilgrimA_data, age_99_exists == 1 )
summary(PA_pilgrimA_data.agemissing$profit_99)
summary(PA_pilgrimA_data.agenotmissing$profit_99)

#compare the average profitability of customers where age data is and isn't missing
t.test(PA_pilgrimA_data.agemissing$profit_99, PA_pilgrimA_data.agenotmissing$profit_99)

#regression
Regression2 = lm(PA_pilgrimA_data$profit_99 ~ age_99_exists)
summary(Regression2)

#Ways to Manage the Missing Age Data
#we could create a variable just like age_99, except that we subsitute the missing observations with zero
#recode subsubtitutes the missing observations with zero, and generate creates a new variable called age_99_Zero that contains this new information
#the age_99 variable remains unchanged
#recode age_99 (.=0), generate(age_99_Zero)

PA_pilgrimA_data$age_99_zero <- PA_pilgrimA_data$age_99
PA_pilgrimA_data$age_99_zero[is.na(PA_pilgrimA_data$age_99_zero)] <- 0

# try our regression controlling for age, this time using age_99_Zero instead of age_99
Regression3 = lm(PA_pilgrimA_data$profit_99 ~ PA_pilgrimA_data$online_99 + PA_pilgrimA_data$age_99_zero)
summary(Regression3)

# replace missing age variable w variable that is equal to the mean of the age_99 variable
PA_pilgrimA_data$age_99_mean <- PA_pilgrimA_data$age_99
PA_pilgrimA_data$age_99_mean[is.na(PA_pilgrimA_data$age_99_mean)] <- mean(PA_pilgrimA_data$age_99, na.rm=TRUE)

#try our regression controlling for age, this time using age_99_Avg instead of age_99
Regression4 = lm(PA_pilgrimA_data$profit_99 ~ PA_pilgrimA_data$online_99 + PA_pilgrimA_data$age_99_mean)
summary(Regression4)

#try adding our age_99_Exists dummy variable to both regressions
Regression5 = lm(PA_pilgrimA_data$profit_99 ~ PA_pilgrimA_data$online_99 + PA_pilgrimA_data$age_99_zero + age_99_exists)
summary(Regression5)

Regression6 = lm(PA_pilgrimA_data$profit_99 ~ PA_pilgrimA_data$online_99 + PA_pilgrimA_data$age_99_mean + age_99_exists)
summary(Regression6)

#Exploring Other Missing Data
#turn to an evaluation of other demographic variables
#regress profit_99 income_99
Regression7 = lm(PA_pilgrimA_data$profit_99 ~ PA_pilgrimA_data$income_99)
summary(Regression7)

sum(!is.na(PA_pilgrimA_data$income_99)) 
sum(is.na(PA_pilgrimA_data$income_99)) 


#as we did with age, test difference in the average profitability of customers where income data is and isn't missing 
#generate a new dummy variable that equals 1 if income_99 is not missing, and 0 if income_99 is missing
#note we can simply type "g" rather than "generate"
income_99_exists <- as.numeric(!is.na(PA_pilgrimA_data$income_99))

PA_pilgrimA_data.incomemissing = subset(PA_pilgrimA_data, income_99_exists == 0 )
PA_pilgrimA_data.incomenotmissing = subset(PA_pilgrimA_data, income_99_exists == 1 )
summary(PA_pilgrimA_data.incomemissing$profit_99)
summary(PA_pilgrimA_data.incomenotmissing$profit_99)

#is this difference statistically significant?
#t-test
#ttest profit_99, by(income_99_Exists)

#regression

#proceed with the same processes we used to manage the missing age data
#create a variable just like income_99, except that we subsitute the missing observations with zero
#recode income_99 (.=0), generate(income_99_Zero)


#create a variable that is equal to the mean of the income_99 variable
#egen income_99_Avg=mean(income_99)

#replace the values of income_99_Avg with the values of income_99 if income_99 is not equal to missing
#replace income_99_Avg=income_99 if income_99~=.

#try adding our income_99_Exists dummy variable to both regressions
#regress profit_99 online_99 age_99_Zero age_99_Exists income_99_Zero income_99_Exists 

#PART 4: COMPARE PROFIT CONTROLLING FOR REMAINING DEMOGRAPHICS
#adding tenure as a control variable
#regress profit_99 online_99 age_99_Avg age_99_Exists income_99_Avg income_99_Exists tenure_99


# closes your log
#log close
sink()

# drops all data from Stata's memory
#clear
# R: we're not going to do this so that we can examine our environment afterwards
