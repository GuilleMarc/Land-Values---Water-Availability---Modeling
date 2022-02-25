library(sf)

# Making up point-geometries:
# Three points for location "t"
t0= st_point(c(0.0, 0.0))
t1= st_point(c(1.0, 1.0))
t2= st_point(c(2.0, 1.0))
(t= st_sfc(t0, t1, t2))

# Three points for location "s"
s0= st_point(c(-1.0, -1.0))
s1= st_point(c(-2.0, -1.0))
s2= st_point(c(-1.0, 2.0))
(s= st_sfc(s0, s1, s2))

# Calculate a function to get euclidean distance ----
# This function does not correct for curvature:
get_d= function(x,y){
  d= sqrt((x[1] - y[1])**2 + (x[2] - y[2])**2)
  return(round(d, 4))
}

# this function gives you the same results than 
# st_distance(.,., which= "Euclidean") # output in degrees
# To get meters, need to account for shericity (earth)
# check:"haversine" 

#  -- This is a python implementation of the "haversine" function:
#def distance(lat1, lon1, lat2, lon2):
#  p = pi/180
#a = 0.5 - cos((lat2-lat1)*p)/2 + cos(lat1*p) * cos(lat2*p) * (1-cos((lon2-lon1)*p))/2
#return 12742 * asin(sqrt(a)) #2*R*asin...

# Code this function and you should get the output from:
# st_distance(.,..., which= "Great Circle"): gives meters

get_d_haversine<- function(x,y){
  p= pi/180
  a= 0.5 - cos((y[2]-x[2])*p)/2 + cos(x[2]*p) * cos(y[2]*p) * (1-cos((y[1]-x[1])*p))/2
  return(12742 * asin(sqrt(a)))
}


# Try the st_nearest_feature function in sf: ----
nearest= t[st_nearest_feature(s, t)]

# How to extract the POINT geometries from nearest and attach to s
s_nearest_t= cbind(s, nearest)

# Not(print) ----
s_distance_t= c()
for(i in 1:dim(s_nearest_t)[1]){
    i_distance= get_d(
    s_nearest_t[i, 's']$s,
    s_nearest_t[i, 'nearest']$nearest
  )
  print(i_distance)
}

# Using built-in iteration ----
s_distance_t= apply(
  s_nearest_t, 1,
  FUN = function(sp_object){
    get_d(
      sp_object['s']$s, sp_object['nearest']$nearest
    )
  }
)

# The merged dataset for Thompson has about 69,000 rows
