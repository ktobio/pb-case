/**********************************************************************************
File        : PA_pilgrimA_code.do  <--- this should be the exact name of THIS document
Author      : Kristina Tobio 
Created     : 07 Nov 2016
Modified    : 25 Jan 2017
Description : .do file for Pilgrim Bank Case Part A - Student Edition
**********************************************************************************/

// the following four commands prepare your computer for the data and analysis
// these four commands are optional, but helpful
// to run them, highlight this block of text, including the four commands
// while they are highlighted, click the execute Do button above
// the capture command finds and closes open log files
capture log close        
// this clears Stata's data memory so new data can be loaded
clear       
// this makes it so you don't have to keep pressing return/enter to scroll through results
set more off          
// this keeps everything visible on a normal monitor or laptop screen
set linesize 200 

// after executing the commands above, we recommend opening a log file
// log files record all of the commands and output from your work session 

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



