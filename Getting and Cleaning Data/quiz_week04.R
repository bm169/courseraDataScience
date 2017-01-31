# 1. The American Community Survey distributes downloadable data about United States communities. 
# Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
# and load the data into R. The code book, describing the variable names is here:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
# Apply strsplit() to split all the names of the data frame on the characters "wgtp". 
# What is the value of the 123 element of the resulting list?

file_path <- file.path(getwd(), "data.csv")
download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv" , destfile = file_path, mode = "wb")

library(data.table)

 data <- fread(file_path) 
 datanames <-  names(data)
 
 str <- strsplit(datanames, split = "wgtp") 
 str[123]
 #[1] ""   "15"
 
 #******************************************************************************************************
 # 2. Load the Gross Domestic Product data for the 190 ranked countries in this data set:
 #   https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
 # Remove the commas from the GDP numbers in millions of dollars and average them. What is the average?
 # Original data sources:
 #   http://data.worldbank.org/data-catalog/GDP-ranking-table
 
 file_path <- file.path(getwd(),"GDP.csv")
 download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv" , destfile = file_path, mode= "wb")
 
 gdp <- fread(file_path,nrows = 190, skip = 4, select = c(1,2,4,5),col.names = c("CountryCode", "Rank", "Economy", "GDP"))
 
 as.numeric(gsub(",","",gdp$GDP) )%>%
   mean(na.rm=TRUE)
# 377652.4
 
 #****************************************************************************************************
 # 3. In the data set from Question 2 what is a regular expression that would allow you to count the number of countries 
 # whose name begins with "United"? Assume that the variable with the country names in it is named countryNames. 
 # How many countries begin with United?
 
 grep("^United", gdp$Economy)
 #3
 
 #****************************************************************************************************
 # 4. Load the Gross Domestic Product data for the 190 ranked countries in this data set:
 # https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
 # Load the educational data from this data set:
 # https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv
 # Match the data based on the country shortcode. Of the countries for which the end of the fiscal year is available, 
 # how many end in June?
 # Original data sources:
 # http://data.worldbank.org/data-catalog/GDP-ranking-table
 # http://data.worldbank.org/data-catalog/ed-stats
 
 file_path1 <- file.path(getwd(),"edu.csv")
 download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv", destfile = file_path1, mode="wb")
 
 edu <- fread(file_path1)
 
 names(gdp)
 #[1] "CountryCode" "Rank"        "Economy"     "GDP"  
 
 names(edu)
 # [1] "CountryCode"                                       "Long Name"                                        
 # [3] "Income Group"                                      "Region"                                           
 # [5] "Lending category"                                  "Other groups"                                     
 # [7] "Currency Unit"                                     "Latest population census"                         
 # [9] "Latest household survey"                           "Special Notes"                                    
 # [11] "National accounts base year"                       "National accounts reference year"                 
 # [13] "System of National Accounts"                       "SNA price valuation"                              
 # [15] "Alternative conversion factor"                     "PPP survey year"                                  
 # [17] "Balance of Payments Manual in use"                 "External debt Reporting status"                   
 # [19] "System of trade"                                   "Government Accounting concept"                    
 # [21] "IMF data dissemination standard"                   "Source of most recent Income and expenditure data"
 # [23] "Vital registration complete"                       "Latest agricultural census"                       
 # [25] "Latest industrial data"                            "Latest trade data"                                
 # [27] "Latest water withdrawal data"                      "2-alpha code"                                     
 # [29] "WB-2 code"                                         "Table Name"                                       
 # [31] "Short Name"        
 
mergedata <- merge(gdp,edu,all = TRUE, by="CountryCode")

#**************Using grepl
isfiscal<-  grepl("fiscal year", tolower(mergedata$`Special Notes`))
isJune <- grepl("june", tolower(mergedata$`Special Notes`))
tbl <- table(isfiscal,isJune)
tbl
# isJune
# isfiscal FALSE TRUE
# FALSE   199    3
# TRUE     20   13

#*********************using grep
x<- grep("^fiscal year end: june", tolower(mergedata$`Special Notes`))
length(x)
#13

#*******************************************************************************************************************
# 5.You can use the quantmod (http://www.quantmod.com/) package to get historical stock prices for publicly traded companies
# on the NASDAQ and NYSE.
# Use the following code to download data on Amazon's stock price and get the times the data was sampled.
# How many values were collected in 2012? How many values were collected on Mondays in 2012?
install.packages("quantmod")
library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)

filterdate <- sampleTimes[which(year(sampleTimes)== 2012)]
length(filterdate)
#[1] 250

mondate <- filterdate[which(wday(filterdate)==2)]
length(mondate)
#47

#******Using table
table(year(sampleTimes),weekdays(sampleTimes))

#        Friday Monday Thursday Tuesday Wednesday
# 2007     51     48       51      50        51
# 2008     50     48       50      52        53
# 2009     49     48       51      52        52
# 2010     50     47       51      52        52
# 2011     51     46       51      52        52
# 2012     51     47       51      50        51
# 2013     51     48       50      52        51
# 2014     50     48       50      52        52
# 2015     49     48       51      52        52
# 2016     51     46       51      52        52
# 2017      4      3        4       4         4



