var convexStatus=false;
function createConvex(){
	if(!convexStatus)
	{
		fetch('http://localhost:8080/geoserver/wfs?service=wfs&version=1.1.0&request=GetFeature&typeNames=WHUMap_Xin:poi&outputFormat=application/json&srsname=EPSG:4326').then(function(response) {
			return response.json().then(function(points_fc) {
				var convex = turf.convex(points_fc);

				vectorConvexPolygon.addFeatures(geojsonToFeatures(convex, {
					featureProjection: 'EPSG:4326'
				}));

				vectorSourcePoints.addFeatures(geojsonToFeatures(points_fc, {
					featureProjection: 'EPSG:4326'
				}));
			});
		});
		convexStatus=true;
	}else
	{
		vectorConvexPolygon.clear();
		vectorSourcePoints.clear();
		convexStatus=false;
	}
}