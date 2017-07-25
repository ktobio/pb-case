##################################################################################################
# File        : pb-case-prepare-data.R  <--- this should be the exact name of THIS document
# Author      : Kristina Tobio & Bob Freeman 
# Created     : 02 Dec 2016
# Modified    : 14 May 2017
# Description : .R file for preparing data for use in PA_pilgrimA_code.R, PA_pilgrimB_code.R,
# 			  and PA_pilgrimC_code.R.
##################################################################################################
# setup environment for R and script below
install.packages('tidyverse', dependencies = TRUE)
install.packages('Hmisc')
#library('tidyverse')

# this clears R's data memory so new data can be loaded
#clear 
rm(list = ls())

# these commands prepare your computer for the data and analysis
# this finds and closes open log files
#  NOT NEEDED IN R, as we get automatic transcripts
#  or we can implement a logging function
#capture log close        


# this makes it so you don't have to keep pressing return/enter to scroll through results
#  NOT NEEDED IN R, but can output truncated results through head() or 
#set more off 

# this keeps everything visible on a normal monitor or laptop screen
#  NOT NEEDED IN R
#set linesize 200    

# cd means "change directory"
# changes to the current directory 
#cd .
# R: not needed, as opening the RStudio project puts us in the correct directory

# this creates a log file, which will record all of the commands and outputs from this .do file 
# log files should be placed in a folder named "logs" in your directory 
#log using "logs/pb-case-prepare-data", replace 
sink(file = "./logs/pb-case-prepare-data.txt", append = FALSE, type = c("output", "message"), split = TRUE)

# data should be placed in a folder named "data" in your directory 
# this pulls in the data in its exact Excel form from HBP
# this command reads the data into Stata
#import excel using "data/Pilgrim_ABC_Spreadsheet.xls", sheet(Data) firstrow
#  R:
#  we will use readxl package for reading Excel files
library('readxl')     # for reading in Excel files
pilgrim.data <- read_excel("./data/Pilgrim_ABC_Spreadsheet.xls", sheet = "Data", col_names = TRUE)

# renaming variables to make them more user friendly
#rename ID id
#rename Profit profit_99
#rename Online online_99
#rename Age age_99
#rename Inc income_99
#rename Tenure tenure_99
#rename District district_99
#rename H profit_00
#rename I online_00
#rename Billpay billpay_99
#rename K billpay_00
#
# R: we're going to rename variables using rename() from plyr
#
library('plyr')
pilgrim.data <- rename(pilgrim.data, replace =c("ID" = "id"))
# don't neeed 'replace =' if your putting the replacement in the 2nd position
pilgrim.data <- rename(pilgrim.data, c("9Profit" = "profit_99"))
pilgrim.data <- rename(pilgrim.data, c("9Online" = "online_99"))
pilgrim.data <- rename(pilgrim.data, c("9Age" = "age_99"))
pilgrim.data <- rename(pilgrim.data, c("9Inc" = "income_99"))
pilgrim.data <- rename(pilgrim.data, c("9Tenure" = "tenure_99"))
pilgrim.data <- rename(pilgrim.data, c("9District" = "district_99"))
pilgrim.data <- rename(pilgrim.data, c("0Profit" = "profit_00"))
pilgrim.data <- rename(pilgrim.data, c("0Online" = "online_00"))
# let's do two at a time
pilgrim.data <- rename(pilgrim.data, c("9Billpay" = "billpay_99", "0Billpay" = "billpay_00"))



# labels variables
#label var id "Customer ID"
#label var profit_99 "Annual Profit, 1999" 
#label var online_99 "Online Usage, 1999 (1=online, 0=offline)"
#label var age_99 "Age Bucket, 1999"
#label var income_99 "Income Bucket, 1999"
#label var tenure_99 "Tenure (years), 1999"
#label var district_99 "Geographic Region, 1999"
#label var profit_00 "Annual Profit, 2000"
#label var online_00 "Online Usage, 2000 (1=online, 0=offline)"
#label var billpay_99 "Billpay Usage, 1999 (1=billpay, 0=no billpay)"
#label var billpay_00 "Billpay Usage, 2000 (1=billpay, 0=no billpay)"
#
# R: we're going to use the Hmisc package to handle doing column labels
#
str(pilgrim.data)
library('Hmisc')
label(pilgrim.data$id) <- "Customer ID"
label(pilgrim.data$profit_99) <- 'Annual Profit 1999'
label(pilgrim.data$online_99) <- "Online Usage 1999 (1=online 0=offline)"
label(pilgrim.data$age_99) <- "Age Bucket 1999"
label(pilgrim.data$income_99) <- "Income Bucket 1999"
label(pilgrim.data$tenure_99) <- "Tenure (years) 1999"
label(pilgrim.data$district_99) <- "Geographic Region 1999"
label(pilgrim.data$profit_00) <- "Annual Profit 2000"
label(pilgrim.data$online_00) <- "Online Usage 2000 (1=online 0=offline)"
label(pilgrim.data$billpay_99) <- "Billpay Usage 1999 (1=billpay 0=no billpay)"
label(pilgrim.data$billpay_00) <- "Billpay Usage 2000 (1=billpay 0=no billpay)"

