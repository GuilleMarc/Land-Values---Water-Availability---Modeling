# Implementing the distance calculator in the whole dataset
#Sale_GIS_sf
#Water_Use_sf
library(tidyverse)
library(sf)

# Find nearest features and distances -----

# Find the nearest locations: (indexes)
Water_indexes<- st_nearest_feature(
  Sale_GIS_sf, Water_Use_sf
)

# Find the nearest features:
Water_Use_nearest<- Water_Use_sf$geometry[
  Water_indexes
]

# Bind the two geometries together:
# Note that there are duplicate records
Sale_Water_nearest_geometries<- cbind(
  Sale_GIS_sf$geometry,
  Water_Use_nearest
)
colnames(Sale_Water_nearest_geometries)<- c("sales","water")

# Calculate the distances (my way): ----

open_time<- Sys.time()
Sale_distance_Water<- apply(
  Sale_Water_nearest_geometries, 1,
  FUN = function(sp_object){
    get_d(
      sp_object['sales']$sales, sp_object['water']$water
    )
  }
)
end_time= Sys.time()
run_time= round((end_time - open_time), 5)
print(paste0("Calculation time: ", " ", as.character(dim(Sale_Water_nearest_geometries)[1])))
run_time
# Above gives just the output of st_distance(..., which= "Euclidean")

# calculate distances correcting for curvature of earth -----

# Interestingly: below fails because the matrix is 35.7 GB
#Sale_distance_Water_st<- st_distance(
#  Sale_GIS_sf$geometry,
#  Water_Use_nearest,
#  which = "Great Circle"
#)

# Running the harvesine I coded:
open_time<- Sys.time()
Sale_distance_Water_st<- apply(
  Sale_Water_nearest_geometries, 1,
  FUN = function(sp_object){
    get_d_haversine(
      sp_object['sales']$sales, sp_object['water']$water
    )
  }
)
end_time= Sys.time()
run_time= round((end_time - open_time), 5)
print(paste0("Calculation time: ", " ", as.character(dim(Sale_Water_nearest_geometries)[1])))
run_time

# Merge datasets: ----
# Water_indexes # indices in water data
# Sale_Water_nearest_geometries # coordinates of the matching locations
# Sale_distance_Water # vector of distances between pairs of matching locations

# get the coordinates of the matching locations in the Water Use data:
Water_Use_nearest_sf<- Water_Use_sf[Water_indexes,]  
Sale_Water_coordinates<- st_coordinates(Sale_Water_sf)
colnames(Sale_Water_coordinates)<- c("Sale_Water_X","Sale_Water_Y")
Water_Use_nearest_coordinates<- st_coordinates(Water_Use_nearest_sf)
colnames(Water_Use_nearest_coordinates)<- c("Water_Use_X", "Water_Use_Y")

# Run the merging of all the inputs:
kevyn<- cbind(Sale_GIS_sf, Water_Use_nearest_sf, 
      Sale_Water_coordinates, Water_Use_nearest_coordinates,
      Sale_distance_Water, Sale_distance_Water_st)


