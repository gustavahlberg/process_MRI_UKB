
str(svd(la_tab))

s2 = svd(laAnnotations[,-5])
s2 = svd(la_tab[rownames(laAnnotations),])
s = svd(t(la_tab[rownames(laAnnotations),]))

str(s)
U <- s$u
V <- s$v
D <- diag(s$d) 

Yhat <- U %*% D %*% t(V)
resid <- la_tab - Yhat
max(abs(resid))
1-sum(s$d[1]^2)/sum(s$d^2)
plot(s$d)

plot(s$d^2/sum(s$d^2)*100,ylab="Percent variability explained")

hist(PC1)
hist(s$u[,1])
plot(s$u[,1],s$u[,2])

laAnnotations[which(s$u[,1] < -0.04 & s$u[,2] < 0 ),]

plot(laAnnotations$lamax[-which(s$u[,1] > -0.02 )], 
     laAnnotations$lamin[-which(s$u[,1] > -0.02 )])

points(laAnnotations$lamax[which(s$u[,1] > -0.02 )], 
     laAnnotations$lamin[which(s$u[,1] > -0.02 )], cols = 'red')


points(laAnnotations$lamax[which(s$u[,1] < -0.04 & s$u[,2] < 0 )], 
     laAnnotations$lamin[which(s$u[,1] < -0.04 & s$u[,2] < 0 )], col = 'red')


plot(s$u[,1][-which(s$u[,1] < -0.04 & s$u[,2] < 0 )], 
     s$u[,2][-which(s$u[,1] < -0.04 & s$u[,2] < 0 )])

points(s$u[,1][which(s$u[,1] < -0.04 & s$u[,2] < 0 )], 
       s$u[,2][which(s$u[,1] < -0.04 & s$u[,2] < 0 )], col = 'red')

la_tab[which(s$u[,1] < -0.04 & s$u[,2] < 0 ),]


plot(la_tab['2697969',],type = 'l' )

PC1 = s$d[1]*s$v[,1]
PC2 = s$d[2]*s$v[,2]
plot(s$d)
plot(PC1, PC2)

cor(PC1,s$u[1,])

pca = prcomp(laAnnotations, scale. = T, center = T)
summary(pca)

plot(pca$x[,1], pca$x[,2])
str(pca)
hist(pca$x[,1])

plot()

cor(cbind(laAnnotations,PC1))

cor(PC1, s2$u[,1])
