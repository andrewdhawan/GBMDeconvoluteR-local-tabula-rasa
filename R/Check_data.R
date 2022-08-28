check_user_data <- function(input){
  
  if(ncol(input) < 3){
    
    "Insufficient samples (< 2) in data"
    
  }else if(nrow(input) < 100){
    
    "Insufficient genes (n < 100) in data"
    
  }else if(!is.character(input[[1]])){
    
    "Gene symbols not detected in data"
    
  }else if(length(unique(colnames(input))) != ncol(input)){
    
    "Duplicate samples detected in the data"
    
  }else if(length(unique(input[[1]])) != nrow(input)){
    
    "Duplicate genes detected in the data"
    
  }else if(any(apply(input[,-1], 2, function(x) any(x<0)))){
    
    "Negative values detected in the data"
    
  }else{
    
    NULL
    
  }
  
}