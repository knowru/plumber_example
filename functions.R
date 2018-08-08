run <- function(req,used_variables,numericColumns,cats,model,scaler,scaleornot="no"){
 
    if(!all(used_variables%in%names(req))){
          for(i in 1:length(used_variables)){
            if(!used_variables[i]%in%names(req)){
              stop(paste0("'",used_variables[i],"' variable missing"))
            }
          }
      }
      
    
    for(i in 1:length(numericColumns)){
      if(!is.numeric(req[,numericColumns[i]])){
        stop(paste0('values in ',numericColumns[i],' are not numeric. Please enter a numeric value.'))
      }
    }
    
    features <- cbind(req,
                    cats)
    
    prediction <- predictions(predict(model,features))[,2]
    
    if(scaleornot=="yes"){
      to_scale <- data.frame(predictChurn = prediction)
      prediction <- as.numeric(predict(scaler,to_scale,type="response")*100)
    }
                               
    return(prediction)

}








level_binr <- function(data,levels,value,short){
    
    if(!value%in%names(data)){
      stop(paste0("'",value,"' variable missing"))
    }
    if(!any(levels%in%data[[value]])){
      stop(paste0("Invalid string in variable '",value,"'. Please enter a value of the following.... ",paste0(levels,collapse=', ', sep='')))
    }
  
  
    new <- data.frame(rows=1:nrow(data))
    levels <- levels[!grepl("missing",levels)]
    
    for(i in 1:length(levels)){
      coln <- paste0("x_",levels[i],"_",short)
      new[[coln]] <- 0
      
      if(value%in%names(data)){
          new[[coln]] <- ifelse(data[[value]]==levels[i],1,0)
          }
    }
    new$rows <- NULL
    return(new)
}
  



# columnCheck <- function(data,columns){
#   for(i in 1:length(columns)){
#     if(!columns[i]%in%names(data)){
#       data[[columns[i]]] <- 0
#     }
#   }
#   return(data)
# }