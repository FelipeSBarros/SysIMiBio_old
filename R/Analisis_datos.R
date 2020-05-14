# load libraries ----
library(data.table)
library(dbplyr)
library(dplyr)
library(RPostgres)
library(DBI)
library(ggplot2)
library(readr)

# Create a connection to the database ----
# Connect to a specific postgres database i.e. Heroku
con <- dbConnect(RPostgres::Postgres(), dbname = 'imibio', 
                 host = 'localhost', # i.e. 'ec2-54-83-201-96.compute-1.amazonaws.com'
                 port = 5432, # or any other port specified by your DBA
                 user = 'postgres',
                 password = 'M1gu3lL4nus#')

# test query ----
dbGetQuery(con, "select count(*) from sndb_occurrences")

# connecting to sndb_occurrences ----
occs <- tbl(con, "sndb_occurrences")

# initial analysis ----
# total species by class
occs %>%
  group_by(clase) %>% 
  summarise(spp_total = count(distinct(species))) %>% collect()
# couting total species and showing grouped by class
occs %>%
  group_by(clase) %>% 
  summarise(spp_total = count(distinct(species))) %>%
  arrange(desc(spp_total)) %>% 
  show_query()

spp_byClass <- occs %>%
  group_by(clase) %>% 
  summarise(spp_total = count(distinct(species))) %>%
  arrange(desc(spp_total)) %>% collect()


occs %>%
  group_by(clase) %>% 
  summarise(spp_total = count(distinct(species))) %>%
  arrange(desc(spp_total)) %>% 
  filter( clase %in% c("Myxini", "Hyperoartia", "Chondrichthyes", "Actinopterygii", "Sarcopterygii",
                       "Mammalia", "Amphibia", "Magnoliopsida", "Insecta", "Arachnida",
                       "Rodophyta", "Chlorophyta", "Phaeophyceae", "Chrysophyceae", 
                       "Euglenoidea", "Ellobiopsea", "Dinophyceae")) %>% 
  mutate(grupo = dplyr::case_when(
    clase %in% c("Myxini", "Hyperoartia", "Chondrichthyes", "Actinopterygii", "Sarcopterygii") ~ 'peces',
    clase %in% c("Rodophyta", "Chlorophyta", "Phaeophyceae", "Chrysophyceae", "Euglenoidea", "Ellobiopsea", "Dinophyceae") ~ 'Algas (dulceacuícolas y terrestres)',
    TRUE ~ clase)
  ) %>% group_by(grupo) %>% 
  summarise(spp_total = sum(spp_total, na.rm=TRUE)) %>% collect()


occs %>%
  group_by(kingdom, phylum, order, family) %>% 
  summarise(spp_total = count(distinct(species))) %>%
  arrange(desc(spp_total)) %>% 
  ungroup() %>% 
  filter(order %in% c("Coleoptera", "Lepidoptera", "Diptera", "Hymenoptera", "Decapoda") | 
           family == "Formicidae" |
           phylum == "Mollusca" |
           kingdom %in% c('Fungi', "Protozoa", "Bacteria")) %>% 
  mutate(
    grupo = dplyr::case_when(
      order == "Coleoptera"  ~ 'Escarabajos',
      order == "Lepidoptera" ~ 'Mariposas',
      order == 'Decapoda' ~ 'Decápodos (dulceacuícolas y terrestres)',
      order == "Diptera" ~ 'Dípteros',
      family == "Formicidae" ~'Hormigas',
      family == "Apidae" ~'Abejas',
      phylum == "Mollusca" ~"Moluscos",
      kingdom == 'Fungi' ~'Hongos',
      kingdom %in% c("Bacteria", 'Protozoa') ~'Protozoos y Bacterias',
      TRUE ~ order)) %>% 
  group_by(grupo) %>% 
  summarise(spp_total = sum(spp_total, na.rm=TRUE)) %>% collect()

# Grupos para Argentina ----
gruposArgentina <- occs %>%
  filter(
    taxonRank == 'SPECIES',
    taxonomicStatus == 'ACCEPTED',
    kingdom %in% c(
      'Fungi', "Protozoa", "Bacteria", "Plantae", "Animalia") |
      phylum %in% c(
        "Arthropoda", "Mollusca") |
      clase %in% c(
        "Aves", "Mammalia", "Amphibia", "Reptilia", 
        "Actinopterygii", "Elasmobranchii", "Insecta", "Arachnida", "Malacostraca")) %>% 
  group_by(kingdom, phylum, clase) %>% 
  summarise(spp_total = count(distinct(species))) %>%
  arrange(desc(spp_total)) %>% 
  ungroup() %>% 
      mutate(
        grupo = dplyr::case_when(
          
          # peces
          (kingdom == "Animalia" & clase %in%
             c('Actinopterygii', 'Elasmobranchii')) ~'Reino Animalia y Clases Peces', # reino Animalia Y clases definidas
          
          # Aves
          (kingdom == "Animalia" & clase == "Aves") ~ 'Reino Animalia y Order Aves',
          
          (kingdom == "Animalia" & clase == "Mammalia") ~ 'Reino Animalia y Clase Mammalia',
          
          (kingdom == "Animalia" & clase == "Amphibia") ~ 'Reino Animalia y Order Amphibia',
          
          (kingdom == "Animalia" & clase == "Reptilia") ~ 'Reino Animalia y Order Reptilia',
          
          (kingdom == "Animalia" & phylum == "Arthropoda") ~ 'Reino Animalia y phylum Arthropoda',
          (kingdom == "Animalia" & phylum == "Arthropoda" &
             clase == 'Insecta') ~ 'Reino Animalia y phylum Arthropoda y clase Insecta',
          (kingdom == "Animalia" & phylum == "Arthropoda" &
             clase == 'Arachnida') ~ 'Reino Animalia y phylum Arthropoda y clase Arachnida',
          (kingdom == "Animalia" & phylum == "Arthropoda" &
             clase == 'Malacostraca') ~ 'Reino Animalia y phylum Arthropoda y clase Malacostraca',
          
          (kingdom == "Animalia" & phylum == "Mollusca") ~ 'Reino Animalia y phylum Mollusca',
          
          kingdom == "Plantae" ~"Plantas",
          kingdom == "Animalia" ~"Animales",
          kingdom == 'Fungi' ~'Hongos',
          kingdom == "Bacteria" ~'Bacterias',
          kingdom == 'Protozoa' ~'Protozoos'#,
          
          #TRUE ~ "No cumplió ninguna regla"
          )) %>% 
      group_by(grupo) %>% 
      summarise(spp_total = sum(spp_total, na.rm=TRUE)) %>%
      arrange(desc(spp_total)) %>% collect()
