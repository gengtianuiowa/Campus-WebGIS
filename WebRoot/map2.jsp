<!-- 解决中文乱码问题 -->
<%@ page language="java" import="java.util.*" import="java.sql.*" import="java.lang.String" pageEncoding="UTF-8"%>

<!Doctype html>
<html xmlns=http://www.w3.org/1999/xhtml class="HtmlSet">

<head>                  
    <meta http-equiv=Content-Type content="text/html;charset=utf-8"> 
    <meta http-equiv=X-UA-Compatible content="IE=edge,chrome=1">
    <meta content=always name=referrer>
    <title>MrFrost地图交互系统</title>
    
    <link href="ol3.17.1/ol.css" rel="stylesheet" type="text/css" />
    <link href="./css/mysetting.css" rel="stylesheet" type="text/css" />
    <link rel="shortcut icon"href="images/favicon.ico">
    <script type="text/javascript" src="mapdata/ol.js" charset="utf-8"></script>
    <script src="ol3.17.1/ol.js" type="text/javascript" charset="utf-8"></script>
  	<script src="ol3.17.1/zepto.min.js" type="text/javascript" charset="utf-8"></script>
   
       <!-- 支持图表 -->
    <script src="http://echarts.baidu.com/build/dist/echarts-all.js"></script>
    
     <script src="//npmcdn.com/@turf/turf@3.5.1/turf.min.js"></script>
     <script src="assets/js/es6-promise.min.js"></script>
     <script src="https://cdn.polyfill.io/v2/polyfill.min.js?features=requestAnimationFrame,Element.prototype.classList,URL,fetch"></script>
    <script src="assets/js/helpers.js"></script>
   
</head>

