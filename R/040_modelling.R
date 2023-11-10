#'@name 040_modelling.R
#'@date 14.06.2023
#'@author Lisa Bald [bald@staff.uni-marburg.de]
#'@description train random forest models with sentinel ord sentinel and lidar variables for tree species and successional stages
#'@include R/functions/par_ffs.R
#'@include R/functions/modelling.R


# 1 - set up ####
#---------------#

libs=c("dplyr","sf","dplyr","raster","terra", "caret", "CAST", "parallel", "foreach", "randomForest", "doParallel", "future", "telegram.bot")
lapply(libs, require, character.only = TRUE)
source("R/functions/par_ffs.R")
source("R/functions/modelling.R")

# 2 - train successional stages rf Sentinel ####
#----------------------------------------------#

for(i in c( "La", "Lbk", "Lbl", "Dou", "Ei", "Fi", "Ki", "Bu", "Lb")){
  print(i)
  if(!file.exists(sprintf("data/002_modelling/models/%s_Sentinel.RDS", i))){
    
    data=readRDS(sprintf("data/002_modelling/modelling/train/balanced_%s_80_percent_train.RDS", i))
    
    ffsmodel=modelling(predResp=data, responseType = i, 
                       responseColName = "Phase", 
                       predictorsColNo = 1:210, 
                       spacevar = "quality_ID",
                       ncores=60
    )
    
    saveRDS(ffsmodel, sprintf("data/002_modelling/models/%s_Sentinel.RDS", i))
    rm(data, ffsmodel)
  }
}

# 3 - train successional stages rf Sentinel and Lidar ####
#--------------------------------------------------------#

for(i in c( "La", "Lbk", "Lbl", "Dou", "Ei", "Fi", "Ki", "Bu", "Lb")){
  print(i)
  if(!file.exists(sprintf("data/002_modelling/models/%s_SentinelLidar.RDS", i))){
    
    data=readRDS(sprintf("data/002_modelling/modelling/train/balanced_%s_80_percent_train.RDS", i))
    
    ffsmodel=modelling(predResp=data, responseType = i, 
                       responseColName = "Phase", 
                       predictorsColNo = 1:239, 
                       spacevar = "quality_ID",
                       ncores=60
    )
    
    saveRDS(ffsmodel, sprintf("data/002_modelling/models/%s_SentinelLidar.RDS", i))
    rm(data, ffsmodel)
  }
}

# 4 - train successional stages rf  Lidar ####
#--------------------------------------------------------#

for(i in c( "La", "Dou", "Ei", "Fi", "Ki", "Bu", "Lb")){
  print(i)
  if(!file.exists(sprintf("data/002_modelling/models/%s_Lidar.RDS", i))){
    
    data=readRDS(sprintf("data/002_modelling/modelling/train/balanced_%s_80_percent_train.RDS", i))
    
    ffsmodel=modelling(predResp=data, responseType = i, 
                       responseColName = "Phase", 
                       predictorsColNo = 211:239, 
                       spacevar = "quality_ID",
                       ncores=60
    )
    
    saveRDS(ffsmodel, sprintf("data/002_modelling/models/%s_Lidar.RDS", i))
    rm(data, ffsmodel)
  }
}


# 4 - train treeSpecies rf Sentinel (& LiDAR) ####
#------------------------------------------------#

for(i in c("8TS", "7TS")){
  print(i)
  #i="7TS100Perc"
  data=readRDS(sprintf("data/002_modelling/modelling/treeSpecies/balanced_%s_80_percent_train.RDS",i))
  if(!file.exists(sprintf("data/002_modelling/models/%s_Sentinel.RDS", i))){
    
    ffsmodel=modelling(predResp=data, responseType = i, 
                       responseColName = "BAGRu", 
                       predictorsColNo = 1:210, 
                       spacevar = "LLO_ID",
                       ncores=55
    )
    saveRDS(ffsmodel, sprintf("data/002_modelling/models/%s_Sentinel.RDS", i))
    rm( ffsmodel)
  }
  
  if(!file.exists(sprintf("data/002_modelling/models/%s_SentinelLidar.RDS", i))){
    
    ffsmodel=modelling(predResp=data, responseType = i, 
                       responseColName = "BAGRu", 
                       predictorsColNo = 1:239, 
                       spacevar = "LLO_ID",
                       ncores=55
    )
    
    saveRDS(ffsmodel, sprintf("data/002_modelling/models/%s_SentinelLidar.RDS", i))
  }
  rm(data, ffsmodel)
  
}
