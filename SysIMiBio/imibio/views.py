from django.shortcuts import render
from django.core.paginator import Paginator
from .models import Occurrences_imibio
from djgeojson.views import GeoJSONLayerView
from django.contrib.auth.decorators import login_required
from .forms import OccForm
from django.shortcuts import redirect

@login_required
def imibio_occs_list(request):
    template_name = 'occs_list.html'
    objects = Occurrences_imibio.objects.only('scientificName', 'family', 'hasCoordinate', 'county', 'taxonRank', 'municipality', 'locality')
    paginator = Paginator(objects, 25)
    page_number = request.GET.get('page')
    page_obj = paginator.get_page(page_number)
    context = {
        'object_list': objects,
        'page_obj': page_obj,
    }
    return render(request, template_name, context)

@login_required
def Imibio_occ_detail(request, pk):
    template_name = 'occs_details.html'
    occ = Occurrences_imibio.objects.get(pk=pk)
    context = {
        'occ_detail': occ,
    }
    return render(request, template_name, context)

@login_required
def imibio_occs_map(request):
    return render(request, 'occs_mapSNDB.html')

class OccurrencesGeoJson(GeoJSONLayerView):
    model = Occurrences_imibio
    properties = ('popup_content',)

    def get_queryset(self):
        context = Occurrences_imibio.objects.extra(select={'geom':'geom_original'})
        return context

occs_geojson = OccurrencesGeoJson.as_view()

def imibio_occs(request):
    occsHeat = Occurrences_imibio.objects.filter(decimalLatitude__isnull=False, decimalLongitude__isnull=False)
    context = {
        'occs': occsHeat,
    }
    return render(request, 'occs_js.html', context)

@login_required
def agregar_occurencia(request):
    if request.method == "POST":
        form = OccForm(request.POST)
        if form.is_valid():
            occ = form.save(commit=False)
            occ.author = request.user
            #occ.published_date = timezone.now()
            occ.save()
            print("OK")
            template_name = 'occs_details.html'
            #occ = Occurrences_imibio.objects.get(pk=pk)
            context = {
                'occ_detail': occ,
            }
            return render(request, template_name, context)

    else:
        print("NOK")
        form = OccForm()
    return render(request, 'agregar_occ.html', {'form': form})