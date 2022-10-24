#
# "adding new  samples to lists for download (subtracting epoch.bulk list)"
# 
# ----------------------------------------------------

args <- commandArgs(trailingOnly=TRUE)
new.fn <- args[1]

epoch <- read.table("ukb_CMR_la_sa_ao.epoch.220628.bulk",
                 stringsAsFactors = F,
                 header = F)


new <- read.table(new,
                  stringsAsFactors = F,
                  header = F)



# -----------------------------------------------
#
# 1st imaging visit
#
# rm IDs already analysed

firstVisitEpoch <- epoch[grep("2_0",epoch$V2),]
sample.epoch.id <- unique(firstVisitEpoch[,1])

newFirstVisit <- new[(!new$V1 %in% sample.epoch.id) & grepl("2_0",new$V2),]



# 1st imaging visit
firstVisit <- newFirstVisit[grep("2_0", newFirstVisit$V2),]
sample.id <- unique(firstVisit[,1])

N_list <- ceiling(length(sample.id)/1000)
dataDir <- "/home/projects/cu_10039/projects/process_MRI_UKB/data/imgVisit/"
oldDirs <- basename(list.dirs(dataDir)) 
N_exists <-max(as.numeric(oldDirs[oldDirs != "imgVisit"]))

listTab <- list()
if(N_list <= 1) {
    listTab[as.character(N_list + N_exists) ]<-list(sample.id)
} else {
    listTab <- split(sample.id, cut(1:length(sample.id), N_list, labels = 1:N_list))
}



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


# -----------------------------------------------
#
# 2nd imaging visit
#
# rm IDs already analysed

secondVisitEpoch <- epoch[grep("3_0",epoch$V2),]
sample.epoch.id <- unique(secondVisitEpoch[,1])

newSecondVisit <- new[(!new$V1 %in% sample.epoch.id) & grepl("3_0",new$V2),]


# 2nd imaging visit
secondVisit <- newSecondVisit[grep("3_0", newSecondVisit$V2),]
sample.id <- unique(secondVisit[,1])


N_list <- ceiling(length(sample.id)/1000)
dataDir <- "/home/projects/cu_10039/projects/process_MRI_UKB/data/repImgVisit/"
oldDirs <- basename(list.dirs(dataDir)) 
N_exists <-max(as.numeric(oldDirs[oldDirs != "repImgVisit"]))

listTab <- list()
if(N_list <= 1) {
    listTab[as.character(N_list + N_exists) ]<-list(sample.id)
} else {
    listTab <- split(sample.id, cut(1:length(sample.id), N_list, labels = 1:N_list))
}



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


