from django.shortcuts import render
from django.core.paginator import Paginator
from .models import Occurrences
from djgeojson.views import GeoJSONLayerView

def occs_list(request):
    template_name = 'occs_list.html'
    objects = Occurrences.objects.all()
    paginator = Paginator(objects, 25)  # Show 25 contacts per page.
    page_number = request.GET.get('page')
    page_obj = paginator.get_page(page_number)
    context = {
        'object_list': objects,
        'page_obj': page_obj,
    }
    return render(request, template_name, context)

def occs_details(request, pk):
    template_name = 'occs_details.html'
    occ = Occurrences.objects.get(pk=pk)
    #print(occ.geom_original.x)
    context = {
        'occ_detail': occ,
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

def occs(request):
    occsHeat = Occurrences.objects.filter(decimalLatitude__isnull=False, decimalLongitude__isnull=False)
    context = {
        'occs': occsHeat,
    }
    return render(request, 'occs_js.html', context)
