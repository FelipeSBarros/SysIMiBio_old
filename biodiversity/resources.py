from import_export import resources
from .models import gbif

class PersonResource(resources.ModelResource):
    class Meta:
        model = gbif