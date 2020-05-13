# load libraries ----
library(dbplyr)
library(dplyr)
library(RPostgres)
library(DBI)
library(ggplot2)

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
occs %>%
  group_by(kingdom, phylum, clase, order, family) %>% 
  summarise(spp_total = count(distinct(species))) %>%
  arrange(desc(spp_total)) %>% 
  ungroup() %>% 
  filter(
    kingdom %in% c('Fungi', "Protozoa", "Bacteria") |
      phylum == "Mollusca" |
      clase %in% c(
        "Mammalia", "Aves", "Amphibia", "Reptilia",
        "Myxini", "Hyperoartia", "Chondrichthyes", "Actinopterygii", "Sarcopterygii", # peces
        "Rodophyta", "Chlorophyta", "Phaeophyceae", "Chrysophyceae", "Euglenoidea", "Ellobiopsea", "Dinophyceae", # algas
        
        "Magnoliopsida", "Insecta", "Arachnida",
                       "Rodophyta", "Chlorophyta", "Phaeophyceae", "Chrysophyceae", 
                       "Euglenoidea", "Ellobiopsea", "Dinophyceae",
                   "Cycadopsida", "Ginkgoopsida", "Pinopsida", "Gnetopsida") |
      order %in% c("Coleoptera", "Lepidoptera", "Decapoda", "Diptera", 
                   "Cycadales", "Ginkgoales", "Pinales", "Gnatales", # plantas
                   "Amborellales", "Nymphaeales", "Austrobaileyales",
                   'Chloranthales', "Magnoliales", "Laurales", "Canellales",
                   "Piperales", "Acorales", "Alismatales", "Petrosaviales",
                   "Dioscoreales", "Pandanales", "Liliales", "Asparagales",
                   "Arecales", "Poales", "Commelinales", "Zingiberales",
                   "Ceratophyllales", "Ranunculales", "Sabiaceae",
                   "Proteales", "Trochodendrales", "Buxales",
                   "Gunnerales", "Dillniaceae", "Saxifragales",
                   "Vitales", "Zygophyllales", "Celatrales",
                   "Oxalidades", "Malpighiales", "Fabales",
                   "Rosales", "Cucurbitales", "Fagales",
                   "Geraniales", "Myrtales", "Crossosomatales",
                   "Picramniales", "Sapindales", "Huerteales",
                   "Malvales", "Brassicales", "Santalales",
                   "Berberidopsiadales", "Caryopphyllales",
                   "Cornales", "Ericales", "Garryales", "Gentianales",
                   "Solanales", "Boraginales", "Lamiales",
                   "Aquifoliales", "Asterales", "Escalloniales",
                   "Bruniales", "Apiales", 
                   "Paracryphiales", "Dipsacales" # plantas
                   ) |
      family %in% c("Formicidae", "Apidae") # hormigas y abejas
    ) %>% 
  mutate(
    grupo = dplyr::case_when(
      kingdom == 'Fungi' ~'Hongos',
      kingdom %in% c("Bacteria", 'Protozoa') ~'Protozoos y Bacterias',
      
      phylum == "Mollusca" ~"Moluscos",
      
      clase == "Mammalia" ~ "Mamiferos",
      clase == "Aves" ~ "Aves",
      clase == "Amphibia" ~"Amphibia",
      clase == "Reptilia" ~"Reptilia",
      clase %in% c("Myxini", "Hyperoartia", "Chondrichthyes", 
                   "Actinopterygii", "Sarcopterygii") ~ 'Peces',
      clase %in% c("Rodophyta", "Chlorophyta", "Phaeophyceae", 
                   "Chrysophyceae", "Euglenoidea", 
                   "Ellobiopsea", "Dinophyceae") ~ 'Algas (dulceacuícolas y terrestres)',
      #clase %in% c("Cycadopsida", "Ginkgoopsida", "Pinopsida", "Gnetopsida") ~'Gimnospermas',
      
      order == "Coleoptera"  ~ 'Escarabajos',
      order == "Lepidoptera" ~ 'Mariposas',
      order == 'Decapoda' ~ 'Decápodos (dulceacuícolas y terrestres)',
      order == "Diptera" ~ 'Dípteros',
      order %in% c("Cycadales", "Ginkgoales", "Pinales", "Gnatales",
                   "Amborellales", "Nymphaeales", "Austrobaileyales",
                   'Chloranthales', "Magnoliales", "Laurales", "Canellales",
                   "Piperales", "Acorales", "Alismatales", "Petrosaviales",
                   "Dioscoreales", "Pandanales", "Liliales", "Asparagales",
                   "Arecales", "Poales", "Commelinales", "Zingiberales",
                   "Ceratophyllales", "Ranunculales", "Sabiaceae",
                   "Proteales", "Trochodendrales", "Buxales",
                   "Gunnerales", "Dillniaceae", "Saxifragales",
                   "Vitales", "Zygophyllales", "Celatrales",
                   "Oxalidades", "Malpighiales", "Fabales",
                   "Rosales", "Cucurbitales", "Fagales",
                   "Geraniales", "Myrtales", "Crossosomatales",
                   "Picramniales", "Sapindales", "Huerteales",
                   "Malvales", "Brassicales", "Santalales",
                   "Berberidopsiadales", "Caryopphyllales",
                   "Cornales", "Ericales", "Garryales", "Gentianales",
                   "Solanales", "Boraginales", "Lamiales",
                   "Aquifoliales", "Asterales", "Escalloniales",
                   "Bruniales", "Apiales", 
                   "Paracryphiales", "Dipsacales") ~'Angiospermas',

      family == "Formicidae" ~'Hormigas',
      family == "Apidae" ~'Abejas',
      #family == 'Dasypogonaceae' ~'Angiospermas',
      
      TRUE ~ order)) %>% 
  group_by(grupo) %>% 
  summarise(spp_total = sum(spp_total, na.rm=TRUE)) %>%
  arrange(desc(spp_total)) %>% collect() %>% 
  write.csv("./output/GruposArgentina.csv")

# Grupos para Misiones Txt ----
