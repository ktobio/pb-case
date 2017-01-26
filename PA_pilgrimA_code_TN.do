/**********************************************************************************
File        : PA_pilgrimA_code_DRAFT.do  <--- this should be the exact name of THIS document
Author      : Kristina Tobio 
Created     : 07 Nov 2016
Modified    : 19 Jan 2017
Description : .do file for Pilgrim Bank Case Part A 
**********************************************************************************/



// the following five commands prepare your computer for the data and analysis
// these five commands are optional, but helpful
// to run them, highlight this block of text, including the five commands
// while they are highlighted, click the execute Do button above
// the capture command finds and closes open log files
capture log close        
// this clears Stata's data memory so new data can be loaded
clear       
// this makes it so you don't have to keep pressing return/enter to scroll through results
set more off          
// this sets memory size
set linesize 200    

// after executing the commands above, we recommend opening a log file
// log files record all of the commands and output from your work session 



// this code labels the variables
label var id "Customer ID"
label var profit_99 "Annual Profit, 1999" 
label var online_99 "Online Usage, 1999"
label var age_99 "Age Bucket, 1999"
label var income_99 "Income Bucket, 1999"
label var tenure_99 "Tenure (years), 1999"
label var district_99 "Geographic Region, 1999"

// save the data as a Stata dataset
*save "data/pb-case-data.dta", replace

// this describes the data, including listing the names and labels
describe

// displays summary statistics for all variables
summarize 

// displays more detailed summary statistics for a particular variable
// note "summarize" and "sum" are the same command
sum profit_99, detail

// other analyses are up to you!
// please be prepared in class on Wednesday to discuss how you analyzed the data
// the "Stata Basics" guide on Canvas may be helpful





// WALKING THROUGH THE STATISTICS REVIEW

// PART 1: EXPLORE PROFIT
// calculating the 95% confidence interval for average (mean) customer profitability in 1999
ci mean profit_99, level(95)

// PART 2: COMPARE PROFITABILITY OF ONLINE AND OFFLINE CUSTOMERS
// the online_99 variable is a dummy variable, which equals 1 if a customer is online and equals 0 if a customer is offline
// the bysort command allows us to compare the average profitability of online and offline customers
bysort online_99: sum profit_99

// is the difference between the mean profitability for online and offline customers significant?
// we can test this in two ways, a t-test and a regression:
// t-test
ttest profit_99, by(online_99)
// regression
regress profit_99 online_99

// PART 3: MANAGING MISSING DATA
// regression controlling for age
regress profit_99 online_99 age_99
// when we add age_99 to our regression, we see there are fewer observations in our regression
// it seems that some of our customers are missing age data.
// ~= means "not equal", so this command counts the observations where age_99 is not missing 
count if age_99~=.
// == means "equal", so this command counts the observations where age_99 is missing 
count if age_99==.

// Testing for Bias
// generate a new dummy variable that equals 1 if age_99 is not missing, and 0 if age_99 is missing
generate age_99_Exists=1 if age_99~=.
replace age_99_Exists=0 if age_99_Exists==.
bysort age_99_Exists: count if age_99==.
// compare the average profitability of customers where age data is and isn't missing
bysort age_99_Exists: sum profit_99
// is this difference significant? Once again, we can use a t-test or a regression to find out.
// t-test
ttest profit_99, by(age_99_Exists)
// regression
regress profit_99 age_99_Exists

// Ways to Manage the Missing Age Data
// we could create a variable just like age_99, except that we subsitute the missing observations with zero
// recode subsubtitutes the missing observations with zero, and generate creates a new variable called age_99_Zero that contains this new information
// the age_99 variable remains unchanged
recode age_99 (.=0), generate(age_99_Zero)
// try our regression controlling for age, this time using age_99_Zero instead of age_99
regress profit_99 online_99 age_99_Zero
// the egen command, along with mean, creates a variable that is equal to the mean of the age_99 variable
egen age_99_Avg=mean(age_99)
// to check, summarize age_99, then tabulate the values of age_99_Avg. They are equal. 
sum age_99
tab age_99_Avg, missing
// now, we want to replace age_99_Avg with the actual age values, if they are not missing
// if the actual age values are missing, we will keep the average age value
// this command below replaces the values of age_99_Avg with the values of age_99 if age_99 is not equal to missing
replace age_99_Avg=age_99 if age_99~=.
// we can check our work in the following way
tab age_99_Avg if age_99==.
// try our regression controlling for age, this time using age_99_Avg instead of age_99
regress profit_99 online_99 age_99_Avg
// try adding our age_99_Exists dummy variable to both regressions
regress profit_99 online_99 age_99_Zero age_99_Exists
regress profit_99 online_99 age_99_Avg age_99_Exists
 
