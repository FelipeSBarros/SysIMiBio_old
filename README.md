# SysIMiBio: IMiBio's Biodiversity Management System  

Repository of the development and implementation of the Biodiversity [Management System held by Instituto Misionero de Biodiversidad](imibio.misiones.gob.ar)  

## Installing and setting up environment  

### Miniconda  

```shell script
# updte miniconda
conda update -n base conda

# creating and installing pythhon pacjages
conda create -n sysimibio python django pandas geopandas

# Saving environment requirements
conda env export > environments.yml
```
If runing from created requirement:  

```shell script
# Using requirements to create an environment
conda env create -f environment.yml
```

### Creating Django's project  

```python
# Creating project
django-admin startproject SysIMiBio .

# Creating Database: 
python manage.py migrate
```

#### Setting up  

#### Changign configs (settings.py)  

* [Time zone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones): Search for `TIME_ZONE` and change for the desired one;  
* [Lenguage/translation](https://docs.djangoproject.com/en/2.0/ref/settings/#language-code): Search for `LANGUAGE_CODE` and change for the desired lenguage.  
* Static files: Search for (it will be in the end of the setting.py) `STATIC_URL`, and add new variable: `STATIC_ROOT = os.path.join(BASE_DIR, 'static')`  
* Allowed_host: `ALLOWED_HOSTS = ['127.0.0.1', '.pythonanywhere.com']`  
  
#### Creating App  

```shell script
python manage.py startapp biodivertsity
```

**After creating database model, add it to `INSTALLED_APPS` and apply migrations.**  

1. Create tables:
    1. follow the example on models.py: `tablename(field = models.FieldType())`;  
1. Make migrations;  
1. Register table in the admin site for CRUD;  
1. Create superuser: `python manage.py createsuperuser`  

```shell script
# creating tables
python manage.py makemigrations biodiversity
# Making migrations
python manage.py migrate biodiversity
```

## test with django-import-export  

`pip install django-import-export`  

## Geodatabase

```
sudo su
su postgres
createdb imibio --template=GISTemplate
psql imibio
create extension postgis
```