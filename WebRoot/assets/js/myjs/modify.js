//显示要素
var drawedFeature = null;
var newId=1;
var WFSStatus=false;
var POI_categories;
var fCount;
var showFeatures;
/*
var source=new ol.source.Vector({
	format: new ol.format.GeoJSON(),
	url: 'http://localhost:8080/geoserver/wfs?service=wfs&version=1.1.0&request=GetFeature&typeNames=WHUMap_Xin:poi&outputFormat=application/json&srsname=EPSG:4326'
});
wfsVectorLayer2=new ol.layer.Vector({
	source:source
	,
	style: new ol.style.Style({
		image:new ol.style.Circle({
			radius:7,
			fill:new ol.style.Fill({ color:'orange'})
		,
				stroke:new ol.style.Stroke({color:'yellow',width:2})
		})
	})
});
map.addLayer(wfsVectorLayer2);
var pointFeatures = wfsVectorLayer2.getSource().getFeatures();
var listenerKey = source.on('change', function(){
	if (source.getState() === 'ready') {    // 判定是否加载完成
		var pointFeatures = wfsVectorLayer2.getSource().getFeatures();
		fCount=source.getFeatures().length;
		POI_categories=new Array([fCount]);
		showFeatures =new Array([fCount]);
		for(var i=0;i<fCount;i++)
		{
			POI_categories[i]=pointFeatures[i].get("category");
			showFeatures[i]=pointFeatures[i];
		}
		map.removeLayer(wfsVectorLayer2);
	}	
});


function queryWfs() {
	if(!WFSStatus)
	{
		if (wfsVectorLayer2) {
			map.removeLayer(wfsVectorLayer2);
		}
		
		var pointFeatures = wfsVectorLayer2.getSource().getFeatures();
		for(var i=0;i<fCount;i++)
		{
			var watch=POI_categories[i];
			if(POI_categories[i]==='门')
			{
				showFeatures[i].setStyle(pointStyleSet('green'));
			}
			if(POI_categories[i]==='教学楼')
			{
				showFeatures[i].setStyle(pointStyleSet('red'));
			}
			if(POI_categories[i]==='宿舍')
			{
				showFeatures[i].setStyle(pointStyleSet('pink'));
			}
			if(POI_categories[i]==='院办')
			{
				showFeatures[i].setStyle(pointStyleSet('blue'));
			}
			if(POI_categories[i]==='操场')
			{
				showFeatures[i].setStyle(pointStyleSet('brown'));
			}
		}
		showLegend();
		map.addLayer(wfsVectorLayer2);
		WFSStatus=true;
	}else
	{
		map.removeLayer(wfsVectorLayer2);
		closeLegend();
		WFSStatus=false;
	}
}*/

var wfsVectorLayer=null;
function queryWfs() {
	if(!WFSStatus)
	{
		if (wfsVectorLayer) {
			map.removeLayer(wfsVectorLayer);
		}

		wfsVectorLayer = new ol.layer.Vector({
			source: new ol.source.Vector({
				format: new ol.format.GeoJSON({
					geometryName: 'the_geom'
				}),
				url: 'http://localhost:8080/geoserver/wfs?service=wfs&version=1.1.0&request=GetFeature&typeNames=WHUMap_Xin:poi&outputFormat=application/json&srsname=EPSG:4326'
			})
		,
		style: function(feature, resolution) {
			var category=feature.get("category");
			feature.setStyle(pointStyleSet('yellow'));
			if(category==='门')
			{
				feature.setStyle(pointStyleSet('green'));
			}
			if(category==='教学楼')
			{
				feature.setStyle(pointStyleSet('red'));
			}
			if(category==='宿舍')
			{
				feature.setStyle(pointStyleSet('pink'));
			}
			if(category==='院办')
			{
				feature.setStyle(pointStyleSet('blue'));
			}
			if(category==='操场')
			{
				feature.setStyle(pointStyleSet('brown'));
			}
		}
		});
		map.addLayer(wfsVectorLayer);
		showLegend();
		WFSStatus=true;
	}else
	{
		map.removeLayer(wfsVectorLayer);
		closeLegend();
		WFSStatus=false;
	}
}

