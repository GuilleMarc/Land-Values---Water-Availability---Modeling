##### Starting code for Thompson Project #########
# Created: 12/4/2021
# Last edited: 12/6/2021
# GM
##################################################

##### Import Libraries ####
library(tidyverse)
library(sf)

###### Read the data sets ####################
current_path= dir()
#where_files= grep(".xlsx", current_path)

# Files:
Water_Use_file= "WaterUse_Means_All_2005_2015.xlsx" #current_path[8]
Sale_GIS_file= "Sale_GIS_All_2012_2021.xlsx" #current_path[4]

# Create data frames:
open_time<- Sys.time()
Water_use_df<- readxl::read_xlsx(Water_Use_file)
Sale_GIS_df<- readxl::read_xlsx(Sale_GIS_file)
end_time= Sys.time()
run_time= round((end_time - open_time),2)
run_time 

###### Some check-ups ####################
# Make some sense of the dispersion of the location coordinates:

# Water Use (First Layer)

open_time<- Sys.time()
ggplot(
aes(GIS_LONG, GIS_LAT),
data = Water_use_df
)+
geom_point() +
  geom_point(
    aes(LONG, LAT, color= "red"), # Sales (second layer)
    data = Sale_GIS_df
  )
end_time= Sys.time()
run_time= round((end_time - open_time),2)
run_time  # 

# (Not print):

# There were 8 IDs with zero lat and long
Sale_GIS_df_problem<- Sale_GIS_df[Sale_GIS_df$LONG == 0,]
Sale_GIS_df_problem

# Clean the Sale data: Drop the zero lat and long:
Sale_GIS_df<- Sale_GIS_df[Sale_GIS_df$LONG != 0, ] # Get back to line 28 to plot again

# Converting the two data sets to spatial objects (Using spatial features) ####
Sale_GIS_sf<- sf::st_as_sf(Sale_GIS_df, coords= c("LONG", "LAT"), crs= 4326)
Water_Use_sf<- sf::st_as_sf(Water_use_df, coords= c("GIS_LONG", "GIS_LAT"), crs= 4326)













# Merging (OLD VERSION) ----

# This operation keeps the geometry of the Sale data, and adds the
# values for ACRES_IRR, AF_USED, and PUMP_RATE in the Water data,
# using the coordinates in Sale-data more closely distant from Water-Data
# more closely related in 

open_time<- Sys.time()
st_join(
  Sale_GIS_sf,
  Water_Use_sf,
  join= st_nearest_feature,
  left= T
) -> Sale_Water_sf


# If need o keep (lat, long) in separate columns #####

# Convert sf back to a data frame (matrix)
Sale_Water_df<- Sale_Water_sf %>% sf::st_drop_geometry()
Sale_Water_coords<- sf::st_coordinates(Sale_Water_sf)
Sale_Water_df[,c("LONG","LAT")]<- Sale_Water_coords

# Export the final "merged" data frame for Cheyenne (with lat and long @ end)
# NOTE  .csv files are easier to handle than xls, or xlsx
# If you REALLY need to work with excel files directly, you can simply save
# the csv file in any excel format you want 
Sale_Water_df %>%  write.csv(., "Sale_Water_All_Merged.csv")




# ----- Do not run this ----------------
# Not (print)

Sale_sample_sf<- Sale_GIS_sf[1:10, c("CountyName","Adj_PPAcre", "TimeTrend")]
Water_Use_sample_sf<- Water_Use_sf[1:10, c("COUNTY_NAME", "ACRES_IRR")]

st_join(
  Sale_sample_sf,
  Water_Use_sf[, c("COUNTY_NAME", "ACRES_IRR")],
  join= st_nearest_feature,
  left= T
) -> Sale_Water_sample_sf

st_distance(Sale_sample_sf, 
            Water_Use_sf[, c("COUNTY_NAME", "ACRES_IRR")]
) -> Sale_Water_sample_distances

ggplot(
  aes(LONG, LAT),
  data = Sale_Water_df
)+
  geom_point()+
geom_point(
  aes(LONG, LAT, color= "red"), # Sales (second layer)
  data = Sale_GIS_df
)















