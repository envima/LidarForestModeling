#'@name 070_plot_variable_importance.R
#'@author Lisa Bald [bald@staff.uni-marburg.de]
#'@date 14.06.2023
#'@description plot variable importance



# 1 - setup ####
#--------------#

library(ggplot2)
library(dplyr)
library(forcats)

# 2 - load variable tables for naming convention ####
#---------------------------------------------------#

sentinel=read.csv("data/003_validation/tables/sentinel_indices.csv", sep=";", header=T)
colnames(sentinel)<-c("Label","Name" ,"Description","Reference" ) 

sentinel=sentinel[,c(1,2)]
sentinel[sentinel == ''] <- NA
sentinel=na.omit(sentinel)

sentinel=rbind(data.frame(Label=paste0(sentinel$Label, "_MONTH_01"), Name=paste0(sentinel$Name, " January")),
               data.frame(Label=paste0(sentinel$Label, "_MONTH_03"), Name=paste0(sentinel$Name, " March")),
               data.frame(Label=paste0(sentinel$Label, "_MONTH_04"), Name=paste0(sentinel$Name, " April")),
               data.frame(Label=paste0(sentinel$Label, "_MONTH_05"), Name=paste0(sentinel$Name, " May")),
               data.frame(Label=paste0(sentinel$Label, "_MONTH_06"), Name=paste0(sentinel$Name, " June")),
               data.frame(Label=paste0(sentinel$Label, "_MONTH_09"), Name=paste0(sentinel$Name, " September")),
               data.frame(Label=paste0(sentinel$Label, "_MONTH_10"), Name=paste0(sentinel$Name, " October"))
)
sentinel$category="Sentinel"

lidar=read.csv("data/003_validation/tables/lidar_indices.csv", sep=",", header = T)
colnames(lidar)<- c("Label","Name" , "Description")
lidar[lidar == ''] <- NA
lidar=na.omit(lidar)
lidar=lidar[,c(1,2)]
lidar[lidar$Label == "BE_H_MAX",]$Name <- "CH max"
lidar[lidar$Label == "BE_PR_CAN",]$Name <- "PR canopy"
lidar[lidar$Label == "vegetation_coverage_01m_CHM",]$Name <- "VC 1m"
lidar[lidar$Label == "dtm_elevation_max",]$Name <- "Elev max"
lidar$category="Lidar"

vars=rbind(lidar, sentinel);rm(lidar,sentinel)


# 3 - prepare data ####
#---------------------#

data=do.call(rbind,lapply(c("Lb",  "Dou",  "La", "Ei", "Bu", "Fi", "Ki"), function(treeSpecies){
  
  senLidar=readRDS(sprintf("data/002_modelling/models/%s_SentinelLidar.RDS", treeSpecies))
  sen=readRDS(sprintf("data/002_modelling/models/%s_Sentinel.RDS", treeSpecies))
  
  varNamesSen=data.frame(name=sen$selectedvars, Label=NA, order=1:length(sen$selectedvars))
  varNamesSen=merge(varNamesSen,vars, by.x="name", by.y = "Label", all.x = T, all.y = F)
  varNamesSen=varNamesSen%>%dplyr::arrange(order)
  sen$selectedvars<- varNamesSen$Name
  
  varNamesSenLidar=data.frame(name=senLidar$selectedvars, Label=NA, order=1:length(senLidar$selectedvars))
  varNamesSenLidar=merge(varNamesSenLidar,vars, by.x="name", by.y = "Label", all.x = T, all.y = F)
  varNamesSenLidar=varNamesSenLidar%>%dplyr::arrange(order)
  senLidar$selectedvars<- varNamesSenLidar$Name
  
  
  # Dataset 1: one value per group
  dataSentinel <- data.frame(
    name=c(paste(sen$selectedvars[1],"&", sen$selectedvars[2]),sen$selectedvars[-c(1:2)]),
    val=sen$selectedvars_perf,
    sd=sen$selectedvars_perf_SE,
    treeSpecies=treeSpecies,
    model="spectral model"#,
    #category=
  )
  
  # Dataset 1: one value per group
  dataSentinelLidar <- data.frame(
    name=c(paste(senLidar$selectedvars[1],"&", senLidar$selectedvars[2]),senLidar$selectedvars[-c(1:2)]),
    val=senLidar$selectedvars_perf,
    sd=senLidar$selectedvars_perf_SE,
    treeSpecies=treeSpecies,
    model="hybrid model"
  )
  
  data=rbind(dataSentinel, dataSentinelLidar)
  
  
  data$val=1-data$val
  
  # rename german to english:
  if (treeSpecies== "Bu") data[data$treeSpecies == "Bu",]$treeSpecies <- "Beech"
  if (treeSpecies== "Dou")data[data$treeSpecies == "Dou",]$treeSpecies <- "Douglas fir"
  if (treeSpecies== "Ei")data[data$treeSpecies == "Ei",]$treeSpecies <- "Oak"
  if (treeSpecies== "Fi")data[data$treeSpecies == "Fi",]$treeSpecies <- "Spruce"
  if (treeSpecies== "Ki")data[data$treeSpecies == "Ki",]$treeSpecies <- "Pine"
  if (treeSpecies== "La")data[data$treeSpecies == "La",]$treeSpecies <- "Larch"
  if (treeSpecies== "Lb")data[data$treeSpecies == "Lb",]$treeSpecies <- "Other deciduous trees"
  #data[data$treeSpecies == "Lbl",]$treeSpecies <- "Longlived deciduous-trees"
  #data[data$treeSpecies == "Lbk",]$treeSpecies <- "Shortlived deciduous-trees"
  
  # define modeling approach
  data$modellingApproach=paste0(data$treeSpecies, " ", data$model)
  
  return(data)
}))









