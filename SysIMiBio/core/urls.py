from django.urls import path
from SysIMiBio.core import views as v

app_name = 'core'

urlpatterns = [
    path('', v.index, name = 'index'),
    path('mapa/', v.mapa, name='mapa'),
]