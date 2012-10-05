plotlegend<-function()
{label <- c("1-cell stage", "2-cell tage", "4-cell stage", "8-cell stage", "16-cell stage",
            "TE", "ICM", "PE", "EPI")

symbolColour <- c(2:(length(label)+1))
#   symbolShape <- c("x", "o", "+", "*", "s", "d", "v", "^", "<", ">", "p") 
symbolShape <-c(4,1,3,8,0,5,6,2,15,16,17)


legend("topleft",label, ncol = 2, 
       cex = 1, col = symbolColour, 
       pch = symbolShape)
}