# Trying the distance calculator on Thompson dataset:
#Sale_GIS_sf
#Water_Use_sf

# 1) Pick a random sample (w.o. replacement) of 100 observations ----
sample_size<- 100
set.seed(1234)
resample<- sample(seq(dim(Sale_GIS_sf)[1]), sample_size, replace= T)
Sale_GIS_sf_sample<- Sale_GIS_sf[resample,]

# Find the nearest features:
Water_Use_nearest<- Water_Use_sf$geometry[
  st_nearest_feature(
    Sale_GIS_sf_sample, Water_Use_sf
    )
  ]

# Bind the two geometries together:
Sale_Water_nearest_geometries<- cbind(
  Sale_GIS_sf_sample$geometry,
  Water_Use_nearest
)
colnames(Sale_Water_nearest_geometries)<- c("sales","water")

# Calculate the distances (Euclidean - My Way) ----
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
print(paste0("Printing results from N= ", " ", as.character(sample_size)))
run_time 

# Calculate distances ("Great Circle") - My Way ------
open_time<- Sys.time()
Sale_distance_Water_Great_Circle<- apply(
  Sale_Water_nearest_geometries, 1,
  FUN = function(sp_object){
    get_d_haversine(
      sp_object['sales']$sales, sp_object['water']$water
    )
  }
)
end_time= Sys.time()
run_time= round((end_time - open_time), 5)
print(paste0("Printing results from N= ", " ", as.character(sample_size)))
run_time 



# Not (print) ----
# Based on the concept of "haversine" calculation for sphericity
# Below gives you a matrix of distances (m x n)
# modify argument which to "Great Circle" or "Euclidean"
Sale_distance_Water_st<-st_distance(
  Sale_GIS_sf_sample$geometry, 
  Water_Use_nearest, 
  which = "Great Circle") # "Euclidean" gets degrees not meters
Sale_distance_Water_st_min= apply(Sale_distance_Water_st, 1, min) # gives the shortest distances
apply(Sale_distance_Water_st, 2, min) # Same than above

