#
# Indexed and rank transformed LA variables
#
# ---------------------------------------------
#
# index variables
# lamax,lamin,lamdv,labac,lasv,laev ,lapev


voltab$ilamax = voltab$lamax/voltab$bsa
voltab$ilamin = voltab$lamin/voltab$bsa
voltab$ilamdv = voltab$lamdv/voltab$bsa
voltab$ilabac = voltab$labac/voltab$bsa
voltab$ilasv = voltab$lasv/voltab$bsa
voltab$ilaev = voltab$laev/voltab$bsa
voltab$ilapev = voltab$lapev/voltab$bsa

# ---------------------------------------------
#
# rtrn setup
#

rtrnFun <- function(y = NULL, X = NULL, subsetVec = NULL) {
  res = lm(y ~ X, subset = subsetVec)$residuals
  rntrnRes = rankNorm(res)
  rntrn <- rep(NA,length(y))
  rntrn[as.numeric(names(res))] <- rntrnRes
  return(rntrn)
}


subsetVec = (voltab$hf_cm == 0 & voltab$mi == 0 & (voltab$bmi > 16 & voltab$bmi < 40) &
               !(voltab$LVEF < 20 | voltab$LVEF > 80 | is.na(voltab$LVEF)))
X = model.matrix(~ voltab$sex + voltab$age + voltab$genotyping.array + voltab$imgCenter)[,-1]
Xbsa = model.matrix(~ voltab$sex + voltab$age + voltab$bsa + voltab$genotyping.array + voltab$imgCenter)[,-1]


# ---------------------------------------------
#
# rtrn setup
#

LaParameters = c(colnames(voltab)[grep("la",colnames(voltab))], "aeTangent", "peTangent", "expansionidx")
voltabbakk = voltab

# w/o bsa
for(laPar in LaParameters) {
  print(laPar)
  res = rtrnFun(y = voltabbakk[,laPar], X = X,subsetVec = subsetVec)
  par = paste0("rntrn_",laPar)
  voltabbakk[,par] <- res
}


LaParameters = LaParameters[-grep("^i",LaParameters)]
# w/ bsa
for(laPar in LaParameters) {
  print(laPar)
  res = rtrnFun(y = voltabbakk[,laPar], X = Xbsa, subsetVec = subsetVec)
  par = paste0("rntrnBSA_",laPar)
  voltabbakk[,par] <- res
}


voltab = voltabbakk


# ---------------------------------------------
#
# check diffrent clusters of parameters
#

# rntrn
LaParameters = c(colnames(voltab)[grep("la",colnames(voltab))],
                 "aeTangent", "peTangent", "expansionidx")
LaParameters = LaParameters[-grep("rntrn",LaParameters)]
LaParameters = LaParameters[-grep("BSA|svd",LaParameters)]
#LaParameters = LaParameters[grep("v",LaParameters)]

lapar = (voltab[subsetVec,LaParameters])
dd <- as.dist((1 - cor(lapar))/2)
round(1000 * dd) # (prints more nicely)
par(mfrow=c(1,2))
plot(hclust(dd)) # to see a dendrogram of clustered variables
fit <- cmdscale(dd,eig=TRUE, k=2)
plot(fit$points[,1],fit$points[,2], type = 'n')
text(fit$points[,1],fit$points[,2], labels = rownames(fit$points))

s = svd(voltab[subsetVec,LaParameters])
plot(s$d^2/sum(s$d^2)*100)

PC1 = s$d[1]*s$v[,1]
PC2 = s$d[2]*s$v[,2]
plot(PC1,PC2)

d = cor(lapar)
k = kmeans(d, 3,50)
plot(k$centers[2,],k$centers[1,], type = 'n')
text(k$centers[2,],k$centers[1,], labels = names(k$cluster))



# ---------------------------------------------
#
# check multi regression
#

library(BGLR)

LaParameters = c(colnames(voltab)[grep("la",colnames(voltab))],
                 "aeTangent", "peTangent", "expansionidx")
LaParameters = LaParameters[-grep("rntrn",LaParameters)]
LaParameters = LaParameters[-grep("BSA|svd",LaParameters)]
LaParameters = LaParameters[-grep("^i",LaParameters)]
LaParameters = LaParameters[-grep("^v",LaParameters)]

LaParameters = c("lamax", "lamin","lamdv","labac", "ilamax", "ilamin","ilamdv","ilabac")
LaParameters = c("ilamax", "ilamin","ilamdv","ilabac")
LaParameters = c("lasv","laev","lapev")
LaParameters = c("ilasv","ilaev","ilapev")
LaParameters = c("lamax", "lamin","lamdv","labac")

