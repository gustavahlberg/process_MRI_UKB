#
#
# covarites
# 
# age, sex, weight, bmi, etc 
# bsa, PC1-10, batch, indexed measures
#
# ---------------------------------------------
#
# load data
#

h5ls(h5.fn)
sample.id = h5read(h5.fn,"sample.id")
colnames(sample.id) = "sample.id"


sampleFile = read.table("../../data/ukbCMR.ordered.etn_200219.sample",
                        stringsAsFactors = F,
                        header = T)


dim(voltab)
dim(sampleFile)


all(voltab$sample.id %in% as.character(sampleFile$ID_1))
sum(sampleFile$ID_1 %in% voltab$sample.id)
samplesCMR = voltab$sample.id


# ---------------------------------------------
#
# Imaging center
#

h5readAttributes(h5.fn,"f.54")
h5readAttributes(h5.fn,"f.54/f.54")[,3]
imgCenter = h5read(h5.fn,"f.54/f.54")[,3]
names(imgCenter) = sample.id[,1]
any(imgCenter[samplesCMR] == -9999)

all(voltab$sample.id == names(imgCenter[samplesCMR]))
voltab$imgCenter = as.factor(imgCenter[samplesCMR])



# ---------------------------------------------
#
# age
#

h5ls(h5.fn)
age = h5read(h5.fn,"f.21003/f.21003")[,3]
names(age) = sample.id[,1]
any(age[samplesCMR] == -9999)
age = age[samplesCMR]
hist(age)

all(voltab$sample.id == names(age))
voltab$age = age

# ---------------------------------------------
#
# sex
#

sex = h5read(h5.fn,"f.31/f.31")[,1]
sexGen = h5read(h5.fn,"f.22001/f.22001")[,1]

names(sex) = sample.id[,1]
any(sex[samplesCMR] == -9999)
sex = sex[samplesCMR]


all(voltab$sample.id == names(sex))
voltab$sex = sex
any(voltab$sample.id %in% names(sexMismatch))


# ---------------------------------------------
#
# height & weight
# Body Surface Area (BSA) (Dubois and Dubois) = 
# 0.007184 x (patient height in cm)0.725 x (patient weight in kg)0.425
#
# height
height =  h5read(h5.fn,"f.50/f.50")
rownames(height) = sample.id[,1]
height = height[samplesCMR,]
height.2 = height[,3]

height.2[which(height.2 == -9999)]  <- height[which(height.2 == -9999),][,1]
any(height.2 == -9999)

height = height.2
all(voltab$sample.id == names(height))
voltab$height = height

# weight
weight =  h5read(h5.fn,"f.21002/f.21002")
rownames(weight) = sample.id[,1]
weight = weight[samplesCMR,]
weight.2 = weight[,3]

weight.2[which(weight.2 == -9999)]  <- weight[which(weight.2 == -9999),][,1]
any(weight.2 == -9999)

weight = weight.2
all(voltab$sample.id == names(weight))
voltab$weight = weight

voltab$bsa =  0.007184*(voltab$height^0.725) * (voltab$weight^0.425)
voltab$bsa.2 =  sqrt(voltab$height*voltab$weight/3600)
voltab$bmi = voltab$weight/(voltab$height/100)^2

hist(voltab$bsa)

# ---------------------------------------------
#
# MI
#

h5readAttributes(h5.fn,"f.42001")
mi = h5read(h5.fn,"f.42001/f.42001")
rownames(mi) = sample.id[,1]
mi = mi[samplesCMR,]

mi = ifelse(mi == -9999 | mi == 0 ,0,1)
#mi = ifelse(mi == -9999  ,0,1)

all(voltab$sample.id == names(mi))
voltab$mi = mi
sum(voltab$mi == 1)


# ---------------------------------------------
#
# Pulse rate
#

h5readAttributes(h5.fn,"f.102")
h5readAttributes(h5.fn,"f.102/f.102")
PulseRate = h5read(h5.fn,"f.102/f.102")
rownames(PulseRate) = sample.id[,1]
PulseRate = PulseRate[samplesCMR,]
PulseRate.2 = ifelse(PulseRate[,c(5)] <=  PulseRate[,c(6)] & PulseRate[,c(5)] != -9999, 
                     PulseRate[,c(5)],  ifelse( PulseRate[,c(6)] == -9999, PulseRate[,c(5)],  PulseRate[,c(6)] ))
