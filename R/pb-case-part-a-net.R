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

install.packages("doBy")
library("doBy")

# PART 1: EXPLORE PROFIT
# calculating the 95% confidence interval for average (mean) customer profitability in 1999
LSmeans(PA_pilgrimA_data.profit_99, level=.95)

# closes your log
#log close
sink()

# drops all data from Stata's memory
#clear
# R: we're not going to do this so that we can examine our environment afterwards
