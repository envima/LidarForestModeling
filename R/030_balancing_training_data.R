#'@name 030_balancing_training_data.R
#'@date 22.03.2023
#'@author Lisa Bald [bald@staff.uni-marburg.de]
#'@description balance the data extracted data for successional stages and tree species models
#'@dependencies: sf, terra, raster, dplyr
#'@include R/functions/balancing_tree_species.R

# 1 - load libraries and functions ####
#-------------------------------------#

libs=c("dplyr","sf","dplyr","raster","terra")
lapply(libs, require, character.only = TRUE)

source("R/functions/balancing_tree_species.R")
# load helper function:
`%not_in%` <- purrr::negate(`%in%`)

# 2 - balance data for successional stages models ####
#----------------------------------------------------#

for (treeSpecies in c("La","Lbk","Ki", "Lbl","Bu", "Ei", "Dou", "Fi")){
  print(treeSpecies)
  pred_resp = readRDS(sprintf("data/002_modelling/extract/2022/extract_%s.RDS",treeSpecies))
  pred_resp$quality_ID<-paste0(pred_resp$LLO_ID, "_", pred_resp$Phase)
  if(treeSpecies %in% c("La", "Ki")){
    balanced= balancing(pred_resp = pred_resp, idCol="quality_ID", response="Phase", class=c("Dim", "Rei"))
  }else{
    balanced= balancing(pred_resp = pred_resp, idCol="quality_ID", response="Phase", class=c("Qua", "Dim", "Rei"))
  }
  
  saveRDS(balanced, sprintf("data/002_modelling/modelling/balanced_%s.RDS", treeSpecies))
  
  # check balancing
  print( unique(table(balanced$quality_ID)))
  
  print( balanced %>%
           group_by(Phase) %>%
           dplyr::summarize(number_of_distinct_locations = n_distinct(quality_ID)))
  
  print(table(balanced$Phase))
  rm(pred_resp, balanced)
}

# 2.1 - balance successional stages model all decidious trees ####
#--------------------------------------------------------------#

lbk = readRDS("data/002_modelling/extract/2022/extract_Lbk.RDS")
lbl = readRDS("data/002_modelling/extract/2022/extract_Lbl.RDS")
pred_resp=rbind(lbk,lbl);rm(lbk,lbl)
pred_resp$quality_ID<-paste0(pred_resp$LLO_ID, "_", pred_resp$Phase)
balanced= balancing(pred_resp = pred_resp, idCol="quality_ID", response="Phase", class=c("Qua", "Dim", "Rei"))
saveRDS(balanced, "data/002_modelling/modelling/balanced_Lb.RDS")
rm(pred_resp, balanced)

# 3 - split train and test data successional stages (80/20)####
#-------------------------------------------------------------#


for (treeSpecies in c("Bu", "Ei", "Dou", "Fi", "Ki", "La", "Lbk", "Lbl", "Lb")){
  
  if(!dir.exists("data/002_modelling/modelling/train")) dir.create("data/002_modelling/modelling/train", recursive = T)
  if(!dir.exists("data/002_modelling/modelling/test")) dir.create("data/002_modelling/modelling/test", recursive = T)
  
  
  
  predResp=readRDS(sprintf("data/002_modelling/modelling/balanced_%s.RDS", treeSpecies))
  
  predResp_train <-   do.call(rbind,
                              lapply(1:n_distinct(predResp$Phase), function(i){
                                x=predResp%>%dplyr::filter(Phase == unique(predResp$Phase)[[i]])
                                colnames(x)<-gsub("-", "_",colnames(x))
                                n=colnames(x)
                                n=n[! n %in% c("band1", "dtm_surface_ratio","dsm_surface_ratio","chm_surface_ratio", "surface_intensity_mean")]
                                patterns=c("MONTH_02", "MONTH_07", "MONTH_08", "MONTH_11", "MONTH_12")
                                vars = n[grepl(paste(patterns, collapse="|"), n)]
                                vars2 = n[n%not_in%vars]
                                x = x[,vars2]
                                # divide in train and test data
                                ids=sample(unique(x$LLO_ID), n_distinct(x$LLO_ID)*0.8)
                                x = x%>%dplyr::filter(LLO_ID %in% ids)
                                return(x)
                              }))
  
  ids=unique(predResp_train$LLO_ID)
  predResp_test = predResp%>%dplyr::filter(LLO_ID %not_in% ids)
  
  saveRDS(predResp_train, sprintf("data/002_modelling/modelling/train/balanced_%s_80_percent_train.RDS", treeSpecies))  
  saveRDS(predResp_test, sprintf("data/002_modelling/modelling/test/balanced_%s_20_percent_test.RDS", treeSpecies))  
}


# 4 - balance tree species model ####
#-----------------------------------#

# balance data to train a tree species model but only use the data that is NOT in the testdata of the successional stages!