<body>
  	<div id="anchor1"><img id="anchorImg" src="./images/anchor.png" alt="示例锚点"/></div>
    <div id="map" style="width: 100%;height :100%"></div>
    <!-- 控制游客的访问权限 -->
     <%
  boolean flag=(Boolean)session.getAttribute("flag");
	if(flag)
	{
	%>
		<!--很简单，不用注释。注意button都在同一个类里-->
        <input type="button" class="bt" id="bt1" onClick="moveToLeft();" value="左移" />
        <input type="button" class="bt" id="bt2" onClick="moveToRight();" value="右移" />
        <input type="button" class="bt" id="bt3" onClick="moveToUp();" value="上移" />
        <input type="button" class="bt" id="bt4" onClick="moveToDown();" value="下移" />
        <input type="button" class="bt" id="bt5" onClick="moveToWHU();" value="返回" />
        <input type="button" class="bt" id="bt6" onClick="zoomIn();" value="放大" />
        <input type="button" class="bt" id="bt7" onClick="zoomOut();" value="缩小" />
        <input type="button" class="bt" id="bt8" onClick="PaintLine();" value="绘制线" />
        <input type="button" class="bt" id="bt9" onClick="PaintPoligon();" value="绘制面" />
        <input type="button" class="bt" id="bt10" onClick="RemovePaints();" value="清除绘制" />
        <input type="button" class="bt" id="bt11" onClick="showAttTb();" value="属性表" />
        <input type="button" class="bt" id="bt12" onClick="showChart1();" value="统计图表1" />
        <input type="button" class="bt" id="bt13" onClick="showChart2();" value="统计图表2" />
        <input type="button" class="bt" id="bt14" onClick="showChart3();" value="统计图表3" />
        <input type="button" class="bt" id="bt15" onClick="Transform();" value="转换格式" />
        <input type="button" class="bt" id="bt16" onClick="Edit();" value="开始编辑" />
        <input type="button" class="bt" id="bt17" onClick="stopEdit();" value="停止编辑" />
        <input type="button" class="bt" id="bt18" onClick="createConvex();" value="生成凸壳" />
        <input type="button" class="bt" id="bt19" onClick="selectFeature();" value="选取要素" />
        <input type="button" class="bt" id="bt20" onClick="addFeature();" value="添加要素" />
        <input type="button" class="bt" id="bt21" onClick="deleteFeature();" value="删除要素" />
        <input type="button" class="bt" id="bt22" onClick="showFeature();" value="专题数据" />
     <%
	 }
	 else 
	 {
	 %>
	  <input type="button"  id="bt1" class="bt" value="登录" onClick="gotoLogin()">
	 <%
	 }
	  %>
	 
	   <%
	if(flag)
	{
	%>
	<input type="button" value="查询" onclick="queryWfs();" />
  <input id="add" type="checkbox" value="add" />新增
  <input id="saveNew" type="button" value="保存" onclick="onSaveNew();" />
	<div id="navigate-container" class="FloatControl" >
   		<span class="position-span">当前鼠标坐标为：</span> 
        <span id="mouse-position" ></span> 
    </div>
    
    <div class="attribute-wrapper" id="att">
    	<span id="nameSearch" class="attTbl">名称：</span> <span id="POI_name" class="attTbl"></span> 
    	<br><br>
        <span id="ctgySearch" class="attTbl">类型：</span> <span id="POI_ctgy" class="attTbl"></span> 
        <input type="button" class="bt" id="bt_att" onClick="closeAtt();" value="关闭" />
    </div>
	
    <div class="input-wrapper"> 
<!-- 	    <input type="text" class="input" id="coorInput"  placeholder="请输入想要转到的坐标" /> -->
<!--         <input type="button" class="bt" onClick="moveToCoor();" value="确定" /> -->
        <input type="text" class="input" id="POIInput"  placeholder="请输入想要转到的POI" />
        <input type="button" class="search-btn" onClick="moveToPOI();" value="确定" />
    </div> 
    
	<div id="light" class="white_content">
		<div id="chart" style="height:400px;width:600px"></div>
		<input type="button" class="bt" onClick="closeChart();" value="关闭图表" />
	</div> 
    <div id="fade" class="black_overlay"></div> 
         <%
	 }
	 %>
    <script>   
        var format = 'image/png';
        var bounds = [114.361951666549,30.537112086553,114.36666490291,30.5419052728032];//范围


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


		// 创建用于新绘制feature的layer
	    var drawLayer = new ol.layer.Vector({
	      source: new ol.source.Vector()
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
                ImageMap1,ImageMap2,vectorLayerPoints,vectorLayerConvexPolygon,drawLayer
            ],
            //设置视图
            view: new ol.View({
                //设置投影
                projection: projection,
                //center: [114.361951666549,30.537112086553],zoom:15
            })
        });

        //地图显示，其实也可不设置，在view当中设置好center和zoom即可。但下列代码是给与一个刚好看到全部的合适视角。具体见API
        map.getView().fit(bounds, map.getSize());
        /*var map = new ol.Map({
        target: 'map',
        layers: [
          new ol.layer.Tile({
            source: new ol.source.OSM()
          }),
          vectorLayerPoints,
          vectorLayerConvexPolygon
        ],
        view: new ol.View({
          center: ol.proj.fromLonLat([-1.5603, 47.2383]),
          zoom: 10
        })
      });*/
        
        //将锚点放置至中心,不放在左上角挤占位置
         var anchor = new ol.Overlay({
	        element: document.getElementById('anchor')
	      });

    /*       map.on('singleclick', function(event){
        // 通过getEventCoordinate方法获取地理位置，再转换为wgs84坐标，并弹出对话框显示
        alert(ol.proj.transform(map.getEventCoordinate(event), 'EPSG:3857', 'EPSG:4326'));
    }) */

		//若未登录回登录界面
 		function gotoLogin()
      {
      	window.location.href="login.jsp";
      }
      

		//控制导航，代码很简单，不赘述
        function moveToLeft() {
            var view = map.getView();
            var mapCenter = view.getCenter();
            mapCenter[0] += 0.0001;
            view.setCenter(mapCenter);
            map.render();
        }

        function moveToRight() {
            var view = map.getView();
            var mapCenter = view.getCenter();
            mapCenter[0] -= 0.0001;
            view.setCenter(mapCenter);
            map.render();
        }

        function moveToUp() {
            var view = map.getView();	
            var mapCenter = view.getCenter();
            mapCenter[1] -= 0.0001;
            view.setCenter(mapCenter);
            map.render();
        }

        function moveToDown() {
            var view = map.getView();
            var mapCenter = view.getCenter();
            mapCenter[1] += 0.0001;
            view.setCenter(mapCenter);
            map.render();
        }

        function moveToWHU() {
            var view = map.getView();
            map.getView().fit(bounds, map.getSize());
        }

        function zoomIn() {
            var view = map.getView();
            view.setZoom(view.getZoom() + 1);
        }

        function zoomOut() {
            var view = map.getView();
            view.setZoom(view.getZoom() - 1);
        }
        
        //移动至指定坐标
        function moveToCoor(){
        //var coor= [114.3637,30.5402];
        //动态创建数组
       var coor=new Array(2);
       //注意这个.value！否则无法正常获取！清楚没有尾部和.value和.innerHTML的区别
       var get=document.getElementById('POIInput').value;
       var result=get.split(",");
		for(var i=0;i<2;i++){
		  coor[i]=result[i];
		}
        var anchor = new ol.Overlay({
	        element: document.getElementById('anchor1')
	      });
	      // 关键的一点，需要设置附加到地图上的位置
	      anchor.setPosition(coor);
	      // 然后添加到map上
	      map.addOverlay(anchor);
        }

		/*//设置几个固定的POI
		var coor_southgate=[114.3653,30.5371];
		var coor_qinglou=[114.3653,30.5382];
		var coor_13dorm=[114.3637,30.5394];*/
		
		var vector,POI_id,POI_category;
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
		
		var newId = 1;
    var wfsVectorLayer = null;
    var drawedFeature = null;


    // 添加绘制新图形的interaction，用于添加新的线条
    var drawInteraction = new ol.interaction.Draw({
      type: 'Point',
      source: drawLayer.getSource()
    });
    drawInteraction.on('drawend', function(e) {
      // 绘制结束时暂存绘制的feature
      drawedFeature = e.feature;
    });

    
    function queryWfs() {
      if (wfsVectorLayer) {
        map.removeLayer(wfsVectorLayer);
      }

      wfsVectorLayer = new ol.layer.Vector({
        source: new ol.source.Vector({
          format: new ol.format.GeoJSON({
            geometryName: 'the_geom'
          }),
          url: 'http://localhost:8080/geoserver/wfs?service=wfs&version=1.1.0&request=GetFeature&typeNames=nyc_roads:POI&outputFormat=application/json&srsname=EPSG:4326'
        })
        
      });
      map.addLayer(wfsVectorLayer);
    }

    $('#add').change(function() {
      if (this.checked) {
        // 勾选新增复选框时，添加绘制的Interaction
        map.removeInteraction(drawInteraction);
        map.addInteraction(drawInteraction);
      } else {
        // 取消勾选新增复选框时，移出绘制的Interaction，删除已经绘制的feature
        map.removeInteraction(drawInteraction);
        if (drawedFeature) {
          drawLayer.getSource().removeFeature(drawedFeature);
        }
        drawedFeature = null;
      }
    });

    // 保存新绘制的feature
    function onSaveNew() {
      // 转换坐标
      var geometry = drawedFeature.getGeometry().clone();
      /* geometry.applyTransform(function(flatCoordinates, flatCoordinates2, stride) {
        for (var j = 0; j < flatCoordinates.length; j += stride) {
          var y = flatCoordinates[j];
          var x = flatCoordinates[j + 1];
          flatCoordinates[j] = x;
          flatCoordinates[j + 1] = y;
        }
      }); */

      // 设置feature对应的属性，这些属性是根据数据源的字段来设置的
      var newFeature = new ol.Feature();
      newFeature.setId( newId);
      newFeature.setGeometryName('the_geom');
      newFeature.set('the_geom', null);
      newFeature.set('id',99999);
      newFeature.set('note', 'test');
      newFeature.set('category', 'test1');
var watch1=geometry.getCoordinates();
      newFeature.setGeometry(new ol.geom.Point(geometry.getCoordinates()));

      addWfs([newFeature]);
      // 更新id
      newId = newId + 1;
      // 3秒后，自动刷新页面上的feature
      setTimeout(function() {
        drawLayer.getSource().clear();
        queryWfs();
      }, 3000);
    }

    // 添加到服务器端
    function addWfs(features) {
      var WFSTSerializer = new ol.format.WFS();
      var featObject = WFSTSerializer.writeTransaction(features,
        null, null, {
          featureType: 'POI',
          featureNS: 'http://geoserver.org/nyc_roads',
          srsName: 'EPSG:4326'
        });
      var serializer = new XMLSerializer();
      var featString = serializer.serializeToString(featObject);
      var request = new XMLHttpRequest();
      request.open('POST', 'http://localhost:8080/geoserver/wfs?service=wfs');
      request.setRequestHeader('Content-Type', 'text/xml');
      request.send(featString);
    }

		

		//画面	
		var poligonStatus=false;
		var poligonLayer;
		var drawPoligon;
		var poligonFill=[255,255,255,0];
		function PaintPoligon(){
		if(!poligonStatus)
		{
				//为绘制准备的layer和interaction
			poligonLayer = new ol.layer.Vector({
		        source: new ol.source.Vector(),
		        style: new ol.style.Style({
		            stroke: new ol.style.Stroke({
		                color: 'blue',
		                size: 1,	
		            }),
		            fill: new ol.style.Fill({  
                        //填充颜色  
                        color: 'rgba(37,241,239,0.2)'  
                    })
		        })
		    });
			drawPoligon=new ol.interaction.Draw({
		        type: 'Polygon',
		        source: poligonLayer.getSource()    // 注意设置source，这样绘制好的线，就会添加到这个source里
		    });
		    map.addLayer(poligonLayer);
		    map.addInteraction(drawPoligon);
		    poligonStatus=true;
    	}else
    	{
    		poligonStatus=false;
    		map.removeInteraction(drawPoligon);
    	}
		}
		
		function RemovePaints(){
		map.removeInteraction(drawLine);
		map.removeInteraction(drawPoligon);
		
		map.removeLayer(lineLayer);
		map.removeLayer(poligonLayer);
		}
		
		
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
       
       function showAttTb()
       {
        document.getElementById('att').style.display='block';
       }
       
       function closeChart()
       {
        document.getElementById('light').style.display='none';
        document.getElementById('fade').style.display='none';
       }
       
       function closeAtt()
       {
        document.getElementById('att').style.display='none';
       }
       
       
       var editStatus=false;
       var mapStatus=1;//1图像，2矢量
       var select,modify;
       function Edit(){
	       if(editStatus===false)
	       {
	       	   if(mapStatus===1)
	       	   {
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
			   		map.removeLayer(ImageMap1);
	   				map.removeLayer(ImageMap2);
	   				map.addLayer(VecMap2);
			   		map.addLayer(VecMap1);
			   		mapStatus=2;
	       	   }
				select = new ol.interaction.Select({
				  wrapX: false
				});
				
				modify = new ol.interaction.Modify({
				  features: select.getFeatures()
				});
				
				  map.addInteraction(select);
				  map.addInteraction(modify);
				  editStatus=true;
			 }
       }
       
       function stopEdit()
       {
	       if(editStatus)
	       {
			 	map.removeInteraction(select);
				map.removeInteraction(modify);
				Transform();	
		        editStatus=false;
	        }
       }
       
       
       function Transform(){
	       if(mapStatus===1)
	       {
		        map.removeLayer(ImageMap1);
		   		map.removeLayer(ImageMap2); 
		   		
		   		map.addLayer(VecMap2);
		   		map.addLayer(VecMap1); 
		   		mapStatus=2;
	   		}else
	   		{
		   		map.removeLayer(VecMap2);
		   		map.removeLayer(VecMap1); 
		   		
		   		map.addLayer(ImageMap1);
		   		map.addLayer(ImageMap2);
		   		mapStatus=1;
	   		}
       }
       
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
      

    </script>
</body>

</html>