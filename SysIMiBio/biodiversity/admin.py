from django.contrib import admin
from .models import Gbif

@admin.register(Gbif)
class GbifAdmin(admin.ModelAdmin):
    list_display = ('__str__',
                    "family",
                    'hasCoordinate',
                    "county",
                    "municipality",
                    "locality")
    search_fields = ('acceptedScientificName',)
    list_filter = ('hasCoordinate',)