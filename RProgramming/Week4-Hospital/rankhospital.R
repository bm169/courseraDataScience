
rankhospital<- function(state,outcome,rank)
{
  #1. Load csv file into data
  data<- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  #2. Get states levels and check for invalid state
  st <- levels(factor(data[,7]))
  if(state %in% st == FALSE){stop("Invalid State")}
  #3. Check invalid outcome and set column index accordingly
  if(tolower(outcome)!="heart attack" & tolower(outcome) != "heart failure" & tolower(outcome)!="pneumonia")
  {stop("Invalid outcome")}
  
  #4. Get column index by provided outcome argument
  if(tolower(outcome)=="heart attack")
  {o<-11}
  else if( tolower(outcome) == "heart failure")
  {o<-17}
  else if (tolower(outcome)=="pneumonia")
  {o<-23}
  
  #5. Get subset for state
  subdata <- subset(data, State == state)
  
  #6. Clean data and convert outcome column into numeric
  selectedcol <- suppressWarnings(as.numeric(subdata[,o]))
  subdata <- subdata[!(is.na(selectedcol)),] # cleaned data
  
  selectedcol <- as.numeric(subdata[,o])
  
  #7 Order the df by outcome and then hospital
  
  sorteddata <- subdata[order(selectedcol,subdata[2]),]
  
  
  #8 subset by rank
  if (rank == "best")
  {
    r <- 1
  }
  else if (rank =="worst")
  {
    r<-nrow(sorteddata)
  }
  else if(rank > nrow(sorteddata))
  {
    stop("Invalid rank")
  }
  else
  {
    r<-rank
  }
  s<- sorteddata[r,2]
  

  return(s)

}