""""
Script to import data to biodiversity_gbif database
"""
import os
import django
import pandas as pd
from decouple import config

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
filename = './data/occurrence.txt'
for chunk in pd.read_csv(filename, sep = '\t', keep_default_na=False, na_values=['None'], skiprows = lambda x: x in [1461549, 1470372], nrows=1000000, chunksize=chunksize):
    bio = chunk.replace({'': None})
    bio = bio.rename(columns={'class': 'clase'})
    if "id" in bio:
        bio = bio.drop("id", 1)
    if "author_id" not in bio:
        bio['author_id'] = 1
    for item in bio.iterrows():
        # item[1]["id"] = dbId
        dict = item[1].to_dict()
        #print(" Ate author_id", dict["author_id"])

        # http://blog.mathieu-leplatre.info/geodjango-maps-with-leaflet.html
        #geom = Point(lng, lat)
        Gbif.objects.create(**dict)
