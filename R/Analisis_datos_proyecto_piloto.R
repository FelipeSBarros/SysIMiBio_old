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

# connecting to sndb_occurrences ----
ObsProyPiloto <- tbl(con, "obs_proyecto_piloto")

# Grupo Proyecto Piloto ----
grupos <- ObsProyPiloto %>%
  filter(
    taxonRank == 'SPECIES',
    taxonomicStatus == 'ACCEPTED',
    basisOfRecord != "FOSSIL_SPECIMEN") %>% 
  mutate(
    grupo = dplyr::case_when(
      
      # Dicotiledoneas
      (kingdom == "Plantae" & phylum == "Tracheophyta" &
         clase == 'Magnoliopsida') ~ 'Dicotiledoneas',
      # Monocotiledoneas
      (kingdom == "Plantae" & phylum == "Tracheophyta" &
         clase == 'Liliopsida') ~ 'Monocotiledoneas',
      # Gismnospermas
      (kingdom == "Plantae" & phylum == "Tracheophyta" &
         ! clase %in% c("Liliopsida", "Magnoliopsida")) ~ 'Gimnospermas',
      
      # Insectos
      (kingdom == "Animalia" & phylum == "Arthropoda" &
         clase == 'Insecta') ~ 'Reino Animalia y phylum Arthropoda y clase Insecta',
      (kingdom == "Animalia" & phylum == "Arthropoda" &
         clase == 'Arachnida') ~ 'Reino Animalia y phylum Arthropoda y clase Arachnida',
      (kingdom == "Animalia" & phylum == "Arthropoda" &
         clase == 'Malacostraca') ~ 'Reino Animalia y phylum Arthropoda y clase Malacostraca',
      
      (kingdom == "Animalia" & phylum == "Arthropoda") ~ 'Reino Animalia y phylum Arthropoda',
      
      # Moluscos
      (kingdom == "Animalia" & phylum == "Mollusca") ~ 'Reino Animalia y phylum Mollusca',
      
      # Peces
      (kingdom == "Animalia" & clase %in%
         c('Actinopterygii', 'Elasmobranchii')) ~'Reino Animalia y Clases Peces', # reino Animalia Y clases definidas
      
      # Aves
      (kingdom == "Animalia" & clase == "Aves") ~ 'Reino Animalia y Clase Aves',
      # Mamalia
      (kingdom == "Animalia" & clase == "Mammalia") ~ 'Reino Animalia y Clase Mammalia',
      # Amphibia
      (kingdom == "Animalia" & clase == "Amphibia") ~ 'Reino Animalia y Order Amphibia',
      # Reptilia
      (kingdom == "Animalia" & clase == "Reptilia") ~ 'Reino Animalia y Order Reptilia',
      
      
      
      # Tracheophyta
      (kingdom == "Plantae" & phylum == "Tracheophyta") ~ 'Reino Plantae y phylum Tracheophyta',
      
      # Bryophytas
      (kingdom == "Plantae" & phylum == "Bryophyta") ~ 'Bryophyta',
      
      # Plantaes
      kingdom == "Plantae" ~"Plantas",
      # Animalea
      kingdom == "Animalia" ~"Animales",
      # Hongos
      kingdom == 'Fungi' ~'Hongos',
      # Bacterias
      kingdom == "Bacteria" ~'Bacterias',
      # Protozoos
      kingdom == 'Protozoa' ~'Protozoos',
      
      TRUE ~ "No cumplió ninguna regla"
    )) %>% 
  group_by(grupo) %>% 
  summarise(spp_total = count(distinct(species))) %>%
  arrange(desc(spp_total)) %>% collect()

# grupos %>% 
# write_csv("./output/GruposProyectoPiloto.csv")

# Listado spp Misiones -----
listaProyectoPiloto <- 
  ObsProyPiloto %>%
  filter(
    taxonRank == 'SPECIES',
    taxonomicStatus == 'ACCEPTED',
    basisOfRecord != "FOSSIL_SPECIMEN") %>% 
  mutate(
    grupo = dplyr::case_when(
      
      # Moluscos
      (kingdom == "Animalia" & phylum == "Mollusca") ~ 'Reino Animalia y phylum Mollusca',
      
      # Peces
      (kingdom == "Animalia" & clase %in%
         c('Actinopterygii', 'Elasmobranchii')) ~'Reino Animalia y Clases Peces', # reino Animalia Y clases definidas
      
      # Aves
      (kingdom == "Animalia" & clase == "Aves") ~ 'Reino Animalia y Clase Aves',
      # Mamalia
      (kingdom == "Animalia" & clase == "Mammalia") ~ 'Reino Animalia y Clase Mammalia',
      # Amphibia
      (kingdom == "Animalia" & clase == "Amphibia") ~ 'Reino Animalia y Order Amphibia',
      # Reptilia
      (kingdom == "Animalia" & clase == "Reptilia") ~ 'Reino Animalia y Order Reptilia',
      
      TRUE ~ "No cumplió ninguna regla"
    )) %>% 
  select(grupo, species) %>% 
  group_by(grupo, species) %>% 
  summarise(spp_total = count(distinct(species))) %>%
  arrange(grupo, species) %>% collect() %>% select(grupo, species)
listaProyectoPiloto %>% write_csv("./output/Lista_spp_proyectoPiloto600.csv")
