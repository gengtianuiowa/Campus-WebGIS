//开始图标绘制的数据准备
//'教学楼','图书馆','院办','门','操场'
var tchBd,lby,sclOfc,gate,plgd,bldSearch;

//教学楼
bldSearch='http://localhost:8080/geoserver/wfs?service=wfs&version=1.1.0&'+
'request=GetFeature&typeNames=WHUMap_Xin:poi&'+
'outputFormat=application/json&srsname=EPSG:4326&cql_filter=category=%27教学楼%27';
var bldSource1=new ol.source.Vector({
	format: new ol.format.GeoJSON(),
	url: bldSearch
});

var bldvec1 = new ol.layer.Vector({
	source:bldSource1
});
map.addLayer(bldvec1);
//注意！！！因为是异步加载，所以必须检测图层是否加载成功，否则将会算成0。ADD仅仅是一个计算的过程，所以之后要remove
var listenerKey = bldSource1.on('change', function(){
	if (bldSource1.getState() === 'ready') {    // 判定是否加载完成
		tchBd = bldSource1.getFeatures().length;
		map.removeLayer(bldvec1);
	}
});



//图书馆
bldSearch='http://localhost:8080/geoserver/wfs?service=wfs&version=1.1.0&'+
'request=GetFeature&typeNames=WHUMap_Xin:poi&'+
'outputFormat=application/json&srsname=EPSG:4326&cql_filter=category=%27图书馆%27';
var bldSource2=new ol.source.Vector({
	format: new ol.format.GeoJSON(),
	url: bldSearch
});

var bldvec2 = new ol.layer.Vector({
	source:bldSource2
});
map.addLayer(bldvec2);
//注意！！！因为是异步加载，所以必须检测图层是否加载成功，否则将会算成0。ADD仅仅是一个计算的过程，所以之后要remove
var listenerKey = bldSource2.on('change', function(){
	if (bldSource2.getState() === 'ready') {    // 判定是否加载完成
		lby = bldSource2.getFeatures().length;
		map.removeLayer(bldvec2);
	}
});

//院办
bldSearch='http://localhost:8080/geoserver/wfs?service=wfs&version=1.1.0&'+
'request=GetFeature&typeNames=WHUMap_Xin:poi&'+
'outputFormat=application/json&srsname=EPSG:4326&cql_filter=category=%27院办%27';
var bldSource3=new ol.source.Vector({
	format: new ol.format.GeoJSON(),
	url: bldSearch
});

var bldvec3 = new ol.layer.Vector({
	source:bldSource3
});
map.addLayer(bldvec3);
//注意！！！因为是异步加载，所以必须检测图层是否加载成功，否则将会算成0。ADD仅仅是一个计算的过程，所以之后要remove
var listenerKey = bldSource3.on('change', function(){
	if (bldSource3.getState() === 'ready') {    // 判定是否加载完成
		sclOfc = bldSource3.getFeatures().length;
		map.removeLayer(bldvec3);
	}
});

//门
bldSearch='http://localhost:8080/geoserver/wfs?service=wfs&version=1.1.0&'+
'request=GetFeature&typeNames=WHUMap_Xin:poi&'+
'outputFormat=application/json&srsname=EPSG:4326&cql_filter=category=%27门%27';
var bldSource4=new ol.source.Vector({
	format: new ol.format.GeoJSON(),
	url: bldSearch
});

var bldvec4 = new ol.layer.Vector({
	source:bldSource4
});
map.addLayer(bldvec4);
//注意！！！因为是异步加载，所以必须检测图层是否加载成功，否则将会算成0。ADD仅仅是一个计算的过程，所以之后要remove
var listenerKey = bldSource4.on('change', function(){
	if (bldSource4.getState() === 'ready') {    // 判定是否加载完成
		gate = bldSource4.getFeatures().length;
		map.removeLayer(bldvec4);
	}
});

//操场
bldSearch='http://localhost:8080/geoserver/wfs?service=wfs&version=1.1.0&'+
'request=GetFeature&typeNames=WHUMap_Xin:poi&'+
'outputFormat=application/json&srsname=EPSG:4326&cql_filter=category=%27操场%27';
var bldSource5=new ol.source.Vector({
	format: new ol.format.GeoJSON(),
	url: bldSearch
});

