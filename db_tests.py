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
c.execute("DELETE FROM biodiversity_gbif WHERE author_id = 1")
conn.commit()
conn.close()

# From bash
sqlite3 db.sqlite3
.tables
.quit()