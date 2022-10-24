#
# 
# 
# ---------------------------------------------------------------

dataDir <- "/home/projects/cu_10039/projects/process_MRI_UKB/data/imgVisit/"
N <- length(list.dirs(dataDir, recursive = FALSE))

miss <- list()

# for loop start
for(i in 1:N) {

    #i <- 1
    subDir <- paste0(dataDir, i)
    cmd <- paste0("ls -lrt ", subDir, " >", subDir ,"/tmp")
    system(cmd)
    listDir.fn <- paste0(subDir,"/tmp")
    listDir <- read.table(listDir.fn,
                         skip = 1,
                         header = F,
                         stringsAsFactors = F)
    system(paste0("rm ", subDir ,"/tmp"))
    sampleList.fn <- paste0(subDir, "/ukbb_CMR_",i,".bulk")


    sampleList <- read.table(sampleList.fn,
                            stringsAsFactors = F,
                            header = F)$V1

    #rm last entry in list dir
    listDir <- listDir[-which(listDir$V9 == "tmp"),]
    listDir <- listDir[-dim(listDir)[1],]
    
    failed <- listDir$V9[which(listDir$V5 < 120)]
    failed <- failed[failed != "tmp"]
    missing <- sampleList[!sampleList %in% listDir$V9]
    rerun <- unique(c(failed,missing))
    miss[i] <- length(rerun)

    
    print(paste(i,": rerun", length(rerun)))
    out.fn <- paste0(subDir, "/ukbb_CMR_",i,"_rerun.bulk")
    write.table(rerun,
                file = out.fn,
                quote = F,
                col.names = F,
                row.names = F)

}

sum(unlist(miss))



######### EOF ########################