PulseRate.3 = PulseRate[PulseRate.2 == -9999,]
PulseRate.4 = ifelse(PulseRate.3[,c(1)] <=  PulseRate.3[,c(2)] & PulseRate.3[,c(1)] != -9999, 
                     PulseRate.3[,c(1)],  ifelse( PulseRate.3[,c(2)] == -9999, PulseRate.3[,c(1)],  PulseRate.3[,c(2)] ))

PulseRate.5 = PulseRate.3[PulseRate.4 == -9999,]
PulseRate.6 = ifelse(PulseRate.5[,c(3)] <=  PulseRate.5[,c(4)] & PulseRate.5[,c(4)] != -9999, 
                     PulseRate.5[,c(3)],  ifelse( PulseRate.5[,c(4)] == -9999, PulseRate.5[,c(3)],  PulseRate.5[,c(4)] ))
PulseRate.5[PulseRate.6 == -9999,]

#check
any(duplicated(c(names(PulseRate.2[PulseRate.2 != -9999]), names(PulseRate.4[PulseRate.4 != -9999]), names(PulseRate.6))))

PulseRate.2[names(PulseRate.4)] <- PulseRate.4
PulseRate.2[names(PulseRate.6)] <- PulseRate.6
PulseRate.2[PulseRate.2 == -9999] <- NA

all(voltab$sample.id == names(PulseRate.2))
voltab$pulseRate = PulseRate.2

# ---------------------------------------------
#
# diastolic BP
#

h5readAttributes(h5.fn,"f.4079")
h5readAttributes(h5.fn,"f.4079/f.4079")
dbp = h5read(h5.fn,"f.4079/f.4079")
rownames(dbp) = sample.id[,1]

dbp = dbp[samplesCMR,]
dbp.2 = ifelse(dbp[,c(5)] <=  dbp[,c(6)] & dbp[,c(5)] != -9999, 
               dbp[,c(5)],  ifelse( dbp[,c(6)] == -9999, dbp[,c(5)],  dbp[,c(6)] ))
dbp.3 = dbp[dbp.2 == -9999,]
dbp.4 = ifelse(dbp.3[,c(1)] <=  dbp.3[,c(2)] & dbp.3[,c(1)] != -9999, 
               dbp.3[,c(1)],  ifelse( dbp.3[,c(2)] == -9999, dbp.3[,c(1)],  dbp.3[,c(2)] ))

dbp.5 = dbp.3[dbp.4 == -9999,]
dbp.6 = ifelse(dbp.5[,c(3)] <=  dbp.5[,c(4)] & dbp.5[,c(4)] != -9999, 
               dbp.5[,c(3)],  ifelse( dbp.5[,c(4)] == -9999, dbp.5[,c(3)],  dbp.5[,c(4)] ))
dbp.5[dbp.6 == -9999,]

#check
any(duplicated(c(names(dbp.2[dbp.2 != -9999]), names(dbp.4[dbp.4 != -9999]), names(dbp.6))))
length(c(names(dbp.2[dbp.2 != -9999]), names(dbp.4[dbp.4 != -9999]), names(dbp.6)))

dbp.2[names(dbp.4)] <- dbp.4
dbp.2[names(dbp.6)] <- dbp.6
dbp.2[dbp.2 == -9999] <- NA

all(voltab$sample.id == names(dbp.2))
voltab$dbp = dbp.2
hist(voltab$dbp)

# ---------------------------------------------
#
# systolic BP
#

h5readAttributes(h5.fn,"f.4080")
h5readAttributes(h5.fn,"f.4080/f.4080")
sbp = h5read(h5.fn,"f.4080/f.4080")
rownames(sbp) = sample.id[,1]

sbp = sbp[samplesCMR,]
sbp.2 = ifelse(sbp[,c(5)] <=  sbp[,c(6)] & sbp[,c(5)] != -9999, 
               sbp[,c(5)],  ifelse( sbp[,c(6)] == -9999, sbp[,c(5)],  sbp[,c(6)] ))
