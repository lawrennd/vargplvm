lvmLoadData <-
function(dataSet, dataDir = system.file("extdata",package="vargplvm"))
{
  #   baseDir <-system.file("extdata",package="vargplvm")
  switch (EXPR = dataSet, 
          oil = {
            dataSetName <- paste(dataDir, "/3Class.mat", sep = "")
            data <-readMat(dataSetName)},
          gene = {
            data <- list()
            data$DataTrn <-read.table(file = 
              paste(dataDir,"/gene_expression_guo.txt",sep =""),sep=",")
            data$DataTrnLbls <-read.table(file = 
              paste(dataDir,"/labels_guo.txt",sep = ""),sep=",")
            
            })
  return(data)
}
