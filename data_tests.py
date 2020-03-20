import pandas as pd
import geopandas as gpd
import sqlite3


bio = pd.read_csv('./data/HeadOccurrence.txt', sep = '\t')
bio.head()
bio["gbifID"]
bio.head()['accessRights']

# get output ready for database export
output = bio.itertuples()
data = tuple(output)
type(data)
wildcards = ','.join(['?'] * 3)

dataDict = bio.head().to_dict(orient='records')


conn = sqlite3.connect('db.sqlite3')
c = conn.cursor()

# Larger example that inserts many records at a time
purchases = [('2006-03-28', 'BUY', 'IBM', 1000, 45.00),
             ('2006-04-05', 'BUY', 'MSFT', 1000, 72.00),
             ('2006-04-06', 'SELL', 'IBM', 500, 53.00),
            ]
print('INSERT INTO stocks VALUES (?,?,?,?,?)', purchases)
c.executemany('INSERT INTO stocks VALUES (?,?,?,?,?)', purchases)