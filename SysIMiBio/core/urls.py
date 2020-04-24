from django.urls import path, include
from SysIMiBio.core import views as v

app_name = 'core'

urlpatterns = [
    path('', v.index, name='index'),
    path('accounts/login', include('django.contrib.auth.urls'), name='Login'),
    path('accounts/logout', include('django.contrib.auth.urls'), name='Logout'),
]