var vector,POI_category;
function moveToPOI(){
	//清除上一个点
	map.removeLayer(vector);
	var searchInput=document.getElementById('POIInput').value;
	var search='http://localhost:8080/geoserver/wfs?service=wfs&version=1.1.0&request=GetFeature&typeNames=WHUMap_Xin:poi&outputFormat=application/json&srsname=EPSG:4326&cql_filter=note=%27'+searchInput+'%27';

	pointSource=new ol.source.Vector({
		format: new ol.format.GeoJSON(),
		url: search
	});

	vector = new ol.layer.Vector({
		source: pointSource,
	});
	var POICoor;
	var listenerKey = pointSource.on('change', function(){
		if (pointSource.getState() === 'ready') {    // 判定是否加载完成
			//将查询到的属性赋予HTML
			var POI_category=pointSource.getFeatures()[0].get("category");
			document.getElementById('POI_ctgy').innerText = POI_category;
			var POI_name=pointSource.getFeatures()[0].get("note");
			document.getElementById('POI_name').innerText = POI_name;
			POICoor=pointSource.getFeatures()[0].get("geometry").A;
			//注意这个.value！否则无法正常获取！清楚没有尾部和.value和.innerHTML的区别
			var anchor = new ol.Overlay({
				element: document.getElementById('anchor1')
			});
			// 关键的一点，需要设置附加到地图上的位置
			anchor.setPosition(POICoor);
			// 然后添加到map上
			map.addOverlay(anchor);
			document.getElementById('anchor1').style.display='block';
		}	
	});
	map.addLayer(vector);
}