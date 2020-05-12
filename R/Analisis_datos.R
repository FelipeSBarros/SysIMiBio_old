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
      clase %in% c("Myxini", "Hyperoartia", "Chondrichthyes", "Actinopterygii", "Sarcopterygii",
                       "Mammalia", "Aves", "Amphibia", "Reptilia", "Magnoliopsida", "Insecta", "Arachnida",
                       "Rodophyta", "Chlorophyta", "Phaeophyceae", "Chrysophyceae", 
                       "Euglenoidea", "Ellobiopsea", "Dinophyceae",
                   "Cycadopsida", "Ginkgoopsida", "Pinopsida", "Gnetopsida") |
      order %in% c("Coleoptera", "Lepidoptera", "Diptera", "Hymenoptera", "Decapoda", "Asterales") |
      family == "Formicidae"
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
      clase %in% c("Cycadopsida", "Ginkgoopsida", "Pinopsida", "Gnetopsida") ~'Gimnospermas',
      
      order == "Coleoptera"  ~ 'Escarabajos',
      order == "Lepidoptera" ~ 'Mariposas',
      order == 'Decapoda' ~ 'Decápodos (dulceacuícolas y terrestres)',
      order == "Diptera" ~ 'Dípteros',
      order %in% c(
        "Nymphaeales", "Austrobaileyales", "Magnoliopsida",
        "Ranunculales", "Sabiales", "Trochodendrales", "Buxales", "Gunnerales",
        "Beberberidopsidales", "Dilleniales", "Caryophyllales", "Santanales",
        "Saxifragales", "Vitales", "Celastrales", "Curcubitales", "Fabales", 
        "Fagales", "Malpighiales", "Oxalidales", "Rosales", "Zyogophyllales",
        "Brassicales", "Crossosomatales", "Geraniales", "Huerteales", "Malvales",
        "Myrtales", "Picramniales", "Sapindales", "Acirales", "Alismatales", 
        "Petrosaviales", "Dioscoreales", "Pandanales", "Liliales", "Asparagales",
        "Arecales", "Commelinales", "Zingiberales", "Poales", "Asterales") ~'Angiospermas',

      family == "Formicidae" ~'Hormigas',
      family == "Apidae" ~'Abejas',
      family == 'Dasypogonaceae' ~'Angiospermas',
      
      TRUE ~ order)) %>% 
  group_by(grupo) %>% 
  summarise(spp_total = sum(spp_total, na.rm=TRUE)) %>%
  arrange(desc(spp_total)) %>% collect()

# Grupos para Misiones Txt ----
occs %>%
  group_by(kingdom, phylum, clase, order, family) %>% 
  summarise(spp_total = count(distinct(species))) %>%
  arrange(desc(spp_total)) %>% 
  ungroup() %>% 
  filter(
    stateProvince == 'Misiones',
    kingdom %in% c('Fungi', "Protozoa", "Bacteria") |
      phylum == "Mollusca" |
      clase %in% c("Myxini", "Hyperoartia", "Chondrichthyes", "Actinopterygii", "Sarcopterygii",
                   "Mammalia", "Amphibia", "Magnoliopsida", "Insecta", "Arachnida",
                   "Rodophyta", "Chlorophyta", "Phaeophyceae", "Chrysophyceae", 
                   "Euglenoidea", "Ellobiopsea", "Dinophyceae",
                   "Cycadopsida", "Ginkgoopsida", "Pinopsida", "Gnetopsida") |
      order %in% c("Coleoptera", "Lepidoptera", "Diptera", "Hymenoptera", "Decapoda", "Asterales") |
      family == "Formicidae"
  ) %>% 
  mutate(
    grupo = dplyr::case_when(
      kingdom == 'Fungi' ~'Hongos',
      kingdom %in% c("Bacteria", 'Protozoa') ~'Protozoos y Bacterias',
      
      phylum == "Mollusca" ~"Moluscos",
      
      clase %in% c("Myxini", "Hyperoartia", "Chondrichthyes", 
                   "Actinopterygii", "Sarcopterygii") ~ 'Peces',
      clase %in% c("Rodophyta", "Chlorophyta", "Phaeophyceae", 
                   "Chrysophyceae", "Euglenoidea", 
                   "Ellobiopsea", "Dinophyceae") ~ 'Algas (dulceacuícolas y terrestres)',
      clase %in% c("Cycadopsida", "Ginkgoopsida", "Pinopsida", "Gnetopsida") ~'Gimnospermas',
      
      order == "Coleoptera"  ~ 'Escarabajos',
      order == "Lepidoptera" ~ 'Mariposas',
      order == 'Decapoda' ~ 'Decápodos (dulceacuícolas y terrestres)',
      order == "Diptera" ~ 'Dípteros',
      order %in% c(
        "Nymphaeales", "Austrobaileyales", "Magnoliopsida",
        "Ranunculales", "Sabiales", "Trochodendrales", "Buxales", "Gunnerales",
        "Beberberidopsidales", "Dilleniales", "Caryophyllales", "Santanales",
        "Saxifragales", "Vitales", "Celastrales", "Curcubitales", "Fabales", 
        "Fagales", "Malpighiales", "Oxalidales", "Rosales", "Zyogophyllales",
        "Brassicales", "Crossosomatales", "Geraniales", "Huerteales", "Malvales",
        "Myrtales", "Picramniales", "Sapindales", "Acirales", "Alismatales", 
        "Petrosaviales", "Dioscoreales", "Pandanales", "Liliales", "Asparagales",
        "Arecales", "Commelinales", "Zingiberales", "Poales", "Asterales") ~'Angiospermas',
      
      family == "Formicidae" ~'Hormigas',
      family == "Apidae" ~'Abejas',
      family == 'Dasypogonaceae' ~'Angiospermas',
      
      TRUE ~ order)) %>% 
  group_by(grupo) %>% 
  summarise(spp_total = sum(spp_total, na.rm=TRUE)) %>%
  arrange(desc(spp_total)) %>% collect()
