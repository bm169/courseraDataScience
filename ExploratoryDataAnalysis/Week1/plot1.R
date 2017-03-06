# Download the file and unzip it
filepath <- file.path(getwd(), "exdata%2Fdata%2Fhousehold_power_consumption.zip")
f <- unzip(filepath)

#Read only the required rows
library(sqldf)

sqlquery <- "Select * from file where Date in ('1/2/2007' , '2/2/2007')"
data <- read.csv.sql(file = f, sql= sqlquery, sep=";")
closeAllConnections()

#Plot 1

png(filename = "plot1.png", width = 480, height = 480, bg="transparent", units = "px")
with(data, hist(x= Global_active_power, freq = 2,col = "red",main = "Global Active Power",xlab = "Global Active Power (kilowatts)", axes = TRUE))
dev.off()