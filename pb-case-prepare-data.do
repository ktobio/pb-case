/*************************************************************************************************File        : pb-case-prepare-data.do  <--- this should be the exact name of THIS documentAuthor      : Kristina Tobio Created     : 02 Dec 2016Modified    : 19 Jan 2017Description : .do file for preparing data for use in PA_pilgrimA_code.do, PA_pilgrimB_code.do,			  and PA_pilgrimC_code.do.*************************************************************************************************/// these commands prepare your computer for the data and analysis// this finds and closes open log filescapture log close        // this clears Stata's data memory so new data can be loadedclear       // this makes it so you don't have to keep pressing return/enter to scroll through resultsset more off          // this keeps everything visible on a normal monitor or laptop screenset linesize 200    // cd means "change directory"// changes to the current directory cd .// this creates a log file, which will record all of the commands and outputs from this .do file // log files should be placed in a folder named "logs" in your directory log using "logs/pb-case-prepare-data", replace// data should be placed in a folder named "data" in your directory // this pulls in the data in its exact Excel form from HBP// this command reads the data into Stataimport excel using "data/Pilgrim_ABC_Spreadsheet.xls", sheet(Data) firstrow// renaming variables to make them more user friendlyrename ID idrename Profit profit_99rename Online online_99rename Age age_99rename Inc income_99rename Tenure tenure_99rename District district_99rename H profit_00rename I online_00rename Billpay billpay_99rename K billpay_00// labels variableslabel var id "Customer ID"label var profit_99 "Annual Profit, 1999" label var online_99 "Online Usage, 1999"label var age_99 "Age Bucket, 1999"label var income_99 "Income Bucket, 1999"label var tenure_99 "Tenure (years), 1999"label var district_99 "Geographic Region, 1999"label var profit_00 "Annual Profit, 2000"label var online_00 "Online Usage, 2000"label var billpay_99 "Billpay Usage, 1999"label var billpay_00 "Billpay Usage, 2000"// export data into a CSV file that can be easily imported into Stataexport delimited "data/PA_pilgrim_data.csv", replaceexport excel "data/PA_pilgrim_data.xls", replace// create a seperate dataset for Part A of case (and PA_pilgrimA_code.do), which only uses the 1999 (suffix "_99") data and no billpay_99keep id profit_99 online_99 age_99 income_99 tenure_99 district_99export delimited "data/PA_pilgrimA_data.csv", replaceexport excel "data/PA_pilgrimA_data.xls", firstrow(variables) replace// clear Stata memoryclear// create a seperate dataset for additional data for Part B of case (and PA_pilgrimB_code.do), which adds the 2000 (suffix "_00") data save the billpay variableinsheet using "data/PA_pilgrim_data.csv", nameskeep id profit_00 online_00 profit_99 online_99 age_99 income_99 tenure_99 district_99export delimited "data/PA_pilgrimB_original_data.csv", replaceexport excel "data/PA_pilgrimB_original_data.xls", firstrow(variables) replace// clear Stata memoryclear// create a seperate dataset for additional data for Part C of case (and PA_pilgrimC_code.do), which adds the billpay variablesinsheet using "data/PA_pilgrim_data.csv", nameskeep id billpay_99 billpay_00 profit_00 online_00 profit_99 online_99 age_99 income_99 tenure_99 district_99export delimited "data/PA_pilgrimC_original_data.csv", replaceexport excel "data/PA_pilgrimC_original_data.xls", firstrow(variables) replace// clear Stata memoryclear// merging the three datasets together// Step 1: Save all CSV files as Stata data filesinsheet using "data/PA_pilgrimA_data.csv", namessave "data/PA_pilgrimA_data.dta", replaceclearinsheet using "data/PA_pilgrimB_original_data.csv", namessave "data/PA_pilgrimB_original_data.dta", replaceclearinsheet using "data/PA_pilgrimC_original_data.csv", namessave "data/PA_pilgrimC_original_data.dta", replaceclear// Step 2: Merge together one at a time// "id" is the common variable in all three datasetsuse "data/PA_pilgrimA_data.dta"merge 1:1 id using "data/PA_pilgrimB_original_data.dta"tab _merge// _merge should all equal "3" if it is successfuldrop _mergesave "data/PA_pilgrim_data.dta", replacemerge 1:1 id using "data/PA_pilgrimC_original_data.dta"tab _merge// merge should all equal "3" if it is successfuldrop _mergesave "data/PA_pilgrim_data.dta", replace// closes your loglog close// drops all data from Stata's memoryclear