sbp.3 = sbp[sbp.2 == -9999,]
sbp.4 = ifelse(sbp.3[,c(1)] <=  sbp.3[,c(2)] & sbp.3[,c(1)] != -9999, 
               sbp.3[,c(1)],  ifelse( sbp.3[,c(2)] == -9999, sbp.3[,c(1)],  sbp.3[,c(2)] ))

sbp.5 = sbp.3[sbp.4 == -9999,]
sbp.6 = ifelse(sbp.5[,c(3)] <=  sbp.5[,c(4)] & sbp.5[,c(4)] != -9999, 
               sbp.5[,c(3)],  ifelse( sbp.5[,c(4)] == -9999, sbp.5[,c(3)],  sbp.5[,c(4)] ))
sbp.5[sbp.6 == -9999,]

#check
any(duplicated(c(names(sbp.2[sbp.2 != -9999]), names(sbp.4[sbp.4 != -9999]), names(sbp.6))))
length(c(names(sbp.2[sbp.2 != -9999]), names(sbp.4[sbp.4 != -9999]), names(sbp.6)))

sbp.2[names(sbp.4)] <- sbp.4
sbp.2[names(sbp.6)] <- sbp.6
sbp.2[sbp.2 == -9999] <- NA

all(voltab$sample.id == names(sbp.2))
voltab$sbp = sbp.2
hist(voltab$sbp)


# ---------------------------------------------
#
# HF
#

source("bin/defHF.R")
sum(rowSums(CMpheno[,-1]) >= 1)
sum(rowSums(HFpheno[,-1]) >= 1)

cm = ifelse(rowSums(CMpheno[,-1]) >= 1,1,0)
hf = ifelse(rowSums(HFpheno[,-1]) >= 1,1,0)

all(voltab$sample.id == CMpheno$sample.id) ; all(voltab$sample.id == HFpheno$sample.id)
voltab$cm = cm
voltab$hf = hf
voltab$hf_cm = ifelse(hf == 1 | cm == 1, 1,0)
sum(voltab$hf_cm )


# ---------------------------------------------
#
# ventricular volumes
#


source("bin/ventricularVolumes.R")


# ---------------------------------------------
#
# AF
#


source("bin/defAF.R")
sum(rowSums(AFpheno[,-1]) >= 1)


af = ifelse(rowSums(AFpheno[,-1]) >= 1,1,0)

all(voltab$sample.id == AFpheno$sample.id) 
voltab$af = af

sum(voltab$af)

# ---------------------------------------------
#
# Stroke
#

h5readAttributes(h5.fn,"f.42007")
stroke = h5read(h5.fn,"f.42007/f.42007")
rownames(stroke) = sample.id[,1]
stroke = stroke[samplesCMR,]
stroke = ifelse(stroke == -9999  ,0,1)

all(voltab$sample.id == names(stroke))
voltab$stroke = stroke
sum(voltab$stroke)

# ---------------------------------------------
#
# PC1-10 & batch
#

c("array",paste0("PC",1:10))
pcTab = qcTab[,c("sample.id","genotyping.array",paste0("PC",1:10))]

pcTab = pcTab[pcTab$sample.id %in% voltab$sample.id,]
pcTab = pcTab[match(voltab$sample.id,pcTab$sample.id),]
all(pcTab$sample.id == voltab$sample.id)

voltab = cbind(voltab,pcTab[,-1])
table(voltab$genotyping.array)


# ---------------------------------------------
#
# Cognitive function
#

h5readAttributes(h5.fn,"f.4282")
h5readAttributes(h5.fn,"f.4282/f.4282")
numeric = h5read(h5.fn,"f.4282/f.4282")
rownames(numeric) = sample.id[,1]
numeric = numeric[samplesCMR,]
numeric[numeric == -9999] <- NA
numeric = rowMeans(numeric,na.rm = T)
numeric[numeric == 'NaN'] <- NA
numeric[numeric == -1] <- NA


h5readAttributes(h5.fn,"f.20023")
reactionTime = h5read(h5.fn,"f.20023/f.20023")
rownames(reactionTime) = sample.id[,1]
reactionTime = reactionTime[samplesCMR,]
reactionTime[reactionTime == -9999] <- NA
reactionTime = rowMeans(reactionTime,na.rm = T)
reactionTime[reactionTime == 'NaN'] <- NA


