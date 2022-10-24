#
#
# explore associaions to af and stroke
# w/ xgboost
# ---------------------------------------------
#
# datasets train /test 
#

library(xgboost)
idxExcl = which(voltab$mi == 1 | voltab$bmi > 40 | voltab$hf_cm == 1 )
#volttmp = voltab[-idxExcl,-c(15,21,23,27,28,29,32,43:44)]
volttmp = voltab[,-c(15,21,23,27,28,29,32,43:44)]
dim(volttmp)
idxComplete = complete.cases(volttmp) 
x = scale(volttmp[idxComplete,-which(colnames(volttmp) == "stroke")])
y = volttmp$stroke[idxComplete]

trainIndex <- createDataPartition(y, p = 0.75,
                                  list = FALSE, 
                                  times = 1)

xtrain = x[trainIndex,]; xtest = x[-trainIndex,]
ytrain = y[trainIndex]; ytest = y[-trainIndex]


# ---------------------------------------------
#
# train 
#
params <- list(booster = "gbtree", 
               objective = "binary:logistic", 
               eta=0.3, 
               gamma=0, 
               max_depth=6, 
               min_child_weight=1, 
               subsample=1, 
               colsample_bytree=1)


bstDense <- xgboost(data = xtrain, 
                    label = ytrain, 
                    max.depth = 2, 
                    eta = 1, 
                    nthread = 2, 
                    nrounds = 50, 
                    objective = "binary:logistic")


xgbpred <- predict(bstDense,xtest)
auc(ytest, xgbpred)




confusionMatrix(xgbpred, ytest)

