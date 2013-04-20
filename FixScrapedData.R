setwd("/home/susan/Dropbox/Public/AuburnWeather/")

library(ggplot2)
library(lubridate)

data <- read.csv("AuburnWeather.csv", stringsAsFactors=FALSE)
data <- data[,colSums(!is.na(data))>0]

data$X1hrPrecip <- apply(data[,grep("X1hrPrecip", names(data))], 1, function(x) if(sum(!is.na(x))==0) NA else max(x, na.rm=TRUE))
data$X3hrPrecip <- apply(data[,grep("X3hrPrecip", names(data))], 1, function(x) if(sum(!is.na(x))==0) NA else max(x, na.rm=TRUE))
data$X6hrPrecip <- apply(data[,grep("X6hrPrecip", names(data))], 1, function(x) if(sum(!is.na(x))==0) NA else max(x, na.rm=TRUE))
data$Air.Temp <- apply(data[,grep("Air.Temp", names(data))], 1, function(x) if(sum(!is.na(x))==0) NA else mean(x, na.rm=TRUE))
data <- data[,1:18]

whoops <- which(decimal_date(data$DateTime)>(decimal_date(today())+1/365))
month(data$DateTime[whoops]) <- 3
day(data$DateTime[whoops]) <- data$Day[whoops]

# write.csv(data,"AuburnWeather.csv", row.names=FALSE)

# data <- read.csv("SpringTXWeather.csv", stringsAsFactors=FALSE)
# data <- data[,colSums(!is.na(data))>0]
# 
# data$X1hrPrecip <- apply(data[,grep("X1hrPrecip", names(data))], 1, function(x) if(sum(!is.na(x))==0) NA else max(x, na.rm=TRUE))
# data$X3hrPrecip <- apply(data[,grep("X3hrPrecip", names(data))], 1, function(x) if(sum(!is.na(x))==0) NA else max(x, na.rm=TRUE))
# data$X6hrPrecip <- apply(data[,grep("X6hrPrecip", names(data))], 1, function(x) if(sum(!is.na(x))==0) NA else max(x, na.rm=TRUE))
# data$Air.Temp <- apply(data[,grep("Air.Temp", names(data))], 1, function(x) if(sum(!is.na(x))==0) NA else mean(x, na.rm=TRUE))
# data <- data[,1:20]
# write.csv(data,"SpringTXWeather.csv", row.names=FALSE)


data <- read.csv("AuburnWeather.csv", stringsAsFactors=TRUE)
data$DateTime <- ymd_hms(data$DateTime)
data$Date <- as.Date(data$DateTime)
data$Humidity <- as.numeric(gsub("%", "", data$Humidity))
data[,c(4, 7:16)] <- apply(data[,c(4, 7:16)], 2, as.numeric)
data2 <- data[month(data$Date)>2,c(7, 8, 11, 12, 13, 17)]
data2 <- melt(data2, id.vars="Date")
days.data <- ddply(data2, .(Date, variable), summarise, min=min(value, na.rm=TRUE), q25=quantile(value, .25, na.rm=TRUE), med=median(value, na.rm=TRUE), q75=quantile(value, .75, na.rm=TRUE), max=max(value, na.rm=TRUE), mean=mean(value, na.rm=TRUE))
days.data <- melt(days.data, id.vars=c("Date", "variable"), variable_name="TempType", value_name="Temp")
days.data <- cast(days.data, Date+TempType~variable)
qplot(data=days.data, x=Date, y=AltimeterPressure, geom="line", colour=TempType) + scale_colour_manual(values=c(min="blue", q25="darkgreen", med="gold", mean="green", q75="orange", max="red"))