#'@name evaluation.R
#'@author Lisa Bald [bald@staff.uni-marburg.de]
#'@date 31.03.2023
#'@description calculate confusion matrices for all models


# 1 - set up ####
#---------------#

libs=c("dplyr","sf","dplyr","raster","terra", "caret", "CAST", "parallel", "foreach", "randomForest", "doParallel", "future", "telegram.bot", "ggplot2", "tidyverse")
lapply(libs, require, character.only = TRUE)


# 2 - confusion matrices successional stages models ####
#------------------------------------------------------#

for(treeSpecies in c(  "Dou",  "La", "Ei",  "Bu","Ki", "Fi", "Lb")){
  print(treeSpecies)
  #treeSpecies="Lb"
  testData=readRDS(sprintf("data/002_modelling/modelling/test/balanced_%s_20_percent_test.RDS", treeSpecies))
  testData=na.omit(testData)
  colnames(testData)<- gsub("-", "_", colnames(testData))
  
  # load models
  senLidar=readRDS(sprintf("data/002_modelling/models/%s_SentinelLidar.RDS", treeSpecies))
  sen=readRDS(sprintf("data/002_modelling/models/%s_Sentinel.RDS", treeSpecies))
  lidar=readRDS(sprintf("data/002_modelling/models/%s_Lidar.RDS", treeSpecies))
  
  # confusion matrix sentinel lidar
  if(!file.exists(sprintf("data/003_validation/confusionMatrix/%s_SentinelLidar_cm.RDS", treeSpecies))){
    evalSenLidar=data.frame(observed=testData$Phase, predicted=predict(senLidar, testData))
    cmSenLidar = caret::confusionMatrix(table(evalSenLidar$predicted, evalSenLidar$observed))
    saveRDS(cmSenLidar , sprintf("data/003_validation/confusionMatrix/%s_SentinelLidar_cm.RDS", treeSpecies))
  }
  # confusion matrix sentinel
  if(!file.exists(sprintf("data/003_validation/confusionMatrix/%s_Sentinel_cm.RDS", treeSpecies))){
    evalSen=data.frame(observed=testData$Phase, predicted=predict(sen, testData))
    cmSen = caret::confusionMatrix(table(evalSen$predicted, evalSen$observed))
    saveRDS(cmSen , sprintf("data/003_validation/confusionMatrix/%s_Sentinel_cm.RDS", treeSpecies))
  }
  
  # confusionmatrix lidar
  if(!file.exists(sprintf("data/003_validation/confusionMatrix/%s_Lidar_cm.RDS", treeSpecies))){
    evalLidar=data.frame(observed=testData$Phase, predicted=predict(lidar, testData))
    cmLidar = caret::confusionMatrix(table(evalLidar$predicted, evalLidar$observed))
    saveRDS(cmLidar , sprintf("data/003_validation/confusionMatrix/%s_Lidar_cm.RDS", treeSpecies))
  }
  
  
  
  # tidy up
  rm(cmSen, cmSenLidar, evalSen, evalSenLidar, senLidar, sen, testData, evalLidar, cmLidar)
}




# 3 - confusion matrices tree species stages models ####
#------------------------------------------------------#


data=lapply(c(  "Dou",  "La", "Ei",  "Bu","Ki", "Fi", "Lb"), function(treeSpecies){
  print(treeSpecies)
  # treeSpecies="Lb"
  testData=readRDS(sprintf("data/002_modelling/modelling/test/balanced_%s_20_percent_test.RDS", treeSpecies))
  testData=na.omit(testData)
  if(treeSpecies=="Lb"){
    testData[testData$BAGRu %in% c("Lbl", "Lbk"),]$BAGRu <- "Lb"
  }
  
  colnames(testData)<- gsub("-", "_", colnames(testData))
  mod=readRDS("data/002_modelling/models/7TS_SentinelLidar.RDS")
  
  
  evalSenLidar=data.frame(predicted=factor(predict(mod, testData), levels = c("Dou","Lä","Ei","Bu","Ki","Fi","Lb")),
                          observed=factor(testData$BAGRu, levels = c("Dou","Lä","Ei","Bu","Ki","Fi","Lb")))
  
  evalSenLidar=na.omit(evalSenLidar)
  return(evalSenLidar)
  
})

data2=do.call(rbind, data)


data3=data2 %>% 
  group_by(observed) %>%
  slice_sample(n = min(table(data2$observed)))


cm=caret::confusionMatrix(table(data3$predicted, data3$observed))
saveRDS(cm, "data/003_validation/confusionMatrix/7TS_SentinelLidar_cm.RDS")



# 4 - confusion matrix tree species AND sucessional stages ####
#-------------------------------------------------------------#

l=c(paste0(c("Bu", "Dou","Ei","Fi"), "_","Qua"), paste0(c("Bu", "Dou","Ei","Fi","Ki","Lä"), "_", "Dim"),paste0(c("Bu", "Dou","Ei","Fi","Ki","Lä"), "_", "Rei"))

data=lapply(c(  "Dou",  "La", "Ei",  "Bu","Ki", "Fi"), function(treeSpecies){
  print(treeSpecies)
  # treeSpecies="Lb"
  testData=readRDS(sprintf("data/002_modelling/modelling/test/balanced_%s_20_percent_test.RDS", treeSpecies))
  testData=na.omit(testData)
  if(treeSpecies=="Lb"){
    testData[testData$BAGRu %in% c("Lbl", "Lbk"),]$BAGRu <- "Lb"
  }
  
  colnames(testData)<- gsub("-", "_", colnames(testData))
  
  senLidar=readRDS(sprintf("data/002_modelling/models/%s_SentinelLidar.RDS", treeSpecies))
  mod=readRDS("data/002_modelling/models/7TS_SentinelLidar.RDS")
  
  
  evalSenLidar=data.frame(predicted=factor(paste0(predicted_ts=predict(mod, testData), "_",  predict(senLidar, testData)), levels=l),
                          observed=factor(paste0(testData$BAGRu , "_", testData$Phase), levels=l))
  
  evalSenLidar=na.omit(evalSenLidar)
  return(evalSenLidar)
  
})

data2=do.call(rbind, data)

#data_beech=data2%>%dplyr::filter(observed %in% c("Lä_Dim","Lä_Rei"))

data3=data2 %>% 
  group_by(observed) %>%
  slice_sample(n = min(table(data2$observed)))


cm=caret::confusionMatrix(data3$predicted, data3$observed)
saveRDS(cm, "data/003_validation/confusionMatrix/Map_SentinelLidar_cm.RDS")

