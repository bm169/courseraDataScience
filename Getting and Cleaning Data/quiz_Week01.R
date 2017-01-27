
# 1. The American Community Survey distributes downloadable data about United States communities.
#Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here:   
#   https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv 
# and load the data into R. The code book, describing the variable names is here:   
#   https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf

#download file and save as idaho.csv
url_idaho <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
destfile_idaho <- "idaho.csv"
download.file(url=url_idaho,destfile = destfile_idaho)

#read data into data df
data_idaho<- read.csv("idaho.csv")
data_idaho <- data_idaho[!(is.na(data_idaho$VAL)),]
Sub_data <- subset(data_idaho, data_idaho$VAL ==24)
nrow(Sub_data)
#53

#***************************************************************************************************************************
# 3. Download the Excel spreadsheet on Natural Gas Aquisition Program here:   
#   https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx 
# Read rows 18-23 and columns 7-15 into R and assign the result to a variable called:

install.packages("xlsx")
install.packages("rJava")
installed.packages("xlsxjars")

if (Sys.getenv("JAVA_HOME")!="")
  Sys.setenv(JAVA_HOME="")
library(rJava)
library(xlsxjars)
library(xlsx)

download.file(url="https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx",destfile = "getdata%2Fdata%2FDATA.gov_NGAP.xlsx", mode= "wb")
dat <- read.xlsx("getdata%2Fdata%2FDATA.gov_NGAP.xlsx",sheetName = "NGAP Sample Data", rowIndex = 18:23, colIndex = 7:15)
sum(dat$Zip*dat$Ext,na.rm=T)
#36534720

#***************************************************************************************************************************
# 4. Read the XML data on Baltimore restaurants from here:   
#   https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml 
# How many restaurants have zipcode 21231?

install.packages("XML")
library(XML)
library("methods")

download.file(url="https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml", destfile = "getdata%2Fdata%2Frestaurants.xml",mode="wb")
doc<- xmlTreeParse("getdata%2Fdata%2Frestaurants.xml")

#load the data in result
result<- xmlParse("getdata%2Fdata%2Frestaurants.xml")
#get the root now which is 'row' in this case
rootnode <- xmlRoot(result)
#get the size of sub node of 'row' node. This subnode further has nodes 'name' and 'zipcode'
rootsize <- xmlSize(rootnode[[1]])
#write function to convert nodes under subnode into dataframe.
f<- function(i){
    subnode <- xmlSApply(rootnode[[1]][[i]],function(x) xmlSApply(x, xmlValue))
    xml_df <- data.frame(t(subnode), row.names=NULL)
    return(xml_df)
}
#use sapply to call f() for each subnode of rootnode
x<- 1:rootsize
final <- do.call(rbind, lapply(x, function(x) f(x)))
#final dataframe has 1327 rows and 6 columns.

#Now, find subset of those rows which have zipcode == 21231
sub <- subset(final, final[["zipcode"]] == 21231)
nrow(sub)
#127

###Other simpler method 
zipcode <- xpathSApply(rootNode,"//zipcode",xmlValue)
length(zipcode[zipcode==21231])


#***************************************************************************************************************************
#5. The American Community Survey distributes downloadable data about United States communities.
# Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv
# using the fread() command load the data into an R object

download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv", destfile = "getdata%2Fdata%2Fss06pid.csv")
install.packages("data.table")
library(data.table)
DT <- fread("getdata%2Fdata%2Fss06pid.csv")

system.time(sapply(split(DT$pwgtp15,DT$SEX),mean) )
system.time(mean(DT$pwgtp15,by=DT$SEX) )
system.time(rowMeans(DT)[DT$SEX==1])
system.time( rowMeans(DT)[DT$SEX==2] )
system.time( mean(DT[DT$SEX==1,]$pwgtp15) )
system.time(mean(DT[DT$SEX==2,]$pwgtp15))
system.time(tapply(DT$pwgtp15,DT$SEX,mean) )
system.time(DT[,mean(pwgtp15),by=SEX] )




