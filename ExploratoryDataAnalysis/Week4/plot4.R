file<- file.choose()
unzip(file)

#Reading rds file
nei <-readRDS("summarySCC_PM25.rds")
scc <- readRDS("Source_Classification_Code.rds")


#Getting only coal combustion related sources
coalscc <- scc[grep("[cC]oal", scc$Short.Name),]

#Reading only required two columns
coalscc<- coalscc[,c("SCC","Short.Name")]

#Merging data in order to get only Coal combustion related sources emissions
coalnei <- merge(coalscc,nei,"SCC")

#Finding total of Emissions year wise
sumemi <- aggregate(Emissions~year,data=coalnei, sum)

#Plot
library(ggplot2)
g <- qplot(data=sumemi, x=year, y = Emissions/1000, ylab = "PM2.5 Emissions in kilotons", xlab = "Year", main = "Emissions from Coal cumbustion")

g+geom_point(color="red",size=2) + geom_line() +geom_text(aes(label=round(Emissions/1000,1)),hjust=0.75,vjust=1.25)

dev.copy(png,file="plot4.png",width = 480, height=480)
dev.off()
