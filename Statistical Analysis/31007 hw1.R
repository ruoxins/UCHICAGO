dataPath <- "C:/Users/Public/Documents"
data <- read.table(paste(dataPath,'Week1_Test_Sample.csv',sep = '/'), header=TRUE)


N<-length(data[,1])

# u: 1, 2, 3
# v: 1, 2, 3, 4
ctable.u1 <- xtabs(~v, subset(data,u==1))/N

u1 <- data[data$u==1,]
# check
u1_v1 <- u1[u1$v==1,] # 6
u1_v2 <- u1[u1$v==2,] # 15
u1_v3 <- u1[u1$v==3,] # 18
u1_v4 <- u1[u1$v==4,] # 12

ctable.u2 <- xtabs(~v, subset(data,u==2))/N
# check
u2 <- data[data$u==2,]
u2_v1 <- u2[u2$v==1,] # 0
u2_v2 <- u2[u2$v==2,] # 12
u2_v3 <- u2[u2$v==3,] # 9
u2_v4 <- u2[u2$v==4,] # 8

ctable.u3 <- xtabs(~v, subset(data,u==3))/N
# check
u3 <- data[data$u==3,]
u3_v1 <- u3[u3$v==1,] # 0
u3_v2 <- u3[u3$v==2,] # 7
u3_v3 <- u3[u3$v==3,] # 9
u3_v4 <- u3[u3$v==4,] # 4

joint_distribution <- array(rep(NA,12),dim=c(3,4),
                            dimnames=list(paste("u", 1:3, sep = "."),
                                          paste("v", 1:4, sep=".")))
joint_distribution[1,] <-ctable.u1
joint_distribution[2,1] <- 0
joint_distribution[2,2:4] <- ctable.u2
joint_distribution[3,1] <- 0
joint_distribution[3,2:4] <-ctable.u3

joint_distribution


u_Marginal <- c(u_1=sum(joint_distribution["u.1",]),
                u_2=sum(joint_distribution["u.2",]),
                u_3=sum(joint_distribution["u.3",]))
u_Marginal


v_Marginal <- c(v_1=sum(joint_distribution[,"v.1"]),
                v_2=sum(joint_distribution[,"v.2"]),
                v_3=sum(joint_distribution[,"v.3"]),
                v_4=sum(joint_distribution[,"v.4"]))
v_Marginal


# Create variable u_Conditional_v equal 
# to the vector of conditional probabilities P[u|v=4].
u_Conditional_v <- joint_distribution[,"v.4"]/v_Marginal["v_4"]


# Create variable v_Conditional_u equal to 
# the vector of conditional probabilities P[v|u=3].
v_Conditional_u <- joint_distribution["u.3",]/u_Marginal["u_3"]


res <-list(Joint_distribution=joint_distribution,
           u_Marginal = u_Marginal,
           v_Marginal = v_Marginal,
           u_Conditional_v = u_Conditional_v,
           v_Conditional_u = v_Conditional_u)

saveRDS(res, file = paste(dataPath,'result.rds',sep = '/'))
