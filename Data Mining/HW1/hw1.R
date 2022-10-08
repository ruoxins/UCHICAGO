# load data
library(caret)
data(GermanCredit)

# create dummy variables for 'Class'
GermanCredit$class_good <- ifelse(GermanCredit$Class == 'Good', 1, 0)
GermanCredit$class_bad <- ifelse(GermanCredit$Class == 'Bad', 1, 0)
GermanCredit <- subset(GermanCredit, select = -c(Class))

################################################################################
# Select variables to keep
################################################################################
# split once
train_ind <- sample(seq_len(nrow(GermanCredit)), size = 632)
train <- GermanCredit[train_ind, ]
test <- GermanCredit[-train_ind, ]

# Train an rpart model and compute variable importance.
rPartMod <- train(Amount ~ ., data=train, method="rpart")
rpartImp <- varImp(rPartMod)
print(rpartImp)


# delete unsignificant(NA coefficient, correlated) columns
train2 <- subset(train, select = -c(CheckingAccountStatus.none, CreditHistory.Critical, 
                                    Purpose.Vacation, Purpose.Other, SavingsAccountBonds.Unknown,
                                    EmploymentDuration.Unemployed, Personal.Male.Married.Widowed, 
                                    Personal.Female.Single, OtherDebtorsGuarantors.Guarantor, Property.Unknown,
                                    OtherInstallmentPlans.None, Housing.ForFree, Job.Management.SelfEmp.HighlyQualified,
                                    class_bad))



# delete unsignificant(NA coefficient, correlated) columns for test data
test2 <- subset(test, select = -c(CheckingAccountStatus.none, CreditHistory.Critical, 
                                     Purpose.Vacation, Purpose.Other, SavingsAccountBonds.Unknown,
                                     EmploymentDuration.Unemployed, Personal.Male.Married.Widowed, 
                                     Personal.Female.Single, OtherDebtorsGuarantors.Guarantor, Property.Unknown,
                                     OtherInstallmentPlans.None, Housing.ForFree, Job.Management.SelfEmp.HighlyQualified,
                                     class_bad))

test2_no_amount <- subset(test2, select = -c(Amount))


# calculate correlation matrix
correlationMatrix <- cor(train2)
# summarize the correlation matrix
print(correlationMatrix)
# find attributes that are highly corrected (ideally >0.75)
highlyCorrelated <- findCorrelation(correlationMatrix, cutoff=0.6)
# print indexes of highly correlated attributes
print(highlyCorrelated)
# 36  2 45 47 37
colnames(correlationMatrix)[36] # Personal.Male.Single
colnames(correlationMatrix)[45] # Housing.Own
colnames(correlationMatrix)[47] # Job.UnskilledResident
colnames(correlationMatrix)[37] # OtherDebtorsGuarantors.None



# create model
# model with selected variables
model2 <- lm(Amount ~ ., data = train2)
res <- summary(model2)
res$r.squared

# predict result for test data
pred <- predict(model2, test2_no_amount)
pred
cor_coeff <- cor(test2$Amount, pred)^2

################################################################################
# Repitition 1000 times ########################################################
################################################################################

#create dataframe to store model coefficients
coeffs <- data.frame(matrix(ncol = 49, nrow = 1000))
colnames(coeffs) <- names(model2$coefficients)

#create dataframe to store model coefficients
r_square <- data.frame(matrix(ncol = 2, nrow = 1000))
colnames(r_square) <- c("R^2 for Train", "R^2 for Test")
n <- 10000

for (i in 1:n) {
  # split
  train_ind <- sample(seq_len(nrow(GermanCredit)), size = 632)
  train <- GermanCredit[train_ind, ]
  test <- GermanCredit[-train_ind, ]
  
  # delete unsignificant(NA coefficient, correlated) columns
  train2 <- subset(train, select = -c(CheckingAccountStatus.none, CreditHistory.Critical, 
                                       Purpose.Vacation, Purpose.Other, SavingsAccountBonds.Unknown,
                                       EmploymentDuration.Unemployed, Personal.Male.Married.Widowed, 
                                       Personal.Female.Single, OtherDebtorsGuarantors.Guarantor, Property.Unknown,
                                       OtherInstallmentPlans.None, Housing.ForFree, Job.Management.SelfEmp.HighlyQualified,
                                       class_bad))
  
  test2 <- subset(test, select = -c(CheckingAccountStatus.none, CreditHistory.Critical, 
                                     Purpose.Vacation, Purpose.Other, SavingsAccountBonds.Unknown,
                                     EmploymentDuration.Unemployed, Personal.Male.Married.Widowed, 
                                     Personal.Female.Single, OtherDebtorsGuarantors.Guarantor, Property.Unknown,
                                     OtherInstallmentPlans.None, Housing.ForFree, Job.Management.SelfEmp.HighlyQualified,
                                     class_bad))
  
  test2_no_amount <- subset(test2, select = -c(Amount))
  
  m <- lm(Amount ~ ., data = train2)
  res <- summary(m)
  r_square[i,1] <- res$r.squared
  coeffs[i,] <- m$coefficients
  pred <- predict(m, test2_no_amount)
  cor_coeff <- cor(test2$Amount, pred)^2
  r_square[i,2] <- cor_coeff
}

