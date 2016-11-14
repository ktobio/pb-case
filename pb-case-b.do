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
// Export variable names and coefficients to Excel, where it can be used as a model to forecast individual customers' potential profitability
// This command sets up the Excel file where we will be exporting our results
putexcel set "data/forecast-model.xls", replace
// This command tells Stata to put the heading "Variable Name" in the A1 (top lefthand corner) cell
putexcel A1="Variable Name"
// This command tells Stata to put the heading "Variable" in the B1  cell
putexcel B1="Coefficient"
// This command creates a 2x11 matrix with variable names on the lefthand side and coefficients on the righthand side
matrix b = e(b)'
// This command exports the matrix into Excel
// NB: This command will write over the "data/forecast-model.xls" file every time the program is run. To keep any work you do on this file, save it to another location.
putexcel A2 = matrix(b), rownames nformat(number_d2)

// PART 3: IDENTIFY DRIVERS OF CUSTOMER RETENTION
// create an indicator for customers that were retained
// customers that were NOT retained will have missing data for _0profit
// == is "equal to", and ~= is "not equal to"
g retain=0 if _0profit==.
replace retain=1 if _0profit~=.
// use the summarize command to determine the share of customers who were not retained
sum retain
// Does customer online status from 1999 predict customer retention?
regress retain _9online
// What additional customer characteristics from 1999 predict customer retention?
regress retain _9online _9tenure _9incZero _9ageZero _9incExist _9ageExist i._9district

// PART 4: USING LOGISTIC REGRESSION WITH A BINARY DEPENDENT VARIABLE


// PART 5: INTERPRETING LOGISTIC REGRESSION COEFFICIENTS



stop
// closes your log
log close

// drops all data from Stata's memory
clear