iC = model.matrix(~voltab$imgCenter)[,-1]
par = c("sex","age", "bmi", paste0("PC",1:10))

rownames(ttnvar) <- as.character(ttnvar$IID)

X = scale(as.matrix(cbind(voltab[,par], iC, ttnvar[voltab$sample.id,]$rs2042995_C)))
Y = scale(voltab[,LaParameters])

SVD=svd(Y)
U=SVD$u
D=diag(SVD$d)
V=SVD$v
plot(SVD$d^2/sum(SVD$d^2)*100)
plot(cumsum(SVD$d^2)/sum(SVD$d^2)*100)
B=matrix(nrow=ncol(X),ncol=ncol(Y))

n = 4
B=matrix(nrow=ncol(X),ncol=n)

ETA=list(list(X=X,model='BayesB'))
for(i in 1:n){
  #fm=BGLR(y=U[,i],ETA=ETA,verbose=F,burnIn=2000,nIter = 12000 ) 
  y = U[,i]
  fm = lm(y ~ -1 + X)
  B[,i] = coef(fm)
  #b.se[,i] = sqrt(diag(vcov(fm)))
  #B[,i]=fm$ETA[[1]]$b
}

Borg=matrix(nrow=ncol(X),ncol=ncol(Y))
b.se.org=matrix(nrow=ncol(X),ncol=ncol(Y))
tstat = matrix(nrow=ncol(X),ncol=ncol(Y))
pval = matrix(nrow=ncol(X),ncol=ncol(Y))
for(i in 1:ncol(Y)){
  y = Y[,i]
  fm = lm(y ~ -1 + X)
  Borg[,i] = coef(fm)
  b.se.org[,i] = sqrt(diag(vcov(fm)))
  tstat[,i] = summary(fm)$coefficients[,3]
  pval[,i] = summary(fm)$coefficients[,4]
  #fm=BGLR(y=Y[,i],ETA=ETA,verbose=F,burnIn=2000,nIter = 12000 ) 
  #Borg[,i]=fm$ETA[[1]]$b
}

str(SVD)

k <- 4
Bhat <- B[,1:k] %*% (D[1:k,1:k] %*% t(V[,1:k]))

for(i in 1:dim(Bhat)[2] ){
  print(cor(Bhat[,i],Borg[,i]))
}

# Prediction
YHat=as.matrix(X)%*%Bhat
YHat2=as.matrix(X)%*%Borg

# correlation in training
for(i in 1:ncol(Y)){ print(cor(Y[,i],YHat[,i])) }
for(i in 1:ncol(Y)){ print(cor(Y[,i],YHat2[,i])) }
for(i in 1:ncol(Y)){ print(cor(YHat[,i],YHat2[,i])) }

mse1 = c(); mse2 = c();
for(i in 1:ncol(Y)) {
  mse1 = c(mse1, 1/nrow(Y) * sum((Y[,i] - YHat[,i])^2))
  mse2 = c(mse2, 1/nrow(Y) * sum((Y[,i] - YHat2[,i])^2))
}
plot(mse1,mse2)
cor(mse1,mse2)
mse1 - mse2
100*(mse1 - mse2)/mse2


# check tstats, 'real' pvalues
round(Borg/b.se.org,4) == round(tstat,4)
t = Borg/b.se.org
phat = 2*pt(-abs(t),df=dim(X)[1]-16)
rownames(phat) = colnames(X)
colnames(phat) = colnames(Y)
phat



# p svd
colnames(X)
t = B/b.se
psvd = 2*pt(-abs(t),df=dim(X)[1]-16)
rownames(psvd) = colnames(X)
psvd


# p transformed
b.se.hat=matrix(nrow=ncol(X),ncol=ncol(Y))
# estimate of sigma-squared
dSigmaSq <- colSums((Y - YHat)^2)/(nrow(X)-ncol(X))  
covmat = chol2inv(chol(t(X)%*%X))
# variance covariance matrix
for(i in 1:length(dSigmaSq)) {
  # variance covariance matrix
  mVarCovar <- dSigmaSq[i]*covmat
  # coeff. est. standard errors
  b.se.hat[,i] <- sqrt(diag(mVarCovar))
}

that = Bhat/b.se.hat
ptrans = 2*pt(-abs(that),df=dim(X)[1]-16)
tail(ptrans)
tail(phat)





#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################
