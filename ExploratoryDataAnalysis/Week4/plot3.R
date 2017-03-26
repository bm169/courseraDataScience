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

#Get sum of emissions fo each type and year 
baldata <- with(baldata, aggregate(Emissions~type+year, FUN = sum))

baldata

library(ggplot2)

g<- ggplot(baldata,aes(year,Emissions,color=type))

g +geom_point()+geom_line()+ 
  ggtitle("PM2.5 in Baltimore city by Type")+ xlab("Year")+ylab("PM2.5 Emissions in kilotons")+
  geom_text(aes(label=round(Emissions,1)),hjust=0.5,vjust=-.5)

dev.copy(png,file="plot3.png",width = 480, height=480)
dev.off()
