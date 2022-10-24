point = NULL
layers <- list(eve)
layerExpressions <- sub("^[\\s\"]*(.+?)[\\s\"]*$", "\\1", 
                        sapply(substitute(list(eve)), deparse, control = NULL, 
                               nlines = 1)[-1], perl = TRUE)
nLayers <- length(layers)
if (nLayers == 0) 
  stop("At least one image must be specified")
originalXform <- NULL
orientation <- ifelse(radiological, "LAS", "RAS")
for (i in seq_len(nLayers)) {
  if (!inherits(layers[[i]], "viewLayer")) {
    layers[[i]] <- RNifti::lyr(layers[[i]])
    layers[[i]]$label <- layerExpressions[i]
  }
  if (i == 1) 
    originalXform <- RNifti::xform(layers[[i]]$image)
  header <- RNifti::niftiHeader(layers[[i]]$image)
  if (RNifti::ndim(layers[[i]]$image) > 2 && (header$qform_code > 
                                      0 || header$sform_code > 0)) {
    orientation(layers[[i]]$image) <- orientation}
}

baseImage <- layers[[1]]$image
reorientedXform <-xform(baseImage)
ndim <- ndim(baseImage)
dims <- c(dim(baseImage), rep(1, max(0, 3 - ndim)))[1:3]
fov <- dims * c(pixdim(baseImage), rep(1, max(0, 3 - ndim)))[1:3]
if (ndim < 3L || attr(reorientedXform, "code") == 0L) {
  labels <- FALSE }
if (is.null(point) && any(origin(originalXform) > 1)) {
  point <- round(origin(originalXform)) } else if (is.null(point)) {
  point <- round(dims/2)
  }
reorientedPoint <- round(worldToVoxel(voxelToWorld(point, 
                                                   originalXform), reorientedXform))
positiveLabels <- unlist(strsplit(orientation, ""))
negativeLabels <- c(R = "L", A = "P", S = "I", L = "R", 
                    P = "A", I = "S")[positiveLabels]
oldPars <- par(bg = "black", col = "white", fg = "white", 
               col.axis = "white", col.lab = "white", col.main = "white")
oldOptions <- options(locatorBell = FALSE, preferRaster = TRUE)
on.exit({
  par(oldPars)
  options(oldOptions)
})
repeat {
  reorientedPoint[reorientedPoint < 1] <- 1
  reorientedPoint[reorientedPoint > dims] <- dims[reorientedPoint > 
                                                    dims]
  voxelCentre <- (reorientedPoint - 1)/(dims - 1)
  point <- round(worldToVoxel(voxelToWorld(reorientedPoint, 
                                           reorientedXform), originalXform))
  starts <- ends <- numeric(0)
  if (ndim == 2) {
    starts <- ends <- rep(0:1, 2)
    layout(matrix(c(2, 1), nrow = 1))
  }
  else layout(matrix(c(2, 3, 4, 1), nrow = 2, byrow = TRUE))
  data <- lapply(layers, function(layer) {
    indices <- alist(i = , j = , k = , t = , u = , v = , 
                     w = )
    indices[seq_along(point)] <- reorientedPoint
    result <- do.call("[", c(list(layer$image), indices[seq_len(ndim(layer$image))]))
    if (inherits(layer$image, "rgbArray")) 
      return(as.character(structure(result, dim = c(1, 
                                                    length(result)), class = "rgbArray")))
    else return(result)
  })
  #infoPanel(point, data, sapply(layers, "[[", "label"))
  for (i in 1:3) {
    if (ndim == 2 && i < 3) 
      next
    inPlaneAxes <- setdiff(1:3, i)
    loc <- replace(rep(NA, 3), i, reorientedPoint[i])
    for (j in seq_along(layers)) .plotLayer(layers[[j]], 
                                            loc, asp = fov[inPlaneAxes[2]]/fov[inPlaneAxes[1]], 
                                            add = (j > 1))
    region <- par("usr")
    starts <- c(starts, region[c(1, 3)])
    ends <- c(ends, region[c(2, 4)])
    width <- c(region[2] - region[1], region[4] - region[3])
    if (crosshairs) {
      halfVoxelWidth <- 0.5/(dims[inPlaneAxes] - 1)
      lines(rep(voxelCentre[inPlaneAxes[1]], 2), c(-halfVoxelWidth[2], 
                                                   1 + halfVoxelWidth[2]), col = "red")
      lines(c(-halfVoxelWidth[1], 1 + halfVoxelWidth[1]), 
            rep(voxelCentre[inPlaneAxes[2]], 2), col = "red")
    }
    if (labels) {
      currentLabels <- c(negativeLabels[inPlaneAxes[1]], 
                         positiveLabels[inPlaneAxes[1]], negativeLabels[inPlaneAxes[2]], 
                         positiveLabels[inPlaneAxes[2]])
      text(c(0.1 * width[1] + region[1], 0.9 * width[1] + 
               region[1], 0.5 * width[2] + region[3], 0.5 * 
               width[2] + region[3]), c(0.5 * width[1] + 
                                          region[1], 0.5 * width[1] + region[1], 0.1 * 
                                          width[2] + region[3], 0.9 * width[2] + region[3]), 
           labels = currentLabels)
    }
  }
  if (!interactive) 
    break
  nextPoint <- locator(1)
  if (is.null(nextPoint)) 
    break
  nextPoint <- unlist(nextPoint)
  if (nextPoint[1] > ends[5] && nextPoint[2] <= ends[6]) 
    next
  else if (nextPoint[1] <= ends[5] && nextPoint[2] > ends[6]) {
    adjustedPoint <- (nextPoint - c(starts[5], ends[6]))/(ends[5:6] - 
                                                            starts[5:6]) * (ends[1:2] - starts[1:2]) + starts[1:2]
    reorientedPoint[2:3] <- round(adjustedPoint * (dims[2:3] - 
                                                     1)) + 1
  }
  else if (nextPoint[1] > ends[5] && nextPoint[2] > ends[6]) {
    adjustedPoint <- (nextPoint - ends[5:6])/(ends[5:6] - 
                                                starts[5:6]) * (ends[3:4] - starts[3:4]) + starts[3:4]
    reorientedPoint[c(1, 3)] <- round(adjustedPoint * 
                                        (dims[c(1, 3)] - 1)) + 1
  }
  else reorientedPoint[1:2] <- round(nextPoint * (dims[1:2] - 
                                                    1)) + 1
}
invisible(NULL)
}
