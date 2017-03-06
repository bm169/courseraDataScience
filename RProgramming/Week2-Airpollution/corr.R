# Created by :  Bhavana Jain
# Requirement:  Write a function that takes a directory of data files and a threshold for complete cases and calculates the correlation between 
#               sulfate and nitrate for monitor locations where the number of completely observed cases (on all variables) is greater than the threshold.
#               The function should return a vector of correlations for the monitors that meet the threshold requirement. 
#               If no monitors meet the threshold requirement, then the function should return a numeric vector of length 0.
# 
# Comment :    This can be solved using two methods : loop or sapply. sapply one is written below.


corr <- function(directory,threshold = 0)
{
  #1. Call complete function from Complete.R script. The function returns a data frame with number of complete cases for each id.
  completeData <- complete(directory)
  
  #2. Get the ids from completeData whose number of complete cases are > threshold provided. 
  completeId <- subset(completeData, completeData$nbos > threshold)$id
  
  #3. Call corrId function which will find corelation between Sulfate and Nitrate values for each Ids in completeId.
  corrId <- function(i)
  {
    #3.1 Read the file for each id.
    x<- formatC(i,width=3,format="d",flag="0")
    fileData <- read.csv(paste(directory,"/",x,".csv",sep=""))
    
    #3.2 Only get the complete cases as subset for that id data.
    compl_case <- fileData[complete.cases(fileData),]
    
    #3.3 Find correlation and return.
    correl <- cor(compl_case$sulfate,compl_case$nitrate)
    
  }
  
  #4. Use sapply to call corrId function for each id in completeId. Save the retured values in vector corelation.
  corelation <- sapply(completeId,corrId)
  
  #5. Return corelation
  return(corelation)
  
}