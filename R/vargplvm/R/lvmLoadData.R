lvmLoadData <-
function(dataset, dataDir = system.file("extdata",package="vargplvm"))
{
  #   baseDir <-system.file("extdata",package="vargplvm")
  switch (EXPR = dataset, 
          oil = {
            dataSetName <- paste(dataDir, "/3Class.mat", sep = "")
            data <-readMat(dataSetName)})
  return(data)
}