h5readAttributes(h5.fn,"f.20016")
h5readAttributes(h5.fn,"f.20016/f.20016")
fluidInt = h5read(h5.fn,"f.20016/f.20016")
rownames(fluidInt) = sample.id[,1]
fluidInt = fluidInt[samplesCMR,]
fluidInt[fluidInt == -9999] <- NA
fluidInt = rowMeans(fluidInt,na.rm = T)
fluidInt[fluidInt == 'NaN'] <- NA



h5readAttributes(h5.fn,"f.399")
h5readAttributes(h5.fn,"f.399/f.399")
pairsMatching = h5read(h5.fn,"f.399/f.399")
rownames(pairsMatching) = sample.id[,1]
pairsMatching = pairsMatching[samplesCMR,]
pairsMatching[pairsMatching == -9999] <- NA
pairsMatching = rowMeans(pairsMatching[,c(2,5,8,11)],na.rm = T)
hist(pairsMatching)
pairsMatching[pairsMatching == 'NaN'] <- NA


h5readAttributes(h5.fn,"f.20018")
h5readAttributes(h5.fn,"f.20018/f.20018")
prospectiveMemory = h5read(h5.fn,"f.20018/f.20018")
rownames(prospectiveMemory) = sample.id[,1]
prospectiveMemory = prospectiveMemory[samplesCMR,]
prospectiveMemory[prospectiveMemory == -9999] <- NA
prospectiveMemory = apply(prospectiveMemory,1 , function(x){
  if(all(is.na(x))) {
    return(NA)
  } else{
    idx  = which(!is.na(x))
    return(x[idx[which.max(idx)]])
  }
})



h5readAttributes(h5.fn,"f.6348")
h5readAttributes(h5.fn,"f.6348/f.6348")
trailMakingNum = h5read(h5.fn,"f.6348/f.6348")
rownames(trailMakingNum) = sample.id[,1]
trailMakingNum = trailMakingNum[samplesCMR,]
trailMakingNum[trailMakingNum == -9999] <- NA
trailMakingNum = rowMeans(trailMakingNum, na.rm = T)
trailMakingNum[trailMakingNum == 'NaN'] <- NA
trailMakingNum[trailMakingNum == 0] <- NA

h5readAttributes(h5.fn,"f.6350")
trailMakingAlphaNum = h5read(h5.fn,"f.6350/f.6350")
rownames(trailMakingAlphaNum) = sample.id[,1]
trailMakingAlphaNum = trailMakingAlphaNum[samplesCMR,]
trailMakingAlphaNum[trailMakingAlphaNum == -9999] <- NA
trailMakingAlphaNum = rowMeans(trailMakingAlphaNum, na.rm = T)
trailMakingAlphaNum[trailMakingAlphaNum == 'NaN'] <- NA
trailMakingAlphaNum[trailMakingAlphaNum == 0] <- NA


summary(glm(voltab$stroke ~ trailMakingAlphaNum, family = binomial()))
summary(glm(voltab$af ~ trailMakingNum + voltab$age , family = binomial()))
summary(glm(voltab$af ~ reactionTime + voltab$age , family = binomial()))
summary(glm(voltab$stroke ~ fluidInt + voltab$age , family = binomial()))



cogDf = data.frame(
  trailMakingAlphaNum,
  trailMakingNum,
  pairsMatching,
  fluidInt,
  reactionTime,
  numeric)


colSums(apply(cogDf,2,is.na))
cor(ifelse(apply(cogDf,2,is.na), 2,1))

# all cog var
dim(cogDf[which(rowSums(is.na(cogDf)) <= 0),])
cogAllDf <- cogDf[which(rowSums(is.na(cogDf)) <= 0),]
cor(cogAllDf)
s = svd(t(cogAllDf))
round(sqrt(2) * s$u , 3)
str(s)
PC1 = s$d[1]*s$v[,1]
PC2 = s$d[2]*s$v[,2]
plot(PC1,PC2)
plot(s$d^2/sum(s$d^2)*100,ylab="Percent variability explained")

voltab$svdAllCogVar = NA
voltab[rownames(cogAllDf),]$svdAllCogVar <- s$v[,1] 
 

