from django.urls import path, include
from SysIMiBio.imibio import views as v

app_name = 'imibio'

urlpatterns = [
    path('', v.imibio_occs_list, name='imibio_occs_list'),
    path('detalles/<int:pk>/', v.Imibio_occ_detail, name='imibio_occ_detail'),
    path('agregar', v.agregar_occurencia, name='agregar_occurencia'),
    #path('mapaSNDB/', v.occs_map, name='occs_mapSNDB'),
    #path('geojson/', v.occs_geojson, name='occs_geojson'),
    #path('occsList/', v.occs, name='occsList'),
]
