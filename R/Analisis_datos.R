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
ObsMisiones <- tbl(con, "obs_misiones")

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
    taxonomicStatus == 'ACCEPTED') %>% 
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
#gruposArgentina %>% 
 # write_csv("./output/GruposArgentina.csv")

# Grupos para Misiones Txt ----
gruposMisiones <- occs %>%
  filter(
    taxonRank == 'SPECIES',
    taxonomicStatus == 'ACCEPTED',
    stateProvince %like% '%siones') %>% 
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

#gruposMisiones %>% 
 # write_csv("./output/GruposMisiones.csv")

# Merging data
(gruposArgentina <- read_csv("./output/GruposArgentina.csv"))
(gruposMisiones <- read_csv("./output/GruposMisiones.csv"))
mergedData <- gruposArgentina %>% right_join(gruposMisiones,suffix = c("_Ar", "_Mis"), by = "grupo")
mergedData <- mergedData %>% 
  mutate(
    "perc_Mis" = (spp_total_Mis/spp_total_Ar) * 100
  ) %>%
  rename(Argentina = spp_total_Ar,
         Misiones = spp_total_Mis) %>%
  arrange(desc(perc_Mis))
mergedData %>% 
  write_csv("./output/Grupos_ArgentinaMisiones.csv")

# Grupo Misiones TXT y sp ----
gruposMisiones2 <- ObsMisiones %>%
  filter(
    taxonRank == 'SPECIES',
    taxonomicStatus == 'ACCEPTED') %>% 
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

#gruposMisiones2 %>% 
# write_csv("./output/GruposMisiones2.csv")

# Merging data
(gruposArgentina <- read_csv("./output/GruposArgentina.csv"))
(gruposMisiones <- read_csv("./output/GruposMisiones.csv"))
(gruposMisiones2 <- read_csv("./output/GruposMisiones2.csv"))
mergedData <- gruposArgentina %>% right_join(gruposMisiones,suffix = c("_Ar", "_Mis"), by = "grupo")
mergedData <- mergedData %>% right_join(gruposMisiones2, by = "grupo") %>%
  rename(
    riqueza_Ar = spp_total_Ar,
    riqueza_Mis = spp_total_Mis,
    riqueza_MisTXTSP = spp_total)
mergedData <- mergedData %>% 
  mutate(
    "perc_MisTXT" = (riqueza_Mis/riqueza_Ar) * 100,
    "perc_MisTXTSP" = (riqueza_MisTXTSP/riqueza_Ar) * 100
  ) %>%
  arrange(desc(perc_MisTXTSP))
mergedData %>% 
  write_csv("./output/Grupos_ArgentinaMisiones.csv")