var bldvec5 = new ol.layer.Vector({
	source:bldSource5
});
map.addLayer(bldvec5);
//注意！！！因为是异步加载，所以必须检测图层是否加载成功，否则将会算成0。ADD仅仅是一个计算的过程，所以之后要remove
var listenerKey = bldSource5.on('change', function(){
	if (bldSource5.getState() === 'ready') {    // 判定是否加载完成
		plgd = bldSource5.getFeatures().length;
		map.removeLayer(bldvec5);
	}
});

//设置图表，echart上官网，自动生成代码
function showChart1()
{
	var myChart = echarts.init(document.getElementById('chart')); 

	option = {
			title : {
				text: 'POI数量统计',
				subtext: '来源：GeoServer',
				x:'center'
			},
			tooltip : {
				trigger: 'item',
				formatter: "{a} <br/>{b} : {c} ({d}%)"
			},
			legend: {
				orient : 'vertical',
				x : 'left',
				data:['教学楼','图书馆','院办','门','操场']
			},
			toolbox: {
				show : true,
				feature : {
					mark : {show: true},
					dataView : {show: true, readOnly: false},
					magicType : {
						show: true, 
						type: ['pie', 'funnel'],
						option: {
							funnel: {
								x: '25%',
								width: '50%',
								funnelAlign: 'left',
								max: 1548
							}
						}
					},
					restore : {show: true},
					saveAsImage : {show: true}
				}
			},
			calculable : true,
			series : [
			          {
			        	  name:'访问来源',
			        	  type:'pie',
			        	  radius : '55%',
			        	  center: ['50%', '60%'],
			        	  data:[
			        	        {value:tchBd, name:'教学楼'},
			        	        {value:lby, name:'图书馆'},
			        	        {value:sclOfc, name:'院办'},
			        	        {value:gate, name:'门'},
			        	        {value:plgd, name:'操场'}
			        	        ]
			          }
			          ]
	};
	// 为echarts对象加载数据 
	myChart.setOption(option); 

	document.getElementById('light').style.display='block';
	document.getElementById('fade').style.display='block';
}

var fucb,dm;
bldSearch='http://localhost:8080/geoserver/wfs?service=wfs&version=1.1.0&'+
'request=GetFeature&typeNames=WHUMap&'+
'outputFormat=application/json&srsname=EPSG:4326&cql_filter=category=%27宿舍%27';
var bld2Source=new ol.source.Vector({
	format: new ol.format.GeoJSON(),
	url: bldSearch
});

var bld2vec = new ol.layer.Vector({
	source:bld2Source
});
map.addLayer(bld2vec);
//注意！！！因为是异步加载，所以必须检测图层是否加载成功，否则将会算成0。ADD仅仅是一个计算的过程，所以之后要remove
var listenerKey = bld2Source.on('change', function(){
	if (bld2Source.getState() === 'ready') {    // 判定是否加载完成
		dm = bld2Source.getFeatures().length;
		map.removeLayer(bld2vec);
	}
});

bldSearch='http://localhost:8080/geoserver/wfs?service=wfs&version=1.1.0&'+
'request=GetFeature&typeNames=WHUMap&'+
'outputFormat=application/json&srsname=EPSG:4326&cql_filter=category=%27功能建筑%27';
var bld2Source2=new ol.source.Vector({
	format: new ol.format.GeoJSON(),
	url: bldSearch
});

var bld2vec2 = new ol.layer.Vector({
	source:bld2Source2
});
map.addLayer(bld2vec2);
//注意！！！因为是异步加载，所以必须检测图层是否加载成功，否则将会算成0。ADD仅仅是一个计算的过程，所以之后要remove
var listenerKey = bld2Source2.on('change', function(){
	if (bld2Source2.getState() === 'ready') {    // 判定是否加载完成
		fucb = bld2Source2.getFeatures().length;
		map.removeLayer(bld2vec2);
	}
});

