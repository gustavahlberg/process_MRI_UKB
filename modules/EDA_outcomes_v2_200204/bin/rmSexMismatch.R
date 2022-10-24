sex = h5read(h5.fn,"f.31/f.31")[,1]
sexGen = h5read(h5.fn,"f.22001/f.22001")[,1]

names(sex) = sample.id
any(sex[samplesCMR] == -9999)
sex = sex[samplesCMR]

names(sexGen) = sample.id
any(sexGen[samplesCMR] == -9999)
sexGen = sexGen[samplesCMR]

sum(sex != sexGen)
sexMismatch = which(sex != sexGen)

all(voltab$sample.id == names(sex))
voltab$sex = sex

if(length(sexMismatch) > 0) {
  voltab = voltab[-sexMismatch,]
}

any(voltab$sample.id %in% names(sexMismatch))
samplesCMR = voltab$sample.id
sample.unrel.eth.cmr.id = voltab$sample.id


