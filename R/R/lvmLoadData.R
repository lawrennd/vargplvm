lvmLoadData <-
function(dataset, baseDir = system.file("extdata",package="vargplvm"), data)
{
  #   baseDir <-system.file("extdata",package="vargplvm")
  switch (EXPR = dataset, 
          oil = {
            dataSetName <- paste(baseDir, "/3Class.mat", sep = "")
            data <-readMat(dataSetName)})
  return(data)
}
