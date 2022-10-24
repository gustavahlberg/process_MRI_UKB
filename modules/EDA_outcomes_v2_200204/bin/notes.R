idx <- apply(voltab[,colnames(voltab[grep('rntrn',colnames(voltab))])[1:10]],1,is.na)
head(voltab[idx,])

voltab[,colnames(voltab[grep('ila',colnames(voltab))])]
voltab['1102188',]

Y=wheat.Y
X=scale(wheat.X)

SVD=svd(Y)
U=SVD$u
D=diag(SVD$d)
V=SVD$v



ETA=list(list(X=X,model='BayesB'))
for(i in 1:ncol(Y)){
  fm=BGLR(y=U[,i],ETA=ETA,verbose=F,burnIn=2000,nIter = 10000 ) #use more iterations!
  B[,i]=fm$ETA[[1]]$b
}

Borg=matrix(nrow=ncol(X),ncol=ncol(Y))
for(i in 1:ncol(Y)){
  fm=BGLR(y=Y[,i],ETA=ETA,verbose=F,burnIn=2000,nIter = 10000 ) #use more iterations!
  Borg[,i]=fm$ETA[[1]]$b
}



# Rotating coefficients to put them in marker space
BETA= B %*% D %*%t(V)

k <- ncol(U)-2
Bhat <- B[,1:k] %*% (D[1:k,1:k] %*% t(V[,1:k]))


# Prediction
YHat=X%*%BETA
YHat2=X%*%Bhat

i = 2
plot(Y[,i],YHat2[,i])
plot(Y[,i],YHat[,i])

resid <- Y - YHat 
sum(abs(Y[,i] - YHat[,i] ))
sum(abs(Y[,i] - YHat2[,i] ))

# correlation in training
for(i in 1:ncol(Y)){ print(cor(YHat[,i],YHat2[,i])) }



voltab[,colnames(voltab[grep('ila',colnames(voltab))])]
lapar = (laannon.filter[,-c(7,15)])
dd <- as.dist((1 - cor(lapar))/2)
round(1000 * dd) # (prints more nicely)
par(mfrow=c(1,2))
plot(hclust(dd)) # to see a dendrogram of clustered variables
fit <- cmdscale(dd,eig=TRUE, k=2)
plot(fit$points[,1],fit$points[,2], type = 'n')
text(fit$points[,1],fit$points[,2], labels = rownames(fit$points))

d = cor(lapar)
k = kmeans(d, 3,50)
plot(k$centers[2,],k$centers[1,], type = 'n')
text(k$centers[2,],k$centers[1,], labels = names(k$cluster))



