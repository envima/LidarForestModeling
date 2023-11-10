#' @name 006_extraction.R
#' @description 
#' @docType function
#' @param pol sf object
#' @param rasterStack terra rast object
#' @param bufferSize default = -10
#' @param idColName string default = "FAT_ID"
#' @return 
#' 


libs=c("parallel","sf","dplyr","raster","terra")
lapply(libs, require, character.only = TRUE)




# 1- load raster ####
#-------------------#
`%not_in%` <- purrr::negate(`%in%`)


listVRT = list.files("data/001_raw_data/force/data/mosaic/")
dates = c("MONTH_01", "MONTH_02", "MONTH_03", "MONTH_04", "MONTH_05", "MONTH_06",
          "MONTH_07", "MONTH_08", "MONTH_09", "MONTH_10", "MONTH_11", "MONTH_12")
n = paste(rep(substr(listVRT, 32, 34), each = length(dates)), dates, sep = "_")
r = terra::rast(list.files("data/001_raw_data/force/mosaic/", full.names = T))
names(r) <- n

r = subset(r, -c(1:12))
r = subset(r, -c(217:228))
r = subset(r, -c(181:192))
r = subset(r, -c(145:156))

rm(dates, listVRT,n)
# reduce variables
patterns=c("MONTH_02", "MONTH_07", "MONTH_08", "MONTH_11", "MONTH_12")
vars = names(r)[grepl(paste(patterns, collapse="|"), names(r))]
vars2 = names(r)[names(r)%not_in%vars]
r = subset(r, vars2)


# 2 - lidar####
#------------------------#

lidar=terra::rast(list.files("data/001_raw_data/lidar/data",full.names=T, pattern=".tif$"))


#-----------------------------------------------------

rasterStack=terra::rast(list(r,lidar))
rasterStack=raster::stack(rasterStack)
rm(r,lidar,patterns,vars,vars2)

extraction <- function(rasterStack = r, pol = sf::read_sf("data/001_raw_data/FID/trainingsgebiete_quality_ID.gpkg"), bufferSize = -10) {
  
  
  
  
  
  #pol = sf::st_transform(pol, crs(rasterStack))  
  if (bufferSize != 0) {
    pol = st_buffer(pol, dist = bufferSize)
    pol = pol[!st_is_empty(pol),]
  }
  pol = sf::st_transform(pol, crs(rasterStack)) 
  pol2= pol;rm(pol)
  bagru = unique (pol2$BAGRu)
  for (i in seq(length(bagru)))  {
    if (!file.exists( paste0("data/002_modelling/extract/extract_", bagru[i], ".RDS"))){
      print(bagru[i])
      pol = pol2[pol2$BAGRu == bagru[i],]
      
      # extract all polygons from raster stack
      result = mclapply(seq(nrow(pol)), function(j){
        
        # Sentinel data
        cur = pol[j,]
        #ext <- raster::ext(sf::st_buffer(cur, 10))
        #sen = raster::crop(rasterStack, cur)
        
        
        
        # extract -------------------------------------------
        
        
        df = raster::extract(rasterStack, cur, df = TRUE)
        
        df = df %>% dplyr::mutate(FAT_ID = cur$FAT__ID,
                                  LLO_ID = cur$LLO_ID,
                                  quality_ID=cur$quality_ID,
                                  quality=cur$quality,
                                  BAGRu = cur$BAGRu,
                                  #  BA_Text = cur$BA_Text,
                                  Phase=cur$Phase)
        df$ID <- NULL
        
        # filter NDVI for decidious and coniferous trees
        
        #if(unique(df$BAGRu) %in% c("Bu", "Ei","Lä" ,"Lbk", "Lbl")){
        #  df =df%>%dplyr::filter(NDV_MONTH_01 < 7000)
        #  
        #}else{
        #  #filter all decidious trees out:
        #  df =df%>%dplyr::filter(ND1_MONTH_06 < 7000)
        #  
        #}
        
        
        
        #---------------------------
        
        print(paste("Extracted Polygon", j, "of", nrow(pol)))
        return(df)
        
      }, mc.cores = 20
      ) # end lapply
      
      res = result[sapply(result, is.data.frame)]
      res = do.call(rbind, res)
      saveRDS(res, paste0("data/002_modelling/extract/extract_", bagru[i], ".RDS"))
      
    }
  }
} # end of function