function pointStyleSet(color)
{
	var style=new ol.style.Style({
		image:new ol.style.Circle({
			radius:7,
			fill:new ol.style.Fill({ color:color})
		/*,
			stroke:new ol.style.Stroke({color:'yellow',width:2})*/
		})
	});
	return style;
}

function queryWfs_geoJSon() {
	if (wfsVectorLayer2) {
		map.removeLayer(wfsVectorLayer2);
	}

	var geojsonObject={"type":"FeatureCollection","totalFeatures":31,"features":[{"type":"Feature","id":"poi.1","geometry":{"type":"Point","coordinates":[114.365222,30.53711589]},"geometry_name":"geom","properties":{"note":"信息学部南门","category":"门","id":1}},{"type":"Feature","id":"poi.2","geometry":{"type":"Point","coordinates":[114.36522441,30.53822539]},"geometry_name":"geom","properties":{"note":"信息学部教1","category":"教学楼","id":2}},{"type":"Feature","id":"poi.3","geometry":{"type":"Point","coordinates":[114.365203,30.53891425]},"geometry_name":"geom","properties":{"note":"信操","category":"操场","id":3}},{"type":"Feature","id":"poi.4","geometry":{"type":"Point","coordinates":[114.36463716,30.53758603]},"geometry_name":"geom","properties":{"note":"资源与环境科学学院","category":"院办","id":4}},{"type":"Feature","id":"poi.5","geometry":{"type":"Point","coordinates":[114.36367475,30.53937586]},"geometry_name":"geom","properties":{"note":"13舍","category":"宿舍","id":5}},{"type":"Feature","id":"poi.6","geometry":{"type":"Point","coordinates":[114.36521464,30.53972432]},"geometry_name":"geom","properties":{"note":"信息学部图书馆","category":"图书馆","id":6}},{"type":"Feature","id":"poi.7","geometry":{"type":"Point","coordinates":[114.36376717,30.53854995]},"geometry_name":"geom","properties":{"note":"国重实验室","category":"院办","id":7}},{"type":"Feature","id":"poi.8","geometry":{"type":"Point","coordinates":[114.36336499,30.54151376]},"geometry_name":"geom","properties":{"note":"北门","category":"门","id":8}},{"type":"Feature","id":"poi.9","geometry":{"type":"Point","coordinates":[114.36367611,30.53900728]},"geometry_name":"geom","properties":{"note":"11舍","category":"宿舍","id":9}},{"type":"Feature","id":"poi.10","geometry":{"type":"Point","coordinates":[114.36367135,30.53917741]},"geometry_name":"geom","properties":{"note":"12舍","category":"宿舍","id":10}},{"type":"Feature","id":"poi.11","geometry":{"type":"Point","coordinates":[114.36367254,30.53949031]},"geometry_name":"geom","properties":{"note":"14舍","category":"宿舍","id":11}},{"type":"Feature","id":"poi.12","geometry":{"type":"Point","coordinates":[114.36463305,30.53791362]},"geometry_name":"geom","properties":{"note":"遥感信息工程学院","category":"院办","id":12}},{"type":"Feature","id":"poi.13","geometry":{"type":"Point","coordinates":[114.36577162,30.53791362]},"geometry_name":"geom","properties":{"note":"测绘学院","category":"院办","id":13}},{"type":"Feature","id":"poi.14","geometry":{"type":"Point","coordinates":[114.36587037,30.53822295]},"geometry_name":"geom","properties":{"note":"信息学部教2","category":"教学楼","id":14}},{"type":"Feature","id":"poi.15","geometry":{"type":"Point","coordinates":[114.36462829,30.53823247]},"geometry_name":"geom","properties":{"note":"信息学部教3","category":"教学楼","id":15}},{"type":"Feature","id":"poi.16","geometry":{"type":"Point","coordinates":[114.36358479,30.53803338]},"geometry_name":"geom","properties":{"note":"6舍","category":"宿舍","id":16}},{"type":"Feature","id":"poi.17","geometry":{"type":"Point","coordinates":[114.36386557,30.53799769]},"geometry_name":"geom","properties":{"note":"7舍","category":"宿舍","id":17}},{"type":"Feature","id":"poi.18","geometry":{"type":"Point","coordinates":[114.36415111,30.538031]},"geometry_name":"geom","properties":{"note":"8舍","category":"宿舍","id":18}},{"type":"Feature","id":"poi.19","geometry":{"type":"Point","coordinates":[114.36239602,30.53932543]},"geometry_name":"geom","properties":{"note":"国软操场","category":"操场","id":19}},{"type":"Feature","id":"poi.74","geometry":{"type":"Point","coordinates":[114.36659628,30.5378215]},"geometry_name":"geom","properties":{"note":null,"category":null,"id":9999}},{"type":"Feature","id":"poi.73","geometry":{"type":"Point","coordinates":[114.36673576,30.53876563]},"geometry_name":"geom","properties":{"note":null,"category":null,"id":9999}},{"type":"Feature","id":"poi.75","geometry":{"type":"Point","coordinates":[114.36698,30.540325]},"geometry_name":"geom","properties":{"note":"测试","category":"测试","id":9999}},{"type":"Feature","id":"poi.76","geometry":{"type":"Point","coordinates":[114.36714,30.539509]},"geometry_name":"geom","properties":{"note":"测试","category":"测试","id":9999}},{"type":"Feature","id":"poi.77","geometry":{"type":"Point","coordinates":[114.36806,30.5396]},"geometry_name":"geom","properties":{"note":"测试","category":"测试","id":9999}},{"type":"Feature","id":"poi.78","geometry":{"type":"Point","coordinates":[114.36814,30.539509]},"geometry_name":"geom","properties":{"note":"测试","category":"测试","id":9999}},{"type":"Feature","id":"poi.79","geometry":{"type":"Point","coordinates":[114.36753,30.53989]},"geometry_name":"geom","properties":{"note":"测试","category":"测试","id":9999}},{"type":"Feature","id":"poi.80","geometry":{"type":"Point","coordinates":[114.36748,30.539804]},"geometry_name":"geom","properties":{"note":"测试","category":"测试","id":9999}},{"type":"Feature","id":"poi.81","geometry":{"type":"Point","coordinates":[114.36736,30.54026]},"geometry_name":"geom","properties":{"note":"测试","category":"测试","id":9999}},{"type":"Feature","id":"poi.82","geometry":{"type":"Point","coordinates":[114.36814,30.539509]},"geometry_name":"geom","properties":{"note":"测试","category":"测试","id":9999}},{"type":"Feature","id":"poi.83","geometry":{"type":"Point","coordinates":[114.36814,30.539509]},"geometry_name":"geom","properties":{"note":"测试","category":"测试","id":9999}},{"type":"Feature","id":"poi.88","geometry":{"type":"Point","coordinates":[114.36814,30.539509]},"geometry_name":"geom","properties":{"note":"测试","category":"测试","id":9999}}],"crs":{"type":"name","properties":{"name":"urn:ogc:def:crs:EPSG::4326"}}};

	var vectorSource = new ol.source.Vector({
		features: (new ol.format.GeoJSON()).readFeatures(geojsonObject)
	});

	var wfsVectorLayer2 = new ol.layer.Vector({
		source: vectorSource
	});
	map.addLayer(wfsVectorLayer2);
}

