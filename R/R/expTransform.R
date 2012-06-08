expTransform <-
function (x, transform)
{
  # % EXPTRANSFORM Constrains a parameter to be positive through exponentiation.
  # % FORMAT
  # % DESC contains commands to constrain parameters to be positive via
  # % exponentiation.
  # % ARG x : input argument.
  # % ARG y : return argument.
  # % ARG transform : type of transform, 'atox' maps a value into
  # % the transformed space (i.e. makes it positive). 'xtoa' maps the
  # % parameter back from transformed space to the original
  # % space. 'gradfact' gives the factor needed to correct gradients
  # % with respect to the transformed parameter.
  # % 
  # % SEEALSO : negLogLogitTransform, sigmoidTransform
  # %
  # % COPYRIGHT : Neil D. Lawrence, 2004, 2005, 2006, 2007
  # 
  # % OPTIMI
  
  
  limVal <- 36 
  y <- rep(0, length(x))
  switch (EXPR = transform,
          atox = { 
            index <- which(x< (-limVal)) 
            y[index] <- exp(-limVal) 
            x[index] <- NaN 
            index <- which(x<limVal) 
            y[index] <- exp(x[index]) 
            x[index] <- NaN 
            index <- which(!is.na(x)) 
            if (!(length(index) == 0))
              y[index] <- exp(limVal) 
          }, 
          xtoa = {
            y <- log(x) }, 
          gradfact = {
            y <- x })
  return (y)
}
