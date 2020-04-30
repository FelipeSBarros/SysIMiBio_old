from django.shortcuts import render
from django.core.paginator import Paginator
from .models import Occurrences
from djgeojson.views import GeoJSONLayerView
from django.contrib.auth.decorators import login_required

@login_required
def occs_list(request):
    template_name = 'occs_list.html'
    objects = Occurrences.objects.all()#values('scientificName', 'family', 'hasCoordinate', 'county', 'taxonRank', 'municipality', 'locality', 'pk')
    paginator = Paginator(objects, 25)
    page_number = request.GET.get('page')
    page_obj = paginator.get_page(page_number)
    context = {
        'object_list': objects,
        'page_obj': page_obj,
    }
    return render(request, template_name, context)

@login_required
def occ_detail(request, pk):
    template_name = 'occs_details.html'
    occ = Occurrences.objects.get(pk=pk)
    context = {
        'occ_detail': occ,
    }
    return render(request, template_name, context)

@login_required
def occs_map(request):
    return render(request, 'occs_mapSNDB.html')

class OccurrencesGeoJson(GeoJSONLayerView):
    model = Occurrences
    properties = ('popup_content',)

    def get_queryset(self):
        context = Occurrences.objects.extra(select={'geom':'geom_original'})
        return context

occs_geojson = OccurrencesGeoJson.as_view()

def occs(request):
    occsHeat = Occurrences.objects.filter(decimalLatitude__isnull=False, decimalLongitude__isnull=False)
    context = {
        'occs': occsHeat,
    }
    return render(request, 'occs_js.html', context)
