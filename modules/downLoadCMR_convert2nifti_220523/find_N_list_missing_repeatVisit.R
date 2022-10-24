#
# 
# 
# ---------------------------------------------------------------

dataDir <- "/home/projects/cu_10039/projects/process_MRI_UKB/data/repImgVisit/"
N <- length(list.dirs(dataDir, recursive = FALSE))

# for loop start
miss <- list()
outList <- c()

for(i in 1:N) {

    #i <- 3
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
    grep("bulk", listDir$V9)
    listDir <- listDir[-which(listDir$V9 == "tmp"),]
    listDir <- listDir[-grep("bulk", listDir$V9),]
    #listDir <- listDir[-dim(listDir)[1],]
    
    missing <- sampleList[!sampleList %in% listDir$V9]
    rerun <- missing

    miss[i] <- length(rerun)
    print(paste(i,": rerun", length(rerun)))
    
    if(length(rerun) > 0) {
        out.fn <- paste0(subDir, "/ukbb_CMR_",i,"_rerun.bulk")
        outList <- c(outList, out.fn)
         write.table(rerun,
                     file = out.fn,
                     quote = F,
                     col.names = F,
                     row.names = F)
   }

}

outList
sum(unlist(miss))


write.table(outList,
            file = "reRunFileList_repeatVisit.txt",
            quote = F,
            col.names = F,
            row.names = F
            )








######### EOF ########################
