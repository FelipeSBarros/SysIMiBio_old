from django import forms
from .models import Occurrences_imibio

class OccForm(forms.ModelForm):

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