# base R to show structure of datafram
str(pilgrim.data)
# nicer function from Hmisc to show info
contents(pilgrim.data)

# export data into a CSV file that can be easily imported into Stata
#export delimited "data/PA_pilgrim_data.csv", replace
#export excel "data/PA_pilgrim_data.xls", replace
#save "data/PA_pilgrim_data.dta", replace
#  R:
#  write csv file using readr library
library('readr')
write_csv(pilgrim.data, file = "data/PA_pilgrim_data.csv", na = "", 
          append = FALSE, col_names = TRUE)
#  write excel file
#   as with all R functions, the param name can be ommitted if things are in the 
#   correct position. Do this only if it helps readability: for example, we know we're
#   talking about a file at this particular position in this function call
write_excel_csv(pilgrim.data, "data/PA_pilgrim_data.xls", na = "",
                append = FALSE, col_names = TRUE)
#  write R datafile
save(pilgrim.data, "data/PA_pilgrim_data.RData")



library('dplyr')
# create a seperate dataset for Part A of case (and PA_pilgrimA_code.do), which only uses the 1999 (suffix "_99") data and no billpay_99
#keep id profit_99 online_99 age_99 income_99 tenure_99 district_99
pilgrimA.data <- select(pilgrim.data, id, profit_99, online_99, 
                                      age_99, income_99, tenure_99, district_99)
#export delimited "data/PA_pilgrimA_data.csv", replace
write_csv(pilgrimA.data, "data/PA_pilgrimA_data.csv", na = "", 
          append = FALSE, col_names = TRUE)
#export excel "data/PA_pilgrimA_data.xls", firstrow(variables) replace
write_excel_csv(pilgrimA.data, "data/PA_pilgrimA_data.xls", na = "",
                append = FALSE, col_names = TRUE)
#save "data/PA_pilgrimA_data.dta", replace
save(pilgrimA.data, file = "data/PA_pilgrimA_data.RData")


# clear Stata memory
#clear
# R: don't need to do this

# create a seperate dataset for additional data for Part B of case (and PA_pilgrimB_code.do), which adds the 2000 (suffix "_00") data save the billpay variable
#use "data/PA_pilgrim_data"
# R: don't need that
#keep id profit_00 online_00 profit_99 online_99 age_99 income_99 tenure_99 district_99
pilgrimB.data <- select(pilgrim.data, id, profit_00, online_00, profit_99, online_99,
                        age_99, income_99, tenure_99, district_99)
#export delimited "data/PA_pilgrimB_original_data.csv", replace
write_csv(pilgrimB.data, "data/PA_pilgrimB_original_data.csv", na = "", 
          append = FALSE, col_names = TRUE)
#export excel "data/PA_pilgrimB_original_data.xls", firstrow(variables) replace
write_excel_csv(pilgrimB.data, "data/PA_pilgrimB_original_data.xls", na = "",
                append = FALSE, col_names = TRUE)
#save "data/PA_pilgrimB_original_data.dta", replace
save(pilgrimB.data, file = "data/PA_pilgrimB_original_data.RData")


# clear Stata memory
#clear
# R: no need for this


# create a seperate dataset for additional data for Part C of case (and PA_pilgrimC_code.do), which adds the billpay variables
#use "data/PA_pilgrim_data"
# R: no need for this
#keep id billpay_99 billpay_00 profit_00 online_00 profit_99 online_99 age_99 income_99 tenure_99 district_99
pilgrimC.data <- select(pilgrim.data, id, billpay_99, billpay_00, profit_00, online_00,
                        profit_99, online_99, age_99, income_99, tenure_99, district_99)
