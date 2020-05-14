-- count total number of columns
select count(column_name)as Number from information_schema.columns where table_name='sndb_occurrences'
-- count total rows
select count(*) from sndb_occurrences

-- remove duplicated values with <> ids
DELETE FROM sndb_occurrences T1
    USING   sndb_occurrences T2
WHERE   T1.id < T2.id  -- delete the older versions
    AND T1."gbifID"  = T2."gbifID";  -- add more columns if needed
