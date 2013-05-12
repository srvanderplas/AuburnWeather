library(scrapeR)
library(XML)
library(lubridate)
library(reshape)

setwd("/home/susan/Documents/R Projects/AuburnWeather")
date <- today()

webpage <- scrape("http://w1.weather.gov/data/obhistory/KAFK.html")

tab <- readHTMLTable(webpage[[1]], skip.rows=c(1, 2,3), which=4, stringsAsFactors=FALSE)
tab <- tab[-c((nrow(tab)-3):nrow(tab)),]
names(tab) <- c("Day", "Time", "Wind", "Visibility", "Weather", "Sky", "Air.Temp", "DewPt", "Max6hr", "Min6hr", "Humidity", "WindChill", "HeatIndex", "AltimeterPressure", "SeaLevelPressure", "X1hrPrecip", "X3hrPrecip", "X6hrPrecip")

tab$Date <- date-ddays((day(date)-as.numeric(tab$Day)))
tab$DateTime <- ymd_hm(paste(tab$Date, tab$Time, sep=" "))

data <- read.csv("AuburnWeather.csv", stringsAsFactors=FALSE)
data$DateTime <- ymd_hms(data$DateTime)

data <- rbind.fill(data, tab[which(!tab$DateTime %in%data$DateTime),])

write.csv(data, "AuburnWeather.csv", row.names=FALSE)

webpage <- scrape("http://w1.weather.gov/data/obhistory/KIAH.html")

tab <- readHTMLTable(webpage[[1]], skip.rows=c(1, 2,3), which=4, stringsAsFactors=FALSE)
tab <- tab[-c((nrow(tab)-3):nrow(tab)),]
names(tab) <- c("Day", "Time", "Wind", "Visibility", "Weather", "Sky", "Air.Temp", "DewPt", "Max6hr", "Min6hr", "Humidity", "WindChill", "HeatIndex", "AltimeterPressure", "SeaLevelPressure", "X1hrPrecip", "X3hrPrecip", "X6hrPrecip")

tab$Date <- date-(day(date)-as.numeric(tab$Day))
tab$DateTime <- ymd_hm(paste(tab$Date, tab$Time, sep=" "))

data <- read.csv("SpringTXWeather.csv", stringsAsFactors=FALSE)
data$DateTime <- ymd_hms(data$DateTime)

data <- rbind.fill(data, tab[which(!tab$DateTime %in%data$DateTime),])

write.csv(data, "SpringTXWeather.csv", row.names=FALSE)