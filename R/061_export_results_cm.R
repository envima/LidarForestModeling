#'@name 061_export_results_cm.R
#'@date 23.06.2023
#'@author Lisa Bald [bald@staff.uni-marburg.de]
#'@description transform confusion matrix for barplot and export as excel file


# 1 - set up ####
#---------------#

library(xlsx)


# 2 - helper function ####
#------------------------#

# helper function to create confucion matrix in right order for barplots
create_cm <- function(cm){
  cm=as.data.frame.matrix(t(cm$table))
  if(i %in% c("La", "Ki")){
    cm$Qua<-0
    cm=rbind(cm, c(0,0,0))
    rownames(cm)<- c("Dim", "Rei", "Qua" )
  }
  #reorder column names
  cm=cm[,c("Qua","Dim","Rei")]
  # reorder rows
  cm=cm[c("Qua","Dim","Rei"),]
  
  # translate to english
  
  colnames(cm)<- c("Qualification", "Dimensioning", "Maturing")
  rownames(cm)<- c("Qualification", "Dimensioning", "Maturing")
  
  #add column with rowsum
  cm$rowSum=rowSums(cm)
  cm$QuaPerc=cm$Qualification/cm$rowSum
  cm$DimPerc=cm$Dimensioning/cm$rowSum
  cm$MatPerc=cm$Maturing/cm$rowSum
  
  cm$QuaPerc2=round(cm$Qualification/cm$rowSum*100,0)
  cm$DimPerc2=round(cm$Dimensioning/cm$rowSum*100,0)
  cm$MatPerc2=round(cm$Maturing/cm$rowSum*100,0)
  
  return(cm)
}

# 3 - export as excel ####
#------------------------#

for (i in c("Dou", "Ei", "Lb", "La",  "Bu", "Ki","Fi")){
  #i="Dou"
  cm=readRDS(sprintf("data/003_validation/confusionMatrix/%s_Sentinel_cm.RDS",i))
  cm=create_cm(cm=cm)
  write.xlsx(cm, "data/003_validation/tables/successional_stages_cm.xlsx", sheetName = paste0(i, "_Sentinel"), 
             col.names = TRUE, row.names = TRUE, append = TRUE)
  rm(cm)
  
  # create confusion matrix for Sentinel & LiDAR models
  cm=readRDS(sprintf("data/003_validation/confusionMatrix/%s_SentinelLidar_cm.RDS",i))
  cm=create_cm(cm=cm)
  write.xlsx(cm, "data/003_validation/tables/successional_stages_cm.xlsx", sheetName = paste0(i, "_SentinelLidar"), 
             col.names = TRUE, row.names = TRUE, append = TRUE)
  rm(cm)
}



# 4 - export tree species and map cm ####
#---------------------------------------#

treeModel=readRDS("data/003_validation/confusionMatrix/7TS_SentinelLidar_cm.RDS")

treeModel=as.data.frame.matrix(treeModel$table)
#reorder column names
treeModel=treeModel[,c("Dou", "Lä","Ki","Fi",  "Bu","Ei",  "Lb")]
# reorder rows
treeModel=treeModel[c("Dou", "Lä","Ki","Fi",  "Bu","Ei",  "Lb"),]
colnames(treeModel)<-c("Douglas fir", "Larch", "Pine", "Spruce", "Beech", "Oak", "Other deciduous trees")
rownames(treeModel)<-c("Douglas fir", "Larch", "Pine", "Spruce", "Beech", "Oak", "Other deciduous trees")

write.xlsx(treeModel, "data/003_validation/tables/treeSpecies_and_map_cm.xlsx", sheetName = "Tree species model2", 
           col.names = TRUE, row.names = TRUE, append = TRUE)

#------------------
map=readRDS("data/003_validation/confusionMatrix/Map_SentinelLidar_cm.RDS")
map=as.data.frame.matrix(map$table)
#reorder column names
map=map[,c("Dou_Qua", "Dou_Dim", "Dou_Rei", "Lä_Dim", "Lä_Rei", "Ki_Dim", "Ki_Rei", "Fi_Qua", "Fi_Dim", "Fi_Rei", 
           "Bu_Qua", "Bu_Dim", "Bu_Rei", "Ei_Qua", "Ei_Dim", "Ei_Rei")]
# reorder rows
map=map[c("Dou_Qua", "Dou_Dim", "Dou_Rei", "Lä_Dim", "Lä_Rei", "Ki_Dim", "Ki_Rei", "Fi_Qua", "Fi_Dim", "Fi_Rei", 
          "Bu_Qua", "Bu_Dim", "Bu_Rei", "Ei_Qua", "Ei_Dim", "Ei_Rei"),]

colnames(map)<-c("Douglas fir qualification", "douglas fir dimensioning", "Douglas fir maturing", "Larch dimensioning", "Larch maturing", "Pine dimensioning", "Pine maturing", "Spruce qualification", "Spruce dimensioning", "Spruce maturing", 
                 "Beech qualification", "Beech dimensioning", "Beech maturing", "Oak qualification", "Oak dimensioning", "Oak maturing")

rownames(map)<-c("Douglas fir qualification", "douglas fir dimensioning", "Douglas fir maturing", "Larch dimensioning", "Larch maturing", "Pine dimensioning", "Pine maturing", "Spruce qualification", "Spruce dimensioning", "Spruce maturing", 
                 "Beech qualification", "Beech dimensioning", "Beech maturing", "Oak qualification", "Oak dimensioning", "Oak maturing")


write.xlsx(map, "data/003_validation/tables/treeSpecies_and_map_cm.xlsx", sheetName = "Map confusion matrix", 
           col.names = TRUE, row.names = TRUE, append = TRUE)


# 5 - lidar models evaluation ####
#--------------------------------#

for (i in c("Dou", "Ei", "Lb", "La",  "Bu", "Ki","Fi")){
  #i="Fi"
  cm=readRDS(sprintf("data/003_validation/confusionMatrix/%s_Lidar_cm.RDS",i))
  cm=create_cm(cm=cm)
  write.xlsx(cm, "data/003_validation/tables/successional_stages_cm.xlsx", sheetName = paste0(i, "_Lidar"), 
             col.names = TRUE, row.names = TRUE, append = TRUE)
  rm(cm)
}
