file<- file.choose()
unzip(file)

#Reading rds file
nei <-readRDS("summarySCC_PM25.rds")
scc <- readRDS("Source_Classification_Code.rds")

#Overview of datasets
dim(nei)
dim(scc)

str(nei)

#Get data for Baltimore city
baldata <- subset(nei,nei$fips == "24510")

#Getting total sum of Emmissions year wise
sumdata <- aggregate(Emissions~year , baldata, sum)

#Creating Emissions in kilo tons and year vector
emm <- sumdata$Emissions/1000
year <- sumdata$year

#Creating two plots. One is bar plot and other is line plot

par(mfrow= c(1,2), oma = c(0,0,2,0))

plot1 <- barplot(emm,year,names.arg = year,xlab = "Year", ylab="PM2.5 (kilo tons)")
text(plot1,emm,labels = round(emm,1),cex=0.75,pos=1)


plot(year, emm,type = "l",xlab="Year",ylab="PM2.5 (kilo tons)")


mtext(text = "Total PM2.5 emmissions in Baltimore",outer = TRUE)

dev.copy(png,file="plot2.png",width = 480, height=480)
dev.off()
