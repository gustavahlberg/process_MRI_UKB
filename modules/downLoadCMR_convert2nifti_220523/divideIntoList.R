#
# "Divinding samples to lists for download (using epoch.bulk list)"
# 

tab <- read.table("ukb_CMR_la_sa_ao.epoch.220628.bulk",
                 stringsAsFactors = F,
                 header = F)


# 1st imaging visit
firstVisit <- tab[grep("2_0",tab$V2),]
sample.id <- unique(firstVisit[,1])

N_list <- ceiling(length(sample.id)/1000)


listTab <- split(sample.id, cut( 1:length(sample.id), N_list, labels = 1:N_list))

dataDir <- "/home/projects/cu_10039/projects/process_MRI_UKB/data/imgVisit/"

for(i in seq(length(listTab))) {

    makedir <- paste0(dataDir,names(listTab)[i])
    dir.create(makedir,showWarnings = F)
    out.fn <- paste0(makedir,"/ukbb_CMR_",names(listTab)[i],".bulk")
    
    write.table(listTab[[i]],
                file = out.fn,
                quote = F,
                col.names = F,
                row.names = F
                )
}


# 2nd imaging visit
secondVisit <- tab[grep("3_0",tab$V2),]
sample.id <- unique(secondVisit[,1])

N_list <- ceiling(length(sample.id)/1000)


listTab <- split(sample.id, cut(1:length(sample.id), N_list, labels = 1:N_list))

dataDir <- "/home/projects/cu_10039/projects/process_MRI_UKB/data/repImgVisit/"

for(i in seq(length(listTab))) {

    makedir <- paste0(dataDir,names(listTab)[i])
    dir.create(makedir,showWarnings = F)
    out.fn <- paste0(makedir,"/ukbb_CMR_",names(listTab)[i],".bulk")
    
    write.table(listTab[[i]],
                file = out.fn,
                quote = F,
                col.names = F,
                row.names = F
                )
}



######### EOF ########################
