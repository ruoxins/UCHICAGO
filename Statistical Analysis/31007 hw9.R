dataPath <- "C:/Users/Public/Documents/msca 31007"
test_dat <- read.table(paste(dataPath,'Week9_Test_Sample.csv',sep = '/'), header=TRUE)


matplot(test_dat,type="l")


pca <- princomp(test_dat[, 2:11])
names(pca)
pca$sdev

barplot(pca$sdev)

summary(pca)

# manual
Covariance.Matrix<-cov(test_dat)

eig <- eigen(Covariance.Matrix)
eig_val <- eig$values

pcaLoadings<-pca$loadings[,1:3]
pcaLoading0<-pca$center
pcaFactors<-pca$scores[,1:3]

loadingsComparison<-cbind(pcaLoadings,eig$vectors[,1:3])
colnames(loadingsComparison)<-c(paste0("PCA",1:3),paste0("Manual",1:3))
loadingsComparison

# importance of factor
barplot(eig_val/sum(eig_val),
        width=2,col = "black",
        names.arg=c("F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11"),
        main="Importance of Factors")



# linear model
new_dat <- as.data.frame(cbind(test_dat$Resp, pca$scores))


m1 <- lm(V1 ~ ., new_dat)
summary(m1)
names(summary(m1))
r_2 <- summary(m1)$r.squared
r_2

desired_r <- 0.9*r_2
desired_r  # 0.8792409

m2 <- lm(V1 ~ Comp.1 + Comp.4, new_dat)
summary(m2)$r.squared

pca$scores
