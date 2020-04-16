""""
Script to import data to biodiversity_gbif database
"""
import os
import django
import pandas as pd
from django.contrib.gis.geos import GEOSGeometry, Point

# setting environment
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "SysIMiBio.settings")
django.setup()

# importing model
from SysIMiBio.sndb.models import Occurrences

# getting last table id

def get_db_id(Model):
    from django.db.models import Max
    maxId = Model.objects.aggregate(Max('id'))
    return maxId['id__max']


dbId = get_db_id(Occurrences)
dbId is None

# reading dataset
#chunksize = 10 ** 4
chunksize = 1000
#filename = './data/occurrence.txt'
filename = './data/Head1kOccurrences.txt'
for chunk in pd.read_csv(filename, sep = '\t', keep_default_na=False, na_values=['None'], skiprows = lambda x: x in [1461549, 1470372],
                         #nrows=1000000
                         nrows=10000, chunksize=chunksize):
    bio = chunk.replace({'': None})
    bio = bio.rename(columns={'class': 'clase'})
    if "id" in bio:
        bio = bio.drop("id", 1)
    if "author_id" not in bio:
        bio['author_id'] = 1
    for item in bio.iterrows():
        # item[1]["id"] = dbId
        if item[1]["decimalLongitude"] is not None and item[1]["decimalLatitude"] is not None:
            item[1]['geom_original'] = GEOSGeometry(
                "SRID=4326;POINT(" + str(item[1]["decimalLongitude"]) + " " + str(item[1]["decimalLatitude"]) + ")")
        # converting to dict
        dict = item[1].to_dict()

        # commiting
        Occurrences.objects.create(**dict)
