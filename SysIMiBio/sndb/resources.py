from import_export import resources
from .models import Occurrences

class PersonResource(resources.ModelResource):
    class Meta:
        model = Occurrences