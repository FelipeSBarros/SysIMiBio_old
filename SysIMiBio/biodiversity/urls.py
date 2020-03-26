from django.urls import path
from SysIMiBio.biodiversity import views as v

app_name = 'biodiversity'

urlpatterns = [
    path('', v.species_list, name='species_list'),
]