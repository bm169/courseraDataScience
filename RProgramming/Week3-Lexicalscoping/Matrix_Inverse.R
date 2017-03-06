# Created by : Bhavana Jain
# Requirement :Caching the Inverse of a Matrixless 
#               Write a pair of functions that cache the inverse of a matrix.
# Comment: 


makeCacheMatrix <- function(x=matrix()){
  
#1. Initializing inverse variable to null
  i <- NULL
  
#2. Resetting inverse matrix (cache) value to null if matrix object is set to new value 
  set <- function(y)
  {
    x<<- y
    i<<-NULL
  }
  
  #return matrix
    get <- function() x
  
  #function gets the inverse value as argument and sets it to variable i
    set_inverse <- function(inverse) i <<-inverse
    
    get_inverse <-function() i
    
    list(set = set, get = get,
         set_inverse = set_inverse,
         get_inverse = get_inverse)
  
}

cachesolve <- function(x,...)
{
  i <- x$get_inverse()
  
  if(!is.null(i))
  {
    message("Getting cached inverse marix")
    return(i)
    
  }
  
  mat <- x$get()
  i<- solve(mat)
  x$set_inverse(i)
  
  return(i)
  
}