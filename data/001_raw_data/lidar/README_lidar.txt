## LiDAR data

The 3D LiDAR data were made available by the "Landesamt für Vermessung und Geobasisinformation Rheinland-Pfalz" (https://lvermgeo.rlp.de/) as part of the project "Development of forest structure-based habitat models for forest bats" funded by the Rhineland-Palatinate State Office for the Environment (Landesamt für Umwelt Rheinland-Pfalz).

The 3D point cloud was processed using the Remote sensing database (RSDB; https://environmentalinformatics-marburg.github.io/rsdb). 

Required dataset:

1. **LiDAR data**
   - **Name in R scripts:** raster layers with the indices should be stored in the folder data/001_raw_data/lidar/data and are listed in R with the following command: terra::rast(list.files("data/001_raw_data/lidar/data",full.names=T, pattern=".tif$"))
   - **Description:** 29 LiDAR indices derived from a point cloud on the HRL forest mask
   - **Access Instructions:** This dataset is not openly accessible. Please refer to Landesamt für Vermessung und Geobasisinformation Rheinland-Pfalz (https://lvermgeo.rlp.de/)


## Usage
To process the 3D pointcloud to LiDAR indices in the RSDB the following task definition was used where "rlp2022" was the name of the point cloud and HRL_force the name of the raster layer on which the indices should be calculated:

{ "task_pointcloud": "index_raster", "pointcloud": "rlp_2022", "rasterdb": "HRL_force", "indices": [ "BE_H_MAX", "chm_height_max", "BE_H_MEAN", "chm_height_mean", "BE_H_SD", "chm_height_sd", "BE_H_MEDIAN", "BE_H_SKEW", "BE_H_KURTOSIS", "BE_H_P30", "BE_H_P70", "BE_PR_CAN", "BE_PR_REG", "BE_PR_UND", "BE_RD_CAN", "BE_RD_REG", "BE_RD_UND", "VDR", "AGB", "LAI", "BE_FHD", "vegetation_coverage_01m_CHM", "vegetation_coverage_02m_CHM", "vegetation_coverage_05m_CHM", "vegetation_coverage_10m_CHM", "dtm_elevation_max", "BE_ELEV_MEAN", "dtm_elevation_sd", "BE_ELEV_SLOPE" ] }

After processing the data was downloaded from the RSDB and extracted to the folder data/001_raw_data/lidar/data for each of the indices one tif file is available in this folder e.g. "AGB.tif".

For a detailed describtion of the 3D LiDAR data refer to file "ProduktbeschreibungRLP_Laserpunkte.pdf"

