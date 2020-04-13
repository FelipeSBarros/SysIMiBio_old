from django.contrib.gis import admin
from .models import Gbif

@admin.register(Gbif)
class GbifAdmin(admin.GeoModelAdmin):
    list_display = ('__str__',
                    "family",
                    'hasCoordinate',
                    "county",
                    "municipality",
                    "locality")
    search_fields = ('acceptedScientificName',)
    list_filter = ('hasCoordinate',)