#export delimited "data/PA_pilgrimC_original_data.csv", replace
write_csv(pilgrimC.data, "data/PA_pilgrimC_original_data.csv", na = "", 
          append = FALSE, col_names = TRUE)
#export excel "data/PA_pilgrimC_original_data.xls", firstrow(variables) replace
write_excel_csv(pilgrimC.data, "data/PA_pilgrimC_original_data.xls", na = "",
                append = FALSE, col_names = TRUE)
#save "data/PA_pilgrimC_original_data.dta", replace
save(pilgrimC.data, file = "data/PA_pilgrimC_original_data.RData")


# clear Stata memory
#clear
# R: no need for this

# merging the three datasets together
#
# ** Not really necessary in R. Still want to do this??
#
  # # Merge together one at a time
  # # "id" is the common variable in all three datasets
  # use "data/PA_pilgrimA_data.dta"
  # merge 1:1 id using "data/PA_pilgrimB_original_data.dta"
  # tab _merge
  # # _merge should all equal "3" if it is successful
  # drop _merge
  # save "data/PA_pilgrim_data.dta", replace
  # merge 1:1 id using "data/PA_pilgrimC_original_data.dta"
  # tab _merge
  # # merge should all equal "3" if it is successful
  # drop _merge
  # save "data/PA_pilgrim_data.dta", replace
  # clear
#


# Creating datasets for Parts B and C that include variables created in Part A (for Part B) and Part B (for Part C)
# Part B
# use "data/PA_pilgrimB_original_data.dta"
# Creating variables that are created in the PA_pilgrimA_code_TN.do file 
# generate a new dummy variable that equals 1 if age_99 is not missing, and 0 if age_99 is missing
#generate age_exist_99=1 if age_99~=.
#replace age_exist_99=0 if age_exist_99==.
#label var age_exist_99 "Age Exists Indicator, 1999 (1=age exists)"
# R:
# create new column on the fly and store with value (thought not really needed)
pilgrimB.data$age_exist_99 <- ifelse(is.na(pilgrimB.data$age_99), 0, 1)
label(pilgrimB.data$age_exist_99) <- "Age Exists Indicator 1999 (1=age exists)"
#
# recode subsubtitutes the missing observations with zero, and generate creates a new variable
# called age_zero_99 that contains this new information. The age_99 variable remains unchanged
#recode age_99 (.=0), generate(age_zero_99)
#label var age_zero_99 "Age replaced with Zero if Missing, 1999"
# R: 
# let's do this again
pilgrimB.data$age_zero_99 <- ifelse(is.na(pilgrimB.data$age_99), 1, 0)
label(pilgrimB.data$age_zero_99) <- "Age replaced with Zero if Missing 1999"
#
# the egen command, along with mean, creates a variable that is equal to the mean of the age_99 variable
#egen age_99_Avg=mean(age_99)
#
pilgrimB.data$age_99_Avg <- mean(pilgrimB.data$age_99, na.rm = TRUE)
#
# now, we want to replace age_99_Avg with the actual age values, if they are not missing
# if the actual age values are missing, we will keep the average age value
# this command below replaces the values of age_99_Avg with the values of age_99 if age_99 is not equal to missing
#replace age_99_Avg=age_99 if age_99~=.
#label var age_99_Avg "Age replaced with Age Average if Missing, 1999"
# 
pilgrimB.data$age_99_Avg <- ifelse(!is.na(pilgrimB.data$age_99), pilgrimB.data$age_99, pilgrimB.data$age_99_Avg)
label(pilgrimB.data$age_99_Avg) <- "Age replaced with Age Average if Missing 1999"
#
# generate a new dummy variable that equals 1 if income_99 is not missing, and 0 if income_99 is missing
# note we can simply type "g" rather than "generate"
#g income_exist_99=1 if income_99~=.
#label var income_exist_99 "Income Exists Indicator, 1999 (1=income exists)"
#replace income_exist_99=0 if income_exist_99==.
#
pilgrimB.data$income_exist_99 <- ifelse(is.na(pilgrimB.data$income_exist_99), 0, 1)
label(pilgrimB.data$income_exist_99) <-  "Income Exists Indicator 1999 (1=income exists)"
#
# create a variable just like income_99, except that we subsitute the missing observations with zero
#recode income_99 (.=0), generate(income_zero_99)
#label var income_zero_99 "Income replaced with Zero if Missing, 1999"
#
pilgrimB.data$income_zero_99 <- ifelse(is.na(pilgrimB.data$income_99), 1, 0)
label(pilgrimB.data$income_zero_99) <- "Income replaced with Zero if Missing 1999"
#
# create a variable that is equal to the mean of the income_99 variable
#egen income_99_Avg=mean(income_99)
#
pilgrimB.data$income_99_Avg <- mean(pilgrimB.data$income_99, na.rm = TRUE)
#
# replace the values of income_99_Avg with the values of income_99 if income_99 is not equal to missing
#replace income_99_Avg=income_99 if income_99~=.
#label var income_99_Avg "Income replaced with Income Average if Missing, 1999"
#
pilgrimB.data$income_99_Avg <- ifelse(!is.na(pilgrimB.data$income_99), pilgrimB.data$income_99, pilgrimB.data$income_99_Avg)
label(pilgrimB.data$income_99_Avg) <- "Income replaced with Income Average if Missing 1999"
#
# save the dataset for Part B
#save "data/PA_pilgrimB_data.dta", replace
#export excel "data/PA_pilgrimB_data.xls", firstrow(variables) replace
#clear
write_excel_csv(pilgrimB.data, "data/PA_pilgrimB_data.xl", na = "",
                append = FALSE, col_names = TRUE)
