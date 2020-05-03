from django import forms
from .models import Occurrences_imibio

class OccForm(forms.ModelForm):
    #occurrenceID = forms.CharField(required=True) # not necessary. it is created on insertion
    basisOfRecord = forms.CharField(required=True)
    institutionCode = forms.CharField(required=True)
    collectionCode = forms.CharField(required=True)
    catalogNumber = forms.CharField(required=True)
    scientificName = forms.CharField(required=True)
    kingdom = forms.CharField(required=True)
    phylum = forms.CharField(required=True)
    clase = forms.CharField(required=True)
    order = forms.CharField(required=True)
    family = forms.CharField(required=True)
    genus = forms.CharField(required=True)
    specificEpithet = forms.CharField(required=False)
    taxonRank = forms.CharField(required=False)
    infraspecificEpithet = forms.CharField(required=False)
    identificationQualifier = forms.CharField(required=False)
    county = forms.CharField(required=True)
    stateProvince = forms.CharField(required=True)
    locality = forms.CharField(required=True)
    recordedBy = forms.CharField(required=False)
    recordNumber = forms.CharField(required=False)

    class Meta:
        model = Occurrences_imibio
        fields = (
            'occurrenceID',
            #dicterms:modified,  # es este el campo "modified" que figura en SNDB?
            'basisOfRecord',
            'institutionCode',
            'collectionCode',
            'catalogNumber',
            'scientificName',
            'kingdom',
            'phylum',
            'clase',
            'order',
            'family',
            'genus',
            'specificEpithet',
            'taxonRank',
            'infraspecificEpithet',
            # 'scientificNameAutorship', # no existe en dwc
            'identificationQualifier',
            'county',
            'stateProvince',
            'locality',
            'recordedBy',
            'recordNumber',
            'decimalLatitude',
            'decimalLongitude',
            #'geodeticDatum',  # no figura en los datos del SNDB
            #'coordinateUncartaintyInMeters',
            #'georeferenceProtocol',
            #'georeferenceSources',
        )
