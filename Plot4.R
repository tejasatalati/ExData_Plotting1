## Set working directory.
setwd("C://Tejas//Learnings//Coursera//Exploratory_Data_Analysis//Project1")
getwd()

## Load required libraries
##install.packages('data.table')
library(data.table)

## Check if file exists else download the file and extract in the folder
fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

if (!file.exists('./household_power_consumption.zip')){
  download.file(fileurl,'./household_power_consumption.zip', mode = 'wb')
  unzip("household_power_consumption.zip", exdir = '.')
}

## Read Household Power Consumption data into dataset using fread for dates 2007-02-01 and 2007-02-02.
## Skip all rows upto 2007-02-01. read next 2 days of data with 1 min interval. 24(hr)*60(min)*2(days)

hpc_data <- fread('./household_power_consumption.txt',sep = ';',header = FALSE, na.strings = "?",skip = 66637,nrows = 2879,check.names = FALSE)
var_names <- names(hpc_data)

## Get column headers
hpc_cols <- fread('./household_power_consumption.txt',sep = ';',header = TRUE, na.strings = "?",nrows = 1)
hpc_cols <- names(hpc_cols)

## Apply back column headers
setnames(hpc_data,var_names,hpc_cols)

## Convert dates
col_datetime <- paste(as.Date(hpc_data$Date, format="%d/%m/%Y"), hpc_data$Time)
hpc_data$Datetime <- as.POSIXct(col_datetime)

## Set Canvas for Plots - Cols, Rows, Margin and outer margin.
par(mfrow=c(2,2), mar=c(4,4,1,1),oma=c(0,0,2,0))

## Generate Plot-4 (Multiple line plots on a page)
with (hpc_data,{
  plot(Global_active_power ~ Datetime, type="l", ylab="Global Active Power", xlab="")
  plot(Voltage~Datetime, type="l", ylab="Voltage", xlab="datetime")
  plot(Sub_metering_1 ~ Datetime, type="l", ylab="Energy sub metering",xlab="")
    lines(Sub_metering_2 ~ Datetime,col='Red')
    lines(Sub_metering_3 ~ Datetime,col='Blue')
  legend("topright", col=c("black", "red", "blue"), lty=1, legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),cex = 0.5)
  plot(Global_reactive_power~Datetime, type="l",ylab="Global_Rective_Power",xlab="datetime")  
 }
)

## Save plot to .PNG file
dev.copy(png, file="plot4.png", height=480, width=480)
dev.off()