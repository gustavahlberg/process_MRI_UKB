la_tab = read.csv("results/33/table_atrial_volume.csv",
                  stringsAsFactors = F)

#la_tab = la_tab[sample(dim(la_tab)[1], size = 200, replace = F),]

HR  = la_tab[,2]
names(HR) = la_tab[,1]
hist(HR)


rownames(la_tab) = la_tab[,1]
la_tab = as.matrix(la_tab[,-c(1,2)])
la_tab[names(which(HR > 0)),]

idxCheck = which(rownames(la_tab) %in% rownames(laAnnotations[laAnnotations$laaef > 90,]))

# lavolumes = matrix(NA, nrow = nrow(la_tab), ncol = 4,
#                    dimnames = list(row.names(la_tab), 
#                                    c("lamax","lamin","lamdv","labac")))

plot(la_tab[1,], type = 'n',
     ylim = c(0, 120))

#for(i in 1:dim(la_tab)[1]) {
for(i in idxCheck) {
  print(i)
  print(paste("HR:",HR[i]))
  # plot(as.vector(la_tab[names(which(HR < 90)),][i,]), type = 'l',
  #      ylim = c(0, 120))
  #lines(as.vector(la_tab[names(which(HR < 90)),][i,]))
  #i = 11
  x = la_tab[i,]
  names(x) = 1:50
  lavmax = max(x)
  lavmin = min(x)
  minmax = local.min.max(x)
  
  idxMax = which.max(x)
  idxMin = which.min(x)
  
  xdelta = diff(x)
  #xdelta = diff(smth.gaussian(x,tails = T))
  xdelta = xdelta[as.numeric(names(xdelta)) >= idxMax]
  #local.min.max(xdelta)
  xdeltaSort = sort(xdelta)
  
  
  # get slope interval 1
  flagSlope = T
  intUp = 0
  intDwn = 0
  while(flagSlope) {
    intUpPrev = intUp
    intDwnPrev = intDwn
    
    if(as.numeric(names(xdelta[length(xdelta)])) > (as.numeric(names(xdeltaSort[1])) + intUp)) {
      if(xdelta[ as.character(as.numeric(names(xdeltaSort[1])) + intUp)] < 0) {
        intUp = intUp + 1
      }
    }
    
    if(as.numeric(names(xdelta[1])) < (as.numeric(names(xdeltaSort[1])) + intDwn)) {
      if(xdelta[as.character(as.numeric(names(xdeltaSort[1])) + intDwn)] < 0) {
        intDwn = intDwn - 1
      }
    }
    
    if(intUpPrev == intUp & intDwnPrev == intDwn) {
      flagSlope = F
    }
  }
  
  
  idxdelta <-  as.numeric(names(xdeltaSort))
  
  drops = c(xdeltaSort[1],
            xdeltaSort[as.character(
              idxdelta[!(
              idxdelta >= (idxdelta[1] + intDwn -1 ) 
              & idxdelta <= (idxdelta[1] + intUp +1  ) )]
              )
              ][1]
            )
  
  names(drops) = as.numeric(names(drops)) -1
  idxdrops = sort(as.numeric(names(drops)))
  
  x.smth = smth(x,tails = T)
  names(x.smth) = 1:50
  minmaxsmth = local.min.max(x.smth)
  minsmth = minmaxsmth$minima
  maxsmth = minmaxsmth$maxima
  

  maxima = minmax$maxima[which(idxdrops[1] <= as.numeric(names(minmax$maxima)) & 
                                 idxdrops[2] >= as.numeric(names(minmax$maxima)))]
  
  if(length(maxima) == 0) {
    print(paste("could not determine:", rownames(la_tab)[i]))
    local.min.max(x)
    Sys.sleep(5)
    next
  }
  
  if(names(maxima) == idxMax) {
    maxima = maxima[-which(names(maxima) == idxMax)]
  }
  minima = minmax$minima[which(idxdrops[1] <= as.numeric(names(minmax$minima)) & 
                                 idxdrops[2] >= as.numeric(names(minmax$minima)))]
  
  minsmth = minsmth[as.numeric(names(minsmth)) >= idxdrops[1] &
                      as.numeric(names(minsmth)) <= idxdrops[2]]
  
  maxsmth = maxsmth[as.numeric(names(maxsmth)) >= idxdrops[1] &
                      as.numeric(names(maxsmth)) <= idxdrops[2]]
  
  
  
  if (!(length(minsmth) == 0  | length(maxsmth) == 0)) {
    fmin = as.numeric(names(minsmth[which.min(abs(as.numeric(names(minsmth)) - idxdrops[which.min(idxdrops)]))])) -2
    fmax = as.numeric(names(maxsmth[which.min(abs(as.numeric(names(maxsmth)) - idxdrops[which.max(idxdrops)]))])) + 2
     
    maxima = maxima[which(fmin <= as.numeric(names(maxima)) & 
                          fmax >= as.numeric(names(maxima)))]
    minima = minima[which(fmin <= as.numeric(names(minima)) & 
                          fmax >= as.numeric(names(minima)))]
  }
  
  if(length(minima) == 0 | length(maxima) == 0 ) {
    print(paste("could not determine:", rownames(la_tab)[i]))
    local.min.max(x)
    Sys.sleep(5)
    next
  }
  
  flag = T
  flag2 = "go"
  while(flag) {
    #bac
    bac = maxima[which.max(maxima)]
    idxbac = as.numeric(names(bac))
  
    #mdv 
    mdv = minima[which.min(minima)]
    idxmdv = as.numeric(names(mdv))
    
    if(identical(idxmdv > idxbac,logical(0))) {
      flag = F
      flag2 = "break"
      next
    }
    
    if(idxmdv > idxbac) {
      if(length(minima) <= 1 & length(maxima) <= 1) {
        flag = F
        flag2 = "break"
        next
      } 
    }

    if(idxmdv > idxbac) {
      closerTo2ndDrop_mdv = abs(idxmdv - idxdrops[which.max(idxdrops)]) < abs(idxmdv - idxdrops[which.min(idxdrops)])
      closerTo2ndDrop_bac = abs(idxbac - idxdrops[which.max(idxdrops)]) < abs(idxbac - idxdrops[which.min(idxdrops)])
      
      if(closerTo2ndDrop_mdv & closerTo2ndDrop_bac) {
        if(length(minima) > 1 ) {
          minima = minima[-which(names(minima) == as.character(idxmdv))]
        } else if(length(maxima) > 1) {
          maxima = maxima[-which(names(maxima) == as.character(idxbac))]
        }
      } else{
        if(length(maxima) > 1 ) {
          maxima = maxima[-which(names(maxima) == as.character(idxbac))]
        } else if(length(minima) > 1) {
          minima = minima[-which(names(minima) == as.character(idxmdv))]
        }
      }
    } else{
      flag = F
    }

  } # end while loop
  
  if(flag2 == "break") {
    print(paste("could not determine:", rownames(la_tab)[i]))
    local.min.max(x)
    Sys.sleep(5)
    next
  } 
  
  
  # peTangent
  peTangent = drops[which.min(as.numeric(names(drops)))]
  
  # aeTangent
  aeTangent = drops[which.max(as.numeric(names(drops)))]
  minmax = local.min.max(x)
  points(idxMax,x[idxMax],pch = 14)
  points(idxMin,x[idxMin],pch = 14)
  points(idxmdv,x[idxmdv],pch = 14)
  points(idxbac,x[idxbac],pch = 15)
  points(as.numeric(names(aeTangent))+1,x[as.numeric(names(aeTangent))+1],pch = 19)
  points(as.numeric(names(peTangent)),x[as.numeric(names(peTangent))],pch = 19)
  
  print(paste0("drop: ", aeTangent))
  Sys.sleep(3)  
  
  #lavolumes[i,] = c(lavmax, lavmin, mdv, bac)
}


lavolumes = data.frame(lavolumes, stringsAsFactors = F)
hist(lavolumes$labac, breaks = 30)
hist(lavolumes$lamdv, breaks = 30)
hist(lavolumes$lamin, breaks = 30)
hist(lavolumes$lamax, breaks = 30)
