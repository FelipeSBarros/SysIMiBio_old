from django.shortcuts import render

def index(request):
    return render(request, 'index.html')

def vmapaSNDB(request):
    return render(request, 'mapaSNDB.html')
