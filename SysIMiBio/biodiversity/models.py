from django.conf import settings
from django.db import models


class Gbif(models.Model):
    author = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    gbifID = models.BigIntegerField(blank=True, null=True)
    abstract = models.CharField(max_length=254, blank=True, null=True)
    accessRights = models.CharField(max_length=254, blank=True, null=True)
    accrualMethod = models.CharField(max_length=254, blank=True, null=True)
    accrualPeriodicity = models.CharField(max_length=254, blank=True, null=True)
    accrualPolicy = models.CharField(max_length=254, blank=True, null=True)
    alternative = models.CharField(max_length=254, blank=True, null=True)
    audience = models.CharField(max_length=254, blank=True, null=True)
    available = models.CharField(max_length=254, blank=True, null=True)
    bibliographicCitation = models.CharField(max_length=254, blank=True, null=True)
    conformsTo = models.CharField(max_length=254, blank=True, null=True)
    contributor = models.CharField(max_length=254, blank=True, null=True)
    coverage = models.CharField(max_length=254, blank=True, null=True)
    created = models.CharField(max_length=254, blank=True, null=True)
    creator = models.CharField(max_length=254, blank=True, null=True)
    date = models.CharField(max_length=254, blank=True, null=True)
    dateAccepted = models.CharField(max_length=254, blank=True, null=True)
    dateCopyrighted = models.CharField(max_length=254, blank=True, null=True)
    dateSubmitted = models.CharField(max_length=254, blank=True, null=True)
    description = models.CharField(max_length=254, blank=True, null=True)
    educationLevel = models.CharField(max_length=254, blank=True, null=True)
    extent = models.CharField(max_length=254, blank=True, null=True)
    format = models.CharField(max_length=254, blank=True, null=True)
    hasFormat = models.CharField(max_length=254, blank=True, null=True)
    hasPart = models.CharField(max_length=254, blank=True, null=True)
    hasVersion = models.CharField(max_length=254, blank=True, null=True)
    identifier = models.CharField(max_length=254, blank=True, null=True)
    instructionalMethod = models.CharField(max_length=254, blank=True, null=True)
    isFormatOf = models.CharField(max_length=254, blank=True, null=True)
    isPartOf = models.CharField(max_length=254, blank=True, null=True)
    isReferencedBy = models.CharField(max_length=254, blank=True, null=True)
    isReplacedBy = models.CharField(max_length=254, blank=True, null=True)
    isRequiredBy = models.CharField(max_length=254, blank=True, null=True)
    isVersionOf = models.CharField(max_length=254, blank=True, null=True)
    issued = models.CharField(max_length=254, blank=True, null=True)
    language = models.CharField(max_length=254, blank=True, null=True)
    license = models.CharField(max_length=254, blank=True, null=True)
    mediator = models.CharField(max_length=254, blank=True, null=True)
    medium = models.CharField(max_length=254, blank=True, null=True)
    modified = models.CharField(max_length=254, blank=True, null=True)
    provenance = models.CharField(max_length=254, blank=True, null=True)
    publisher = models.CharField(max_length=254, blank=True, null=True)
    references = models.CharField(max_length=254, blank=True, null=True)
    relation = models.CharField(max_length=254, blank=True, null=True)
    replaces = models.CharField(max_length=254, blank=True, null=True)
    requires = models.CharField(max_length=254, blank=True, null=True)
    rights = models.CharField(max_length=254, blank=True, null=True)
    rightsHolder = models.CharField(max_length=254, blank=True, null=True)
    source = models.CharField(max_length=254, blank=True, null=True)
    spatial = models.CharField(max_length=254, blank=True, null=True)
    subject = models.CharField(max_length=254, blank=True, null=True)
    tableOfContents = models.CharField(max_length=254, blank=True, null=True)
    temporal = models.CharField(max_length=254, blank=True, null=True)
    title = models.CharField(max_length=254, blank=True, null=True)
    type = models.CharField(max_length=254, blank=True, null=True)
    valid = models.CharField(max_length=254, blank=True, null=True)
    institutionID = models.CharField(max_length=254, blank=True, null=True)
    collectionID = models.CharField(max_length=254, blank=True, null=True)
    datasetID = models.CharField(max_length=254, blank=True, null=True)
    institutionCode = models.CharField(max_length=254, blank=True, null=True)
    collectionCode = models.CharField(max_length=254, blank=True, null=True)
    datasetName = models.CharField(max_length=254, blank=True, null=True)
    ownerInstitutionCode = models.CharField(max_length=254, blank=True, null=True)
    basisOfRecord = models.CharField(max_length=254, blank=True, null=True)
    informationWithheld = models.CharField(max_length=254, blank=True, null=True)
    dataGeneralizations = models.CharField(max_length=254, blank=True, null=True)
    dynamicProperties = models.CharField(max_length=254, blank=True, null=True)
    occurrenceID = models.CharField(max_length=254, blank=True, null=True)
    catalogNumber = models.CharField(max_length=254, blank=True, null=True)
    recordNumber = models.CharField(max_length=254, blank=True, null=True)
    recordedBy = models.CharField(max_length=254, blank=True, null=True)
    individualCount = models.CharField(max_length=254, blank=True, null=True)
    organismQuantity = models.CharField(max_length=254, blank=True, null=True)
    organismQuantityType = models.CharField(max_length=254, blank=True, null=True)
    sex = models.CharField(max_length=254, blank=True, null=True)
    lifeStage = models.CharField(max_length=254, blank=True, null=True)
    reproductiveCondition = models.CharField(max_length=254, blank=True, null=True)
    behavior = models.CharField(max_length=254, blank=True, null=True)
    establishmentMeans = models.CharField(max_length=254, blank=True, null=True)
    occurrenceStatus = models.CharField(max_length=254, blank=True, null=True)
    preparations = models.CharField(max_length=254, blank=True, null=True)
    disposition = models.CharField(max_length=254, blank=True, null=True)
    associatedReferences = models.CharField(max_length=254, blank=True, null=True)
    associatedSequences = models.CharField(max_length=254, blank=True, null=True)
    associatedTaxa = models.CharField(max_length=254, blank=True, null=True)
    otherCatalogNumbers = models.CharField(max_length=254, blank=True, null=True)
    occurrenceRemarks = models.CharField(max_length=254, blank=True, null=True)
    organismID = models.CharField(max_length=254, blank=True, null=True)
    organismName = models.CharField(max_length=254, blank=True, null=True)
    organismScope = models.CharField(max_length=254, blank=True, null=True)
    associatedOccurrences = models.CharField(max_length=254, blank=True, null=True)
    associatedOrganisms = models.CharField(max_length=254, blank=True, null=True)
    previousIdentifications = models.CharField(max_length=254, blank=True, null=True)
    organismRemarks = models.CharField(max_length=254, blank=True, null=True)
    materialSampleID = models.CharField(max_length=254, blank=True, null=True)
    eventID = models.CharField(max_length=254, blank=True, null=True)
    parentEventID = models.CharField(max_length=254, blank=True, null=True)
    fieldNumber = models.CharField(max_length=254, blank=True, null=True)
    eventDate = models.CharField(max_length=254, blank=True, null=True)
    eventTime = models.CharField(max_length=254, blank=True, null=True)
    startDayOfYear = models.BigIntegerField(blank=True, null=True)
    endDayOfYear = models.BigIntegerField(blank=True, null=True)
    year = models.BigIntegerField(blank=True, null=True)
    month = models.BigIntegerField(blank=True, null=True)
    day = models.BigIntegerField(blank=True, null=True)
    verbatimEventDate = models.CharField(max_length=254, blank=True, null=True)
    habitat = models.CharField(max_length=254, blank=True, null=True)
    samplingProtocol = models.CharField(max_length=254, blank=True, null=True)
    samplingEffort = models.CharField(max_length=254, blank=True, null=True)
    sampleSizeValue = models.CharField(max_length=254, blank=True, null=True)
    sampleSizeUnit = models.CharField(max_length=254, blank=True, null=True)
    fieldNotes = models.CharField(max_length=254, blank=True, null=True)
    eventRemarks = models.CharField(max_length=254, blank=True, null=True)
    locationID = models.CharField(max_length=254, blank=True, null=True)
    higherGeographyID = models.CharField(max_length=254, blank=True, null=True)
    higherGeography = models.CharField(max_length=254, blank=True, null=True)
    continent = models.CharField(max_length=254, blank=True, null=True)
    waterBody = models.CharField(max_length=254, blank=True, null=True)
    islandGroup = models.CharField(max_length=254, blank=True, null=True)
    island = models.CharField(max_length=254, blank=True, null=True)
    countryCode = models.CharField(max_length=254, blank=True, null=True)
    stateProvince = models.CharField(max_length=254, blank=True, null=True)
    county = models.CharField(max_length=254, blank=True, null=True)
    municipality = models.CharField(max_length=254, blank=True, null=True)
    locality = models.CharField(max_length=254, blank=True, null=True)
    verbatimLocality = models.CharField(max_length=254, blank=True, null=True)
    verbatimElevation = models.CharField(max_length=254, blank=True, null=True)
    verbatimDepth = models.CharField(max_length=254, blank=True, null=True)
    minimumDistanceAboveSurfaceInMeters = models.CharField(max_length=254, blank=True, null=True)
    maximumDistanceAboveSurfaceInMeters = models.CharField(max_length=254, blank=True, null=True)
    locationAccordingTo = models.CharField(max_length=254, blank=True, null=True)
    locationRemarks = models.CharField(max_length=254, blank=True, null=True)
    decimalLatitude = models.FloatField(blank=True, null=True)
    decimalLongitude = models.FloatField(blank=True, null=True)
    coordinateUncertaintyInMeters = models.FloatField(blank=True, null=True)
    coordinatePrecision = models.CharField(max_length=254, blank=True, null=True)
    pointRadiusSpatialFit = models.CharField(max_length=254, blank=True, null=True)
    verbatimCoordinateSystem = models.CharField(max_length=254, blank=True, null=True)
    verbatimSRS = models.CharField(max_length=254, blank=True, null=True)
    footprintWKT = models.CharField(max_length=254, blank=True, null=True)
    footprintSRS = models.CharField(max_length=254, blank=True, null=True)
    footprintSpatialFit = models.CharField(max_length=254, blank=True, null=True)
    georeferencedBy = models.CharField(max_length=254, blank=True, null=True)
    georeferencedDate = models.BigIntegerField(blank=True, null=True)
    georeferenceProtocol = models.CharField(max_length=254, blank=True, null=True)
    georeferenceSources = models.CharField(max_length=254, blank=True, null=True)
    georeferenceVerificationStatus = models.CharField(max_length=254, blank=True, null=True)
    georeferenceRemarks = models.CharField(max_length=254, blank=True, null=True)
    geologicalContextID = models.CharField(max_length=254, blank=True, null=True)
    earliestEonOrLowestEonothem = models.CharField(max_length=254, blank=True, null=True)
    latestEonOrHighestEonothem = models.CharField(max_length=254, blank=True, null=True)
    earliestEraOrLowestErathem = models.CharField(max_length=254, blank=True, null=True)
    latestEraOrHighestErathem = models.CharField(max_length=254, blank=True, null=True)
    earliestPeriodOrLowestSystem = models.CharField(max_length=254, blank=True, null=True)
    latestPeriodOrHighestSystem = models.CharField(max_length=254, blank=True, null=True)
    earliestEpochOrLowestSeries = models.CharField(max_length=254, blank=True, null=True)
    latestEpochOrHighestSeries = models.CharField(max_length=254, blank=True, null=True)
    earliestAgeOrLowestStage = models.CharField(max_length=254, blank=True, null=True)
    latestAgeOrHighestStage = models.CharField(max_length=254, blank=True, null=True)
    lowestBiostratigraphicZone = models.CharField(max_length=254, blank=True, null=True)
    highestBiostratigraphicZone = models.CharField(max_length=254, blank=True, null=True)
    lithostratigraphicTerms = models.CharField(max_length=254, blank=True, null=True)
    group = models.CharField(max_length=254, blank=True, null=True)
    formation = models.CharField(max_length=254, blank=True, null=True)
    member = models.CharField(max_length=254, blank=True, null=True)
    bed = models.CharField(max_length=254, blank=True, null=True)
    identificationID = models.CharField(max_length=254, blank=True, null=True)
    identificationQualifier = models.CharField(max_length=254, blank=True, null=True)
    typeStatus = models.CharField(max_length=254, blank=True, null=True)
    identifiedBy = models.CharField(max_length=254, blank=True, null=True)
    dateIdentified = models.CharField(max_length=254, blank=True, null=True)
    identificationReferences = models.CharField(max_length=254, blank=True, null=True)
    identificationVerificationStatus = models.CharField(max_length=254, blank=True, null=True)
    identificationRemarks = models.CharField(max_length=254, blank=True, null=True)
    taxonID = models.CharField(max_length=254, blank=True, null=True)
    scientificNameID = models.CharField(max_length=254, blank=True, null=True)
    acceptedNameUsageID = models.CharField(max_length=254, blank=True, null=True)
    parentNameUsageID = models.CharField(max_length=254, blank=True, null=True)
    originalNameUsageID = models.CharField(max_length=254, blank=True, null=True)
    nameAccordingToID = models.CharField(max_length=254, blank=True, null=True)
    namePublishedInID = models.CharField(max_length=254, blank=True, null=True)
    taxonConceptID = models.CharField(max_length=254, blank=True, null=True)
    scientificName = models.CharField(max_length=254, blank=True, null=True)
    acceptedNameUsage = models.BigIntegerField(blank=True, null=True)
    parentNameUsage = models.CharField(max_length=254, blank=True, null=True)
    originalNameUsage = models.CharField(max_length=254, blank=True, null=True)
    nameAccordingTo = models.CharField(max_length=254, blank=True, null=True)
    namePublishedIn = models.CharField(max_length=254, blank=True, null=True)
    namePublishedInYear = models.CharField(max_length=254, blank=True, null=True)
    higherClassification = models.CharField(max_length=254, blank=True, null=True)
    kingdom = models.CharField(max_length=254, blank=True, null=True)
    phylum = models.CharField(max_length=254, blank=True, null=True)
    clase = models.CharField("class", max_length=254, blank = True, null = True)
    order = models.CharField(max_length=254, blank=True, null=True)
    family = models.CharField(max_length=254, blank=True, null=True)
    genus = models.CharField(max_length=254, blank=True, null=True)
    subgenus = models.CharField(max_length=254, blank=True, null=True)
    specificEpithet = models.CharField(max_length=254, blank=True, null=True)
    infraspecificEpithet = models.CharField(max_length=254, blank=True, null=True)
    taxonRank = models.CharField(max_length=254, blank=True, null=True)
    verbatimTaxonRank = models.CharField(max_length=254, blank=True, null=True)
    vernacularName = models.CharField(max_length=254, blank=True, null=True)
    nomenclaturalCode = models.CharField(max_length=254, blank=True, null=True)
    taxonomicStatus = models.CharField(max_length=254, blank=True, null=True)
    nomenclaturalStatus = models.CharField(max_length=254, blank=True, null=True)
    taxonRemarks = models.CharField(max_length=254, blank=True, null=True)
    datasetKey = models.CharField(max_length=254, blank=True, null=True)
    publishingCountry = models.CharField(max_length=254, blank=True, null=True)
    lastInterpreted = models.CharField(max_length=254, blank=True, null=True)
    elevation = models.CharField(max_length=254, blank=True, null=True)
    elevationAccuracy = models.CharField(max_length=254, blank=True, null=True)
    depth = models.FloatField(blank=True, null=True)
    depthAccuracy = models.CharField(max_length=254, blank=True, null=True)
    distanceAboveSurface = models.CharField(max_length=254, blank=True, null=True)
    distanceAboveSurfaceAccuracy = models.CharField(max_length=254, blank=True, null=True)
    issue = models.CharField(max_length=254, blank=True, null=True)
    mediaType = models.CharField(max_length=254, blank=True, null=True)
    hasCoordinate = models.CharField(max_length=254, blank=True, null=True)
    hasGeospatialIssues = models.CharField(max_length=254, blank=True, null=True)
    taxonKey = models.BigIntegerField(blank=True, null=True)
    acceptedTaxonKey = models.BigIntegerField(blank=True, null=True)
    kingdomKey = models.BigIntegerField(blank=True, null=True)
    phylumKey = models.BigIntegerField(blank=True, null=True)
    classKey = models.BigIntegerField(blank=True, null=True)
    orderKey = models.BigIntegerField(blank=True, null=True)
    familyKey = models.BigIntegerField(blank=True, null=True)
    genusKey = models.BigIntegerField(blank=True, null=True)
    subgenusKey = models.CharField(max_length=254, blank=True, null=True)
    speciesKey = models.BigIntegerField(blank=True, null=True)
    species = models.CharField(max_length=254, blank=True, null=True)
    genericName = models.CharField(max_length=254, blank=True, null=True)
    acceptedScientificName = models.CharField(max_length=254, blank=True, null=True)
    verbatimScientificName = models.CharField(max_length=254, blank=True, null=True)
    typifiedName = models.CharField(max_length=254, blank=True, null=True)
    protocol = models.CharField(max_length=254, blank=True, null=True)
    lastParsed = models.CharField(max_length=254, blank=True, null=True)
    lastCrawled = models.CharField(max_length=254, blank=True, null=True)
    repatriated = models.CharField(max_length=254, blank=True, null=True)
    relativeOrganismQuantity = models.CharField(max_length=254, blank=True, null=True)

    def __str__(self):
        return f'{self.acceptedScientificName}'