// Exploring Other Missing Data
// turn to an evaluation of other demographic variables
regress profit_99 income_99
// determine if income_99 (1999 Income) has missing data
count if income_99==.
// as we did with age, test difference in the average profitability of customers where income data is and isn't missing 
// generate a new dummy variable that equals 1 if income_99 is not missing, and 0 if income_99 is missing
// note we can simply type "g" rather than "generate"
g income_99_Exists=1 if income_99~=.
replace income_99_Exists=0 if income_99_Exists==.
bysort income_99_Exists: count if income_99==.
bysort income_99_Exists: sum profit_99
// is this difference statistically significant?
// t-test
ttest profit_99, by(income_99_Exists)
// regression
regress profit_99 income_99_Exists
// proceed with the same processes we used to manage the missing age data
// create a variable just like income_99, except that we subsitute the missing observations with zero
recode income_99 (.=0), generate(income_99_Zero)
// create a variable that is equal to the mean of the income_99 variable
egen income_99_Avg=mean(income_99)
// replace the values of income_99_Avg with the values of income_99 if income_99 is not equal to missing
replace income_99_Avg=income_99 if income_99~=.
// try adding our income_99_Exists dummy variable to both regressions
regress profit_99 online_99 age_99_Zero age_99_Exists income_99_Zero income_99_Exists 
regress profit_99 online_99 age_99_Avg age_99_Exists income_99_Avg income_99_Exists 

// PART 4: COMPARE PROFIT CONTROLLING FOR REMAINING DEMOGRAPHICS
// adding tenure as a control variable
regress profit_99 online_99 age_99_Avg age_99_Exists income_99_Avg income_99_Exists tenure_99
// adding district as a control variable
regress profit_99 online_99 age_99_Avg age_99_Exists income_99_Avg income_99_Exists tenure_99 district_99

// District is a Categorical Variable
// we should create a dummy variable for each of the three categories in district_99
tab district_99, gen(district_99_Dum)
// we have created three dummy variables: district_99_Dum1, district_99_Dum2, and district_99_Dum3
// we only need to include two of these three variables in our regression
// "*" is a wildcard, and if we type district_99_Dum*, Stata will choose which dummy variable to drop for us
regress profit_99 online_99 age_99_Avg age_99_Exists income_99_Avg income_99_Exists tenure_99 district_99_Dum*
// alternatively, we can choose which one to drop
// the results of all three of these regressions are the same
regress profit_99 online_99 age_99_Avg age_99_Exists income_99_Avg income_99_Exists tenure_99 district_99_Dum1 district_99_Dum2
regress profit_99 online_99 age_99_Avg age_99_Exists income_99_Avg income_99_Exists tenure_99 district_99_Dum1 district_99_Dum3
regress profit_99 online_99 age_99_Avg age_99_Exists income_99_Avg income_99_Exists tenure_99 district_99_Dum2 district_99_Dum3
// instead of creating the dummy variables, we could use a special command in our regression so that the dummies are created when the regression is run
// this command puts an "i." in front of the variable we want to create dummies out of, in this case, district_99
regress profit_99 online_99 age_99_Avg age_99_Exists income_99_Avg income_99_Exists tenure_99 i.district_99

// because we created some new variables, we want to save this dataset in case we want to use it later
save "data/PA_pilgrimA_updated_data.dta", replace
// Note that this save command did not work for Jeff

// closes your log
log close

// drops all data from Stata's memory
clear


