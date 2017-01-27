# Register an application with the Github API here https://github.com/settings/applications.
# Access the API to get information on your instructors repositories (hint: this is the url you want "https://api.github.com/users/jtleek/repos").
# Use this data to find the time that the datasharing repo was created. What time was it created?
# 
# 
# App registered - 
# https://github.com/settings/applications/468255

library(httr)
install.packages("httpuv")
library(httpuv)


oauth_endpoints("github")
myapp <- oauth_app("TestApp",key = "ccd1e48e0fe29e49c51b", secret = "b56b0fa8b483d854c803707f04a61548e32f66be")

github_token <- oauth2.0_token(oauth_endpoints("TestApp"),myapp)
get_token <- config( token = github_token)

req <- GET("https://api.github.com/users/jtleek/repos",get_token)
stop_for_status(req)

library(httr)
require(httpuv)
require(jsonlite)


oauth_endpoints("github")

# 2. Register an application at https://github.com/settings/applications
#    Insert your values below - if secret is omitted, it will look it up in
#    the GITHUB_CONSUMER_SECRET environmental variable.
#
#    Use http://localhost:1410 as the callback url
myapp <- oauth_app("TestApp", "ccd1e48e0fe29e49c51b", secret="b56b0fa8b483d854c803707f04a61548e32f66be")

# 3. Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)
#redirects to authentication page where it says the TestApp will like to access the page of my account. I authorized.

# 4. Use API
req <- GET("https://api.github.com/users/jtleek/repos", config(token = github_token))
stop_for_status(req)
output <- content(req)

list(output[[11]]$name, output[[11]]$created_at)

##**************************************************************************************************************************

# 2. The sqldf package allows for execution of SQL commands on R data frames. We will use the sqldf package to practice the queries we might send with 
# the dbSendQuery command in RMySQL.
# Download the American Community Survey data and load it into an R object called
# acs
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv
# 
# Which of the following commands will select only the data for the probability weights pwgtp1 with ages less than 50?


download.file(url= "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv" ,destfile = "getdata%2Fdata%2Fss06pid.csv")
acs <- read.csv("getdata%2Fdata%2Fss06pid.csv")

install.packages("sqldf")


install.packages("gsubfn")
install.packages("proto")
install.packages("RSQLite")



library("gsubfn")
library("proto")
library("RSQLite")

library(sqldf)

# #4. How many characters are in the 10th, 20th, 30th and 100th lines of HTML from this page:
# 
# http://biostat.jhsph.edu/~jleek/contact.html
# 
# (Hint: the nchar() function in R may be helpful)

con <- url("http://biostat.jhsph.edu/~jleek/contact.html")
htmlcode <- readLines(con)
nchar(htmlcode[10])
nchar(htmlcode[20])
nchar(htmlcode[30])
nchar(htmlcode[100])

#45,31,7,25


# 
# Read this data set into R and report the sum of the numbers in the fourth of the nine columns.
# 
# https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for
# 
# Original source of the data: http://www.cpc.ncep.noaa.gov/data/indices/wksst8110.for


install.packages("foreign")
library(foreign)

a <- read.fwf(file = "https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for", widths = c(10,9,4,9,4,9,4,9,4),skip = 4)
sum(a[,4])
#[1] 32426.7


