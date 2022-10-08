dataPath <- "C:/Users/Public/Documents/msca 31007"
test_dat <- read.table(paste(dataPath,'Week8_Test_Sample.csv',sep = '/'), header=TRUE)


m1 <- lm(Output ~ Treatment, test_dat)

m2 <- lm(Output ~ Treatment-1, test_dat)

summary(m2)

m2_anova <- anova(m2)
m2_anova$`Sum Sq`

m1_Summary<-summary(m1)
m1_ANOVA<-anova(m1)S

m1_Summary
m1_ANOVA

# calcualte the mean for each group

# summaryByGroup<-aggregate(Output~Treatment,data=test_dat,FUN=summary)
# means<-cbind(Means=summaryByGroup$Output[,4],Sizes=aggregate(Output~Treatment,data=test_dat,FUN=length)$Output)
# rownames(means)<-as.character(summaryByGroup$Treatment)
# means

meanA <- mean(test_dat[test_dat$Treatment == 'A',]$Output)
meanB <- mean(test_dat[test_dat$Treatment == 'B',]$Output)
meanC <- mean(test_dat[test_dat$Treatment == 'C',]$Output)
len_A <- length(test_dat[test_dat$Treatment == 'A',]$Output)
len_B <- length(test_dat[test_dat$Treatment == 'B',]$Output)
len_C <- length(test_dat[test_dat$Treatment == 'C',]$Output)
mean <- cbind(c(meanA, meanB, meanC), c(len_A, len_B, len_C))
rownames(mean) <- c('A', 'B', 'C')
colnames(mean) <- c('mean', 'count')

# calcualte the grand mean
grand.mean<-mean(test_dat$Output)

#Create subsets for each area
groupA <-subset(test_dat, Treatment == 'A')
groupB <-subset(test_dat, Treatment == 'B')
groupC <-subset(test_dat, Treatment == 'C')

# Calcuate within group SS: find SS for each subset, then add them together
SSW <- sum(((groupA$Output - meanA)^2))+
  sum(((groupB$Output - meanB)^2))+
  sum(((groupC$Output - meanC)^2))

# Calcualte between group SS:
Model.Groups<-c(rep(meanA,len_A),
                rep(meanB,len_B),
                rep(meanC,len_C))
SSB <- sum((Model.Groups-grand.mean)^2)
SST <- SSW + SSB


boxplot(Output~Treatment, data=test_dat, pch=19,col="black")
