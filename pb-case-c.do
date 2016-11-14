/**********************************************************************************
File        : pb-case-c.do  <--- this should be the exact name of THIS document
Author      : Kristina Tobio 
Created     : 08 Nov 2016
Modified    : 14 Nov 2016
Description : .do file for Pilgrim Bank Case Part C 
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
// log files should be placed in the logs folder in your directory
log using "logs/pb-case-c", replace

// we created a set of variable in Part B of this case, and they may be useful to us now
// so, we use our saved dataset
use "data/pb-case-data-new-variables-b.dta"

// WALKING THROUGH THE STATISTICS REVIEW
// The teaching note has similar analyses, but doesn't include the demographic varibles of age, income, and district

// PART 1: ADD ELECTRONIC BILLBAY TO DRIVERS OF CUSTOMER RETENTION
// Here is our regression from Part B, where we predict 2000 profit based on 1999 characteristics
regress _0profit _9profit _9online _9tenure _9incZero _9ageZero _9incExist _9ageExist i._9district
// What happens when we also control for customers that used electronic billpay in 1999?
regress _0profit _9profit _9online _9tenure _9incZero _9ageZero _9incExist _9ageExist i._9district _9billpay
// From Part B: what customer characteristics from 1999 predict customer retention?
regress retain _9profit _9online _9tenure _9incZero _9ageZero _9incExist _9ageExist i._9district
// What happens when we also control for customers that used electronic billpay in 1999?
regress retain _9profit _9online _9tenure _9incZero _9ageZero _9incExist _9ageExist i._9district _9billpay

// PART 2: EXAMINE TRANSITION PROBABILITIES
// There are four discrete states for customers: 
// (a) Offline (b) Offline without billpay (c) Online with billpay (d) Left the bank (2000 only)
// Creating 1999 state variable
g _9state="9Offline" if _9online==0
replace _9state="9Online, BP" if _9billpay==1 & _9online==1
replace _9state="9Online, no BP" if _9billpay==0 & _9online==1
// Creating 2000 state variable
g _0state="0Offline" if _0online==0
replace _0state="0Online, BP" if _0billpay==1 & _0online==1
replace _0state="0Online, no BP" if _0billpay==0 & _0online==1
replace _0state="Left" if retain==0
// Create a contingency table
// The "row" command calculates the percentage of row total 
tabulate _9state _0state, row
// Using Regression to Get Some of the Transition Probabilities
regress retain _9online _9billpay

// closes your log
log close

// drops all data from Stata's memory
clear
