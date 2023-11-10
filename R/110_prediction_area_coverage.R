#'@name 110_prediction_area_coverage.R
#'@date 18.07.2023
#'@author Lisa Bald [bald@staff.uni-marburg.de]
#'@description number of pixel of each class of the predictions
#'

library(terra)

data=data.frame(class=c("Bu", "Dou", "Ei", "Fi", "Ki", "La", "Lb", "Bu_Qua", "Bu_Dim", "Bu_Rei",
                        "Dou_Qua", "Dou_Dim", "Dou_Rei", "Ei_Qua", "Ei_Dim", "Ei_Rei","Fi_Qua",
                        "Fi_Dim", "Fi_Rei", "Ki_Dim", "Ki_Rei", "La_Dim", "La_Rei", "Lb_Qua", "Lb_Dim",
                        "Lb_Rei"),
                size=NA)





for(i in c("Bu", "Dou", "Ei", "Fi","Ki", "La", "Lb")){
  
  r=terra::rast(sprintf("data/002_modelling/prediction/7TS_%s_SentinelLidar_pred.tif", i))
  v=terra::values(r, na.rm=T)
  
 
  if(i %in% c("Bu", "Dou", "Ei", "Fi", "Lb")){
    Qua=length(v[v==2])
    Dim=length(v[v==1])
    Rei=length(v[v==3])
    
    data[data$class == i,]$size <-length(v)
    data[data$class == paste0(i, "_Qua"),]$size <- Qua
    data[data$class == paste0(i, "_Dim"),]$size <- Dim
    data[data$class == paste0(i, "_Rei"),]$size <- Rei
  } else if (i %in% c("La", "Ki")){
    Dim=length(v[v==1])
    Rei=length(v[v==2])
    data[data$class == i,]$size <-length(v)
    data[data$class == paste0(i, "_Dim"),]$size <- Dim
    data[data$class == paste0(i, "_Rei"),]$size <- Rei
    
  }
}


data$m2 <- data$size*100
data$km2 <- data$m2/1e+6

colnames(data)<-c("class","no_pixels","m2","km2")

write.csv(data, "data/003_validation/tables/flaechenabdeckung_predictions.csv")




