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

## System overview  

* Database: PostgreSQL and psycopg2. [More info, check this tutorial](https://djangocentral.com/using-postgresql-with-django/)  
* [Decouple](https://github.com/henriquebastos/python-decouple)  
* [GIS Models](https://docs.djangoproject.com/en/3.0/ref/contrib/gis/model-api/)
* Add [django.contrib.gis to INSTALLED_APPS](https://docs.djangoproject.com/en/3.0/ref/contrib/gis/install/#add-django-contrib-gis-to-installed-apps)  
* [leaflet](https://leafletjs.com/download.html) in static files, as suggested [here](https://github.com/marcellobenigno/geopocos/blob/master/docs/05-nosso-primeiro-mapa.md)  

## Importing initial data (GBIF and SNDB) 

First of all, make sure you:  
* have PostgreSQL installed with GIS extention;  
* have made the migrations and created superuser;
Any doubt, take a look on [CreationProcess.md](./CreationProcess.md)  

## to PostGreSQL [with pandas]  

*see* [ImportData.py](./ImportData.py)
```commandline
python ImportData.py
```

# Tutorials  
* [Herança de models](https://youtu.be/nlHfCt0HuGY?t=382)  
* [from Regis video](https://www.youtube.com/watch?v=l7-lypZz95g)  

#### GeoDjango models  

[GeoDjango models](https://docs.djangoproject.com/en/3.0/ref/contrib/gis/model-api/)  
[Django geom organization](http://blog.mathieu-leplatre.info/geodjango-maps-with-leaflet.html)  
[automatic-spatial-transformations](https://docs.djangoproject.com/en/3.0/ref/contrib/gis/tutorial/#automatic-spatial-transformations)  
