from django import forms
from .models import Occurrences_imibio

class OccForm(forms.ModelForm):
    occurrenceID = forms.CharField(required=False)
    basisOfRecord = forms.CharField(required=False)
    catalogNumber = forms.CharField(required=False)
    scientificName = forms.CharField(required=False)
    kingdom = forms.CharField(required=False)
    phylum = forms.CharField(required=False)
    clase = forms.CharField(required=False)
    order = forms.CharField(required=False)
    family = forms.CharField(required=False)
    genus = forms.CharField(required=False)
    specificEpithet = forms.CharField(required=False)
    taxonRank = forms.CharField(required=False)
    infraspecificEpithet = forms.CharField(required=False)
    identificationQualifier = forms.CharField(required=False)
    county = forms.CharField(required=False)
    stateProvince = forms.CharField(required=False)
    locality = forms.CharField(required=False)
    recordedBy = forms.CharField(required=False)
    recordNumber = forms.CharField(required=False)

    class Meta:
        model = Occurrences_imibio
        fields = (
            'occurrenceID',
            #dicterms:modified,  # es este el campo "modified" que figura en SNDB?
            'basisOfRecord',
            #'institutionCode',
            #collectionCode,
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
            # 'scientificNameAuthorship', # no existe en dwc
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
