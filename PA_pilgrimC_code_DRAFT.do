/**********************************************************************************
File        : pb-case-c.do  <--- this should be the exact name of THIS document
Author      : Kristina Tobio 
Created     : 08 Nov 2016
Modified    : 10 Jan 2017
Description : .do file for Pilgrim Bank Case Part C 
**********************************************************************************/

// these commands prepare your computer for the data and analysis
// this finds and closes open log files
capture log close        
// this clears Stata's data memory so new data can be loaded
clear       
// this makes it so you don't have to keep pressing return/enter to scroll through results
set more off          
// this keeps everything visible on a normal monitor or laptop screen
set linesize 200    

// cd means "change directory"
// changes to the current directory 
cd .

// this creates a log file, which will record all of the commands and outputs from this .do file 
// log files should be placed in the logs folder in your directory
log using "logs/PA_pilgrimC_log", replace

// we created a set of variable in Part B of this case, and they may be useful to us now
// so, we use our saved dataset
use "data/pb-case-data-new-variables-b.dta"

// label variables
label var id "Customer ID"
label var profit_99 "Annual Profit, 1999" 
label var online_99 "Online Usage, 1999"
label var age_99 "Age Bucket, 1999"
label var income_99 "Income Bucket, 1999"
label var tenure_99 "Tenure (years), 1999"
label var district_99 "Geographic Region, 1999"
label var profit_00 "Annual Profit, 2000"
label var online_00 "Online Usage, 2000"

// WALKING THROUGH THE STATISTICS REVIEW
// The teaching note has similar analyses, but doesn't include the demographic varibles of age, income, and district

// PART 1: ADD ELECTRONIC BILLBAY TO DRIVERS OF CUSTOMER RETENTION
// Here is our regression from Part B, where we predict 2000 profit based on 1999 characteristics
regress profit_00 profit_99 online_99 tenure_99 income_99_Zero age_99_Zero income_99_Exist age_99_Exist i.district_99
// What happens when we also control for customers that used electronic billpay in 1999?
regress profit_00 profit_99 online_99 tenure_99 income_99_Zero age_99_Zero income_99_Exist age_99_Exist i.district_99 billpay_99
// From Part B: what customer characteristics from 1999 predict customer retention?
regress retain profit_99 online_99 tenure_99 income_99_Zero age_99_Zero income_99_Exist age_99_Exist i.district_99
// What happens when we also control for customers that used electronic billpay in 1999?
regress retain profit_99 online_99 tenure_99 income_99_Zero age_99_Zero income_99_Exist age_99_Exist i.district_99 billpay_99

// PART 2: EXAMINE TRANSITION PROBABILITIES
// There are four discrete states for customers: 
// (a) Offline (b) Offline without billpay (c) Online with billpay (d) Left the bank (2000 only)
// Creating 1999 state variable
g state_99="Offline_99" if online_99==0
replace state_99="Online_99, BP" if billpay_99==1 & online_99==1
replace state_99="Online_99, no BP" if billpay_99==0 & online_99==1
// Creating 2000 state variable
g state_00="Offline_00" if online_00==0
replace state_00="Online_00, BP" if billpay_00==1 & online_00==1
replace state_00="Online_00, no BP" if billpay_00==0 & online_00==1
replace state_00="Left" if retain==0
// Create a contingency table
// The "row" command calculates the percentage of row total 
tabulate state_99 state_00, row
// Using Regression to Get Some of the Transition Probabilities
regress retain online_99 billpay_99

// closes your log
log close

// drops all data from Stata's memory
clear
