phenos = c("lamax","lamin","lamdv","labac","lasv","laev","lapev","latef",
           "lapef","laaef","expansionidx","aeTangent","peTangent","ilamax",
           "ilamin", "ilamdv","ilabac","ilasv","ilaev","ilapev")
mat = matrix(NA, nrow = length(phenos), ncol = length(phenos))

rownames(mat) = phenos
colnames(mat) = phenos

for(i in 1:length(phenos)) {
  for(j in 1:length(phenos)){
    pheno1=phenos[i]
    pheno2=phenos[j]
    mat[i,j] = paste(pheno1,pheno2, sep = '-')
  }
}

sum(upper.tri(mat))
idxupper = which(upper.tri(mat))

# quotient
idxcol = 1+idxupper %/% length(phenos)
# remainder
idxrow = idxupper %% length(phenos)


mat = matrix(NA, nrow = length(phenos), ncol = length(phenos))
rownames(mat) = phenos
colnames(mat) = phenos


for(i in 1:length(idxupper)) {
  pheno1=phenos[idxrow[i]]
  pheno2=phenos[idxcol[i]]
  mat[idxrow[i],idxcol[i]] = paste(pheno1,pheno2, sep = '-')
}
mat