# trail + numeric
dim(cogDf[which(rowSums(is.na(cogDf[,c(1,2,5)])) <= 0),c(1,2,5)])
cogTrailDf <- cogDf[which(rowSums(is.na(cogDf[,c(1,2,5)])) <= 0), c(1,2,5)]
s = svd(t(cogTrailDf))
PC1 = s$d[1]*s$v[,1] ;PC2 = s$d[2]*s$v[,2]
plot(PC1,PC2)
plot(s$d^2/sum(s$d^2)*100,ylab="Percent variability explained")

voltab$svdTrailCog = NA
voltab[rownames(cogTrailDf),]$svdTrailCog <- s$v[,1] 


 


#######################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#######################################################

s = svd(t(scale(cbind(voltab$lapef,voltab$lapev/voltab$bsa))))
voltab$lape_svd = s$v[,1]

var = scale(s$v[,1])
var = scale(voltab$lapef)
tmp = scale(voltab$lamin*voltab$laaef)
summary(glm(voltab$stroke ~  voltab$af + voltab$dbp + voltab$sbp + voltab$imgCenter +
              var  + voltab$bmi + voltab$age + voltab$sex  , family = binomial()))


summary(glm(voltab$stroke ~  voltab$af + voltab$dbp + voltab$sbp + tmp + voltab$bmi + voltab$imgCenter +
              var + voltab$bsa + voltab$age + voltab$sex  , family = binomial()))

summary(glm(voltab$stroke ~  voltab$af + voltab$dbp + voltab$sbp + 
              scale(var)  + voltab$height + voltab$age + voltab$sex + voltab$weight , family = binomial()))


fit = glm(voltab$stroke ~  voltab$af + voltab$dbp + voltab$sbp + voltab$height + 
      scale(var) + voltab$bmi + voltab$age + voltab$sex  , family = binomial())
vif(fit)

summary(lm(voltab$lamin ~  voltab$age + voltab$sex))
summary(lm(voltab$lamin/voltab$bsa ~  voltab$age + voltab$sex))
summary(lm(voltab$lamin ~ voltab$bsa+ voltab$age + voltab$sex))

summary(lm(scale(voltab$svdAllCogVar) ~ scale(var) +voltab$lamin + voltab$af + voltab$bsa  + poly(voltab$age,2) + voltab$sex +
             voltab$dbp + voltab$sbp + voltab$height + voltab$bmi))


summary(glm(voltab$stroke ~  scale(var) + voltab$bsa + voltab$age + voltab$sex  , family = binomial()))

colnames(x[,names(which(coef(cvfit, s = "lambda.min")[,1] != 0))[-c(1,9)]])
summary(glm(voltab$af ~ scale(var) + voltab$sex + voltab$age + voltab$height +
              voltab$hf_cm +  voltab$bmi, 
            family = binomial()))


fit = lm(voltab$height ~ var)
summary(fit)
plot(fit)




summary(glm(voltab$stroke ~ scale(voltab$lapef) + voltab$lamdv  + voltab$age + voltab$sex,
            family = binomial()))

summary(glm(voltab$af ~ voltab$laaef:voltab$aeTangent + voltab$laaef*voltab$lamin +
              voltab$age + voltab$sex + voltab$bmi + voltab$bsa,
            family = binomial()))


plot(voltab$lamin, voltab$latef)



summary(glm(voltab$af ~ voltab$laaef*voltab$lamin +
              voltab$age + voltab$sex + voltab$bmi + voltab$bsa  ,
            family = binomial()))



summary(glm(voltab$af ~ voltab$latef*voltab$lamin + voltab$age + voltab$sex,
            family = binomial()))


summary(lm(voltab$af ~ voltab$latef*voltab$lamin  + voltab$age + voltab$sex))
summary(lm(voltab$lapef ~ var  + voltab$age + voltab$sex))

summary(lm(voltab$lapef ~ voltab$stroke  + voltab$age + voltab$sex))
summary(lm(voltab$lapef ~ voltab$  + voltab$age + voltab$sex))



summary(glm(voltab$stroke ~ voltab$laaef*voltab$lamin +
              voltab$age + voltab$sex + voltab$bmi + voltab$bsa  ,
            family = binomial()))

summary(glm(voltab$stroke ~ scale(voltab$lapef)  +
              voltab$age + voltab$sex + voltab$bsa  + voltab$bmi,
            family = binomial()))

tmp = voltab$lamin/voltab$bsa

