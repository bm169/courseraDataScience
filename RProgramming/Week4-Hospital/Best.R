#Created by : Bhavana Jain
#Requirement : Finding the best hospital in a state

best <- function(state,outcome)
{
  
  
  #1. Read data into data df
  data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  
  
  #2. Get unique states and check for invalid state. If so, stop and print message
  st <- levels(factor(data[,7]))
  
  if(!(state %in% st)){stop("State invalid")}
    
  
  #3. Verify outcome argument and if invalid, stop and print message
  if(tolower(outcome)!="heart attack" & tolower(outcome) != "heart failure" & tolower(outcome)!="pneumonia")
  {stop("Invalid outcome")}
  
  #4. Get column index by provided outcome argument
  if(tolower(outcome)=="heart attack")
  {o<-11}
  else if( tolower(outcome) == "heart failure")
  {o<-17}
  else if (tolower(outcome)=="pneumonia")
  {o<-23}
    
  #5. Get subset of data_host  df for specified state. Avoid bringing na values in outcome column. Bring only three columns.
  sub_data <- subset(data,state == state)
  
  #6. clean data for outcome column. Now col_data has list of all row index with numeric outcome column value
  col_data <- suppressWarnings(as.numeric(sub_data[,o]))
  sub_data <- sub_data[!(is.na(col_data)),]
  
  col_data <- as.numeric(sub_data[,o])
  
  #7. Get rows with min col_data value. This will return row index which has min col value
  row<- which(col_data == min(col_data))
  
  #8. Return subset for this row
  s<- sub_data[row,2]
  s<- sort(s)
return(s)

}