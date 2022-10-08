dataPath<-"C:/Users/Public/Documents"
dat <- read.table(paste(dataPath,'Week3_Test_Sample.csv',sep = '/'), header=TRUE)


#datNorm <- rnorm(500, dat$x[1], dat$x[2])
#datExp <- rexp(500,dat$x[3])

datNorm <- qnorm(dat$x[4:503], dat$x[1], dat$x[2])
datExp <- qexp(dat$x[4:503], dat$x[3])


res<-cbind(datNorm=datNorm,datExp=datExp)

write.table(res, file = paste(dataPath,'result.csv',sep = '/'), row.names = F)

hist(dat$x[4:503])
hist(datNorm)
hist(datExp)
