# SysIMiBio: IMiBio's Biodiversity Management System  

Repository for the Biodiversity [Management System held by Instituto Misionero de Biodiversidad](imibio.misiones.gob.ar)  

## Installing and setting up environment  

### venv
```buildoutcfg
python3 -m venv .sysimibio
source .sysimibio/bin/activate
pip install -r requirements.txt
pip install numpy
sudo apt-get install libgdal-dev
```

### Creating Django's project  

```python
# Creating project
django-admin startproject SysIMiBio .

# Creating Database: 
python manage.py migrate
```

#### Setting up  

#### Isolate env settings from code
* Create .env file with [env information](https://github.com/silveriomm/django_estoque_regis/tree/master/contrib).  
* Using [decouple](https://github.com/henriquebastos/python-decouple)  

```shell script
pip install python-decouple
```  
 
##### Changing configs (settings.py)  

* Decouple config:
```shell script
from decouple import config, Csv

# then change 
SECRET_KEY = config('SECRET_KEY')
DEBUG = config('DEBUG', default=False, cast=bool)
ALLOWED_HOSTS = config('ALLOWED_HOSTS', default=[], cast = Csv())
```
* [Time zone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones): Search for `TIME_ZONE` and change for the desired one;  
* [Lenguage/translation](https://docs.djangoproject.com/en/2.0/ref/settings/#language-code): Search for `LANGUAGE_CODE` and change for the desired lenguage.  
* Static files: Search for (it will be in the end of the setting.py) `STATIC_URL`, and add new variable: `STATIC_ROOT = os.path.join(BASE_DIR, 'static')`  
* Allowed_host: `ALLOWED_HOSTS = ['127.0.0.1', '.pythonanywhere.com']`  
  
#### Creating App  

```shell script
cd SysIMiBio
python manage.py startapp core
python manage.py startapp sndb
```

**After creating database model, add it to `INSTALLED_APPS` and apply migrations.**  

1. Create tables:
    1. follow the example on models.py: `tablename(field = models.FieldType())`;  
1. Make migrations;  
1. Register table in the admin site for CRUD;  
1. Create superuser: `python manage.py createsuperuser`  

```shell script
# creating tables
python manage.py makemigrations sndb
# Making migrations
python manage.py migrate sndb
```

### PostGreSQL
* Installing module psycopg2. [More info, check this tutorial](https://djangocentral.com/using-postgresql-with-django/)  
```
pip install psycopg2
```

* Installing and creating database [w/ GIS extension]  
More information on [GeoDjango documentation](https://docs.djangoproject.com/en/3.0/ref/contrib/gis/install/postgis/)  

```
# Criando template PostGIS
sudo su - postgres
psql
# Criando DB GISTemplate
CREATE DATABASE imibio;
\q
psql imibio
# Dentro do PostGre na base de interesse
-- Enable PostGIS (includes raster)
CREATE EXTENSION postgis;
\q
exit
```  

* Create user
```
psql imibio
CREATE USER myuser WITH ENCRYPTED PASSWORD 'mypass';
# ALTER ROLE GeoAdmin SET client_encoding TO 'utf8';
ALTER ROLE myuser SET default_transaction_isolation TO 'read committed';
# ALTER ROLE GeoAdmin SET timezone TO 'UTC';
GRANT ALL PRIVILEGES ON DATABASE imibio TO myuser;
\q
exit
exit
```

* Add user & password to .env
`DATABASE_URL=sistema_db://user_db:password_db@localhost/db_name`

* Using dj_database_url on setting.py
```
from dj_database_url import parse as db_url
...
DATABASES = {
    'default': config('DATABASE_URL', cast=db_url),
}
DATABASES['default']['ENGINE'] = 'django.contrib.gis.db.backends.postgis'
```

* [GIS Models](https://docs.djangoproject.com/en/3.0/ref/contrib/gis/model-api/)

```python
from django.contrib.gis.db import models
# Not forget to add srid...
```

* Add [django.contrib.gis to INSTALLED_APPS](https://docs.djangoproject.com/en/3.0/ref/contrib/gis/install/#add-django-contrib-gis-to-installed-apps)

* Making migrations
```shell script
python manage.py migrate
```

Then, repeat `makemigrations` and `migrate` for [django app](#creating-app)... and don't forget to create superuser!  

* removing database (if necessary)  
```
sudo su
su postgres
psql
DROP DATABSE imibio
```

### For the maps  

Download [leaflet](https://leafletjs.com/download.html) and export to static, as suggested [here](https://github.com/marcellobenigno/geopocos/blob/master/docs/05-nosso-primeiro-mapa.md)  

#### GeoDjango models  

[GeoDjango models](https://docs.djangoproject.com/en/3.0/ref/contrib/gis/model-api/)  
[Django geom organization](http://blog.mathieu-leplatre.info/geodjango-maps-with-leaflet.html)  
[automatic-spatial-transformations](https://docs.djangoproject.com/en/3.0/ref/contrib/gis/tutorial/#automatic-spatial-transformations)  
