kernExpandParam <-
function (kern, params, untransformed.values=FALSE) {
# browser()
  if ( is.list(params) )
    params <- params$values
  
  if ( "transforms" %in% names(kern) && (length(kern$transforms) > 0)
      && !untransformed.values )
    for ( i in seq(along=kern$transforms) ) {
      index <- kern$transforms[[i]]$index
      funcName <- paste(kern$transforms[[i]]$type, "Transform", sep = "")
      func <- get(funcName, mode="function")
      if (("transformsettings" %in% names(kern$transforms[[i]])) && 
        (length(kern$transforms[[i]]$transformsettings)>0))
        params[index] <- func(params[index], "atox", kern$transform[[i]]$transformsettings) ## log-transformed params just been exp-transformed
      else {
        params[index] <- func(params[index], "atox")
      }
    }

  funcName <- paste(kern$type, "KernExpandParam", sep="")
  func <- get(funcName, mode="function")
# browser()
  kern <- func(kern, params)

  return (kern)
  
}
