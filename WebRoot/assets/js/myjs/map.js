var format = 'image/png';
var bounds = [114.34959598862,30.5266841001062,114.358078712253,30.535330320335];//范围


//两个矢量数据，编辑用
var MapURL1='http://localhost:8080/geoserver/wfs?service=wfs&version=1.1.0&'+
'request=GetFeature&typeNames=WHUMap_Xin:WHUMap&'+
'outputFormat=application/json&srsname=EPSG:4326';

var MapSource1=new ol.source.Vector({
	format: new ol.format.GeoJSON(),
	url:  MapURL1
});
var VecMap1 = new ol.layer.Vector({
	source: MapSource1
});


var MapURL2='http://localhost:8080/geoserver/wfs?service=wfs&version=1.1.0&'+
'request=GetFeature&typeNames=WHUMap_Xin:WHUMapBg&'+
'outputFormat=application/json&srsname=EPSG:4326';

var MapSource2=new ol.source.Vector({
	format: new ol.format.GeoJSON(),
	url: MapURL2
});
var VecMap2 = new ol.layer.Vector({
	source: MapSource2
});


//两个图像数据，美观用
var ImageMap1 = new ol.layer.Image({
	source: new ol.source.ImageWMS({
		ratio: 1,
		//自己的服务url,不是完整链接，因为下面还要设置参数
		url: 'http://localhost:8080/geoserver/WHUMap_Xin/wms',
		//设置服务参数
		params: {
			'FORMAT': format,
			'VERSION': '1.1.0',
			STYLES: '',
			//图层信息
			LAYERS: 'WHUMap_Xin:WHUMapBg',
		}
	})
});

var ImageMap2 = new ol.layer.Image({
	source: new ol.source.ImageWMS({
		ratio: 1,
		//自己的服务url,不是完整链接，因为下面还要设置参数
		url: 'http://localhost:8080/geoserver/WHUMap_Xin/wms',
		//设置服务参数
		params: {
			'FORMAT': format,
			'VERSION': '1.1.0',
			STYLES: '',
			//图层信息
			LAYERS: 'WHUMap_Xin:WHUMap',
		}
	})
});


var BasicMap=new ol.layer.Tile({source: new ol.source.OSM()});

//设置地图投影
var projection = new ol.proj.Projection({
	code: 'EPSG:4326',//投影编码
	units: 'degrees',
	axisOrientation: 'neu'
});

var mousePositionControl = new ol.control.MousePosition({
	coordinateFormat: ol.coordinate.createStringXY(4),
	projection: 'EPSG:4326',
	// comment the following two lines to have the mouse position
	// be placed within the map.
	className: 'custom-mouse-position',
	target: document.getElementById('mouse-position'),
	undefinedHTML: '&nbsp;'
});

var vectorSourcePoints = new ol.source.Vector();
var vectorConvexPolygon = new ol.source.Vector();

var vectorLayerPoints = new ol.layer.Vector({
	source: vectorSourcePoints
});

var vectorLayerConvexPolygon = new ol.layer.Vector({
	source: vectorConvexPolygon
});


//创建用于新绘制feature的layer
var drawLayer = new ol.layer.Vector({
	source: new ol.source.Vector()
});

var OSMMap = new ol.layer.Tile({source: new ol.source.OSM()});

var myview=new ol.View({
	//设置投影
	projection: projection,
	//center: [114.361951666549,30.537112086553],zoom:15
});
//设置地图,先加载美观的图像数据
var map = new ol.Map({
	//地图中的比例尺等控制要素
	controls: ol.control.defaults({
		attribution: false
	}).extend([
	           new ol.control.ScaleLine(),mousePositionControl
	           ]),
	           //设置显示的容器
	           target: 'map',
	           //设置图层
	           layers: [
	                    //添加图层
	                    //BasicMap,
	                    OSMMap,ImageMap1,ImageMap2,vectorLayerPoints,vectorLayerConvexPolygon,drawLayer
	                    ],
	                    //设置视图
	                    view: myview
});

//地图显示，其实也可不设置，在view当中设置好center和zoom即可。但下列代码是给与一个刚好看到全部的合适视角。具体见API
map.getView().fit(bounds, map.getSize());

//专题数据
var wfsVectorLayer2=null;
var showmapStatus=true;
myview.on('propertychange', function(e) {
	var view=map.getView().getZoom();
	var center=map.getView().getCenter();
	var center_x=center[0];
	var center_y=center[1];
	if(view>=15&&center_x>114.34959598862&&center_x<114.358078712253&&center_y>30.5266841001062&&center_y<30.535330320335)
	{
		if(!showmapStatus)
		{
			map.addLayer(ImageMap1);
			map.addLayer(ImageMap2);
			map.addLayer(vectorLayerPoints);
			map.addLayer(vectorLayerConvexPolygon);
			map.addLayer(drawLayer);
			showmapStatus=true;
			if (WFSStatus) {
				map.addLayer(wfsVectorLayer2);
			}
		}
	}
	else
	{
		map.removeLayer(ImageMap1);
		map.removeLayer(ImageMap2);
		map.removeLayer(vectorLayerPoints);
		map.removeLayer(vectorLayerConvexPolygon);
		map.removeLayer(drawLayer);
		if (WFSStatus) {
			map.removeLayer(wfsVectorLayer2);
		}
		showmapStatus=false;
	}
});

//将锚点放置至中心,不放在左上角挤占位置
var anchor = new ol.Overlay({
	element: document.getElementById('anchor')
});

//若未登录回登录界面
function gotoLogin()
{
	window.location.href="login.jsp";
}
