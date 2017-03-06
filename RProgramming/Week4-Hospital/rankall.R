rankall <- function(outcome, rank="best")
{
  #1. Read csv file
  data<- read.csv("outcome-of-care-measures.csv", colClasses = "character")
 
  #2. Check invalid outcome and set column index accordingly
  if(tolower(outcome)!="heart attack" & tolower(outcome) != "heart failure" & tolower(outcome)!="pneumonia")
  {stop("Invalid outcome")}
  
  #3. Get column index by provided outcome argument
  if(tolower(outcome)=="heart attack")
  {o<-11}
  else if( tolower(outcome) == "heart failure")
  {o<-17}
  else if (tolower(outcome)=="pneumonia")
  {o<-23}
  
  #3. Get states levels
  State <- levels(factor(data[,7]))
  
  #4. clean data
  selectedcol <- suppressWarnings(as.numeric(data[,o]))
  data <- data[!(is.na(selectedcol)),]
  
  selectedcol <- as.numeric(data[,o])
  
  sorteddata <- data[order(data[7],selectedcol,data[2]),]
  
  
  
  
  getdata <- function(state)
 {
 s<- subset(sorteddata, State == state)
 #8 subset by rank
 if (rank == "best")
 {
   r <- 1
 }
 else if (rank =="worst")
 {
   r<-nrow(s)
 }
 
 else
 {
   r<-rank
 }
 w <- s[r,2]
   
 return(w)
  }
  
Hospital<- sapply(State,getdata)

return(data.frame(Hospital ,State))

 # a<- data.frame()
 # ncol(a) <-2
  #colnames(a) <- c("Hospital","State")
 # colnames(a) <- c("Hospital","State")
  
  #for(i in 1:length(State))
  #{
   # s<- subset(sorteddata, State == State[i])
    #w <- s[r,2]
    #a <- rbind(a,c(w,State[i]))
    
    
  #}

  #return(a)
  
  
  
  
  
}