function showChart2()
{
	var myChart = echarts.init(document.getElementById('chart')); 

	option = {
			title : {
				text: '建筑物数量统计',
				subtext: '来源：GeoServer',
				x:'center'
			},
			tooltip : {
				trigger: 'item',
				formatter: "{a} <br/>{b} : {c} ({d}%)"
			},
			legend: {
				orient : 'vertical',
				x : 'left',
				data:['宿舍','功能建筑']
			},
			toolbox: {
				show : true,
				feature : {
					mark : {show: true},
					dataView : {show: true, readOnly: false},
					magicType : {
						show: true, 
						type: ['pie', 'funnel'],
						option: {
							funnel: {
								x: '25%',
								width: '50%',
								funnelAlign: 'left',
								max: 1548
							}
						}
					},
					restore : {show: true},
					saveAsImage : {show: true}
				}
			},
			calculable : true,
			series : [
			          {
			        	  name:'访问来源',
			        	  type:'pie',
			        	  radius : '55%',
			        	  center: ['50%', '60%'],
			        	  data:[
			        	        {value:fucb, name:'功能建筑'},
			        	        {value:dm, name:'宿舍'}
			        	        ]
			          }
			          ]
	};
	// 为echarts对象加载数据 
	myChart.setOption(option); 

	document.getElementById('light').style.display='block';
	document.getElementById('fade').style.display='block';
}

var poic,bdc;
bldSearch='http://localhost:8080/geoserver/wfs?service=wfs&version=1.1.0&'+
'request=GetFeature&typeNames=WHUMap&'+
'outputFormat=application/json&srsname=EPSG:4326';
var bld3Source=new ol.source.Vector({
	format: new ol.format.GeoJSON(),
	url: bldSearch
});

var bld3vec = new ol.layer.Vector({
	source:bld3Source
});
map.addLayer(bld3vec);
//注意！！！因为是异步加载，所以必须检测图层是否加载成功，否则将会算成0。ADD仅仅是一个计算的过程，所以之后要remove
var listenerKey = bld3Source.on('change', function(){
	if (bld3Source.getState() === 'ready') {    // 判定是否加载完成
		bdc = bld3Source.getFeatures().length;
		map.removeLayer(bld3vec);
	}
});

bldSearch='http://localhost:8080/geoserver/wfs?service=wfs&version=1.1.0&'+
'request=GetFeature&typeNames=WHUMap_Xin:poi&'+
'outputFormat=application/json&srsname=EPSG:4326';
var bld3Source2=new ol.source.Vector({
	format: new ol.format.GeoJSON(),
	url: bldSearch
});

var bld3vec2 = new ol.layer.Vector({
	source:bld3Source2
});
map.addLayer(bld3vec2);
//注意！！！因为是异步加载，所以必须检测图层是否加载成功，否则将会算成0。ADD仅仅是一个计算的过程，所以之后要remove
var listenerKey = bld3Source2.on('change', function(){
	if (bld3Source2.getState() === 'ready') {    // 判定是否加载完成
		poic = bld3Source2.getFeatures().length;
		map.removeLayer(bld3vec2);
	}
});

function showChart3()
{
	var myChart = echarts.init(document.getElementById('chart')); 

	option = {
			title : {
				text: '数量对比',
				subtext: '来源：GeoServer',
				x:'center'
			},
			tooltip : {
				trigger: 'item',
				formatter: "{a} <br/>{b} : {c} ({d}%)"
			},
			legend: {
				orient : 'vertical',
				x : 'left',
				data:['poi','建筑']
			},
			toolbox: {
				show : true,
				feature : {
					mark : {show: true},
					dataView : {show: true, readOnly: false},
					magicType : {
						show: true, 
						type: ['pie', 'funnel'],
						option: {
							funnel: {
								x: '25%',
								width: '50%',
								funnelAlign: 'left',
								max: 1548
							}
						}
					},
					restore : {show: true},
					saveAsImage : {show: true}
				}
			},
			calculable : true,
			series : [
			          {
			        	  name:'访问来源',
			        	  type:'pie',
			        	  radius : '55%',
			        	  center: ['50%', '60%'],
			        	  data:[
			        	        {value:poic, name:'poi'},
			        	        {value:bdc, name:'建筑'},
			        	        ]
			          }
			          ]
	};
	// 为echarts对象加载数据 
	myChart.setOption(option); 

	document.getElementById('light').style.display='block';
	document.getElementById('fade').style.display='block';
}


function closeChart()
{
	document.getElementById('light').style.display='none';
	document.getElementById('fade').style.display='none';
}
