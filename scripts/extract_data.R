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
c <- merge(x = a, y = b[ , c("RecordID", "State", "MetroRural", "LGA", "AddressLine1", "AddressLine2", "FullCleanAddress", "StreetName", "Suburb","Postcode", "RawPostcode", "Latitude",  "Longitude")], by = "RecordID", all.x=TRUE)
# serology is excluded as it is a retrospective test that checks for the presence of antibodies
d <- filter(c, TestType != 'Serology')
# check df for NA's
d %>%
  summarise_all(funs(sum(is.na(.))))
# remove columns with NA's for latitude and/or longitude
# this will minimise our extract size but some of these have a valid address/postcode with no coordinates populated
e <-d %>%
  filter(!is.na(Latitude|Longitude))
# select columns wanted
f <- select(e, "TestDate", "RecordID", "State", "MetroRural", "LGA", "AddressLine1", "AddressLine2", "FullCleanAddress", "StreetName", "Suburb", "Postcode", "RawPostcode", "Latitude",  "Longitude")
# chnage to date format
f$TestDate <- as.Date(f$TestDate, '%d/%m/%Y')
# filter to only include feb 2021 onwards
g <- filter(f, TestDate > "2021-01-31")
#export .csv file
setwd("C:/Users/rjan2103/Documents")
fwrite(g, "sitrep.csv", sep=",")
#fwrite(g, "latest.csv", sep=",")