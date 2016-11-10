/**********************************************************************************
File        : pb-case-b.do  <--- this should be the exact name of THIS document
Author      : Kristina Tobio 
Created     : 08 Nov 2016
Modified    : 10 Nov 2016
Description : .do file for Pilgrim Bank Case Part B 
**********************************************************************************/

// these commands prepare your computer for the data and analysis
// this finds and closes open log files
capture log close        
// this clears Stata's data memory so new data can be loaded
clear       
// this makes it so you don't have to keep pressing return/enter to scroll through results
set more off          
// this sets memory size
set mem 100m       
// this keeps everything visible on a normal monitor or laptop screen
set linesize 200    

// cd means "change directory"
// you need to change this to the location on your computer where you are storing the .do and data files
*cd "/Users/ktobio/Desktop/Jeff/Course/Pilgrim Bank/pb-case/"       

// this creates a log file, which will record all of the commands and outputs from this .do file 
// log files should be placed in a folder named "logs" in your directory 
log using "logs/pb-case-b", replace

// we created a set of variable in Part A of this case, and they may be useful to us now
// so, we use our saved dataset
use "data/pb-case-data-new-variables.dta"

// displays summary statistics for online customers in 1999 and 2000
sum _9online _0online

// WALKING THROUGH THE STATISTICS REVIEW

// PART 1: IDENTIFY DRIVERS OF CUSTOMER PROFITABILITY
// Do customer attributes from 1999 significantly predict customer profitability in 2000?
regress _0profit _9online
// What if we add some controls? What coefficients are significant?
// The i. command automatically creates dummy variables from a categorical variable.
regress _0profit _9online _9tenure _9incZero _9ageZero _9incExist _9ageExist i._9district
// We should also control for the customer's profitability in 1999
regress _0profit _9profit _9online _9tenure _9incZero _9ageZero _9incExist _9ageExist i._9district


// PART 2: FORECAST INDIVIDUAL CUSTOMER PROFITABILITY
// PART 3: IDENTIFY DRIVERS OF CUSTOMER RETENTION
// PART 4: USING LOGISTIC REGRESSION WITH A BINARY DEPENDENT VARIABLE
// PART 5: INTERPRETING LOGISTIC REGRESSION COEFFICIENTS




// closes your log
log close

// drops all data from Stata's memory
clear



//DELETE FROM HERE// 
// PART 1: COMPARE PROFITABILITY AND RETENTION OF ONLINE AND OFFLINE CUSTOMERS IN 2000
// the _0online variable is a dummy variable, which equals 1 if a customer is online and equals 0 if a customer is offline
// the bysort command allows us to compare the average profitability of online and offline customers
bysort _0online: sum _0profit

// is the difference between the mean profitability for online and offline customers significant?
// we can test this in two ways, a t-test and a regression:
// t-test
ttest _0profit, by(_0online)
// regression
regress _0profit _0online


// Retention
// create an indicator for customers that were retained
g retained=.
// replace indicator with 0 if there was an account in 1999 but not in 2000
replace retained=0 if _9profit~=. & _0profit==.
// replace indicator with 0 if there was an account in 1999 AND in 2000
replace retained=1 if _9profit~=. & _0profit~=.


regress _0profit _9online _9ageAvg _9ageExists _9incAvg _9incExists _9tenure i._9district


// PART 3: CHANGE IN PROFITABILITY
// create a variable that contains the result of a calculation of profitibility growth/loss for each customer
*g profit_growth_9900=(_0profit-_9profit)/_9profit

 
