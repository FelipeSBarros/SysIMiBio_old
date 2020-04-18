from django.urls import path
from SysIMiBio.sndb import views as v

app_name = 'sndb'

urlpatterns = [
    path('', v.occs_list, name='occs_list'),
    path('<int:pk>', v.occ_detail, name='occ_detail'),
    path('mapaSNDB/', v.occs_map, name='occs_mapSNDB'),
    path('geojson/', v.occs_geojson, name='occs_geojson'),
    path('occsList/', v.occs, name='occsList'),
]