from django.shortcuts import render
from .models import Occurrences
from djgeojson.views import GeoJSONLayerView

def species_list(request):
    template_name = 'species_list.html'
    objects = Occurrences.objects.all()
    context = {
        'object_list': objects
    }
    return render(request, template_name, context)

def vmapaSNDB(request):
    return render(request, 'mapaSNDB.html')

class OccurrencesGeoJson(GeoJSONLayerView):
    model = Occurrences
    properties = ('popup_content',)

    def get_queryset(self):
        context = Occurrences.objects.extra(select={'geom':'geom_original'})#filter(
            #uf=self.request.session['estado']['abreviacao'],
            #tancagens__nome__icontains='etanol')
        return context

occs_geojson = OccurrencesGeoJson.as_view()
