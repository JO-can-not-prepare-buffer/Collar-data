####instruction####

# to convert csv. into a SpatialPointsDataFrame
# input coordinate should be projected to "UTM47N" in Arcmap
  # WGS_1984_UTM_Zone_47N:
    # "+proj=utm +zone=47 +ellps=WGS84 +datum=WGS84 +units=m +no_defs"
      # you can find proj4string in "https://spatialreference.org/"




####Package####

install.packages('adehabitatHR')
install.packages('maptools')
library('adehabitatHR')
library('maptools')
library(sp)




####Process the contents of the entire folder####

a <- list.files("tmp/collar")
a
dir <- paste("tmp/collar/", a, sep = "")
n <- length(dir)
n
merge.location = data.frame(id = NA, X = NA, Y = NA)

for(i in 1:n){
  location <- read.csv(file = dir[i], header = T, sep = ",", stringsAsFactors = F)
  head(location)
  
  merge.location <- rbind(merge.location, location)
  class(merge.location)
}

merge.location <- merge.location[-1,]
View(as.data.frame(merge.location))


siteXY <- data.frame(X = merge.location$X, Y = merge.location$Y)
siteXY <- as.matrix(siteXY)
XY <- SpatialPoints(siteXY, 
                    proj4string = CRS("+proj=utm +zone=47 +ellps=WGS84 +datum=WGS84 +units=m +no_defs"))
head(XY)

#add the id column
id <- merge.location$id
idXY <- data.frame(id)
coordinates(idXY) <- siteXY
class(idXY)
View(as.data.frame(idXY))



####Process the contents one by one####

location <- read.csv("tmp/eg/PKU001point_UTM47.csv",stringsAsFactors = F)
siteXY <- data.frame(X = location$X, Y = location$Y)
siteXY <- as.matrix(siteXY)
XY <- SpatialPoints(siteXY, 
                        proj4string = CRS("+proj=utm +zone=47 +ellps=WGS84 +datum=WGS84 +units=m +no_defs"))
head(XY)

#add the id column
id <- location$id
idXY <- data.frame(id)
coordinates(idXY) <- siteXY
class(idXY)
View(as.data.frame(idXY))




####MCP####

cp <- mcp(idXY[, 1], percent=95, unin = "m", unout = "km2")
class(cp)
plot(cp)
plot(idXY[, 1], add=TRUE)
#writePolyShape(cp, "homerange")

#MCP_home range size
as.data.frame(cp)
hrs <- mcp.area(idXY[, 1], percent = seq(50, 100, by = 5))
plot(hrs)
