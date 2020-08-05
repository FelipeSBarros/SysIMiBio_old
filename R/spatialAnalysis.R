# loading library ----
library(dbplyr)
library(dplyr)
library(RPostgres)
library(DBI)
library(readr)
library(sf)
library(tmap)
library(smoothr)

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
# Theselandscape sizes, ranging from 5000 up to 10,000 ha, are consis-tent with previous studies that quantified the effects habitat lossand fragmentation on biodiversity in the Atlantic Forest (e.g.,Crouzeilleset al.2014, Tambosiet al.2014)

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
tmap_save(landscapeOccs, "Landscape_Occs.png")


riquezaSpp <- tm_shape(landscapes) +
  tm_polygons("num_species", style = "fisher", palette = "viridis", title = "", textNA = "Sin datos",
              legend.format = c(text.separator = "-")) +
  tm_layout(main.title = "Riqueza especies", frame.lwd = 0.5) +
  tm_grid(lwd = 0, projection = 4326) + 
  tm_compass(position = c("left", "top")) +
  tm_scale_bar() 
tmap_save(riquezaSpp, "Landscape_RiquezaSpp.png")

# tm_shape(landscapes) +
#   tm_polygons("num_eoo", style = "fisher", palette = "viridis")

# primera ordem ----
library(spatstat)
library(raster)

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
