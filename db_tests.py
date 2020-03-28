# IF USING SQLITE
conn = sqlite3.connect('db.sqlite3')
c = conn.cursor()
query = c.execute('SELECT max(id) FROM biodiversity_gbif')
id = query.fetchall()[0][0]
conn.close()


sqlite3.version

c = conn.cursor()

for row in c.execute('SELECT * FROM biodiversity_gbif'):
        print(row)

# We can also close the connection if we are done with it.
# Just be sure any changes have been committed or they will be lost.
conn.close()

# delete
c.execute("DELETE FROM biodiversity_gbif WHERE author_id != 0")
conn.commit()
conn.close()


# IF USING POSTGRESQL
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


# others tests
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
