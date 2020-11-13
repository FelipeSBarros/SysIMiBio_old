# loading library ----
library(dbplyr)
library(dplyr)
library(RPostgres)
library(DBI)
library(readr)
library(sf)
library(tmap)
library(smoothr)
library(ggplot2)
library(spatstat)
library(raster)

# Create a connection to the database ----
con <- dbConnect(RPostgres::Postgres(), dbname = 'imibio', 
                 host = 'localhost', # i.e. 'ec2-54-83-201-96.compute-1.amazonaws.com'
                 port = 5432, # or any other port specified by your DBA
                 user = 'postgres',
                 password = 'M1gu3lL4nus#')


# loading sf data from postgis ----
# loading observation and converting to posgar2007 argentina 7
occs_sf <- st_read(
  dsn = con,
  layer = 'obs_misiones',
  #query = "select species, geom_original from obs_misiones",
  as_tibble = TRUE,
  geometry_column = "geom_original"
) %>% mutate(id = row_number()) %>% st_transform(crs = 5349) %>% filter(!is.na(decimalLatitude) | !is.na(decimalLongitude)) %>% dplyr::select(id, species, geom_original)

# Provincia
misiones_sf <- st_read(
  dsn = con,
  layer = 'provincias',
  as_tibble = TRUE,
  geometry_column = "geom"
) %>% filter(provincia == 'Misiones') %>% st_transform(crs = 5349)

# data transformation/creation ----
# EOO
# Changing to multipoint 
spp_sf <- occs_sf %>%
  group_by(species) %>%
  summarise() %>% 
  mutate(id = row_number()) 

# creating convex hulls
spEOOs <- st_convex_hull(spp_sf)

# tm_shape(misiones_sf) + 
#   tm_borders() + 
#   tm_shape(spEOOs) + 
#   tm_borders()


# creating grid
landscapes <- misiones_sf %>%
  st_make_grid(square = FALSE, cellsize = 10750) %>% # more to get closer to 1ha
  #st_intersection(misiones) %>%
  #st_cast("MULTIPOLYGON") %>%
  st_sf() %>%
  mutate(cellid = row_number(),
         area_ha = st_area(.) * 1e-4)

tm_shape(landscapes) +
  tm_borders()
# Theselandscape sizes, ranging from 5000 up to 10,000 ha, are consistent with previous studies that quantified the effects habitat lossand fragmentation on biodiversity in the Atlantic Forest (e.g.,Crouzeilleset al.2014, Tambosiet al.2014)

# Calculating amount occs for each landscape
occs <- landscapes %>%
  st_join(occs_sf) %>%
  mutate(overlap = ifelse(!is.na(id), 1, NA)) %>%
  group_by(cellid) %>%
  summarize(num_obs = sum(overlap)) %>% st_drop_geometry()

# richness
# cell richness
richness <- landscapes %>%
  st_join(spp_sf) %>%
  mutate(overlap = ifelse(!is.na(id), 1, NA)) %>%
  group_by(cellid) %>%
  summarize(num_species = sum(overlap)) %>%  st_drop_geometry()

# convex hull richness
eoo <- landscapes %>%
  st_join(spEOOs) %>%
  mutate(overlap = ifelse(!is.na(id), 1, NA)) %>%
  group_by(cellid) %>%
  summarize(num_eoo = sum(overlap)) %>%  st_drop_geometry()

landscapes <- landscapes %>% left_join(occs) %>% left_join(richness)%>% left_join(eoo) %>% dplyr::select(cellid, num_obs, num_species, num_eoo, geometry)

# saving  grid to postgis ----
# st_write(landscapes,
#  "./MisionesLandScape.shp", delete_layer = TRUE)

landscapeOccs <- tm_shape(landscapes) +
  tm_polygons("num_obs", style = "fisher", palette = "viridis", title = "", textNA = "Sin datos",
              legend.format = c(text.separator = "-")) +
  tm_layout(main.title = "Cantidad de registros", frame.lwd = 0.5) +
  tm_grid(lwd = 0, projection = 4326) + 
  tm_compass(position = c("left", "top")) +
  tm_scale_bar() 
tmap_save(landscapeOccs, "./img/Landscape_Occs.png")


