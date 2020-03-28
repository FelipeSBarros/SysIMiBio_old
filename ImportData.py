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
bio = pd.read_csv('./data/HeadOccurrence.csv', sep = '\t', keep_default_na=False, na_values=['None'])
bio = bio.replace({'':None})

#if dbId is None:
if "id" in bio:
    bio = bio.drop("id", 1)
    # iterating over dataset and importing each
#else:
    #dbId += 1
for item in bio.head(1).iterrows():
    #item[1]["id"] = dbId
    dict = item[1].to_dict()
    Gbif.objects.create(**dict)




# Not necessary anymore
# IF USING SQLITE
conn = sqlite3.connect('db.sqlite3')
c = conn.cursor()
query = c.execute('SELECT max(id) FROM biodiversity_gbif')
id = query.fetchall()[0][0]
conn.close()

# IF USING POSTGRESQL
import psycopg2
try:
    connection = psycopg2.connect(user = config('DBUSER'),
                                  password = config('DBPASSWORD'),
                                  host = "localhost",
                                  port = "5432",
                                  database = "imibio")

    cursor = connection.cursor()
    # get last id from biodiversity_gbif table
    cursor.execute("SELECT max(id) from biodiversity_gbif;")
    id = cursor.fetchone()[0]
    if id is None:
        print("ID is None. No need to have id. Setting it to 0")
        id = 0
    else:
        print("ID is =", id)
except (Exception, psycopg2.Error) as error :
    print ("Error while connecting to PostgreSQL", error)
finally:
    #closing database connection.
        if(connection):
            cursor.close()
            connection.close()
            print("PostgreSQL connection is closed")
