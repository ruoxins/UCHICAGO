# Read data from file
dataPath<-"C:/Users/Public/Documents"
dat <- read.table(paste(dataPath,'Week4_Test_Sample.csv',sep = '/'), header=TRUE)



Estimated.LinearModel <- lm(dat$Y ~ dat$X, data=dat)
summary(Estimated.LinearModel)


Estimated.Residuals <- Estimated.LinearModel$residuals
plot(dat$X, Estimated.Residuals)

c(Left.Mean = mean(Estimated.Residuals[Estimated.Residuals < 0]), 
  Right.Mean = mean(Estimated.Residuals[Estimated.Residuals > 0]))

result <- as.data.frame(cbind(Estimated.Residuals, subsample = c(rep(0, 1000))))

for (i in 1:1000) {
  if (result$Estimated.Residuals[i] < 0) {
    result$subsample[i] = 0
  }
  if (result$Estimated.Residuals[i] > 0) {
    result$subsample[i] = 1
  }
}

Unscrambled.Selection.Sequence <- result$subsample

# Save the result
res <- list(Unscrambled.Selection.Sequence =  Unscrambled.Selection.Sequence)
write.table(res, file = paste(dataPath,'result.csv',sep = '/'), row.names = F)
