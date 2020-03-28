import sqlite3
conn = sqlite3.connect('db.sqlite3')

sqlite3.version

c = conn.cursor()

# Insert a row of data
c.execute("INSERT INTO biodiversity_gbif (author_id, gbifID, abstract) VALUES (1, 1,'BUY')")

# Save (commit) the changes
conn.commit()

for row in c.execute('SELECT * FROM biodiversity_gbif'):
        print(row)

# We can also close the connection if we are done with it.
# Just be sure any changes have been committed or they will be lost.
conn.close()

# delete
c.execute("DELETE FROM biodiversity_gbif WHERE author_id != 0")
conn.commit()
conn.close()

# From bash
sqlite3 db.sqlite3
.tables
.quit()


# testing PostGRESQL
from decouple import config
import psycopg2
try:
    connection = psycopg2.connect(user = config('DBUSER'),
                                  password = config('DBPASSWORD'),
                                  host = "localhost",
                                  port = "5432",
                                  database = "imibio")

    cursor = connection.cursor()
    # Print PostgreSQL Connection properties
    print ( connection.get_dsn_parameters(),"\n")

    # Print PostgreSQL version
    cursor.execute("SELECT version();")
    record = cursor.fetchone()
    print("You are connected to - ", record,"\n")

except (Exception, psycopg2.Error) as error :
    print ("Error while connecting to PostgreSQL", error)
finally:
    #closing database connection.
        if(connection):
            cursor.close()
            connection.close()
            print("PostgreSQL connection is closed")
