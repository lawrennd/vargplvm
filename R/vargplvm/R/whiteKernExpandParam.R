whiteKernExpandParam <-
  function (kern, params, matlabway = TRUE) {
    if ( is.list(params) )
      params <- params$values
    
    kern$variance <- params[1]	## linear domain param, i.e. the untransformed noise variance
    
    return (kern)
  }
