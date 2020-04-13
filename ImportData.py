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
from SysIMiBio.biodiversity.models import Gbif

# getting last table id

def get_db_id(Model):
    # Model = Gbif
    #from django.db import connections
    from django.db.models import Max
    #if connections.databases["default"]["ENGINE"].endswith("psycopg2"):
    maxId = Model.objects.aggregate(Max('id'))
    return maxId['id__max']
    #else:


dbId = get_db_id(Gbif)
dbId is None

# reading dataset
chunksize = 10 ** 4
chunksize = 1000
filename = './data/occurrence.txt'
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
        if item[1]["decimalLongitude"] is not None:
            # pnt = GEOSGeometry('SRID=32140;POINT(954158.1 4215137.1)')
            # pnt = Point(954158.1, 4215137.1, srid=32140)
            # p = Point(item[1]["decimalLongitude"] + "," + item[1]["decimalLatitude"], srid=32140)
            item[1]['geom_original'] = GEOSGeometry(
                "SRID=4326;POINT(" + item[1]["decimalLongitude"] + " " + item[1]["decimalLatitude"] + ")")
            #print(item[1]['geom_original'])
        dict = item[1].to_dict()


        # http://blog.mathieu-leplatre.info/geodjango-maps-with-leaflet.html
        #geom = Point(lng, lat)
        Gbif.objects.create(**dict)

