from django.urls import path
from SysIMiBio.sndb import views as v

app_name = 'sndb'

urlpatterns = [
    path('', v.occs_list, name='species_list'),
    path('<int:pk>', v.occs_details, name='occ_details'),
    path('mapaSNDB/', v.vmapaSNDB, name='mapaSNDB'),
    path('geojson/', v.occs_geojson, name='occs_geojson'),
    path('occsList/', v.occs, name='occsList'),
]