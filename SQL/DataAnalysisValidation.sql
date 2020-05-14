select kingdom, 
	--"order", 
	--"phylum", 
	--clase, 
	count(distinct(species)) from sndb_occurrences 
	where 
		kingdom = 'Animalia' 
	--AND 
	--	"phylum" in ('Mollusca')
		--AND clase = 'Malacostraca'
	group by kingdom--, 
	 --"phylum", 
	--clase
	
	
	-- Registros con info de misiones y sin coordenadas
	select distinct("stateProvince") from  sndb_occurrences where "stateProvince" LIKE '%iones%' AND 'hasCoordinate' = 'False'
	-- registros de provincia distinto al de misioens pero ubicado en misiones
	select count("stateProvince") from  sndb_occurrences where "stateProvince" not LIKE '%iones' AND st_intersects(geom_original, (select geom from provincias where provincia = 'Misiones'))