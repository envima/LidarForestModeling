#'@name 080_plot_results_successional_stages.R
#'@author Lisa Bald [bald@staff.uni-marburg.de]
#'@date 14.06.2023
#'@description plot results successional stages



# 1 - setup ####
#--------------#

library(ggplot2)
library(dplyr)


# 2 - plot confusion matrix as percentage barplot ####
#----------------------------------------------------#


data=do.call(rbind,lapply(c("Dou", "Ei",  "La", "Lbl", "Lbk", "Bu", "Ki","Fi"), function(x){
  
  print(x)
  data=readRDS(sprintf("data/003_validation/confusionMatrix/%s_Sentinel_cm.RDS", x))
  data=as.data.frame(data$table)
  data$Var1<-as.character(data$Var1)
  data$Var2<-as.character(data$Var2)
  
  
  data[data$Var1=="Rei",]$Var1<-"Maturing"
  data[data$Var2=="Rei",]$Var2<-"Maturing"
  
  
  if(any(unique(data$Var1) %in% c("Qua"))){
    data[data$Var1=="Qua",]$Var1<-"Qualification"
    data[data$Var2=="Qua",]$Var2<-"Qualification"
  }
  
  data[data$Var1=="Dim",]$Var1<-"Dimensioning"
  data[data$Var2=="Dim",]$Var2<-"Dimensioning"
  
  
  # data$Var1<-as.factor(data$Var1)
  #  levels(data$Var1)<-c("Rei", "Dim", "Qua")
  #  data$Var2<-as.factor(data$Var2)
  #  levels(data$Var2)<-c("Rei", "Dim", "Qua")
  data$treeSpecies=x
  data$method="Sentinel"
  data2=data
  
  # data sentinel lidar
  
  data=readRDS(sprintf("data/003_validation/confusionMatrix/%s_SentinelLidar_cm.RDS", x))
  data=as.data.frame(data$table)
  data$Var1<-as.character(data$Var1)
  data$Var2<-as.character(data$Var2)
  

    data[data$Var1=="Rei",]$Var1<-"Maturing"
    data[data$Var2=="Rei",]$Var2<-"Maturing"
  
  
  if(any(unique(data$Var1) %in% c("Qua"))){
    data[data$Var1=="Qua",]$Var1<-"Qualification"
    data[data$Var2=="Qua",]$Var2<-"Qualification"
  }
  
  data[data$Var1=="Dim",]$Var1<-"Dimensioning"
  data[data$Var2=="Dim",]$Var2<-"Dimensioning"
  
  
  # data$Var1<-as.factor(data$Var1)
  #  levels(data$Var1)<-c("Rei", "Dim", "Qua")
  #  data$Var2<-as.factor(data$Var2)
  #  levels(data$Var2)<-c("Rei", "Dim", "Qua")
  data$treeSpecies=x
  data$method="Sentinel & LiDAR"
  
  data=rbind(data, data2)
  
  return(data)
  
}))


data[data$treeSpecies == "Bu",]$treeSpecies <- "Beech"
data[data$treeSpecies == "Dou",]$treeSpecies <- "Douglas fir"
data[data$treeSpecies == "Ei",]$treeSpecies <- "Oak"
data[data$treeSpecies == "Fi",]$treeSpecies <- "Spruce"
data[data$treeSpecies == "Ki",]$treeSpecies <- "Pine"
data[data$treeSpecies == "La",]$treeSpecies <- "Larch"
data[data$treeSpecies == "Lbl",]$treeSpecies <- "Longlived deciduous-trees"
data[data$treeSpecies == "Lbk",]$treeSpecies <- "Shortlived deciduous-trees"


data$modelingApproach=paste(data$treeSpecies, data$method)



data$Var1=as.factor(data$Var1)
levels(data$Var1) <- c(    "Maturing" , "Dimensioning", "Qualification"  )
data$Var2=as.factor(data$Var2)
levels(data$Var2) <- c(    "Maturing" , "Dimensioning", "Qualification"  )

# Stacked + percent
ggplot(data, aes(fill=Var1, y=Freq, x=Var2)) + 
  geom_bar(position="fill", stat="identity")+ coord_flip()+facet_wrap(~modelingApproach, ncol=2)+xlab("Successional stage")+ylab("Percentage")+labs(fill="Successional stage")




