# LidarForestModeling :evergreen_tree: :deciduous_tree:	:evergreen_tree: :deciduous_tree:	


Comparison of successional stages models using Sentinel-2 and LiDAR variables vs models using just Sentinel-2 variables. Modeled using random forest, spatial validation and forward feature selection using [CAST](https://hannameyer.github.io/CAST/). Study area is Rhineland-Palatinate.

A preprint of this study is currently available [here](https://osf.io/preprints/osf/nqfvh)

### Data & Code availability
The code to reproduce the study can be found in this github repository. The project follows the following folder structure:

```
├── R
│   └── functions
├── data
│   ├── 001_raw_data
│   │   │   ├── border
│   │   │   ├── FID
│   │   │   ├── force
│   │   │   │   ├── data
│   │   │   │   │   ├── mosaic
│   │   │   │   │   ├── ...
│   │   │   │   │   └── X0031_Y0026
│   │   │   │   └── param
│   │   │   ├── HRL
│   │   │   │   └──  data
│   │   │   └── lidar
│   │   │   │   └──  data
│   ├── 002_modelling
│   │   │   ├── extract
│   │   │   ├── modelling
│   │   │   │   ├── test
│   │   │   │   └── train
│   │   │   ├── models
│   │   │   └── prediction
│   ├── 003_validation
│   │   │   ├── confusionMatrix
│   │   │   ├── plots
│   │   │   └── tables
├── .gitignore
├── index.html
└── README.md
```

Detailed information on the data and how it was processed as well as sample data can be found at the linked project at [OSF](https://osf.io/cek5j/). In total data from five different sources were used for this study. A vector polygon was used to delineate the study area, a forest mask showing the forest areas in the study area and Sentinel-2 and LiDAR data as environmental variables as well as forest inventory data as a response variable.

#### 1. Border of the study area
A polygon vector file was used to delineate the study area, in this case it was the border of the federal state of Rhineland-Palatinate in Germany. The shapefile used in this study can be downloaded from the State Office for Surveying and Geoinformation (Landesamt für Vermessung und Geobasisinformation) [here](http://geo5.service24.rlp.de/wfs/verwaltungsgrenzen_rp.fcgi?&request=GetFeature&TYPENAME=landesgrenze_rlp&VERSION=1.1.0&SERVICE=WFS&OUTPUTFORMAT=SHAPEZIP). For further information have a look at the [README_border file](https://osf.io/mrnbz) at OSF.

#### 2. Sentinel-2 data (processed with FORCE)
Secondly a Sentinel-2 time series is nedded. We downloaded and processed all Sentinel-2 data with the software 'Framework for Operational Radiometric Correction for Environmental monitoring' (FORCE; version 3.7.10; [Frantz 2019](https://doi.org/10.3390/rs11091124)). As our study area is quite large (a complete federal state), keep in mind that the processing time and computational power as well as storage space are quite high. To process the same dataset follow the code in the workflow file we have provided [here](https://doi.org/10.17605/OSF.IO/CEK5J). If you want to work with your own study area we suggest having a look at the study by [Bhandari et al (2024)](https://doi.org/10.1038/s41597-024-03283-3) where the workflow is explained in more detail. In total, the final Sentinel-2 data set for all of Rhineland-Palatinate is 440 GB in size and therefore not provided here, but it can be reproduced with the code in the [workflow file](https://doi.org/10.17605/OSF.IO/CEK5J). A sample dataset of January NDVI for Rhineland-Palatinate is provided at [OSF](https://osf.io/cek5j/) to show the structure of the data.

#### 3. Forest mask (HRL)
We also use a forest mask to limit the study area to the forest areas. This forest mask was created from the [Copernicus high-resolution tree-cover 2018](https://land.copernicus.eu/en/products/high-resolution-layer-forest-type/forest-type-2018?tab=metadata) at 10m resolution. The dataset is available for all of Europe and was downloaded for Rhineland-Palatinate from the [Copernicus Land Monitoring Service](https://land.copernicus.eu/en).

#### 4. LiDAR data
Furthermore, LiDAR data were used, that are regularly collected by the ["Landesamt für Vermessung und Geobasisinformation Rheinland-Pfalz"](https://lvermgeo.rlp.de/) for the entire federal state of Rhineland-Palatinate. The complete LiDAR data comprises over 2 TB of data and are therefore not fully provided here. The data can be obtained from  the open data platform of the state office [here](https://geoshop.rlp.de/digitale_gelaendemodelle/laserpunkte_gelaende_lpg.html). The LiDAR data were processed into LiDAR indices in the remote sensing database ([RSDB](https://environmentalinformatics-marburg.github.io/rsdb); [Wöllauer et al. 2020](https://doi.org/10.1111/ecog.05266)). See the [README_lidar](https://doi.org/10.17605/OSF.IO/CEK5J) file at OSF for detail information on the processing. There you can also find two sample files of the processed LiDAR data.

#### 5. Forest inventory data (FID)
The forest inventory data are polygons that were collected during the state-wide forest inventory in Rhineland-Palatinate. They were collected by ["Landesforsten Rheinland-Pfalz"](https://www.wald.rlp.de/) and are not publicly accessible. They are vector polygons that show forest compartments with their various characteristics, such as main tree species, succession stage and purity. We provide a dummy dataset at [OSF](https://doi.org/10.17605/OSF.IO/CEK5J) that has the same structure as the original dataset to make the workflow reproducible.

#### Acknowledgments
These tree species groups and successional stages models are part of the project "Development of forest structure-based habitat models for forest bats" funded by the Rhineland-Palatinate State Office for the Environment (Landesamt für Umwelt Rheinland-Pfalz). The LiDAR data and forestry data were also provided as part of this project. The development of improved methods for remote sensing based classification of forests was conducted within the Natur 4.0 project funded by the Hessian state offensive for the development of scientific-economic excellence (LOEWE).
