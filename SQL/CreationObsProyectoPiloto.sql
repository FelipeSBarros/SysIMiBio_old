
CREATE TABLE obs_proyecto_piloto as (
select -- row_number() over() as id, species, geom_original as geom 
	*
	from sndb_occurrences where 
	--"stateProvince" LIKE '%iones' OR
	st_intersects(geom_original, (select geom from proyecto_piloto_600)))
																					  
-- DROP TABLE obs_proyecto_piloto