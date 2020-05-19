-- sndb occurrences index
CREATE INDEX sndb_geom_idx
ON sndb_occurrences
USING gist
(geom_original);
-- provincia projected index posgar ar
CREATE INDEX provincia_geom_5341_idx
ON provincias
USING gist
(st_transform(geom, 5341));
-- departamentos projected index
CREATE INDEX departamentos_geom_5341_idx
ON departamentos
USING gist
(st_transform(geom, 5341));
-- municipios projected index
CREATE INDEX municipios_geom_5341_idx
ON municipios
USING gist
(st_transform(geom, 5341));