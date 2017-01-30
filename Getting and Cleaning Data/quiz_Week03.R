# 1. The American Community Survey distributes downloadable data about United States communities. 
# Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
# and load the data into R. The code book, describing the variable names is here:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
# Create a logical vector that identifies the households on greater than 10 acres who sold more than $10,000 worth of 
# agriculture products. Assign that logical vector to the variable agricultureLogical.
# Apply the which() function like this to identify the rows of the data frame where the logical vector is TRUE.
# which(agricultureLogical)
# 
# What are the first 3 values that result?
download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv", destfile = "getdata%2Fdata%2Fss06hid.csv")
data <- read.csv("getdata%2Fdata%2Fss06hid.csv")
# ACR = 3 (for more than 10 acres)
#AGS = 6 (Sale of agriculture products > $10000)
agricultureLogical <- data$ACR == 3 & data$AGS==6
which(agricultureLogical)
#  125  238  262 

#**************************************************************************************************************************
# 2. Using the jpeg package read in the following picture of your instructor into R
# https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg
# Use the parameter native=TRUE. What are the 30th and 80th quantiles of the resulting data? 
# (some Linux systems may produce an answer 638 different for the 30th quantile)
install.packages("jpeg")
library(jpeg)
download.file(url="https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg", destfile = "getdata%2Fjeff.jpg", mode = "wb")
file <- readJPEG(source = "getdata%2Fjeff.jpg" ,native = TRUE)
quantile(file,c(0.3,0.8))
# 30%       80% 
#   -15259150 -10575416 

# #***********************************************************************************************
# 3. Load the Gross Domestic Product data for the 190 ranked countries in this data set:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
# Load the educational data from this data set:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv
# Match the data based on the country shortcode. How many of the IDs match? Sort the data frame in descending order by GDP rank (so United States is last).
# What is the 13th country in the resulting data frame?
# Original data sources:
# http://data.worldbank.org/data-catalog/GDP-ranking-table
# http://data.worldbank.org/data-catalog/ed-stats

file_path <- file.path(getwd(), "GDP.csv")
download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv",destfile = file_path, mode="wb")

file_path1 <- file.path(getwd(), "Country.csv")
download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv",destfile = file_path1, mode= "wb")

#***************************Using read.csv
gross <- read.csv("GDP.csv", skip= 4, nrows = 190)
educ <- read.csv("Country.csv")

setnames(gross,c("X","X.1","X.3"), c("CountryCode", "Rank","Economy"))
m<- merge(gross,educ,by="CountryCode")
dim(m)
#189  40

arrange(m,desc(Rank))[13, "Economy"]
#St. Kitts and Nevis

#***************************************Using fread

gdp = fread(file_path, skip=4, nrows = 190, select = c(1, 2, 4, 5), col.names=c("CountryCode", "Rank", "Economy", "Total"))
edu = fread(file_path1)
merge = merge(gdp, edu, by = 'CountryCode')
nrow(merge)

sort<- arrange(merge, desc(Rank))[13,"Economy"]
sort
# "St. Kitts and Nevis"

#***********************************************************************************************************
#4.What is the average GDP ranking for the "High income: OECD" and "High income: nonOECD" group?


file_path <- file.path(getwd(), "GDP.csv")
download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv",destfile = file_path, mode="wb")

file_path1 <- file.path(getwd(), "Country.csv")
download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv",destfile = file_path1, mode= "wb")


gross <- fread(file_path,skip = 4,nrows = 190, select = c(1,2,4,5), col.names = c("CountryCode", "Rank", "Economy", "Income"))
educ<- fread(file_path1, select = c(1,3), col.names = c("CountryCode", "IncomeGroup"))

merge(gross,educ,by="CountryCode") %>%
  filter(IncomeGroup == "High income: nonOECD" | IncomeGroup == "High income: OECD") %>%
  group_by(IncomeGroup)%>%
  summarize(mean(Rank)) %>%
  
  print

# 
# 1 High income: nonOECD     91.91304
# 2    High income: OECD     32.96667

#*****************************************************************************************************************
#5. Cut the GDP ranking into 5 separate quantile groups. Make a table versus Income.Group. How many countries
#are Lower middle income but among the 38 nations with highest GDP?

#**********************Simple method
q <- quantile(gross$Rank,probs = c(0.2,0.4,0.6,0.8,1))
#> q
#20%   40%   60%   80%  100% 
#38.8  76.6 114.4 152.2 190.0 
mdata <- merge(gross,edu,by= "CountryCode")
f<- filter(mdata, mdata$Rank <=38 & mdata$IncomeGroup == "Lower middle income")
# > f
# CountryCode Rank          Economy      Income         IncomeGroup
# 1         CHN    2            China  8,227,103  Lower middle income
# 2         EGY   38 Egypt, Arab Rep.    262,832  Lower middle income
# 3         IDN   16        Indonesia    878,043  Lower middle income
# 4         IND   10            India  1,841,710  Lower middle income
# 5         THA   31         Thailand    365,966  Lower middle income
# 


#Using Cut
mdata$RankGroup <- cut(mdata$Rank,quantile(mdata$Rank,probs = seq(0,1,0.2)))
new_tbl <- table(mdata$IncomeGroup,mdata$RankGroup)
new_tbl
# 
# (1,38.6] (38.6,76.2] (76.2,114] (114,152] (152,190]
# High income: nonOECD        4           5          8         4         2
# High income: OECD          17          10          1         1         0
# Low income                  0           1          9        16        11
# Lower middle income         5          13         11         9        16
# Upper middle income        11           9          8         8         9
# 

