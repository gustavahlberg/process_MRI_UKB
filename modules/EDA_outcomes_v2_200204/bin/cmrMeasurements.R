#
#
# CMR predicted measurements.
# 
#
# ---------------------------------------------
#
# load data
#


laannon = read.table("../../modules/extrct_atrialVol_200106/results/table_atrial_annotations_all.csv",
                   header = T,
                   stringsAsFactors = F,
                   sep = "\t")

dim(laannon)
sum(laannon$sample.id %in% qcTab$sample.id)


hist(laannon$latef)
hist(log(laannon$lamin), breaks = 30)
summary(laannon$lamin)
quantile(na.omit(laannon$lamin), probs = c(0.01, 0.99))
quantile(na.omit(laannon$lamax), probs = c(0.01, 0.99))

hist(laannon$lamin[laannon$latef > 90 ])
hist(laannon$aeTangent)
hist(laannon$lamin[laannon$aeTangent <  -20])

quantile(na.omit(laannon$peTangent), probs = c(0.01, 0.99))
hist(laannon$lamin[laannon$peTangent < -40 ])
hist(laannon$peTangent)
summary(laannon$peTangent)
sum(laannon$peTangent >= 0)

plot(laannon$latef,laannon$laaef)
plot(laannon$latef,laannon$lamin)
plot(laannon$laaef,laannon$lamin)

# ---------------------------------------------
#
# intial remove
#

laannon.filter = laannon[-which(laannon$latef > 90),]
laannon.filter = laannon.filter[-which(laannon.filter$lamin < 5),]
laannon.filter = laannon.filter[which(laannon.filter$aeTangent < 0),]
laannon.filter = laannon.filter[which(laannon.filter$peTangent < 0),]


# ---------------------------------------------
#
# remove 1% percentile
#

lower = 0.005
upper = 0.995

dim(laannon.filter)
head(laannon)
lamaxRange = quantile(na.omit(laannon.filter$lamax), probs = c(lower, upper))
laminRange = quantile(na.omit(laannon.filter$lamin), probs = c(lower, upper))
latefRange = quantile(na.omit(laannon.filter$latef), probs = c(lower, upper))
laexpRange = quantile(na.omit(laannon.filter$expansionidx), probs = c(lower, upper))
laaefRange = quantile(na.omit(laannon.filter$laaef), probs = c(lower, upper))
lapefRange = quantile(na.omit(laannon.filter$lapef), probs = c(lower, upper))
laAetangent = quantile(na.omit(laannon.filter$aeTangent), probs = c(lower, upper))
laPetangent = quantile(na.omit(laannon.filter$aeTangent), probs = c(lower, upper))


laannon.filter = laannon.filter[which(laannon.filter$lamax > lamaxRange[1] & 
                                      laannon.filter$lamax < lamaxRange[2]),]
laannon.filter = laannon.filter[which(laannon.filter$lamin > laminRange[1] & 
                                        laannon.filter$lamin < laminRange[2]),]
laannon.filter = laannon.filter[which(laannon.filter$latef > latefRange[1] & 
                                        laannon.filter$latef < latefRange[2]),]
laannon.filter = laannon.filter[which(laannon.filter$expansionidx > laexpRange[1] & 
                                        laannon.filter$expansionidx < laexpRange[2]),]
laannon.filter = laannon.filter[which(laannon.filter$laaef > laaefRange[1] & 
                                        laannon.filter$laaef < laaefRange[2]),]
laannon.filter = laannon.filter[which(laannon.filter$lapef > lapefRange[1] & 
                                        laannon.filter$lapef < lapefRange[2]),]

# laannon.filter = laannon.filter[which(laannon.filter$aeTangent > laAetangent[1] & 
#                                         laannon.filter$aeTangent < laAetangent[2]),]
# laannon.filter = laannon.filter[which(laannon.filter$peTangent > laPetangent[1] & 
#                                          laannon.filter$peTangent < laPetangent[2]),]



var = laannon.filter$aeTangent
hist(var); summary(var)


dim(laannon.filter)
length(laannon.filter$sample.id) - sum(laannon.filter$sample.id %in% qcTab$sample.id)

cor(laannon.filter)

# ---------------------------------------------
#
# subset to unrelated ethnic matched
#

sum(laannon.filter$sample.id %in% sample.eth.id)
#sum(laannon.filter$sample.id %in% sample.unrel.eth.id)
#voltab = laannon.filter[which(laannon.filter$sample.id %in% sample.unrel.eth.id),]
voltab = laannon.filter[which(laannon.filter$sample.id %in% sample.eth.id),]
voltab$sample.id = as.character(voltab$sample.id)
dim(voltab)

#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################