# load all test data
test=do.call(rbind,lapply(c( "La", "Lbk", "Lbl", "Dou", "Ei", "Fi", "Ki", "Bu"), function(i){ data=readRDS(sprintf("data/002_modelling/modelling/test/balanced_%s_20_percent_test.RDS", i))
return(data)}))
# get ids of test polygons
testIds=unique(test$LLO_ID);rm(test)

# load all extracted data
data=do.call(rbind,lapply(c( "La", "Lbk", "Lbl", "Dou", "Ei", "Fi", "Ki", "Bu"), function(i){ 
  data=readRDS(sprintf("data/002_modelling/extract/2022/extract_%s.RDS",i))
  return(data)}))

# filter all test polygons out and balance with all the other data
data=data%>%dplyr::filter(LLO_ID %not_in% testIds)
# balance remaining data for treeSpecies
balanced=balancing(pred_resp = data,idCol = "LLO_ID", class = c("Bu", "Dou", "Fi","Ki", "Lä", "Lbl", "Lbk", "Ei"))   
# save data
saveRDS(balanced, "data/002_modelling/modelling/balanced_8TS_without_sussession_test_data.RDS")

# check the balancing
print( unique(table(balanced$LLO_ID)))
print( balanced %>%
         group_by(BAGRu) %>%
         dplyr::summarize(number_of_distinct_locations = n_distinct(LLO_ID)))
print(table(balanced$BAGRu))

# check if IDs are not present:
any(balanced$LLO_ID %in% testIds)


# 5 - balance tree species with combined deciduous tree (7 classes) ####
#----------------------------------------------------------------------#

# balance data to train a tree species model but only use the data that is NOT in the testdata of the successional stages!

# load all test data
test=do.call(rbind,lapply(c( "La", "Lb", "Dou", "Ei", "Fi", "Ki", "Bu"), function(i){ data=readRDS(sprintf("data/002_modelling/modelling/test/balanced_%s_20_percent_test.RDS", i))
return(data)}))
# get ids of test polygons
testIds=unique(test$LLO_ID);rm(test)

# load all extracted data
data=do.call(rbind,lapply(c( "La", "Lbk", "Lbl", "Dou", "Ei", "Fi", "Ki", "Bu"), function(i){ 
  data=readRDS(sprintf("data/002_modelling/extract/2022/extract_%s.RDS",i))
  return(data)}))

data[data$BAGRu == "Lbk",]$BAGRu <- "Lb"
data[data$BAGRu == "Lbl",]$BAGRu <- "Lb"

# filter all test polygons out and balance with all the other data
data=data%>%dplyr::filter(LLO_ID %not_in% testIds)
# balance remaining data for treeSpecies
balanced=balancing(pred_resp = data,idCol = "LLO_ID", class = c("Bu", "Dou", "Fi","Ki", "Lä", "Lb", "Ei"))   
# save data
saveRDS(balanced, "data/002_modelling/modelling/balanced_7TS_without_sussession_test_data.RDS")

# check the balancing
print( unique(table(balanced$LLO_ID)))
print( balanced %>%
         group_by(BAGRu) %>%
         dplyr::summarize(number_of_distinct_locations = n_distinct(LLO_ID)))
print(table(balanced$BAGRu))

# check if IDs are not present:
any(balanced$LLO_ID %in% testIds)


# 6 - split train and test data tree species model ####
#-----------------------------------------------------#
for (treeSpecies in c("8TS", "7TS")){
  
  predResp=readRDS(sprintf("data/002_modelling/modelling/balanced_%s_without_sussession_test_data.RDS", treeSpecies))
  colnames(predResp)<- gsub("-","_", colnames(predResp))
  
  vars=colnames(readRDS("data/002_modelling/modelling/train/balanced_Bu_80_percent_train.RDS"))
  predResp$quality_ID=paste0(predResp$LLO_ID, "_", predResp$Phase)
  predResp=predResp[,vars]
  
  
  predResp_train <-   do.call(rbind,
                              lapply(1:n_distinct(predResp$BAGRu), function(i){
                                x=predResp%>%dplyr::filter(BAGRu == unique(predResp$BAGRu)[[i]])
                                ids=sample(unique(x$LLO_ID), n_distinct(x$LLO_ID)*0.8)
                                x = x%>%dplyr::filter(LLO_ID %in% ids)
                                return(x)
                              }))
  
  ids=unique(predResp_train$LLO_ID)
  predresptest = predResp%>%dplyr::filter(LLO_ID %not_in% ids)
  
  saveRDS(predResp_train, sprintf("data/002_modelling/modelling/treeSpecies/balanced_%s_80_percent_train.RDS", treeSpecies))  
  saveRDS(predresptest, sprintf("data/002_modelling/modelling/treeSpecies/balanced_%s_20_percent_test.RDS", treeSpecies))  
  
}




