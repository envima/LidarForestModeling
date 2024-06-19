## Sentinel-2 data

The Sentinel-2 data were processed using the `Framework for Operational Radiometric Correction for Environmental monitoring` (FORCE; version 3.7.10; Frantz 2019). FORCE is an all-in-one solution to download and process Sentinel-2 data. In this study Sentinel-2 data for all of Rhineland-Palatinate were downloaded for the years 2019-2021 at 10m spatial resolution.

Download the required data from the following sources:

1. **Sentinel-2 data**
   - **Name in R scripts:** virtual mosaics (.vrt) of the Sentinel-2 data were used in this study stored in the following folder: data/001_raw_data/force/data/mosaic/ 
   - **Description:** Sentinel-2 data 2019-2021 at 10m spatial resolution
   - **Download Link:** The Sentinel-2 data can be downloaded from ESA´s Copernicus hub (https://scihub.copernicus.eu/) via FORCE
   - **Access Instructions:** see below section usage


## Usage
The Sentinel-2 data were processed with FORCE. The code for processing the data is available at data\001_raw_data\force\FORCE_workflow.dat
This code can be used to download and process the Sentinel-2 data with FORCE version 3.7.10 as it was used in this study. In the folder 
data\001_raw_data\force\param all parameter files (.prm) that define the parameters choosen for processing the data are available. They are called in the code in the FORCE_workflow file. For a detailed description of the whole workflow and a more generic description of the parameter files please refer to Bhandari et al (2024).


## References
Bhandari, N., Bald, L., Wraase, L., & Zeuss, D. (2024). Multispectral analysis-ready satellite data for three East African mountain ecosystems. Scientific Data, 11(1), 473. https://doi.org/10.1038/s41597-024-03283-3

Frantz, D. (2019). FORCE—Landsat + Sentinel-2 analysis ready data and beyond. Remote Sensing, 11(9), 1124. https://doi.org/10.3390/rs11091124
