# Land-Values---Water-Availability---Modeling
Is there a consistent relationship between groundwater depletion and land values in KS?

The Ogallala Aquifer stretches across eight states from South Dakota to Texas. It is one of the world’s largest aquifers and is the primary source of agricultural irrigation within the study region. Three million acres within the state of Kansas are dedicated to irrigated agriculture producing a variety of crops including corn, alfalfa, sorghum, soybeans, and wheat. With the increase in groundwater pumping, the aquifer has seen steady declines since the 1940s. To date, the depletion of the Ogallala has increasingly exceeded the rate of recharge, and the exhaustion of the aquifer is of heightened concern  

# Data
Data was sourced from the Water Information Management and Analysis System (WIMAS, 2015), the Kansas Department of Revenue (KDR, 2021), and Geographic Information System (GIS, 2021). 526 useable observations within GMD4. 

Prior to modeling, two georeferenced databases were merged on the basis of Euclidean, and curvature-corrected (haversine), nearest distance analysis. 

  - **Land sale prices** (adjusted for inflation, ref= 2020 dollars) --- 2,000 dryland and irrigated land sale transactions (2012 to 2021). 
  - **Water data and crop sources** 2,497 individual wells in GMD4 from 2005 to 2015. 

# Preliminary results and ongoing modeling
A hedonic pricing model has shown that the total acreage used for agriculture varies greatly from less than 1 acre to over 600 acres.  Most of the observations consist of acreage that suggest family farming.  The smaller parcels propose to be a family residence that could be closer to large cities.  

Currently we are training linear classifiers (SVC) based on geographical, agricultural, and socioeconomic features, to evaluate potential areas of concentration in regard to land value and water use.




