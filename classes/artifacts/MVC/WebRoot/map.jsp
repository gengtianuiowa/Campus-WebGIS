<%@ page language="java" import="java.util.*" import="java.sql.*" import="java.lang.String" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    <title>CartoMap主界面</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	<link rel="stylesheet" type="text/css" href="./css/map.css" /> 
	<link href="./v4.2.0-dist/ol.css" rel="stylesheet" type="text/css" />
	<link rel="stylesheet" href="css/poi.css"  type="text/css" />
	
  <script type="text/javascript" src='jquery-3.2.1.js'></script>
    <script type="text/javascript" src="./v4.2.0-dist/ol.js" charset="utf-8"></script>
    
     <style type="text/css">
  
  body, html{width: 100%;height: 100%;margin:0;font-family:"微软雅黑";}
    #map{height:100%;width: 100%;}
    /* 设置图标的图案 */
      @keyframes zoom
      {
        from {top: 0; left: 0; width: 16px; height: 16px;}
        20% {top: -8px; left: -8px; width: 32px; height: 32px;}
        to {top: 0; left: 0; width: 16px; height: 16px;}
      }

      @-moz-keyframes zoom /* Firefox */
      {
        from {top: 0; left: 0; width: 16px; height: 16px;}
        20% {top: -8px; left: -8px; width: 32px; height: 32px;}
        to {top: 0; left: 0; width: 16px; height: 16px;}
      }

      @-webkit-keyframes zoom /* Safari 和 Chrome */
      {
        from {top: 0; left: 0; width: 16px; height: 16px;}
        20% {top: -8px; left: -8px; width: 32px; height: 32px;}
        to {top: 0; left: 0; width: 16px; height: 16px;}
      }

      @-o-keyframes zoom /* Opera */
      {
        from {top: 0; left: 0; width: 16px; height: 16px;}
        20% {top: -8px; left: -8px; width: 32px; height: 32px;}
        to {top: 0; left: 0; width: 16px; height: 16px;}
      }
    #anchorImg
      {
        display: block;
        position: absolute;
        animation: zoom 1s;
        animation-iteration-count: infinite; /* 一直重复动画 */
        -moz-animation: zoom 1s; /* Firefox */
        -moz-animation-iteration-count: infinite; /* 一直重复动画 */
        -webkit-animation: zoom 1s;  /* Safari 和 Chrome */
        -webkit-animation-iteration-count: infinite; /* 一直重复动画 */
        -o-animation: zoom 1s; /* Opera */
        -o-animation-iteration-count: infinite; /* 一直重复动画 */
      }
  </style>
  
  <style>
    .bt{
        position:absolute;
        right:60px;
        width:60px;
        height: 20px;
        border: none;
        background-color: #d83c3c;
        font-weight: bold;
        color : #FFFFFF;
        font-family:"微软雅黑";
        font-size : 8px;
    }
    .bt:hover
    {
        background-color: #ff4545;
    }
    #bt1{
        top:100px;
    }
    #bt2{
        top:125px;
    }
    #bt3{
        top:150px;
    }
    #bt4{
        top:175px;
    }
    #bt5{
        top:200px;
    }
    #bt6{
        top:225px;
    }
    #bt7{
        top:250px;
    }
    </style>
 
  </head>
  <%
  boolean flag=(Boolean)session.getAttribute("flag");
   %>
  <body>
  	<div id="anchor" ><img id="anchorImg" src="./images/anchor.png" alt="示例锚点"/></div>
  
    <div id="map"  ></div>
    
   	<div class="form-wrapper cf">
    <input type="text" placeholder="查找城市..." id="search">
    <button type="button" onClick="cityQuery()">搜索</button>
	</div>
	<% 
	if(flag)
	{
	%>
	 <input type="button" value=<%="Hi:"+session.getAttribute("username").toString() %> id="bt1" class="bt" onClick="gotoLogin()">
	 <input type="button" value="切换底图" id="bt2" class="bt" onClick="changeMap()">
    <input type="button" value="属性信息" id="bt3" class="bt" onClick="showAttribute()">
    <input type="button" value="显示POI" id="bt4" class="bt" onClick="updatePoi()">
    <input type="button" value="添加POI" id="bt5" class="bt" onClick="showPoi()">
    <input type="button" value="统计图表" id="bt6" class="bt" onClick="openChart()">
    <input type="button" value="重置地图" id="bt7" class="bt" onClick="resetMap()">
	 <%
	 }
	 else 
	 {
	 %>
	 <input type="button" value="登录" id="bt1" class="bt" onClick="gotoLogin()">
	 <%
	 }
	  %>
    

		<div class="container">  
		  <div id="contact" >
		    <h3>添加POI兴趣点</h3>
		    <h4>手工创建POI兴趣点，上传到数据库，并在地图上显示</h4>
		    <fieldset>
		      <input id="name" placeholder="请输入POI名称..." type="text" tabindex="1" required autofocus>
		    </fieldset>
		    <fieldset>
		      <input id="type" placeholder="请输入POI类型..." type="email" tabindex="2" required>
		    </fieldset>
		    <fieldset>
		      <input id="lng" placeholder="请输入POI兴趣点的经度_longitude..." type="tel" tabindex="3" required>
		    </fieldset>
		    <fieldset>
		      <input id="lat" placeholder="请输入POI兴趣点的纬度_latitude..." type="tel" tabindex="3" required>
		    </fieldset>
		    <fieldset>
		      <input id="url" placeholder="请输入POI兴趣点的网络图片URL http://..." type="url" tabindex="4" required>
		    </fieldset>
		    <fieldset>
		      <textarea id="describe" placeholder="请简要描述该POI兴趣点..." tabindex="5" required></textarea>
		    </fieldset>
		    <fieldset>
		      <button name="submit" type="submit" id="contact-submit" onClick="submitPoi()" >提交</button>
		      <button name="submit2" type="submit" id="contact-cancel" onClick="hidePoi()" >取消</button>
		    </fieldset>
		  </div>
		</div>
			
    	
 
    <script>
    var mapStyle=1;
    var currentName="Wuhan";
     var poiSource = new ol.source.Vector();
     var poiLayer=  new ol.layer.Vector({source: poiSource});
     hidePoi();
	var pview =new ol.View(
      {
           // 定义地图显示中心于经度0度，纬度0度处
        center: ol.proj.transform([114.26, 30.57], 'EPSG:4326', 'EPSG:3857'),
        zoom: 7
                      // 并且定义地图显示层级为2
              //extent: [113, 33, 115, 35]
      })
      var osmLayer=new ol.layer.Tile({
        source:new ol.source.OSM()
      });
      var stamenLayer=new ol.layer.Tile({
        source:new ol.source.Stamen({
          layer:'watercolor'
        })
      });
 
	var query_layer = new ol.layer.Vector({
    		source: new ol.source.Vector()
  						});


      var map=new ol.Map({
            // 设置地图图层
            layers: [
              // 创建一个使用Open Street Map地图源的瓦片图层
              //new ol.layer.Tile({source: new ol.source.OSM()})
              osmLayer,query_layer
            ],
            // 设置显示地图的视图
            controls: ol.control.defaults().extend([
            <% 
            if(flag)
            {
            %>
            new ol.control.ZoomSlider(),
            new ol.control.OverviewMap()
           <% 
            }
            %>
        	]),
            view: pview,
            // 让id为map的div作为地图的容器
            target: 'map' ,
            logo: {src: './images/favicon.ico', href: 'http://115.159.105.168/'}  
        });
      
      //下面的是创建地图
      // 下面把上面的图标附加到地图上，需要一个ol.Overlay
      var anchor = new ol.Overlay({
        element: document.getElementById('anchor')
      });
      // 关键的一点，需要设置附加到地图上的位置
      anchor.setPosition(ol.proj.transform([114.36, 30.53], 'EPSG:4326', 'EPSG:3857'));
      // 然后添加到map上
      map.addOverlay(anchor);
      
      //用于跳转到登录页面
      function gotoLogin()
      {
      	window.location.href="login.jsp";
      }
      
      function resetMap()
      {
      	window.location.href="map.jsp";
      }
      
      
      //测试新的servlet是否能用
      function test()
      {
      	var cityName=document.getElementById("search").value;
      	//var inputName=encodeURI(encodeURI(cityName));
      	 // 下面把上面的图标附加到地图上，需要一个ol.Overlay
	        			     map.getOverlays().clear();
	        			      // 关键的一点，需要设置附加到地图上的位置
	        			       var anchor2 = new ol.Overlay({
        						element: document.getElementById('anchor')
      											});
	        			      anchor2.setPosition(ol.proj.transform([0, 0], 'EPSG:4326', 'EPSG:3857'));
	        			      // 然后添加到map上
	        			      map.addOverlay(anchor2); 
	        			      

      }
      
      //查询城市功能的前端实现
       function cityQuery()
	        {
	        	var cityName=document.getElementById("search").value;
	        	currentName=cityName;
	        	if(cityName=="")
	        	{
	        		alert("请输入城市名");
	        		return;
	        		
	        	}
	        	var inputName=encodeURI(encodeURI(cityName));
	        	//alert("您正要搜索的城市是："+cityName);
	        	$.ajax({
	        		type:"GET",
	        		data:{name:inputName},
	        		url:"cityQueryServlet",
	        		dataType:"text",
	        		success:function(result){
	        			//document.getElementById("search").value=result;
	        			 var length1=result.length;
	        			var lonformer=result.lastIndexOf('[');
	        			var lonlast=result.lastIndexOf(',');
	        			var lastIndexOf = result.lastIndexOf('{');
	        				var a = result.indexOf(',');
	        				
	        				var first = result.substring(1, a);
	        				//alert(first);
	        				var center = result.substring(a+1,lastIndexOf-2);
	        				//alert(center);
	        				var end = result.substring(lastIndexOf,length1-3);
	        				var lng=result.substring(lonformer+1,lonformer+7);    				
	        				var lat=result.substring(lonlast+1,lonlast+7);
	        				document.getElementById("search").value=lng+","+lat;
	        				
	        				map.removeLayer(query_layer);
	        			
  							//创建一个Feature
  							var tPoint = new ol.Feature({  
       						geometry:new ol.geom.Point(ol.proj.fromLonLat([parseFloat(lng),parseFloat(lat)])) 
       							
       							});  
       						//设置点的样式
       						tPoint.setStyle(new ol.style.Style({  
      						 image:new ol.style.Icon({  
      						 color:'#4271AE',  
       						src:'./images/anchor.png'  
        					})  
     						 })  
     						 ); 
     						 //把点加入矢量数据源;
     						 var source = new ol.source.Vector({  
   							 features:[tPoint]  
								});
								//创建一个新的矢量图层
	        				   query_layer = new ol.layer.Vector({
    							 source: source 
  									});
  							map.addLayer(query_layer);

            				}
            				
            			});
            		}
					            	function changeMap()
					    {
					    if(mapStyle==1)
					    {
					    	mapStyle=2;
					    	map.removeLayer(osmLayer);
					    	map.addLayer(stamenLayer);
					    	stamenLayer.setZIndex(1);
					    	queryLayer.setZIndex(2);
					    }
					    else
					    {
					    	mapStyle=1;
					    	map.removeLayer(stamenLayer);
					    	map.addLayer(osmLayer);
					    	osmLayer.setZIndex(1);
					    	queryLayer.setZIndex(2);
					    }
					    }
	   function openChart(){
	   window.open("charts.jsp");
	   }
	   
	   function showAttribute(){
    	window.open("attrTable.jsp?pinyin="+currentName);
    	}
    	//更新POI信息源头，在地图上进行加载
    	function updatePoi()
    	{
    		var lngStr;
    		var latStr;
    		var num;
    		var lngArr;
    		var latArr;
    		var tPoint;
    			$.ajax({
	        		type:"GET",
	        		//data:{name:inputName},
	        		url:"servlet/getpoilngServlet",
	        		async: false,
	        		dataType:"text",
	        		success:function(result){
	        		
	        			lngStr=result;       		
	        		}
	        		});
	        	$.ajax({
	        		type:"GET",
	        		//data:{name:inputName},
	        		url:"servlet/getpoilatServlet",
	        		async: false,
	        		dataType:"text",
	        		success:function(result){
	        			latStr=result;          		
	        		}
	        		});
	        	$.ajax({
	        		type:"GET",
	        		//data:{name:inputName},
	        		url:"servlet/getpoinumServlet",
	        		async: false,
	        		dataType:"text",
	        		success:function(result){
	        			num=parseInt(result);
						        		
	        		}
	        		});
	        //alert(lngStr+"#"+latStr+"#"+num);
	        lngArr=lngStr.split(",");
	        latArr=latStr.split(",");
	        //alert(lngArr[0]+","+latArr[0]);
	        
	        for (var i=0;i<num;i++)
	        {
						//创建一个Feature
  							 tPoint = new ol.Feature({  
       						geometry:new ol.geom.Point(ol.proj.fromLonLat([parseFloat(lngArr[i]),parseFloat(latArr[i])])) 
       							
       							});  
       						//设置点的样式
       						tPoint.setStyle(new ol.style.Style({  
      						 image:new ol.style.Icon({  
      						 color:'#4271AE',  
       						src:'./images/mark.png'  
        					})  
     						 })  
     						 ); 
     						 //把点加入矢量数据源;
     						 poiSource.addFeature(tPoint);
	        }
	        map.removeLayer(poiLayer);
	        poiLayer=new ol.layer.Vector({
    							 source: poiSource 
  									});
  			map.addLayer(poiLayer);
  			
	        
		//alert(lngStr+"_o");
    	}
    	//显示POI输入狂
    	function showPoi()
    	{
    		document.getElementById("contact").style.visibility="visible";
    		document.getElementById("contact").style.display="block";
    	}
    	//将POI信息写入数据库
    	function submitPoi()
    	{
    		var name=document.getElementById("name").value;
    		var type=document.getElementById("type").value;
    		var lng=document.getElementById("lng").value;
    		var lat=document.getElementById("lat").value;
    		var url=document.getElementById("url").value;
    		var describe=document.getElementById("describe").value;
    		$.ajax({
	        		type:"GET",
	        		data:{name:name,
	        		type:type,
	        		lng:lng,
	        		lat:lat,
	        		url:url,
	        		describe:describe
	        		},
	        		url:"servlet/poiServlet",
	        		dataType:"text",
	        		success:function(result){
	        			alert("数据库写入成功:"+result);
	        			hidePoi();
	        		},
	        		error:function(errorMsg){
	        			alert("下部");
	        			
	        		}
	        		
	        	});
    	
    	}
    	//隐藏POI输入框
    	function hidePoi()
    	{
    		document.getElementById("contact").style.visibility="hidden";
    		document.getElementById("contact").style.display="none";
    	}
	       
	</script>
  </body>
</html>

