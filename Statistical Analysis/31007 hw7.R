# Load data
dataPath <- "C:/Users/Public/Documents"
test_dat <- read.table(paste(dataPath,'Week7_Test_Sample.csv',sep = '/'), header=TRUE)

head(test_dat)


fit.1<-lm(Output~1,data=test_dat)
fit.1.2<-lm(Output~1+Input1,data=test_dat)
fit.1.3<-lm(Output~1+Input2,data=test_dat)
fit.1.2.3<-lm(Output~.,data=test_dat)

anova(fit.1)


round(answer,4)


# 1) Sum of Squares explained by Input1 in model fit.1.2 :
a1 <- round(sum((fit.1.2$fitted.values - mean(test_dat$Output))^2), 4)

# 2) Sum of Squares unexplained by Input1 in model fit.1.2:
a2 <- round(sum(fit.1.2$residuals^2), 4)

# 3) Sum of Squares explained by Input2 in model fit.1.3:
a3 <- round(sum((fit.1.3$fitted.values - mean(test_dat$Output))^2), 4)

# 4) Sum of Squares unexplained by Input2 in model fit.1.3:
a4 <- round(sum(fit.1.3$residuals^2), 4)

# 5) F statistic for comparison of fit.1 and fit.1.2.3:
m <- anova(fit.1, fit.1.2.3)
a5 <- round(m$F[2], 4)

# 389.7

# 6) P-value for comparison of fit.1 with fit.1.2.3:

a6 <- round(m$`Pr(>F)`[2], 4)

anova(fit.1, fit.1.3)

