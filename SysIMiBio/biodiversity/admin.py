from leaflet.admin import LeafletGeoAdmin
from django.contrib import admin
from .models import Gbif

@admin.register(Gbif)
class GbifAdmin(LeafletGeoAdmin):
    list_display = ('__str__',
                    "family",
                    'hasCoordinate',
                    "county",
                    "municipality",
                    "locality")
    search_fields = ('acceptedScientificName',)
    list_filter = ('hasCoordinate',)