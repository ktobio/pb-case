/**********************************************************************************
File        : PA_pilgrimA_code.do  <--- this should be the exact name of THIS document
Author      : Kristina Tobio 
Created     : 07 Nov 2016
Modified    : 19 Jan 2017
Description : .do file for Pilgrim Bank Case Part A 
**********************************************************************************/

// these commands prepare your computer for the data and analysis
// this finds and closes open log files
capture log close        
// this clears Stata's data memory so new data can be loaded
clear       
// this makes it so you don't have to keep pressing return/enter to scroll through results
set more off          
// this sets memory size
set linesize 200    

// cd means "change directory"
// changes to the current directory 
cd .

// this creates a log file, which will record all of the commands and outputs from this .do file 
// log files should be placed in a folder named "logs" in your directory 
log using "logs/PA_pilgrimA_log", replace

// data should be placed in a folder named "data" in your directory 
// the data is in .csv (comma seperated values) format
// this command reads the data into Stata
insheet using "data/pb-case-data.csv", names

// code here that labels the variables?

// save the data as a Stata dataset
save "data/pb-case-data.dta", replace

// displays summary statistics for all variables
summarize 

// displays more detailed summary statistics for a particular variable
// note "summarize" and "sum" are the same command
sum _9profit, detail

// WALKING THROUGH THE STATISTICS REVIEW

// PART 1: EXPLORE PROFIT
// calculating the 95% confidence interval for average (mean) customer profitability in 1999
ci mean _9profit, level(95)

// PART 2: COMPARE PROFITABILITY OF ONLINE AND OFFLINE CUSTOMERS
// the _9online variable is a dummy variable, which equals 1 if a customer is online and equals 0 if a customer is offline
// the bysort command allows us to compare the average profitability of online and offline customers
bysort _9online: sum _9profit

// is the difference between the mean profitability for online and offline customers significant?
// we can test this in two ways, a t-test and a regression:
// t-test
ttest _9profit, by(_9online)
// regression
regress _9profit _9online

// PART 3: MANAGING MISSING DATA
// regression controlling for age
regress _9profit _9online _9age
// when we add _9age to our regression, we see there are fewer observations in our regression
// it seems that some of our customers are missing age data.
// ~= means "not equal", so this command counts the observations where _9age is not missing 
count if _9age~=.
// == means "equal", so this command counts the observations where _9age is missing 
count if _9age==.

// Testing for Bias
// generate a new dummy variable that equals 1 if _9age is not missing, and 0 if _9age is missing
generate _9ageExists=1 if _9age~=.
replace _9ageExists=0 if _9ageExists==.
bysort _9ageExists: count if _9age==.
// compare the average profitability of customers where age data is and isn't missing
bysort _9ageExists: sum _9profit
// is this difference significant? Once again, we can use a t-test or a regression to find out.
// t-test
ttest _9profit, by(_9ageExists)
// regression
regress _9profit _9ageExists

// Ways to Manage the Missing Age Data
// we could create a variable just like _9age, except that we subsitute the missing observations with zero
// recode subsubtitutes the missing observations with zero, and generate creates a new variable called _9ageZero that contains this new information
// the _9age variable remains unchanged
recode _9age (.=0), generate(_9ageZero)
// try our regression controlling for age, this time using _9ageZero instead of _9age
regress _9profit _9online _9ageZero
// the egen command, along with mean, creates a variable that is equal to the mean of the _9age variable
egen _9ageAvg=mean(_9age)
// to check, summarize _9age, then tabulate the values of _9ageAvg. They are equal. 
sum _9age
tab _9ageAvg, missing
// now, we want to replace _9ageAvg with the actual age values, if they are not missing
// if the actual age values are missing, we will keep the average age value
// this command below replaces the values of _9ageAvg with the values of _9age if _9age is not equal to missing
replace _9ageAvg=_9age if _9age~=.
// we can check our work in the following way
tab _9ageAvg if _9age==.
// try our regression controlling for age, this time using _9ageAvg instead of _9age
regress _9profit _9online _9ageAvg
// try adding our _9ageExists dummy variable to both regressions
regress _9profit _9online _9ageZero _9ageExists
regress _9profit _9online _9ageAvg _9ageExists
 
// Exploring Other Missing Data
// turn to an evaluation of other demographic variables
regress _9profit _9inc
// determine if _9inc (1999 Income) has missing data
count if _9inc==.
// as we did with age, test difference in the average profitability of customers where income data is and isn't missing 
// generate a new dummy variable that equals 1 if _9inc is not missing, and 0 if _9inc is missing
// note we can simply type "g" rather than "generate"
g _9incExists=1 if _9inc~=.
replace _9incExists=0 if _9incExists==.
bysort _9incExists: count if _9inc==.
bysort _9incExists: sum _9profit
// is this difference statistically significant?
// t-test
ttest _9profit, by(_9incExists)
// regression
regress _9profit _9incExists
// proceed with the same processes we used to manage the missing age data
// create a variable just like _9inc, except that we subsitute the missing observations with zero
recode _9inc (.=0), generate(_9incZero)
// create a variable that is equal to the mean of the _9inc variable
egen _9incAvg=mean(_9inc)
// replace the values of _9incAvg with the values of _9inc if _9inc is not equal to missing
replace _9incAvg=_9inc if _9inc~=.
// try adding our _9incExists dummy variable to both regressions
regress _9profit _9online _9ageZero _9ageExists _9incZero _9incExists 
regress _9profit _9online _9ageAvg _9ageExists _9incAvg _9incExists 

// PART 4: COMPARE PROFIT CONTROLLING FOR REMAINING DEMOGRAPHICS
// adding tenure as a control variable
regress _9profit _9online _9ageAvg _9ageExists _9incAvg _9incExists _9tenure
// adding district as a control variable
regress _9profit _9online _9ageAvg _9ageExists _9incAvg _9incExists _9tenure _9district

// District is a Categorical Variable
// we should create a dummy variable for each of the three categories in _9district
tab _9district, gen(_9districtDum)
// we have created three dummy variables: _9districtDum1, _9districtDum2, and _9districtDum3
// we only need to include two of these three variables in our regression
// "*" is a wildcard, and if we type _9districtDum*, Stata will choose which dummy variable to drop for us
regress _9profit _9online _9ageAvg _9ageExists _9incAvg _9incExists _9tenure _9districtDum*
// alternatively, we can choose which one to drop
// the results of all three of these regressions are the same
regress _9profit _9online _9ageAvg _9ageExists _9incAvg _9incExists _9tenure _9districtDum1 _9districtDum2
regress _9profit _9online _9ageAvg _9ageExists _9incAvg _9incExists _9tenure _9districtDum1 _9districtDum3
regress _9profit _9online _9ageAvg _9ageExists _9incAvg _9incExists _9tenure _9districtDum2 _9districtDum3
// instead of creating the dummy variables, we could use a special command in our regression so that the dummies are created when the regression is run
// this command puts an "i." in front of the variable we want to create dummies out of, in this case, _9district
regress _9profit _9online _9ageAvg _9ageExists _9incAvg _9incExists _9tenure i._9district

// because we created some new variables, we want to save this dataset in case we want to use it later
save "data/pb-case-data-new-variables.dta"
// Note that this save command did not work for Jeff

// closes your log
log close

// drops all data from Stata's memory
clear