//增加
function addFeature()
{
//	为绘制准备的layer和interaction
	if(!lineStatus)
	{
		map.removeInteraction(drawInteraction);
		map.addInteraction(drawInteraction);

		drawInteraction.on('drawend', function(e) {
			// 绘制结束时暂存绘制的feature
			drawedFeature = e.feature;
			showSetting();
		}); 
	}else
	{
		map.removeInteraction(drawInteraction);
		lineStatus=false;	
	}
}

function showSetting()
{
	document.getElementById('light2').style.display='block';
	document.getElementById('fade').style.display='block';
}

function comfirmSetting()
{
	// 转换坐标
	var watch1=drawedFeature.getGeometry();
	var geometry = drawedFeature.getGeometry().clone();
	geometry.applyTransform(function(flatCoordinates, flatCoordinates2, stride) {
		for (var j = 0; j < flatCoordinates.length; j += stride) {
			var y = flatCoordinates[j];
			var x = flatCoordinates[j + 1];
			flatCoordinates[j] = x;
			flatCoordinates[j + 1] = y;
		}
	});


	var category = document.getElementById('insert_ctgInput').value;
	var note = document.getElementById('insert_noteInput').value;
	// 设置feature对应的属性，这些属性是根据数据源的字段来设置的
	var newFeature = new ol.Feature();
	newFeature.setId('poi.new.' + newId);
	newFeature.setGeometryName('geom');
	newFeature.set('geom', null);
	newFeature.set('id',9999);
	newFeature.set('note',note);
	newFeature.set('category',category); 
	newFeature.setGeometry(new ol.geom.Point(geometry.getCoordinates()));

	addWfs([newFeature]);
	// 更新id
	newId = newId + 1;
	// 3秒后，自动刷新页面上的feature
	setTimeout(function() {
		drawLayer.getSource().clear();
		queryWfs();
		document.getElementById('light2').style.display='none';
		document.getElementById('fade').style.display='none';
	}, 3000);

	document.getElementById('light2').style.display='none';
	lineStatus=true;
}



