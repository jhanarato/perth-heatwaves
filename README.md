# Perth Heatwaves

It's Christmas and if the weather report is right, it will be 44C today. What a great time to sit under the air conditioner and look at how this compares historically. I'm using R and the tidyverse.

## Get the data

While the R package `bomrang` was created to get the BOM data via R code, the BOM seems to have decided to block that access. Here's how to get the data:

* Open http://www.bom.gov.au/climate/data/
* Select "Temperature", "Daily" and "Maximum temperature".
* Enter the station number. That's 9021 for Perth Airport, the longest running weather station in Perth.
* Click "All years of data" and download the zip file. Inside is a CSV file named `IDCJAC0009_9021_1800_Data.csv`. 
* Rename to `perth-temp.csv`

