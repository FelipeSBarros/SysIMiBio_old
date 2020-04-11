from django.contrib.gis import admin
from .models import Gbif

@admin.register(Gbif, admin.GeoModelAdmin)
class GbifAdmin(admin.ModelAdmin):
    list_display = ('__str__',
                    "family",
                    'hasCoordinate',
                    "county",
                    "municipality",
                    "locality")
    search_fields = ('acceptedScientificName',)
    list_filter = ('hasCoordinate',)