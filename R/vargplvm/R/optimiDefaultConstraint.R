optimiDefaultConstraint <-
  function (constraint, matlabway = FALSE) {

    if (!matlabway)
    {
        stop("optimiDefaultConstraint\n")
      if ( constraint == "positive" ) {
        stop("opDefaulCon\n")
        return (list(func="expTransform", hasArgs=FALSE))
      } else if ( constraint == "zeroone" ) {
        return (list(func="sigmoidTransform", hasArgs=FALSE))
      } else if ( constraint == "bounded" ) {
        return (list(func="boundedTransform", hasArgs=TRUE))
      }
    }
    else {
      switch (EXPR = constraint,
              positive = {
                str = "exp" },
              zeroone = { 
                str = "sigmoid" },
              bounded = {
                str = "sigmoidab" }) 
      return (str)
    }
  }
