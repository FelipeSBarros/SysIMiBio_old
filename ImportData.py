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
chunksize = 10 ** 4
#chunksize = 1000
#filename = './data/occurrence.txt'
filename = './data/tail3.txt'
#filename = './data/Head1kOccurrences.txt'
for chunk in pd.read_csv(filename, sep = '\t', keep_default_na=False, na_values=['None'],
                         skiprows=lambda x: x in [5607, 5608, 5609, 8437, 8438, 8439, 9667, 9668, 9669, 9670, 9671, 9672,
                                                  9680, 9681, 9682, 11550, 11551, 11552, 15515, 15516, 15517, 19839, 19840, 19841,
                                                  20719, 20720, 20721, 20779, 20780, 20781, 22107, 22108, 22109,
                                                  23633, 23634, 23635, 23654, 23655, 23656, 30505, 30506, 30507,
                                                  30536, 30537, 30538, 33283, 33284, 33285, 58253, 58254, 58255,
                                                  59323, 59324, 59325, 60094, 60095, 60096, 667232, 667233, 667234,
                                                  1079298, 1079299, 1079300, 1079529, 1079530, 1079531, 1079820, 1079821, 1079822,
                                                  1080042, 1080043, 1080044, 1082717, 1082718, 1082719, 1083005, 1083006, 1083007,
                                                  1083719, 1083720, 1083721, 1084286, 1084287, 1084288, 1120328, 1120329, 1120330,
                                                  1120447, 1120448, 1120449, 1120865, 1120866, 1120867, 1123820, 1123821, 1123822,
                                                  1125162, 1125163, 1125164, 1125360, 1125361, 1125362, 1127224, 1127225, 1127226,
                                                  1127892, 1127893, 1127894, 1127984, 1127985, 1127986, 1127989, 1127990, 1127991,
                                                  1128086, 1128087, 1128088, 1128164, 1128165, 1128166, 1128208, 1128209, 1128210,
                                                  1128938, 1128939, 1128940, 1129929, 1129930, 1129931, 1130001, 1130002, 1130003,
                                                  1143870, 1143871, 1143872],
                         chunksize=chunksize):
    bio = chunk.replace({'': None})
    bio = bio.rename(columns={'class': 'clase'})
    if "id" in bio:
        bio = bio.drop("id", 1)
    if "author_id" not in bio:
        bio['author_id'] = 1
    for item in bio.iterrows():
        if len(bio.columns) != 240:
            print("error col")
            pass
        else:
            # item[1]["id"] = dbId
            if item[1]["decimalLongitude"] is not None and item[1]["decimalLatitude"] is not None:
                item[1]['geom_original'] = GEOSGeometry(
                    "SRID=4326;POINT(" + str(item[1]["decimalLongitude"]) + " " + str(item[1]["decimalLatitude"]) + ")")
            # converting to dict
            dict = item[1].to_dict()

            # commiting
            try:
                Occurrences.objects.create(**dict)
            except:
                print("error")
            finally:
                pass
