dataPath<-"C:/Users/Public/Documents"
dat <- read.table(paste(dataPath,'Week5_Test_Sample.csv',sep = '/'), header=TRUE)

# create model
GeneralModel <- lm(Output ~ Input, dat)


# matplot(dat$Input,cbind(dat$Output,GeneralModel$fitted.values),
#        type="p",pch=16,ylab="Sample and Fitted Values")

# plot residuals
# model_residuals <- GeneralModel$residuals
# plot(dat$Input, model_residuals)


# prob_density_redisual <- density(model_residuals)
#plot(prob_density_redisual,ylim=c(0,.5))
#lines(prob_density_redisual$x,
#      dnorm(prob_density_redisual$x,mean=mean(model_residuals),sd=sd(model_residuals)))



# Unmixing the model
nSample <- length(dat$Input)

# Create NA vectors
Train.Sample <- data.frame(trainInput=dat$Input,trainOutput = rep(NA,nSample))
Train.Sample.Steeper <- data.frame(trainSteepInput=dat$Input,
                                 trainSteepOutput=rep(NA,nSample))  
Train.Sample.Flatter <- data.frame(trainFlatInput=dat$Input,
                                 trainFlatOutput=rep(NA,nSample))  


head(cbind(dat,
           Train.Sample,
           Train.Sample.Steeper,
           Train.Sample.Flatter))

# Create selectors
Train.Sample.Selector <- dat$Input >= 0
Train.Sample.Steeper.Selector <- Train.Sample.Selector&
  (dat$Output > GeneralModel$fitted.values)
Train.Sample.Flatter.Selector <- Train.Sample.Selector&
  (dat$Output <= GeneralModel$fitted.values)

# Select subsamples
Train.Sample[Train.Sample.Selector, 2] <- dat[Train.Sample.Selector, 1]
Train.Sample.Steeper[Train.Sample.Steeper.Selector, 2] <- dat[Train.Sample.Steeper.Selector, 1]
Train.Sample.Flatter[Train.Sample.Flatter.Selector, 2] <- dat[Train.Sample.Flatter.Selector, 1]
head(Train.Sample)


head(cbind(dat,
           Train.Sample,
           Train.Sample.Steeper,
           Train.Sample.Flatter),10)

plot(Train.Sample$trainInput, Train.Sample$trainOutput,
     pch=16, ylab="Training Sample Output",
     xlab="Training Sample Input")
points(Train.Sample.Steeper$trainSteepInput, 
       Train.Sample.Steeper$trainSteepOutput, pch=20, col="green")
points(Train.Sample.Flatter$trainFlatInput, 
       Train.Sample.Flatter$trainFlatOutput, pch=20, col="blue")

Train.Sample.Steeper <- na.omit(Train.Sample.Steeper)
Train.Sample.Flatter <- na.omit(Train.Sample.Flatter)

steep_lm <- lm(trainSteepOutput ~ trainSteepInput, Train.Sample.Steeper)
flat_lm <- lm(trainFlatOutput ~ trainFlatInput, Train.Sample.Flatter)

rbind(Steeper.Coefficients = steep_lm$coefficients,
      Flatter.Coefficients = flat_lm$coefficients)


plot(dat$Input,dat$Output, type="p",pch=19)
lines(dat$Input,predict(steep_lm,
                        data.frame(trainSteepInput=dat$Input),
                        interval="prediction")[,1],col="red",lwd=3)
lines(dat$Input,predict(flat_lm,data.frame(trainFlatInput=dat$Input),
                        interval="prediction")[,1],col="green",lwd=3)



# Rsquare
# 0: 0.9511, 0.9003
# 1: 8783, 0.7529


# Define the distances from each Output point to both estimated training lines
Distances.to.Steeper<-abs(dat$Output-
                            dat$Input*steep_lm$coefficients[2]-
                            steep_lm$coefficients[1])
Distances.to.Flatter<-abs(dat$Output-
                            dat$Input*flat_lm$coefficients[2]-
                            flat_lm$coefficients[1])

# Define the unscramble sequence
Unscrambling.Sequence.Steeper <- Distances.to.Steeper < Distances.to.Flatter

# Define  two subsamples with NAs in the Output columns
Subsample.Steeper<-data.frame(steeperInput=dat$Input,steeperOutput=rep(NA,nSample))
Subsample.Flatter<-data.frame(flatterInput=dat$Input,flatterOutput=rep(NA,nSample))


