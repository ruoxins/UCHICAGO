# Read data
dataPath <- "C:/Users/Public/Documents/"
df <- read.table(paste0(dataPath, 'Week2_Test_Sample.csv'), header=TRUE)

# Calculation
sdX <- sd(df$x)
sdY <- sd(df$y)
sdX <- round(sdX, 2)
sdY <- round(sdY, 2)

cXY <- round(cor(df$x, df$y), 2)
a <- cXY*sdY / sdX

# model <- lm(y~x, data = df)
# summary(model)

# Store the result
result <- data.frame(sdX=sdX, sdY=sdY, cXY=cXY, a=a)  
write.table(result, file = paste(dataPath,'result.csv',sep = '/'), row.names = F)