summary(glm(voltab$stroke ~ scale(voltab$lapef)  + voltab$af + 
              voltab$age + voltab$sex  + scale(voltab$bmi) + scale(voltab$bsa),
            family = binomial()))


plot(voltab$lapev, voltab$laev )
cor(voltab$lapev, voltab$laev )
plot(voltab$lapev/voltab$lamin,voltab$laev/voltab$lamin)
cor(voltab$lapev/voltab$lamin,voltab$laev/voltab$lamin)
cor(voltab$lapef/voltab$lamin,voltab$laaef/voltab$lamin)
plot(voltab$lapef/voltab$lamin,voltab$laaef/voltab$lamin)

cor(voltab$lapef,tmp)

totvol = voltab$lapev + voltab$laev

hist(voltab$lapev/totvol)
var = voltab$lapev/totvol

plot(voltab$lapef, voltab$lamdv)
plot(voltab$laaef, voltab$lamin)

plot(voltab$lapef, scale(voltab$lamin*voltab$laaef))
hist(voltab$lamin/(voltab$labac))

hist((voltab$labac - voltab$lamin)*(voltab$lamin/voltab$labac))
plot(voltab$laaef,(voltab$labac - voltab$lamin)/(voltab$lamin))
plot(voltab$laaef,(voltab$labac - voltab$lamin)/(voltab$lamin))


hist((1- (voltab$lamin/voltab$labac))*(voltab$lamin))
cor((1 - (voltab$lamin/voltab$labac))*(voltab$lamin), (voltab$lamin/voltab$labac)*(voltab$lamin))
hist(1-(voltab$lamin/voltab$labac))
cor((1-(voltab$lamin/voltab$labac))*(voltab$lamin), voltab$labac-voltab$lamin)

plot(voltab$laev,voltab$lamin/voltab$labac)
plot(voltab$laaef/100, voltab$lamin/voltab$labac)

tmp = (voltab$lamax - (voltab$lamdv))/voltab$lamax
(1 - (voltab$lamin)/voltab$labac)
(1 - (voltab$lamin)/voltab$labac)

tmp = voltab$lamin*(1 - (voltab$lamin)/voltab$labac)
hist(var)



summary(glm(voltab$stroke ~   voltab$af + scale(voltab$lapef) + voltab$lamin:voltab$laaef + 
              voltab$age + voltab$sex + scale(voltab$bmi) ,
            family = binomial()))

tmp = scale(voltab$lamin*voltab$laaef/voltab$bsa)
summary(glm(voltab$stroke ~   voltab$af + scale(voltab$lapef) + 
              scale(voltab$age) + voltab$sex + scale(voltab$bmi) + tmp,
            family = binomial()))



tmp = scale(voltab$lamin/voltab$laaef)
hist(tmp)
#tmp = voltab$lamin
plot(tmp, voltab$lapef)
cor(tmp, voltab$lapef)


plot(voltab$lapef, voltab$lamdv)
cor(voltab$lapef, voltab$lamdv)
plot(voltab$laaef, voltab$lamin, pch = 19, col =col.alpha("blue", alpha = 0.05))
#points(voltab$lapef, voltab$lamin, pch = 19, col =col.alpha("blue", alpha = 0.02))
trns = 1/voltab$laaef

fit = lm(lamin ~ trns + sex + age + lapef, data = voltab)
summary(fit)
newdata <- data.frame(trns=1/seq(min(voltab$laaef), max(voltab$laaef), .01),
                      age = mean(voltab$age), sex = 1, lapef = mean(voltab$lapef) - 2*sd(voltab$lapef))
pred = predict(object = fit, newdata = newdata, se.fit = T)
lines(x = seq(min(voltab$laaef), max(voltab$laaef), .01), y = pred$fit, col = 'red')


hist(voltab$lamin/voltab$labac)
plot(voltab$lapef,(voltab$labac - voltab$lamin)*(voltab$lamin/voltab$labac))
s = svd(t(cbind(voltab$lapef,(voltab$labac - voltab$lamin)*(voltab$lamin/voltab$labac))))

(scale(s$v[,1]))

