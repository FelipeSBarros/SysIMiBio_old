-- Registros con info de misiones y sin coordenadas
select distinct("stateProvince") from  sndb_occurrences where "stateProvince" LIKE '%iones%' AND 'hasCoordinate' = 'False'
-- registros de provincia distinto al de misioens pero ubicado en misiones
select count("stateProvince") from  sndb_occurrences where "stateProvince" not LIKE '%iones' AND st_intersects(geom_original, (select geom from provincias where provincia = 'Misiones'))

CREATE TABLE obs_misiones as (
select -- row_number() over() as id, species, geom_original as geom 
	*
	from sndb_occurrences where 
	"stateProvince" LIKE '%iones' OR
	st_intersects(geom_original, (select
								  st_transform(
									  st_buffer(
										  st_transform(geom, 22177), 2500)
									  , 4326) from provincias where provincia = 'Misiones')))
																					  
-- DROP TABLE obs_misiones