# Fill in the unscrambled outputs instead of NAs where necessary
Subsample.Steeper[Unscrambling.Sequence.Steeper,2]<-dat[Unscrambling.Sequence.Steeper,1]
Subsample.Flatter[!Unscrambling.Sequence.Steeper,2]<-dat[!Unscrambling.Sequence.Steeper,1]

# Check the first rows
head(cbind(dat,Subsample.Steeper,Subsample.Flatter))

# Plot the unscrambled subsamples, include the original entire sample as a check
matplot(dat$Input,cbind(dat$Output,
                        Subsample.Steeper$steeperOutput,
                        Subsample.Flatter$flatterOutput),
        type="p",col=c("black","green","blue"),
        pch=16,ylab="Separated Subsamples")


steep <- lm(steeperOutput ~ steeperInput, Subsample.Steeper)
flat <- lm(flatterOutput ~ flatterInput, Subsample.Flatter)

rbind(Steeper.Coefficients=steep$coefficients,
      Flatter.Coefficients=flat$coefficients)

summary(steep)$r.sq
summary(flat)$r.sq


mSteep <- steep
mFlat <- flat

summary(mSteep)
summary(mFlat)


################################################################################
# Alternative

clusteringParabola <- 
  (GeneralModel$fitted.values - mean(GeneralModel$fitted.values))^2

plot(dat$Input,(dat$Output-mean(dat$Output))^2, type="p",pch=19,
     ylab="Squared Deviations")


points(dat$Input,clusteringParabola,pch=19,col="red")


Unscrambling.Sequence.Steeper.var <- 
  (dat$Output-mean(dat$Output))^2 > clusteringParabola

Subsample.Steeper.var<-
  data.frame(steeperInput.var=dat$Input, steeperOutput.var=rep(NA,nSample))
Subsample.Flatter.var<-
  data.frame(flatterInput.var=dat$Input, flatterOutput.var=rep(NA,nSample))

Subsample.Steeper.var[Unscrambling.Sequence.Steeper.var,2] <-
  dat[Unscrambling.Sequence.Steeper.var, 1]
Subsample.Flatter.var[!Unscrambling.Sequence.Steeper.var,2] <-
  dat[!Unscrambling.Sequence.Steeper.var, 1]

# Check the first 10 rows
head(cbind(dat,Subsample.Steeper.var,Subsample.Flatter.var),10)

# Plot clusters of the variance data and the separating parabola
plot(dat$Input,
     (dat$Output-mean(dat$Output))^2,
     type="p",pch=19,ylab="Squared Deviations")
points(dat$Input,clusteringParabola,pch=19,col="red")
points(dat$Input[Unscrambling.Sequence.Steeper.var],
       (dat$Output[Unscrambling.Sequence.Steeper.var]-
          mean(dat$Output))^2,
       pch=19,col="blue")
points(dat$Input[!Unscrambling.Sequence.Steeper.var],
       (dat$Output[!Unscrambling.Sequence.Steeper.var]-
          mean(dat$Output))^2,
       pch=19,col="green")


# Plot the unscrambled subsamples, 
# include the original entire sample as a check.
excludeMiddle<-(dat$Input<=mean(dat$Input)-0)|
  (dat$Input>=mean(dat$Input)+0)
matplot(dat$Input[excludeMiddle],cbind(dat$Output[excludeMiddle],
                                       Subsample.Steeper.var$steeperOutput.var[excludeMiddle],
                                       Subsample.Flatter.var$flatterOutput.var[excludeMiddle]),
        type="p",col=c("black","green","blue"),
        pch=16,ylab="Separated Subsamples")



steep2 <- lm(steeperOutput.var ~ steeperInput.var, Subsample.Steeper.var)
flat2 <- lm(flatterOutput.var ~ flatterInput.var, Subsample.Flatter.var)

rbind(Steeper.Coefficients.var = steep2$coefficients,
      Flatter.Coefficients.var = flat2$coefficients)


plot(dat$Input,dat$Output, type="p",pch=19)
lines(dat$Input,predict(steep2,
                        data.frame(steeperInput.var=dat$Input),
                        interval="prediction")[,1],col="red",lwd=3)
lines(dat$Input,predict(flat2,data.frame(flatterInput.var=dat$Input),
                        interval="prediction")[,1],col="green",lwd=3)

summary(steep2)
summary(flat2)


mSteep <- steep2
mFlat <- flat2



# Save the results
res <- list(GeneralModel = GeneralModel,mSteep = mSteep,mFlat = mFlat)
saveRDS(res, file = paste(dataPath,'result.rds',sep = '/'))
