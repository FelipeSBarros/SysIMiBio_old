import pandas as pd
import geopandas as gpd
import sqlite3


bio = pd.read_fwf('./data/HeadOccurrence.txt')
bio.head()

dataDict = bio.head().to_dict(orient='records')


conn = sqlite3.connect('db.sqlite3')

c = conn.cursor()

conn.execute(table.insert(), dataDict)