(voltab$labac - voltab$lamin)/voltab$labac
1 - voltab$lamin/voltab$labac
voltab$lamin*(1 - voltab$lamin/voltab$labac)
voltab$lamin*(voltab$labac/voltab$labac - voltab$lamin/voltab$labac)
tmp = (voltab$labac - voltab$lamin)*(voltab$lamin/voltab$labac)
plot(voltab$lamin,voltab$lamin/voltab$labac)
plot(voltab$lamin,(1-voltab$lamin/voltab$labac))
plot(log(voltab$lamin),voltab$lamin/voltab$labac*voltab$lamin)
cor(voltab$lamin,(voltab$lamin/voltab$labac)*voltab$lamin)
cor(voltab$lamin,(1-voltab$lamin/voltab$labac)*voltab$lamin)
plot(voltab$lamin,(1-(voltab$lamin/voltab$labac))*voltab$lamin)

cor(voltab$laaef, voltab$lapef)
cor(voltab$lamin, voltab$lapef)

summary(glm(voltab$stroke ~   voltab$af + var + voltab$bsa + tmp + 
              voltab$age + voltab$sex  + scale(voltab$bmi),
            family = binomial()))

summary(glm(voltab$stroke ~ scale(voltab$lapef) + 
            voltab$age + voltab$sex + voltab$height + voltab$weight,
            family = binomial()))

summary(glm(voltab$stroke ~ scale(voltab$lapef) +
              voltab$age + voltab$sex + voltab$bmi, data = voltab,
            subset = !(voltab$bmi > 40 | voltab$bmi < 16 | voltab$hf_cm == 1 | voltab$mi == 1),
            family = binomial()))


summary(glm(voltab$stroke ~ scale(voltab$lapef) + voltab$af +  voltab$laaef:voltab$lamin +
              voltab$age + voltab$sex + voltab$bmi, data = voltab,
            subset = !(voltab$bmi > 40 | voltab$bmi < 16 | voltab$hf_cm == 1 | voltab$mi == 1),
            family = binomial()))

summary(logistf(voltab$stroke ~ scale(voltab$lape_svd) + voltab$af +  voltab$laaef:voltab$lamin +
              voltab$age + voltab$sex + voltab$weight + voltab$height, data = voltab,
            subset = !(voltab$bmi > 40 | voltab$bmi < 16 | voltab$hf_cm == 1 | voltab$mi == 1),
            family = binomial()))


summary(glm(voltab$stroke ~ scale(voltab$lapef) + voltab$af +  voltab$laaef:voltab$lamin +
              voltab$age + voltab$sex + voltab$weight + voltab$height, data = voltab,
            family = binomial()))


summary(logistf(voltab$stroke ~ scale(voltab$lapef) + voltab$af +
              voltab$age + voltab$sex + voltab$bsa, data = voltab,
            family = binomial()))





summary(glm(voltab$stroke ~voltab$af +
              voltab$age + voltab$sex , data = voltab,
            family = binomial()))



summary(glm(voltab$af ~ voltab$dbp + voltab$sbp + voltab$imgCenter + voltab$lamin +
              + voltab$bsa + voltab$age + voltab$sex  , family = binomial()))

var = voltab$lamin
fit1 = glm(voltab$af ~ voltab$dbp + voltab$sbp + voltab$imgCenter + var + voltab$bsa +
            voltab$age + voltab$sex  , family = binomial())

var = voltab$lamin/voltab$bsa
fit2 = glm(voltab$af ~ voltab$dbp + voltab$sbp + voltab$imgCenter + var + 
             voltab$age + voltab$sex  , family = binomial())


summary(fit1)
summary(fit2)
AIC(fit1); AIC(fit2)
anova(fit1, fit2, test ="Chisq")


library(pscl)
varImp(fit1); pR2(fit1)
varImp(fit2); pR2(fit2)


summary(lm(voltab$lamin ~ voltab$dbp + voltab$sbp + voltab$imgCenter +
             voltab$age + voltab$sex))
summary(lm(voltab$lamin/voltab$bsa ~ voltab$dbp + voltab$sbp + voltab$imgCenter +
             voltab$age + voltab$sex))

summary(lm(voltab$lamin ~ voltab$dbp + voltab$sbp + voltab$imgCenter + voltab$bsa +
             voltab$age + voltab$sex))
summary(lm(voltab$lamin/voltab$bsa ~ voltab$dbp + voltab$sbp + voltab$imgCenter +
             voltab$age + voltab$sex ))








