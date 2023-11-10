#'@name 021_plot_training_data.R
#'@author Lisa Bald [bald@staff.uni-marburg.de]
#'@date 23.06.2023
#'@description plot training data



# 1 - setup ####
#--------------#

library(ggplot2)
library(terra)
library(sf)
library(tidyterra)

# laod and transform data
fid = sf::read_sf("data/001_raw_data/FID/trainingsgebiete_quality_ID.gpkg")
fid[fid$BAGRu %in% c("Lbk", "Lbl"),]$BAGRu <- "Lb"

fid$Label<- NA
fid[fid$BAGRu == "Bu",]$Label <- "Beech"
fid[fid$BAGRu == "Dou",]$Label <- "Douglas fir"
fid[fid$BAGRu == "Ei",]$Label <- "Oak"
fid[fid$BAGRu == "Fi",]$Label <- "Spruce"
fid[fid$BAGRu == "Ki",]$Label <- "Pine"
fid[fid$BAGRu == "Lä",]$Label <- "Larch"
fid[fid$BAGRu == "Lb",]$Label <- "Other deciduous trees"

fid$Label <- factor(fid$Label, levels=c("Douglas fir", "Larch", "Pine", "Spruce", "Beech", "Oak", "Other deciduous trees"))
fid=na.omit(fid)

fid[fid$Phase == "Qua",]$Phase <- "Qualification"
fid[fid$Phase == "Dim",]$Phase <- "Dimensioning"
fid[fid$Phase == "Rei",]$Phase <- "Maturing"

fid$Phase<-factor(fid$Phase, levels=c("Qualification", "Dimensioning", "Maturing"))
fid=sf::st_transform(fid, "epsg:4326")

# 2 - plot tree species ####
#--------------------------#

fid <- terra::vect(fid)

p1=ggplot(fid) +
  geom_spatvector(aes(fill = Label, color=Label)) +
  scale_fill_manual(values=c("#ed6ccd","#f18304","#173fc5","#d7191c","#74d70b","#deea13", "#560e2d"), name = "Tree species groups")+
  scale_colour_manual(values=c("#ed6ccd","#f18304","#173fc5","#d7191c","#74d70b","#deea13", "#560e2d"), name = "Tree species groups")+
  coord_sf(crs = 25832)+ theme(legend.position="bottom")

# 3 - plot successional Stage ####
#--------------------------------#

p2=ggplot(fid) +
  geom_spatvector(aes(fill = Phase, color=Phase)) +
#  scale_fill_manual(values=c("#ed6ccd","#f18304","#d7191c","#173fc5","#74d70b","#deea13", "#560e2d"), name = "Successional stages")+
#  scale_colour_manual(values=c("#ed6ccd","#f18304","#d7191c","#173fc5","#74d70b","#deea13", "#560e2d"), name = "Successional stages")+
  coord_sf(crs = 25832)+ theme(legend.position="bottom")+ labs(color = "Successional stages",
                                                               fill= "Successional stages")

# 4 - save plot ####
#------------------#

#p=gridExtra::grid.arrange(p1,p2, ncol=2)
ggsave(p1, filename=sprintf("data/003_validation/plots/training_data.png"), dpi=300, units = "mm", width = 150, height = 200)


