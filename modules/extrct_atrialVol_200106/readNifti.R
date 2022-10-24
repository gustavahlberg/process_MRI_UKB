library(oro.nifti)
library(devtools)
devtools::install_github("jonclayden/RNiftyReg")
library(RNiftyReg)
library(RNifti)

#fname = "../../data/test/3850664/seg_la_2ch.nii.gz"
#fname = "../../data/test/3850664/la_4ch.nii.gz"
fname = "../../data/test/3850664/la_3ch.nii.gz"
fname = "../../data/test/3850664/la_4ch_ES.nii.gz"
fname = "../../data/test/1388640/seg_la_2ch.nii.gz"
# fname = "../../data/test/1388640/seg_la_4ch.nii.gz"
# fname = "../../data/test/1388640/sa.nii.gz"
fname = "../../data/test/1388640/seg_la_4ch_ED.nii.gz"

eve = RNifti::readNifti(fname)
RNifti::lyr(eve)
RNifti::view(eve,radiological = F,interactive = F)
eve  = RNiftyReg::readNifti(fname)
RNifti::view(eve,radiological = T)

pixdim = RNifti::niftiHeader(eve)$pixdim[2:5]
area_per_pix = pixdim[1] * pixdim[2] * 1e-2 

# area
sum(eve[,,1,1])*area_per_pix

#volume
V['LA_2ch'][t] = 8 / (3 * math.pi) * area[0] * area[0] / length[0] 


view(eve[,,,],interactive = F)

for(i in 1:50) {
  view(eve[,,,i],interactive = F)
  print(sum(eve[,,1,i])*area_per_pix)
  Sys.sleep(1)
}


eve = oro.nifti::readNIfTI(fname,reorient = F)
oro.nifti::orthographic(eve)

image(eve,)

#oro.nifti::orthographic(eve)