# Plot histogram of 3 coefficients
par(mfrow = c(3, 1))
for (i in 2:4){
  x <- coeffs[,i]
  hist(x, xlab=colnames(coeffs)[i], main="Histogram")
}

# Plot histogram of all coefficients
# par(mfrow = c(4, 5))
# for (i in 1:20){
#   x <- coeffs[,i]
#   hist(x, xlab=colnames(coeffs)[i], main="Histogram")
# }
# 
# par(mfrow = c(4, 5))
# for (i in 21:40){
#   x <- coeffs[,i]
#   hist(x, xlab=colnames(coeffs)[i], main="Histogram")
# }
# 
# par(mfrow = c(3, 3))
# for (i in 41:49){
#   x <- coeffs[,i]
#   hist(x, xlab=colnames(coeffs)[i], main="Histogram")
# }

# Plot distribution of R squared in train/ hold out
par(mfrow = c(1, 1))
hist(r_square[, 1], xlab="R^2", main="Histogram for Train R^2")
hist(r_square[, 2], xlab="R^2", main="Histogram for Test R^2")

# Calculate percentage decrease of R square from train to holdout and
# plot the distribution
Train.R.Squared <- r_square[, 1]
Holdout.R.Squared <- r_square[, 2]
per_decrease <- (Train.R.Squared - Holdout.R.Squared)/Train.R.Squared
hist(per_decrease)

# Compute the averages of all 1000 coefficients.
# Compute the standard deviation of all 1000 coefficients (for each beta)
coeff_data <- data.frame(matrix(ncol = 49, nrow = 3))
colnames(coeff_data) <- names(model2$coefficients)
rownames(coeff_data) <- c("mean", "stdev", "coeff_sample")
for (i in 1:49) {
  coeff_data[1, i] <- mean(coeffs[,i])
  coeff_data[2, i] <- sd(coeffs[,i])
}

# Compare average across 1000 to single model built using entire sample.
model_entire <- lm(Amount ~ ., data = GermanCredit)
summary(model_entire)
coeff_data[3, ] <- na.omit(model_entire$coefficients)[1:49]

# Compare the means of the 1000 coefficients to the coefficients from the model 
# created in step 2 created using the entire sample. 
# Show the percentage difference
per_change <- (coeff_data[1, ] - coeff_data[3, ]) / coeff_data[1, ]*100


# Sort each coefficient's 1000 values. Compute 2.5%-97.5% Confidence
# Intervals (CI). Scale these CI's down by a factor of .632^0.5 . How do these
# CIs compare to CIs computed from single model's CIs?
CI <- data.frame(matrix(ncol = 7, nrow = 49))
rownames(CI) <- names(model2$coefficients)
colnames(CI) <- c("Rep.lower", "Rep.upper", "Rep scaled width",
                  "Full.lower", "Full.upper", "Full width", "Width Diff")

for (i in 1:49) {
  sample.mean <- coeff_data[1,i]
  sample.se <- coeff_data[2,i]/sqrt(n)
  
  alpha <- 0.05
  degrees.freedom <- n - 1
  t.score <- qt(p=alpha/2, df=degrees.freedom,lower.tail=F)
  #print(t.score)
  
  margin.error <- t.score * sample.se
  lower.bound <- sample.mean - margin.error
  upper.bound <- sample.mean + margin.error
  #print(c(lower.bound,upper.bound))
  CI[i,1] <- lower.bound
  CI[i,2] <- upper.bound
  CI[i,3] <- (upper.bound - lower.bound)*sqrt(0.632)
}



# confidence interval of full model
interval <- confint(model_entire, level=0.95)
interval <- na.omit(interval)
CI[, 4] <- interval[, 1]
CI[, 5] <- interval[, 2]
CI[, 6] <- interval[, 2] - interval[, 1]
CI[, 7] <- CI[,3] - CI[,6]
