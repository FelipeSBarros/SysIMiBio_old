# install.packages("tidyverse")
library(dplyr, warn.conflicts = FALSE)
library(dbplyr)
library(ggplot2)
library(plotly)

# connecting to database
con <- DBI::dbConnect(RSQLite::SQLite(), '../db.sqlite3')

con
# dbListTables(con)
bio <- tbl(con, "biodiversity_gbif")
bio

# exploratory analysis ----

# General exploratory analysis ----

# "gbifID", "Publisher", "BasisOfRecord", "EventDate", "Year"
# Origen de los datos
bio %>%
  group_by(Publisher) %>% 
  summarise(Observaciones = count()) %>% 
  arrange(desc(Observaciones)) %>% 
  ggplot(aes(x = publisher, y = Observaciones)) + geom_col()
# tipo de observacion
bio %>%
  group_by(basisOfRecord) %>% 
  summarise(Observaciones = count()) %>% 
  arrange(desc(Observaciones)) %>% 
  ggplot(aes(x = basisOfRecord, y = Observaciones)) + geom_col()
# ano de observacion
bio %>%
  group_by(year) %>% 
  summarise(Observaciones = count()) %>% 
  arrange(desc(Observaciones)) %>% 
  ggplot(aes(x = year, y = Observaciones)) + geom_col()

# Taxonomic Exploratory analysis ----
"ScientificName", "HigherClassification", "Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "TaxonRank", "TaxonomicStatus", "Issue", "AcceptedScientificName"
# taxon rank
bio %>%
  group_by(taxonRank) %>% 
  summarise(Observaciones = count()) %>% 
  arrange(desc(Observaciones)) %>% 
  ggplot(aes(x = taxonRank, y = Observaciones)) + geom_col()


taxon = c("Kingdom", "Phylum", "Class", "Order", "Family", "Genus")
rep( si, no, )
fig <- plot_ly(
  type = "sankey",
  orientation = "h",
  
  node = list(
    label = c("A1", "A2", "B1", "B2", "C1", "C2"),
    color = c("blue", "blue", "blue", "blue", "blue", "blue"),
    pad = 15,
    thickness = 20,
    line = list(
      color = "black",
      width = 0.5
    )
  ),
  
  link = list(
    source = c(0,1,0,2,3,3),
    target = c(2,3,3,4,4,5),
    value =  c(8,4,2,8,4,2)
  )
)
fig <- fig %>% layout(
  title = "Basic Sankey Diagram",
  font = list(
    size = 10
  )
)

fig

# Spatial exploratory analysis ----
# "CountryCode", "County", "Municipality", "Locality", "DecimalLatitude", "DecimalLatitude", "CoordinateUncertaintyInMeters", "CoordinatePrecision", "PointRadiusSpatialFit", "VerbatimCoordinateSystem", "HasCoordinate", "HasGeospatialIssues"
