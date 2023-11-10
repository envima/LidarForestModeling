#'@name 040_modelling.R
#'@date 14.06.2023
#'@author Lisa Bald [bald@staff.uni-marburg.de]
#'@description calculate the Dissimilarity index for all models

# 1 - set up ####
#---------------#

libs=c("dplyr", "CAST", "parallel", "foreach",  "doParallel")
lapply(libs, require, character.only = TRUE)

# 2 - calculate DI ####
#---------------------#

#doParallel::registerDoParallel(cl=parallel::makeCluster(8))
for(treeSpecies in c("Lbk", "Lbl",  "Dou",  "La", "Ei",  "Bu","Ki", "Fi", "7TS")) {
  print(treeSpecies)
  if(!file.exists(sprintf("data/002_modelling/trainDI/%s_SentinelLidar_trainDI.RDS", treeSpecies))){
    senLidar=readRDS(sprintf("data/002_modelling/models/%s_SentinelLidar.RDS", treeSpecies))
    trainDiSenLidar=CAST::trainDI(model = senLidar)
    saveRDS(trainDiSenLidar , sprintf("data/002_modelling/trainDI/%s_SentinelLidar_trainDI.RDS", treeSpecies))
    rm(trainDiSenLidar,senLidar)
  }
  
  
  if(!file.exists(sprintf("data/002_modelling/trainDI/%s_Sentinel_trainDI.RDS", treeSpecies))){
    sen=readRDS(sprintf("data/002_modelling/models/%s_Sentinel.RDS", treeSpecies))
    trainDiSen=CAST::trainDI(model=sen)
    saveRDS(trainDiSen , sprintf("data/002_modelling/trainDI/%s_Sentinel_trainDI.RDS", treeSpecies))
    rm(trainDiSen, sen)
  }
}
