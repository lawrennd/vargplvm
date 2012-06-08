vargplvmDemo<-function(dataSetName ="oil", baseDir = system.file("extdata",package="vargplvm"), data, iters = 2)
{
  printDiagram <<- NULL

  # dataSetName <- "oil" 
  experimentNo <- 1 
  printDiagram <- 1 
  
  # load data
  data <- lvmLoadData(dataset = dataSetName, baseDir = baseDir)
  Y <- data$DataTrn
  lbls <- data$DataTrnLbls
  
  # Set up model
  options <- vargplvmOptions("dtcvar") 
  options$kern <- c("rbfard2", "bias", "white")
  
  options$numActive <- 50  

  options$optimiser <- "scg" 
  latentDim <- 10 
  d <- ncol(Y) 
  
  # % demo using the variational inference method for the gplvm model
  
  model <- vargplvmCreate(latentDim, d, Y, options) 
  
  model <- vargplvmParamInit(model, model$m, model$X) 
  model$vardist$covars <- 0.5*matrix(1, dim(model$vardist$covars)[1], dim(model$vardist$covars)[2]) +
    0.001*matrix(rnorm(dim(model$vardist$covars)[1]*dim(model$vardist$covars)[2]), 
                 dim(model$vardist$covars)[1], dim(model$vardist$covars)[2]) 
  model$learnBeta<-1 
  
  # % Optimise the model.
  iters <- iters #%2000
  display <- 1 
  model <- vargplvmOptimise(model, display, iters) 
  
  capName <- dataSetName 
  substring(capName[1], 1, 1) <- toupper(substring(capName[1], 1, 1)) 
  modelType <- model$type 
  substring(modelType[1], 1, 1) <- toupper(substring(modelType[1], 1, 1)) 
  save(model, file = paste("dem", capName, modelType, experimentNo, ".RData", sep = "")) 
  
  # % order wrt to the inputScales 
  mm <- vargplvmReduceModel(model,2) 
  
  # %% plot the two largest twe latent dimensions 
  #   to do print
  if (printDiagram)
    lvmPrintPlot(mm, lbls, capName, experimentNo) 
  #   stopCluster(cl)
  return (mm)
  # ts <- toc
}
