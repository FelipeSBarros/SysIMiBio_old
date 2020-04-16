from leaflet.admin import LeafletGeoAdmin
from django.contrib import admin
from .models import Occurrences

@admin.register(Occurrences)
class GbifAdmin(LeafletGeoAdmin):
    list_display = ('__str__',
                    "family",
                    'hasCoordinate',
                    "county",
                    "municipality",
                    "locality")
    search_fields = ('acceptedScientificName',)
    list_filter = ('hasCoordinate',)
