/**********************************************************************************File        : pb-case-a.do  <--- this should be the exact name of THIS documentAuthor      : Kristina Tobio Created     : 07 Nov 2016Modified    : 07 Nov 2016Description : .do file for Pilgrim Bank Part A **********************************************************************************/// this finds and closes open log filescapture log close        // this clears STATA's data memory so new data can be loadedclear       // this makes it so you don't have to keep pressing return/enter to scroll through resultsset more off          // this sets memory sizeset mem 100m       // this keeps everything visible on a normal monitor or laptop screenset linesize 200    // cd means "change directory"// this will need to be the directory on your computer where you are storing the .do and data files*cd "/Users/ktobio/Desktop/Jeff/Course/Pilgrim Bank/pb-case/"       // the data is in .csv (comma seperated values) format// this command reads the data into Statainsheet using pb-case-data.csv, names