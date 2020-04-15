from django.shortcuts import render
from .models import Gbif

def species_list(request):
    template_name = 'species_list.html'
    objects = Gbif.objects.all()
    context = {
        'object_list': objects
    }
    return render(request, template_name, context)