function closeSetting()
{
	document.getElementById('light2').style.display='none';
	document.getElementById('fade').style.display='none';
	map.removeInteraction(drawInteraction);
	lineStatus=false;
}
//添加到服务器端
function addWfs(features) {
	var WFSTSerializer = new ol.format.WFS();
	var featObject = WFSTSerializer.writeTransaction(features,
			null, null, {
		featureType: 'poi',
		featureNS: 'www.TGWCMap.com',
		srsName: 'EPSG:4326'
	});
	var serializer = new XMLSerializer();
	var featString = serializer.serializeToString(featObject);
	var request = new XMLHttpRequest();
	request.open('POST', 'http://localhost:8080/geoserver/wfs?service=wfs');
	request.setRequestHeader('Content-Type', 'text/xml');
	request.send(featString);
}

//删除，得先选择删除的要素
//选择器
var selectInteraction = new ol.interaction.Select();

var selectStatus=false;
function selectFeature()
{
	if(!selectStatus)
	{
		map.removeInteraction(selectInteraction);
		map.addInteraction(selectInteraction);
		selectInteraction.on('select', function(e) {
			// 绘制结束时暂存绘制的feature
			var selectedFeature = e.selected[0];
			var POI_category=selectedFeature.S.category;
			document.getElementById('POI_ctgy').innerText = POI_category;
			var POI_name=selectedFeature.S.note;
			document.getElementById('POI_name').innerText = POI_name;
			var POI_id=selectedFeature.a;
			document.getElementById('POI_id').innerText = POI_id;
			var POICoor=selectedFeature.getGeometry().getCoordinates();
			document.getElementById('POI_coor').innerText = POICoor;
			var POI_fid=selectedFeature.a;
			var type="showPic";
			$.ajax({
				type:"post",
				data:{type:type,POI_fid:POI_fid},
					url:"servlet/Modify",
					dataType:"text",
					success:function(result){
						if(result)
						{
							if(result==="")
								alert("没有图片");
							else{
								document.getElementById("POI_pic").src=result;
								alert("成功");
							}
						}
						
					},
					error:function(){
						document.getElementById("POI_pic").src="";
						alert("获取图片失败");
					}
			});
			selectStatus=true;	
		}); 
	}else
	{
		map.removeInteraction(selectInteraction);
		selectStatus=false;
	}
}

var attStatus=false;
function showAttTb()
{
	if(!attStatus)
	{
		document.getElementById('att').style.display='block';
		attStatus=true;
	}
	else
	{
		closeAtt();
		attStatus=false;
	}
}



function closeAtt()
{
	document.getElementById('att').style.display='none';
}

function showLegend()
{
	document.getElementById('legend').style.display='block';
}

function closeLegend()
{
	document.getElementById('legend').style.display='none';
}

