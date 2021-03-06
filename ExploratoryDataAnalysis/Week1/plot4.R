# Download the file and unzip it
filepath <- file.path(getwd(), "exdata%2Fdata%2Fhousehold_power_consumption.zip")
f <- unzip(filepath)

#Read only the required rows
library(sqldf)

sqlquery <- "Select * from file where Date in ('1/2/2007' , '2/2/2007')"
data <- read.csv.sql(file = f, sql= sqlquery, sep=";")
closeAllConnections()

#Plot 4

data$datetime <- strptime(paste(data$Date,data$Time),format = "%d/%m/%Y %H:%M:%S")

png(filename = "plot4.png", width = 480, height = 480,  units = "px",bg="transparent")

par(mfrow= c(2,2))


with(data, { plot(datetime, Global_active_power,type = "l", xlab = "", ylab = "Global Active Power")
  plot(datetime, Voltage,type = "l", xlab= "datetime", ylab = "Voltage")
  { plot( datetime,Sub_metering_1 ,xlab = "", ylab="Energy sub metering", col="black", type="l")
    lines(datetime, Sub_metering_2, type = "l", col="red")
    lines(datetime, Sub_metering_3, type="l", col="blue")
    legend("topright", col = c("black","red","blue"), legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),bty="n",lty = 1)}
  plot(datetime, Global_reactive_power,type = "l")
  })



dev.off()



