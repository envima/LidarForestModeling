## Copernicus high-resolution tree-cover 2018

Download the required data from the following sources:

1. **Forest mask (HRL)**
   - **Name in R scripts:** HRL_force.tif
   - **Description:** Provides at pan-European level in the spatial resolution of 10 m a forest classification for three thematic classes (all non-forest areas / broadleaved forest / coniferous forest) with the agricultural/urban trees removed for the 2018 reference year.
   - **Download Link:** The dataset can be downloaded at the Copernicus Land Monitoring service: https://land.copernicus.eu/pan-european/high-resolution-layers/forests/forest-type-1/status-maps/forest-type-2018?tab=metadata 
   - **Access Instructions:** The forest cover from 2018 at 100m resolution is used in this study. The dataset is downloaded for all of Rhineland-Palatinate.

## Usage
The processing of the dataset is described in script R/010_HRL_forest_mask.R

The dataset is used to restrict the study area to forested regions. All environmnental datasets are cropped to or calculated on this forest mask.

Detailed description of the datset in file "Forest 2018 user manual.pdf"

