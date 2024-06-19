# LidarForestModeling :evergreen_tree: :deciduous_tree:	:evergreen_tree: :deciduous_tree:	


Comparison of successional stages models using Sentinel-2 and LiDAR variables vs models using just Sentinel-2 variables. Modeled using random forest, spatial validation and forward feature selection using [CAST](https://hannameyer.github.io/CAST/). Study area is Rhineland-Palatinate.

A preprint of this study is currently available [here](https://osf.io/preprints/osf/nqfvh)

### Data
Data from five different sources were used for this study. A vector polygon was used to delineate the study area, a forest mask showing the forest areas in the study area and Sentinel-2 and LiDAR data as environmental variables as well as forest inventory data as a response variable.

#### 1. Border of the study area
A polygon vector file was used to delineate the study area in this case it was the border of the federal state of Rhineland-Palatinate in Germany. The shapefile used in this study can be downloaded from the State Office for Surveying and Geoinformation (Landesamt für Vermessung und Geobasisinformation) [here](http://geo5.service24.rlp.de/wfs/verwaltungsgrenzen_rp.fcgi?&request=GetFeature&TYPENAME=landesgrenze_rlp&VERSION=1.1.0&SERVICE=WFS&OUTPUTFORMAT=SHAPEZIP). For further information have a look at the [README_border file](data/001_raw_data/border/README_border.txt).

#### 2. Sentinel-2 data (processed with FORCE)
Secondly a Sentinel-2 time series is nedded, we downloaded and processed all Sentinel-2 data with the software 'Framework for Operational Radiometric Correction for Environmental monitoring' (FORCE; version 3.7.10; [Frantz 2019](https://doi.org/10.3390/rs11091124)). As our study area is quite large (a complete federal state) therefore keep in mind that the processing time and computational power as well as storage space are quite high. To process the exact same dataset follow the code in the workflow file we have provided [here](data/001_raw_data/force/FORCE_workflow). If you want to work with your own study area we suggest having a look at the study by [Bhandari et al (2024)](https://doi.org/10.1038/s41597-024-03283-3) where the workflow is explained in more detail. In total, the final Sentinel-2 data set for all of Rhineland-Palatinate is 440 GB in size and therefore not provided here, but it can be reproduced with the code in the [workflow file](data/001_raw_data/force/FORCE_workflow).

#### 3. Forest mask (HRL)
We also use a forest mask to limit the study area to the forest areas. This forest mask was created from the [Copernicus high-resolution tree-cover 2018](https://land.copernicus.eu/en/products/high-resolution-layer-forest-type/forest-type-2018?tab=metadata) at 10m resolution. The dataset is available for all of Europe and was downloaded for Rhineland-Palatinate from the [Copernicus Land Monitoring Service](https://land.copernicus.eu/en).

#### 4. LiDAR data
Furthermore, LiDAR data were used, that are regularly collected by the ["Landesamt für Vermessung und Geobasisinformation Rheinland-Pfalz"](https://lvermgeo.rlp.de/) for the entire federal state of Rhineland-Palatinate. The complete LiDAR data comprises approximately 3 TB and are not publicly available but can be requested for research purposes from the state office. The LiDAR data were processed into LiDAR indices in the remote sensing database ([RSDB](https://environmentalinformatics-marburg.github.io/rsdb); [Wöllauer et al. 2020](https://doi.org/10.1111/ecog.05266)).

#### 5. Forest inventory data (FID)
The forest inventory date are polygons die bei der landesweiten waldinventor in Rheinland-Pfalz erhoben wurden 


#### Acknowledgments
These tree species groups and successional stages models are part of the project "Development of forest structure-based habitat models for forest bats" funded by the Rhineland-Palatinate State Office for the Environment (Landesamt für Umwelt Rheinland-Pfalz). The LiDAR data and forestry data were also provided as part of this project. The development of improved methods for remote sensing based classification of forests was conducted within the Natur 4.0 project funded by the Hessian state offensive for the development of scientific-economic excellence (LOEWE).