function deleteFeature()
{
	// 删选择器选中的feature
	if (selectInteraction.getFeatures().getLength() > 0) {
		deleteWfs([selectInteraction.getFeatures().item(0)]);
		
		// 3秒后自动更新features
		setTimeout(function() {
			selectInteraction.getFeatures().clear();
			WFSStatus=false;
			queryWfs();
		}, 3000);
	}
}

//在服务器端删除feature
function deleteWfs(features) {
	var WFSTSerializer = new ol.format.WFS();
	var featObject = WFSTSerializer.writeTransaction(null,
			null, features, {
		featureType: 'poi',
		featureNS: 'www.TGWCMap.com',
		srsName: 'EPSG:4326',
		featurePrefix:'feature'
	});
	var serializer = new XMLSerializer();
	var featString = serializer.serializeToString(featObject);
	var request = new XMLHttpRequest();
	request.open('POST', 'http://localhost:8080/geoserver/wfs?service=wfs');
	request.setRequestHeader('Content-Type', 'text/xml');
	request.send(featString);
}

//修改
var modifiedFeatures = null;
var modifyInteraction = new ol.interaction.Modify({
	features: selectInteraction.getFeatures()
});

modifyInteraction.on('modifyend', function(e) {
	// 把修改完成的feature暂存起来
	modifiedFeatures = e.features;
	if (modifiedFeatures && modifiedFeatures.getLength() > 0) {
		// 转换坐标
		var modifiedFeature = modifiedFeatures.item(0).clone();
		// 注意ID是必须，通过ID才能找到对应修改的feature
		var watch1=modifiedFeatures.item(0).getId();
		modifiedFeature.setId(modifiedFeatures.item(0).getId());


		// 调换经纬度坐标，以符合wfs协议中经纬度的位置
		modifiedFeature.getGeometry().applyTransform(function(flatCoordinates, flatCoordinates2, stride) {
			for (var j = 0; j < flatCoordinates.length; j += stride) {
				var y = flatCoordinates[j];	
				var x = flatCoordinates[j + 1];
				flatCoordinates[j] = x;
				flatCoordinates[j + 1] = y;
			}
		});
		var y= modifiedFeature.getGeometry().A[0];
		var x= modifiedFeature.getGeometry().A[1];
		var id=modifiedFeature.a;
		var type="modify";
		$.ajax({
			type:"post",
			data:{type:type,x:x,y:y,id:id},
				url:"servlet/Modify",
				dataType:"text",
				success:function(result){
					alert(result);
					//queryWfs() ;
				},
				error:function(){
					alert("连接失败");
				}
		});
		/*modifiedFeature.setGeometryName('the_geom');
		// 把修改提交到服务器端
		var WFSTSerializer = new ol.format.WFS();
		var featObject = WFSTSerializer.writeTransaction(null,
				[modifiedFeature], null, {
			featureType: 'poi', 
			featureNS: 'www.TGWCMap.com',  // 注意这个值必须为创建工作区时的命名空间URI
			srsName: 'EPSG:4326',
			featurePrefix:'feature'
		});
		// 转换为xml内容发送到服务器端
		var serializer = new XMLSerializer();
		var featString = serializer.serializeToString(featObject);
		featString=featString.replace("<Name>the_geom</Name>","<Name>geom</Name>");
		var request = new XMLHttpRequest();
		request.open('POST', 'http://localhost:8080/geoserver/wfs?service=wfs');
		// 指定内容为xml类型
		request.setRequestHeader('Content-Type', 'text/xml');
		request.send(featString);*/
		alert("修改成功");
		WFSStatus=false;
		queryWfs();
	}
});


var modifyStatus=false;
function modifyFeature()
{
	if(!modifyStatus)
	{
		// 点选时，添加选择器到地图
		map.removeInteraction(selectInteraction);
		map.addInteraction(selectInteraction);
		map.removeInteraction(modifyInteraction);
		map.addInteraction(modifyInteraction);
	}else
	{
		// 点选时，添加选择器到地图
		map.removeInteraction(selectInteraction);
		map.removeInteraction(modifyInteraction);
	}
}