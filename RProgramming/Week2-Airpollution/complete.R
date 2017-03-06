#Created by : Bhavana Jain
#Requirement :Write a function that reads a directory full of files and reports the number of completely observed cases in each data file.
#             The function should return a data frame where the first column is the name of the file and the second column is the number of complete cases.


#Comment :    This can be solved using two methods : loop or sapply. Both the codes are given below. sapply one is commented.
complete <- function(directory,id = 1:332)
{
  ########################################Method 1 : With Loops
  
  #1. Initialize Dataframe
  data <- data.frame()
  #data <- data.frame()

  for(i in id)
  {
    #2. Get the file format with leading '0' for a three digit number.
    x<- formatC(i,width=3,format="d",flag="0")

    #3. Read file using path created by paste function
    file_name <- read.csv(paste(directory,"/",x,".csv",sep=""))

    #4. Get sum of complete cases for particular monitor
    nbos <- sum(complete.cases(file_name))

    #5. append dataframe
    newRow<- c(i, nbos)
    data <- rbind(data,newRow)

  }

  #6. Set the column names for the data frame
  colnames(data)<- c("id", "nbos")

  #7. Return data frame
  return(data)
  
  # ####################################Method 2: Using sapply
  # #1. Create a function that takes one id at a time as an argument
  # f<- function(i)
  # {
  #   #2. Get file name and read the data
  #   x<- formatC(i,width=3,format="d",flag="0")
  #   file_name <- read.csv(paste(directory,"/",x,".csv",sep=""))
  # 
  #   #3. Get sum of complete cases for the particular id
  #   sum(complete.cases(file_name))
  # 
  # }
  # 
  # #4. Use sapply to call function f() for each id. Save the returned result in nbos
  # nbos <- sapply(id,f)
  # 
  # #5. Return dataframe
  # return(data.frame(id,nbos))



}