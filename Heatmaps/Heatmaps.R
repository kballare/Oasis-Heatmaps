####Make Heat Map Tables####

setwd("~/Desktop/Oasis Analyses/Heatmaps")
 bioindicator_90_names <- read.csv("bioindicator_90_taxa_names.csv")
S19_16SFITS <- read.csv("S19_16SFITS_bindrows_forheatmap.csv")
bioindicator_11_names <- read.csv("bioindicator_11_taxanames.csv")



library(dplyr)
bioindicator_90_S19_freq <- left_join(bioindicator_90_names, S19_16SFITS, by="sum.taxonomy")
bioindicator_11_S19_freq <- left_join(bioindicator_11_names, S19_16SFITS, by="sum.taxonomy")

#write csvs to fix sample names and import to heatmapper
write.csv(bioindicator_11_S19_freq, "bioindicator_11_S19_freq.csv")
write.csv(bioindicator_90_S19_freq, "bioindicator_90_S19_freq.csv")

#heatmap function
library(ggmap)#Load libraries
library(ggplot2)
hpars<-read.table("hpars.dat")#Read in the density data
positions <- data.frame(lon=rnorm(20000, mean=-75.1803458, sd=0.05),
                        lat=rnorm(10000,mean=39.98352197, sd=0.05))#Simulate some geographical coordinates #Switch out for your data that has real GPS coords
map <- get_map(location=c(lon=-75.1803458,
                          lat=39.98352197), zoom=11, maptype='roadmap', color='bw')#Get the map from Google Maps
ggmap(map, extent = "device") +
  geom_density2d(data = positions, aes(x = lon, y = lat), size = 0.3) +
  stat_density2d(data = positions,
                 aes(x = lon, y = lat, fill = ..level.., alpha = ..level..), size = 0.01,
                 bins = 16, geom = "polygon") + scale_fill_gradient(low = "green", high = "red") +
  scale_alpha(range = c(0, 0.3), guide = FALSE)#Plot
