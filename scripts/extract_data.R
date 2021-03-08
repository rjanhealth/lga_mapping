# load packages
library(data.table)
library(dplyr)
options(warn=-1)

# set wd to selected cut
setwd("E:/PBIX/NCoronavirus 2020/Stata nCoV reporting/31 Azure Data Model/DART/Data snapshots/sitrep")
#setwd("E:/PBIX/NCoronavirus 2020/Stata nCoV reporting/31 Azure Data Model/DART/Data snapshots/latest")
# read in data
a <- fread("labresults.txt",sep=",")
b <- fread("Persons.txt",sep=",")
# join dataframes
c <- merge(x = a, y = b[ , c("RecordID", "TestType", "LGA", "FullCleanAddress", "AddressLine1", "AddressLine2", "StreetName", "Suburb", "State", "Postcode", "RawPostcode", "Latitude", "Longitude")], by = "RecordID", all.x=TRUE)
# check df for NA's
c %>%
  summarise_all(funs(sum(is.na(.))))
# remove columns with NA's for latitude and/or longitude
# this will minimise our extract size but some of these have a valid address/postcode with no coordinates populated
d <-c %>%
  filter(!is.na(Latitude|Longitude))
# select columns wanted
e <- select(d, "TestDate", "RecordID", "TestType", "LGA", "FullCleanAddress", "AddressLine1", "AddressLine2", "StreetName", "Suburb", "State", "Postcode", "RawPostcode", "Latitude", "Longitude")
# chnage to date format
e$TestDate <- as.Date(e$TestDate, '%d/%m/%Y')
# filter to only include feb 2021 onwards
f <- filter(e, TestDate > "2021-01-31")
#export .csv files
setwd("C:/Users/rjan2103/Documents")
fwrite(f, "sitrep.csv", sep=",")
#fwrite(g, "latest.csv", sep=",")