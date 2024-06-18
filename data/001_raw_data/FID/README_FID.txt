## Forest inventory data (FID) of Rhineland-Palatinate

This dataset was made available by Landesforsten Rheinland-Pfalz (https://www.wald.rlp.de/) as part of the project "Development of forest structure-based habitat models for forest bats" funded by the Rhineland-Palatinate State Office for the Environment (Landesamt für Umwelt Rheinland-Pfalz).

Required dataset:

1. **Forest inventory data (FID)**
   - **Name in R scripts:** trainingsgebiete_quality_ID.gpkg
   - **Description:**  geopackage file with attribute table with eight columns:
	FAT_ID: [integer] unique ID of the forest unit
	BAGRu: [string] abbreviated tree species goup in german (Bu - beech, Dou - douglas fir, Ei - oak, Fi - spruce, Ki - pine, La - larch, Lb - deciduous trees )
	LLO_ID: [numeric] ID of the polygons used for spatial cross-validation. Adjacent polygons with the same tree species have the same ID here
	quality_ID: [numeric] ID of the polygons used for spatial cross-validation. Adjacent polygons with the same tree species AND successional stage have the same ID here
	quality: [string] sting of trees species and successional stage e.g. "Ei_Qua" (oak qualification)
	Phase: [string] succesional stagees in german (Qua - qualification, Dim - dimensioning, Rei - maturing)
	proz: [numeric] indicates how much of the polygon is covered by the main tree species group in percent
	geom: [multipolygon] gemoetry information about the vector data
   - **Access Instructions:** This dataset is not openly accessible. Please refer to Landesforsten Rheinland-Pfalz (https://www.wald.rlp.de/)

## Usage
The dataset contains the response used for modeling the tree species and successional stages as vector polygons. 

