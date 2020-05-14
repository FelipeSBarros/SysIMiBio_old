with sfmitiones as (select st_transform(
	st_buffer(
		st_transform(
			geom, 5341),
		50),
	4326) as geom from provincias where provincia = 'Misiones')
select count(sndb.*) from 
	sfmitiones,
	sndb_occurrences as sndb where
		sndb."stateProvince" = 'Misiones' OR
		st_intersects(sfmitiones.geom, sndb.geom_original)

select count(*) from sndb_occurrences

select distinct("taxonRemarks") from sndb_occurrences limit 100

with sfmitiones as (select geom from provincias where provincia = 'Misiones')
select count(distinct(species)) from sndb_occurrences as sndb,
	sfmitiones
	WHERE clase = 'Mammalia'  and 
		"stateProvince" = 'Misiones' OR
		st_intersects(sfmitiones.geom, sndb.geom_original) 


select "clase", count(distinct(species)) as total from sndb_occurrences 
WHERE "stateProvince" = 'Misiones' and clase = 'Mammalia' 
group by "clase" order by total desc

select "taxonRank", count(distinct("acceptedScientificName")) as total from sndb_occurrences 
WHERE 
	--"stateProvince" = 'Misiones' and 
	clase = 'Mammalia' 
group by "taxonRank" order by total desc

select distinct("acceptedScientificName") as total from sndb_occurrences 
where "taxonRank" = 'GENUS' limit 3



select "taxonomicStatus", species, "acceptedScientificName" from sndb_occurrences where "taxonomicStatus" != 'ACCEPTED' limit 10

select "clase", count(distinct(species)) from sndb_occurrences 
--WHERE "stateProvince" = 'Misiones' 
group by "clase" order by count desc

select "clase", count(distinct(species)) from sndb_occurrences 
WHERE "kingdom" = 'Fungi' 
group by "clase" order by count desc

select count(distinct(species)) from sndb_occurrences 
WHERE "kingdom" = 'Fungi' AND
"stateProvince" = 'Misiones' order by count desc
