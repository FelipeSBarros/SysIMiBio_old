from django.urls import path
from SysIMiBio.sndb import views as v

app_name = 'sndb'

urlpatterns = [
    path('', v.species_list, name='species_list'),
    path('mapaSNDB/', v.vmapaSNDB, name='mapaSNDB'),
    path('geojson/', v.occs_geojson, name='occs_geojson'),
]