# 4 - plot variable importance of successional stages ####
#--------------------------------------------------------#

for(i in unique(data$modellingApproach)){
  
  assign(i,data %>% dplyr::filter(modellingApproach == i) %>%
           # mutate(Name = forcats::fct_reorder(Name, desc(val))) %>%
           ggplot( aes(x=forcats::fct_reorder(name, val), y=val)) +
           geom_point(stat="identity", color="black",size=4) +
           geom_segment(aes(x=name, xend=name, y=0, yend=val), color="black")+
           coord_flip() +
           xlab("") + ylab("")+
           # ylim(0.3,0.9)+
           #scale_y_continuous(limits = c(0.3,0.9))
           theme_bw()+
           #theme_minimal()+
           #theme_light()+
           facet_wrap(~modellingApproach, ncol = 2, scales="free")+
           theme(strip.text = element_text(size=13))
         
  )
  # ggsave(pl, filename=sprintf("data/003_validation/plots/var_imp_%s.png",i), dpi=300, units = "mm", width = 100, height = 75)
  
}


# save plots variable importance
p1=gridExtra::grid.arrange(`Douglas fir spectral model`, `Douglas fir hybrid model`,
                           `Larch spectral model`, `Larch hybrid model`,
                           `Pine spectral model`, `Pine hybrid model`,
                           `Spruce spectral model`, `Spruce hybrid model`, ncol=2)
ggsave(p1, filename=sprintf("data/003_validation/plots/varImp1_original.png"), dpi=300, units = "mm", width = 250, height = 300)

p2=gridExtra::grid.arrange(`Beech spectral model`, `Beech hybrid model`,
                           `Oak spectral model`, `Oak hybrid model`,
                           `Other deciduous trees spectral model`, `Other deciduous trees hybrid model`, ncol=2)



ggsave(p2, filename=sprintf("data/003_validation/plots/varImp2_original.png"), dpi=300, units = "mm", width = 250, height = 300)



# 3 - plot variable importance of tree species models ####
#--------------------------------------------------------#

mod=readRDS("data/002_modelling/models/7TS_SentinelLidar.RDS")

varNames=data.frame(name=mod$selectedvars, Label=NA, order=1:length(mod$selectedvars))
varNames=merge(varNames,vars, by.x="name", by.y = "Label", all.x = T, all.y = F)
varNames=varNames%>%dplyr::arrange(order)
#mod$selectedvars<- varNamesmod$Name


# Dataset 1: one value per group
data <- data.frame(
  name=c(paste(mod$selectedvars[1],"&", mod$selectedvars[2]),mod$selectedvars[-c(1:2)]),
  val=mod$selectedvars_perf,
  sd=mod$selectedvars_perf_SE,
  modellingApproach="Tree species groups"
)




data$val=1- data$val


p=data %>% 
  # mutate(name = forcats::fct_reorder(name, desc(val))) %>%
  ggplot( aes(x=forcats::fct_reorder(name, val), y=val)) +
  geom_point(stat="identity", color="black",size=4) +
  geom_segment(aes(x=name, xend=name, y=0, yend=val), color="black")+
  coord_flip() +
  xlab("") + ylab("")+
  # ylim(0.3,0.9)+
  #scale_y_continuous(limits = c(0.3,0.9))
  theme_bw()+
  #theme_minimal()+
 # theme_light()+
  facet_wrap(~modellingApproach, ncol = 2, scales="free")+
  theme(strip.text = element_text(size=13))




ggsave(p, filename=sprintf("data/003_validation/plots/varImp_treeSpecies_original.png"), dpi=300, units = "mm", width = 200, height = 100)


