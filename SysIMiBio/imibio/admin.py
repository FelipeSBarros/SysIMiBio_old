from leaflet.admin import LeafletGeoAdmin
from django.contrib import admin
from .models import Occurrences_imibio

@admin.register(Occurrences_imibio)
class GbifAdmin(LeafletGeoAdmin):
    list_display = ('__str__',
                    "family",
                    'hasCoordinate',
                    "county",
                    "taxonRank",
                    "municipality",
                    "locality")
    search_fields = ('acceptedScientificName',)
    list_filter = ('hasCoordinate',)