save(pilgrimB.data, file = "data/PA_pilgrimB_data.RData")

# Part C
#use "data/PA_pilgrimC_original_data.dta"
#merge 1:1 id using "data/PA_pilgrimB_data.dta"
#//tab merge then delete
#tab _merge
#drop _merge
#  R:
#  create a temp dataframe so that we don't merge in duplicate columns
pilgrimBtemp.data <- select(pilgrimB.data, id, income_zero_99, age_zero_99, income_exist_99, age_exist_99)
pilgrimCmerge.data <- merge(pilgrimC.data, pilgrimBtemp.data, by = "id")
#
# create an indicator for customers that were retained
# customers that were NOT retained will have missing data for profit_00
# == is "equal to", and ~= is "not equal to"
#g retain=0 if profit_00==.
#replace retain=1 if profit_00~=.
#label variable retain "Retain Indicator (1=retained, 0=not retained)"
#
pilgrimCmerge.data$retain <- ifelse(is.na(pilgrimCmerge.data$profit_00), 0, 1)
label(pilgrimCmerge.data$retain) <- "Retain Indicator (1=retained 0=not retained)"

#
# Creating variables that are created in the PA_pilgrimB_code_TN.do file 
# Does adding customer profitability from 1999 have an effect on our results?
#regress retain profit_99 online_99 tenure_99 income_zero_99 age_zero_99 income_exist_99 age_exist_99 i.district_99
#
retain.lm <- lm(retain ~ profit_99 + online_99 + tenure_99 + income_zero_99 + age_zero_99
                + income_exist_99 + age_exist_99 + district_99, data = pilgrimCmerge.data)
summary(retain.lm )
#
# Predict customer retention using the above equation
#predict retainPredict
#label var retainPredict "Prediction of Customer Retention"
#
pilgrimCmerge.data$retainPredict <- predict.lm(retain.lm)
label(pilgrimCmerge.data$retainPredict) <- "Prediction of Customer Retention"
#
# Using logistic regression, which may be a better fit
#logit retain profit_99 online_99 tenure_99 income_zero_99 age_zero_99 income_exist_99 age_exist_99 i.district_99

retain.logit <- glm(retain ~ profit_99 + online_99 + tenure_99 + income_zero_99 + age_zero_99
                    + income_exist_99 + age_exist_99 + district_99, 
                    data = pilgrimCmerge.data, family = binomial(link = "logit"))
summary(retain.logit)
#
# Predict customer retention using the logistic equation
#predict retainLogit
#label var retainLogit "Logit Prediction of Customer Retention"
#
pilgrimCmerge.data$retainLogit <- predict.glm(retain.logit)
label(pilgrimCmerge.data$retainLogit) <- "Logit Prediction of Customer Retention"
#
# save the dataset for Part C
#save "data/PA_pilgrimC_data.dta", replace
#export excel "data/PA_pilgrimC_data.xls", firstrow(variables) replace
#clear
#
save(pilgrimCmerge.data, file="data/PA_pilgrimC_data.RData")
write_excel_csv(pilgrimCmerge.data, "data/PA_pilgrimC_data.xls", na = "",
                append = FALSE, col_names = TRUE)

# closes your log
#log close
sink()

# drops all data from Stata's memory
#clear
# R: we're not going to do this so that we can examine our environment afterwards
