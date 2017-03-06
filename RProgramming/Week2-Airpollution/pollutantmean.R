#Created by : Bhavana Jain
#Requirement :Write a function named 'pollutantmean' that calculates the mean of a pollutant (sulfate or nitrate) across a specified list of monitors.
#             The function 'pollutantmean' takes three arguments: 'directory', 'pollutant', and 'id'. 
#             Given a vector monitor ID numbers, 'pollutantmean' reads that monitors' particulate matter data from the directory specified in 
#             the 'directory' argument and returns the mean of the pollutant across all of the monitors, ignoring any missing values coded as NA. 

#Comment: Solved using loop. Can be solved using sapply also.

pollutantmean<- function(directory, pollutant,id = 1:332)
{
  
#1. Initialize a data frame which will hold datat for all monitors(ids)
  acrossMonitor<- data.frame()
  
#2. Excute for loop to read each file with the provided id and get the value of pollutant for that id.
  for(i in id)
  {
    #2.1 Append '0' till 3 digit number to get the file name
      x<- formatC(i,width=3,format="d",flag="0")
    
    #2.2 Read the file by creating a path using paste function.
      fileData <- read.csv(paste(directory,"/",x,".csv",sep=""))
    
    #2.3 Clean data (coerce as.numeric and remove missing values)
      selectedCol <-  suppressWarnings(as.numeric(fileData[[pollutant]]))
      fileData <- fileData[!(is.na(fileData[[pollutant]])),]
    
    #2.4 Merge data in acrossMonitor data frame
      acrossMonitor <- rbind(acrossMonitor,fileData)
  }
  
#3. Calculate mean for pollutant across all monitors
  meanAcross<- mean(acrossMonitor[,pollutant])
 
#4. Return meanAcross
  return(meanAcross)

}