#gruposArgentina %>% 
 # write_csv("./output/GruposArgentina.csv")

# Grupos para Misiones Txt ----
gruposMisiones <- occs %>%
  filter(
    taxonRank == 'SPECIES',
    taxonomicStatus == 'ACCEPTED',
    stateProvince %like% '%siones',
    kingdom %in% c(
      'Fungi', "Protozoa", "Bacteria", "Plantae", "Animalia") |
      phylum %in% c(
        "Arthropoda", "Mollusca") |
      clase %in% c(
        "Aves", "Mammalia", "Amphibia", "Reptilia", 
        "Actinopterygii", "Elasmobranchii", "Insecta", "Arachnida", "Malacostraca")) %>% 
  group_by(kingdom, phylum, clase) %>% 
  summarise(spp_total = count(distinct(species))) %>%
  arrange(desc(spp_total)) %>% 
  ungroup() %>% 
  mutate(
    grupo = dplyr::case_when(
      
      # peces
      (kingdom == "Animalia" & clase %in%
         c('Actinopterygii', 'Elasmobranchii')) ~'Reino Animalia y Clases Peces', # reino Animalia Y clases definidas
      
      # Aves
      (kingdom == "Animalia" & clase == "Aves") ~ 'Reino Animalia y Order Aves',
      
      (kingdom == "Animalia" & clase == "Mammalia") ~ 'Reino Animalia y Clase Mammalia',
      
      (kingdom == "Animalia" & clase == "Amphibia") ~ 'Reino Animalia y Order Amphibia',
      
      (kingdom == "Animalia" & clase == "Reptilia") ~ 'Reino Animalia y Order Reptilia',
      
      (kingdom == "Animalia" & phylum == "Arthropoda") ~ 'Reino Animalia y phylum Arthropoda',
      (kingdom == "Animalia" & phylum == "Arthropoda" &
         clase == 'Insecta') ~ 'Reino Animalia y phylum Arthropoda y clase Insecta',
      (kingdom == "Animalia" & phylum == "Arthropoda" &
         clase == 'Arachnida') ~ 'Reino Animalia y phylum Arthropoda y clase Arachnida',
      (kingdom == "Animalia" & phylum == "Arthropoda" &
         clase == 'Malacostraca') ~ 'Reino Animalia y phylum Arthropoda y clase Malacostraca',
      
      (kingdom == "Animalia" & phylum == "Mollusca") ~ 'Reino Animalia y phylum Mollusca',
      
      kingdom == "Plantae" ~"Plantas",
      kingdom == "Animalia" ~"Animales",
      kingdom == 'Fungi' ~'Hongos',
      kingdom == "Bacteria" ~'Bacterias',
      kingdom == 'Protozoa' ~'Protozoos'#,
      
      #TRUE ~ "No cumplió ninguna regla"
    )) %>% 
  group_by(grupo) %>% 
  summarise(spp_total = sum(spp_total, na.rm=TRUE)) %>%
  arrange(desc(spp_total)) %>% collect()

#gruposMisiones %>% 
 # write_csv("./output/GruposMisiones.csv")

# Merging data
(gruposArgentina <- read_csv("./output/GruposArgentina.csv"))
(gruposMisiones <- read_csv("./output/GruposMisiones.csv"))
mergedData <- gruposArgentina %>% left_join(gruposMisiones,suffix = c("_Ar", "_Mis"), by = "grupo")
mergedData %>% 
  mutate(
    "perc_Mis" = (spp_total_Mis/spp_total_Ar) * 100
  ) %>% arrange(desc(perc_Mis)) %>% 
  write_csv("./output/Grupos_ArgentinaMisiones.csv")

# Teste sf ----
library(sf)
spp_sf <- st_read(
  dsn = con,
  layer = 'sndb_occurrences',
  #query = "select species, geom_original from sndb_occurrences",
  EWKB = TRUE,
  quiet = FALSE,
  as_tibble = FALSE,
  geometry_column = "geom_original"
)
