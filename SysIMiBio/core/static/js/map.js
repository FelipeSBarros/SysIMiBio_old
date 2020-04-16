var gstreets = L.tileLayer('http://www.google.cn/maps/vt?lyrs=m@189&gl=cn&x={x}&y={y}&z={z}', {
    maxZoom: 20,
    attribution: 'google'
});

var satellite = L.tileLayer('http://www.google.cn/maps/vt?lyrs=s@189&gl=cn&x={x}&y={y}&z={z}', {
    maxZoom: 20,
    attribution: 'google'
});

var myStyle = {
        fillColor: '#ffffff',
        weight: 2,
        opacity: 1,
        color: '#000000',
        fillOpacity: 1
};

var occurrences = L.geoJson([], {
    style: myStyle,
    pointToLayer: function (feature, latlng) {
        return new L.CircleMarker(latlng, {radius: 4});
    },
});

var occs_url = $("#occs_geojson").val();

$.getJSON(occs_url, function (data) {
    // Add GeoJSON layer
    occurrences.addData(data);
})

var map = L.map('map', {
    center: [-27, -55],
    zoom: 8,
    maxZoom: 20,
    layers: [gstreets, occurrences],
});

var overlays = {
    "occurrences":occurrences,
};

var baseLayers = {
    "Google Streets": gstreets,
    "Google Satélite": satellite,
};

var control = L.control.layers(baseLayers, overlays).addTo(map);