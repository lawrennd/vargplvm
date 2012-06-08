kernExtractParam <-
function (kern, only.values=TRUE, untransformed.values=FALSE) {
  funcName <- paste(kern$type, "KernExtractParam", sep="")
  func <- get(funcName, mode="function")

  params <- func(kern, only.values=only.values, untransformed.values=untransformed.values)

  if ( any(is.nan(params)) )
    warning("Parameter has gone to NaN.")

  if ( "transforms" %in% names(kern) && (length(kern$transforms) > 0)
      && !untransformed.values )
    for ( i in seq(along=kern$transforms) ) {
      index <- kern$transforms[[i]]$index
      funcName <-  paste(kern$transforms[[i]]$type, "Transform", sep = "")
      func <- get(funcName, mode="function")
      if (("transformsettings" %in% names(kern$transforms[[i]])) && 
          (length(kern$transforms[[i]]$transformsettings)>0))
        params[index] <- func(params[index], "xtoa", kern$transform[[i]]$transformsettings)
      else
        params[index] <- func(params[index], "xtoa")
    }

  return (params)
}
