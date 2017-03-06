# Download the file and unzip it
filepath <- file.path(getwd(), "exdata%2Fdata%2Fhousehold_power_consumption.zip")
f <- unzip(filepath)

#Read only the required rows
library(sqldf)

sqlquery <- "Select * from file where Date in ('1/2/2007' , '2/2/2007')"
data <- read.csv.sql(file = f, sql= sqlquery, sep=";")
closeAllConnections()
#Plot 2

data$datetime <- strptime(paste(data$Date,data$Time),format = "%d/%m/%Y %H:%M:%S")

png(filename = "plot2.png", width = 480, height = 480, bg="transparent", units = "px")
with(data,plot(datetime, Global_active_power,type = "l", xlab = "", ylab = "Global Active Power (kilowatts)"))
dev.off()