riquezaSpp <- tm_shape(landscapes) +
  tm_polygons("num_species", style = "fisher", palette = "viridis", title = "", textNA = "Sin datos",
              legend.format = c(text.separator = "-")) +
  tm_layout(main.title = "Riqueza especies", frame.lwd = 0.5) +
  tm_grid(lwd = 0, projection = 4326) + 
  tm_compass(position = c("left", "top")) +
  tm_scale_bar() 
tmap_save(riquezaSpp, "./img/Landscape_RiquezaSpp.png")

# tm_shape(landscapes) +
#   tm_polygons("num_eoo", style = "fisher", palette = "viridis")

# primera ordem ----
#Creando PPP
occs.ppp <- ppp(
  st_coordinates(occs_sf)[,1],
  st_coordinates(occs_sf)[,2],
  window = as.owin(misiones_sf)
)

# kernel ----
fc_scott <- bw.scott(occs.ppp)

occs_kernel <- density.ppp(occs.ppp, sigma = 15000)
occs_kernel <- raster(occs_kernel)
crs(occs_kernel) <- crs(occs_sf)
densidad <- tm_shape(occs_kernel) + 
  tm_raster(style = "fisher", palette = "viridis", legend.show = FALSE) + 
  tm_layout(main.title = "Densidad de registros", frame.lwd = 0.5) +
  tm_grid(lwd = 0, projection = 4326) + 
  tm_compass(position = c("left", "top")) +
  tm_scale_bar() 
tmap_save(densidad, "Densidad_registros.png")

# analsisis
glimpse(landscapes)
max(landscapes$num_species, na.rm = T)

# tentando identificar outliers
ggplot(landscapes, aes(x = num_obs)) + geom_histogram() +
  theme_minimal() +
  xlab("cantidad de observaciones") 
# parece que num_obs > 17000 ja apresenta outliers
ggsave("./img/histogram_obs.png")

ggplot(landscapes, aes(x = log(num_obs))) + geom_histogram() +
  theme_minimal() +
  xlab("cantidad de observaciones") 

ggplot(landscapes, aes(y = num_obs)) + geom_boxplot() +
  theme_minimal() +
  ylab("cantidad de observaciones") 

ggplot(landscapes, aes(y = log(num_obs))) + geom_boxplot() +
  theme_minimal() +
  ylab("cantidad de observaciones") 

# num_species
ggplot(landscapes, aes(x = num_species)) + geom_histogram( bins = 30) +
  theme_minimal() +
  xlab("cantidad de especies") 
# num_species > 7500 ja sao ouliers
ggplot(landscapes, aes(x = log(num_species))) + geom_histogram() +
  theme_minimal() +
  xlab("cantidad de especies") 


ggplot(landscapes, aes(y = num_species)) + geom_boxplot() +
  theme_minimal() +
  ylab("cantidad de especies") 

ggplot(landscapes, aes(y = log(num_species))) + geom_boxplot() +
  theme_minimal() +
  ylab("cantidad de especies") 


# teste com error padrão
t <- landscapes %>% group_by(num_obs) %>% 
  summarise(
    evg = mean(num_species),
    se = sd(num_species)/sqrt(n()),
    semin = se*-1
  )

ggplot() +
  geom_errorbar(data=t, mapping=aes(x=num_obs, ymin=semin, ymax=se), width=0.2, size=1) + 
  geom_point(data=t, mapping=aes(x=num_obs, y=evg)) 


# Sem outlier
ggplot(landscapes, aes(x = num_obs, y = num_species)) + geom_point() +
  geom_smooth() +
  xlab("cantidad de observaciones") +
  ylab("cantidad de especies")

# filtrando por num_obs
landscapes %>% filter(num_obs < 17000) %>% ggplot(aes(x = num_obs, y = num_species)) + geom_point() +
  geom_smooth() +
  xlab("cantidad de observaciones") +
  ylab("cantidad de especies")
ggsave("./img/curva_colecta.png")


# filtrando por num_obs
landscapes %>% filter(num_species < 7500) %>% ggplot(aes(x = num_obs, y = num_species)) + geom_point() +
  geom_smooth(method = 'gam') +
  xlab("cantidad de observaciones") +
  ylab("cantidad de especies")
# ggsave("./img/curva_colecta.png")
