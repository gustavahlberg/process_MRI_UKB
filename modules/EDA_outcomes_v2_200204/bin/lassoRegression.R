#
#
# explore associaions to af and stroke
# w/ glmnet and lasso
# ---------------------------------------------
#
# glmnet
#


library(pROC)
library(caret)
library(glmnet)
head(voltab)
y = voltab$stroke

which(colnames(voltab) == "cm")
which(colnames(voltab) == "svdTrailCog")

length(which(voltab$mi == 1 | voltab$bmi > 40 | voltab$hf_cm == 1 ))
idxExcl = which(voltab$mi == 1 | voltab$bmi > 40 | voltab$hf_cm == 1 )
#volttmp = voltab[-idxExcl,-c(15,21,23,27,28,29,32,43:44)]
volttmp = voltab[,-c(16,22,24,28,29,30,33,44,45)]

volttmp$lamini = volttmp$lamin/volttmp$bsa
volttmp$lamaxi = volttmp$lamax/volttmp$bsa

dim(volttmp)
idxComplete = complete.cases(volttmp) 
length(idxComplete)

#x = scale(voltab[idxComplete,-c(15,21,28,31:32,43:44)])
#x = scale(voltab[idxComplete,-c(14,20,27,30:31,42:43,29)])
#y = voltab$stroke[idxComplete]
x = volttmp[idxComplete,-which(colnames(volttmp) == "stroke")]
y = volttmp$stroke[idxComplete]
sum(y)




# x = scale(voltab[,c(1:13,15:19,44)])
#x = scale(voltab[,-c(14,30:31,42:43)])
#x = as.matrix(voltab[,-c(14,30:31,42:43)])
trainIndex <- createDataPartition(y, p = 0.75,
                                  list = FALSE, 
                                  times = 1)

cvfit = cv.glmnet(x[trainIndex,], y[trainIndex], family = "binomial", type.measure = "auc",
                  alpha=1)
plot(cvfit)
log(cvfit$lambda.1se)
coef(cvfit, s = "lambda.1se")
coef(cvfit, s = "lambda.min")

afPredict = predict(cvfit, newx = x[-trainIndex,], s = "lambda.min", type = "response")
auc(y[-trainIndex], afPredict[,1])


fit = glmnet(x[trainIndex,] , y = y[trainIndex], family = "binomial", alpha = 1)
par(mfrow=c(3,1))
plot(fit, xvar="lambda", label = T)
plot(cvfit)
plot(fit, xvar = "dev", label = TRUE)

afPredict = predict(cvfit, newx = x[-trainIndex,], s = "lambda.min", type = "response")
auc(y[-trainIndex], afPredict[,1])

names(which(coef(cvfit, s = "lambda.1se")[,1] != 0))[-1]

mod1 = glm(y ~ x[,names(which(coef(cvfit, s = "lambda.min")[,1] != 0))[-c(1,9)]], family = binomial())
mod2 = glm(y ~ x, family = binomial())
summary(mod1)
summary(mod2)
anova(mod1, mod2, test ="Chisq")
library(pscl)
pR2(mod1)
pR2(mod2)
varImp(mod1)
varImp(mod2)


ctrl <- trainControl(method = "repeatedcv", number = 10, savePredictions = TRUE)
yfac = as.factor(y)
d1 = cbind(y,x[,names(which(coef(cvfit, s = "lambda.min")[,1] != 0))[-1]])
d1[trainIndex,]

mod_fit1 <- train(y ~ lamin + aeTangent +HR  +  latef + laaef +expansionidx+  sex +         
                    age +height + bsa, method="glm", family="binomial",
                  trControl = ctrl, tuneLength = 5, data = d1[trainIndex,])

pred = predict(mod_fit1, newdata=d1[-trainIndex,]) 
auc(y[-trainIndex], pred)
confusionMatrix(data=pred, yfac[-trainIndex])

d2 = cbind(y,x)
mod_fit2 <- train(as.factor(y) ~ ., method="glm", family="binomial",
                  trControl = ctrl, tuneLength = 5, data = d2[trainIndex,])

pred = predict(mod_fit2, newdata=d2[-trainIndex,]) 
auc(y[-trainIndex], pred)




# -------------------------------------------
#
# check interactions
# 

y = as.numeric(volttmp$af)
dat = data.frame(y,volttmp)


# ---------------------------------------------------
# f1

f1 <- as.formula(y ~ lapef + laaef + aeTangent + lamin  +
                   age + sex + bmi + bsa + weight + height)

# --------------------------------------------
# f2

f2 <- as.formula(y ~ laaef*aeTangent + laaef*lamin + lapef + laaef + aeTangent + lamin +
                   age + sex + bmi + bsa + weight + height)

# --------------------------------------------
# f3

f3 <- as.formula(y ~laaef*lamin + latef + laaef + lapef+ lamin + aeTangent + lamax + lamdv +
                   lasv + laev + lapev +
              age + sex + bmi + bsa + weight + height)
  



# --------------------------------------------
# f4 stroke

f4 <- as.formula(y ~ lapef+ peTangent + laaef*lamin + aeTangent +
                   af + age + sex + bmi + bsa + weight + height )



# --------------------------------------------
# f5-f7 indexed values

f5 <- as.formula(y ~ lamin + lamax + latef + laaef:lamin + age + sex  + bsa.2 + imgCenter)
f6 <- as.formula(y ~ lamini + lamaxi + latef + laaef:lamini + age + sex + bsa.2 + imgCenter)
f7 <- as.formula(y ~ lamin + lamax + bsa.2  + age + sex  )
f8 <- as.formula(y ~ lamin + lamax + lamini + lamaxi + bsa.2 +age + sex  )

# ----------------
# run model  

f = f6
x <- model.matrix(f, dat)
x = scale(x[,-1])
y <- as.matrix(dat$y, ncol=1)


# trainIndex <- createDataPartition(y, p = 0.8,
#                                   list = FALSE,
#                                   times = 1)

cvfit = cv.glmnet(x[trainIndex,], y[trainIndex], family = "binomial", type.measure = "auc",
                  alpha=1)

plot(cvfit)
log(cvfit$lambda.1se)
coef(cvfit, s = "lambda.1se")
coef(cvfit, s = "lambda.min")
afPredict = predict(cvfit, newx = x[-trainIndex,], s = "lambda.min", type = "response")
auc(y[-trainIndex], afPredict[,1])
afPredict = predict(cvfit, newx = x[-trainIndex,], s = "lambda.1se", type = "response")
auc(y[-trainIndex], afPredict[,1])


fit = glmnet(x , y = y, family = "binomial", alpha = 1)
par(mfrow=c(3,1))
plot(fit, xvar="lambda", label = T)
plot(cvfit)
plot(fit, xvar = "dev", label = TRUE)

dev.off()
