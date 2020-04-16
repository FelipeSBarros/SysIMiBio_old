from django.shortcuts import render
from .models import Occurrences

def species_list(request):
    template_name = 'species_list.html'
    objects = Occurrences.objects.all()
    context = {
        'object_list': objects
    }
    return render(request, template_name, context)

def vmapaSNDB(request):
    return render(request, 'mapaSNDB.html')
