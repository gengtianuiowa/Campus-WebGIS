<!-- 解决中文乱码问题 -->
<%@ page language="java" import="java.util.*" import="java.sql.*" import="java.lang.String" pageEncoding="UTF-8"%>

<!Doctype html>
<html xmlns=http://www.w3.org/1999/xhtml class="HtmlSet">

<head>                  
    <meta http-equiv=Content-Type content="text/html;charset=utf-8"> 
    <meta http-equiv=X-UA-Compatible content="IE=edge,chrome=1">
    <meta content=always name=referrer>
    <title>MrFrost地图交互系统</title>
    
    <link href="mapdata/ol.css" rel="stylesheet" type="text/css" />
    <link href="./css/mysetting.css" rel="stylesheet" type="text/css" />
    <link rel="shortcut icon"href="images/favicon.ico">
    <script type="text/javascript" src="mapdata/ol.js" charset="utf-8"></script>
    <script src="mapdata/ol.js" type="text/javascript" charset="utf-8"></script>
  	<script src="mapdata/zepto.min.js" type="text/javascript" charset="utf-8"></script>
   
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
	<div class="control" id="bt1"onmouseover="openNavigation();" onmouseout="closeNavigation();"> 
		导航
		<div id="navigation" class="btgroup"  style="display:none;">
			<input type="button" class="bt" onClick="moveToLeft();" value="左移" /><br>
	        <input type="button" class="bt" onClick="moveToRight();" value="右移" /><br>
	        <input type="button" class="bt" onClick="moveToUp();" value="上移" /><br>
	        <input type="button" class="bt" onClick="moveToDown();" value="下移" /><br>
	        <input type="button" class="bt" onClick="moveToWHU();" value="返回" /><br>
	        <input type="button" class="bt" onClick="zoomIn();" value="放大" /><br>
	        <input type="button" class="bt" onClick="zoomOut();" value="缩小" /><br>
		</div>
	</div>
	
	<div class="control" id="bt2" onmouseover="openPaint();" onmouseout="closePaint();"> 
		绘制<br>
		<div id="paint" class="btgroup"  style="display:none;">
	        <input type="button" class="bt" onClick="PaintLine();" value="绘制线" />
	        <input type="button" class="bt" onClick="PaintPoligon();" value="绘制面" />
	        <input type="button" class="bt" onClick="RemovePaints();" value="清除绘制" />
        </div>
    </div>
    <div class="control" id="bt3" onmouseover="openChart_w();" onmouseout="closeChart_w();"> 
		图表<br>
		<div id="chart_w" class="btgroup"  style="display:none;">
	        <input type="button" class="bt" onClick="showChart1();" value="统计图表1" />
	        <input type="button" class="bt" onClick="showChart2();" value="统计图表2" />
	        <input type="button" class="bt" onClick="showChart3();" value="统计图表3" />
        </div>
    </div>
    <div class="control" id="bt4" onmouseover="openEdit();" onmouseout="closeEdit();"> 
		编辑<br>
		<div id="edit" class="btgroup"  style="display:none;">
	        <input type="button" class="bt"  onClick="Transform();" value="转换格式" />
	        <input type="button" class="bt"  onClick="Edit();" value="开始编辑" />
	        <input type="button" class="bt"  onClick="stopEdit();" value="停止编辑" />
	        <input type="button" class="bt"  onClick="addFeature_DB();" value="添加要素" />
	        <input type="button" class="bt"  onClick="modifyFeature()" value="修改要素" />
	        <input type="button" class="bt"  onClick="deleteFeature();" value="删除要素" />
        </div>
    </div>
    <div class="control" id="bt5" onmouseover="openSA();" onmouseout="closeSA();"> 
		空间分析<br>
		<div id="SA" class="btgroup"  style="display:none;">
        <input type="button" class="bt"  onClick="createConvex();" value="生成凸壳" />
        </div>
    </div>
    	<input type="button" class="control" id="bt8" onClick="selectFeature();" value="选取要素" />
        <input type="button" class="control" id="bt10" onClick="queryWfs();" value="专题数据" />
        <input type="button" class="control" id="bt12" onClick="showAttTb();" value="属性表" />
     <%
	 }
	 else 
	 {
	 %>
	  <input type="button"  id="login" class="bt" value="登录" onClick="gotoLogin()">
	 <%
	 }
	  %>
	 
	   <%
	if(flag)
	{
	%>
	<div id="navigate-container" class="FloatControl" >
   		<span class="position-span">当前鼠标坐标为：</span> 
        <span id="mouse-position" ></span> 
    </div>
    
    <div class="attribute-wrapper" id="att" >
    	<span id="nameSearch" class="attTbl">名称：</span> <span id="POI_name" class="attTbl"></span> 
    	<br>
        <span id="ctgySearch" class="attTbl">类型：</span> <span id="POI_ctgy" class="attTbl"></span> 
        <br>
        <span id="idSearch" class="attTbl">id：</span> <span id="POI_id" class="attTbl"></span> 
        <br>
        <span id="coorSearch" class="attTbl">坐标：</span> <span id="POI_coor" class="attTbl"></span> 
        <br>
        <span id="picSearch" class="attTbl">图片：</span> <img id="POI_pic" class="attTbl"/> 
        <input type="button" class="bt" id="bt_att" onClick="closeAtt();" value="关闭" />
    </div>
	
	<div class="attribute-wrapper" id="legend">
	<table>
		<tr>
		 <td><div class="circle" id="circle_brown" style="background: brown;"></div></td><td class="attTbl">&nbsp;&nbsp;&nbsp;操场</td> 
		</tr>
		<tr>
		 <td><div class="circle" id="circle_red" style="background: red;"></div></td> <td class="attTbl">&nbsp;&nbsp;&nbsp;教学楼</td> 
		</tr>
		<tr>
		 <td><div class="circle" id="circle_green" style="background:green;"></div></td><td class="attTbl">&nbsp;&nbsp;&nbsp;大门</td> 
		</tr>
		<tr>
		 <td><div class="circle" id="circle_blue" style="background: blue;"></div></td><td class="attTbl">&nbsp;&nbsp;&nbsp;院办</td> 
		</tr>
		<tr>
		 <td><div class="circle" id="circle_pink" style="background: pink;"></div></td><td class="attTbl">&nbsp;&nbsp;&nbsp;宿舍</td> 
		</tr>
		<tr>
		 <td><div class="circle" id="circle_white" style="background: orange;"></div></td><td class="attTbl">&nbsp;&nbsp;&nbsp;其他</td> 
		</tr>
	</table>
    </div>
    
    <div class="input-wrapper"> 
<!-- 	    <input type="text" class="input" id="coorInput"  placeholder="请输入想要转到的坐标" /> -->
<!--         <input type="button" class="bt" onClick="moveToCoor();" value="确定" /> -->
        <input type="text" class="input" id="POIInput"  placeholder="请输入想要转到的POI" />
        <input type="button" class="search-btn" onClick="moveToPOI();" value="确定" />
    </div> 
    
	<div id="light" class="white_content">
		<div id="chart" style="height:400px;width:600px;"></div>
		<input type="button" class="bt" onClick="closeChart();" value="关闭图表" />
	</div> 
	
    <div id="fade" class="black_overlay"></div> 
    <div id="light2" class="white_content" style="height:400px;width:400px;text-align:center;vertical-align: middle; ">
    	<span class="attTbl">请输入添加点的属性</span>
    	<br>	
    	<span id="ctgyInsert" class="attTbl" >类型：<input type="text" class="input" id="insert_ctgInput" style="float:none;" placeholder="请输入类别名" /></span>
    	<br>
		<span id="nameInsert" class="attTbl" >名称： <input type="text" class="input" id="insert_noteInput" style="float:none;" placeholder="请输入名称"  /></span>
		<br>
		<span id="imgInsert" class="upload-img" style="width:100px;height:100px;float:none;">插入图片：
			<input type="file" onchange="selectImage(this);" id="image"
				name="image" class="bottom" value="+ 浏览上传"
				style="right:0px; "><br>
				 
		</span>
		<img id="imagedisplay" src=""
				class="img-news" alt="图片尺寸：205*140" style="margin-left:50px;" />
		<input type="button" class="bt" onClick="comfirmSetting_DB();" style="right:120px;bottom:30px;" value="确定" />
		<input type="button" class="bt" onClick="closeSetting();" value="关闭" style="right:30px;bottom:30px;"/>
	</div>
	
	<!-- <img id="testimg" src="images/user.png"
				class="img-news" alt="图片尺寸：205*140" style="margin-left:50px;" /> -->
	<%
	 }
	 %>
</body>
<script src="assets/js/myjs/map.js" charset="utf-8"></script>
<script src="assets/js/myjs/navigation.js" charset="utf-8"></script>
<script src="assets/js/myjs/paint.js" charset="utf-8"></script>
<script src="assets/js/myjs/search.js" charset="utf-8"></script>
<script src="assets/js/myjs/chart.js" charset="utf-8"></script>
<script src="assets/js/myjs/edit.js" charset="utf-8"></script>
<script src="assets/js/myjs/SAtools.js" charset="utf-8"></script>
<script src="assets/js/myjs/modify.js" charset="utf-8"></script>
<script src="assets/js/myjs/add_toDB.js" charset="utf-8"></script>
<script src="assets/js/myjs/setting.js" charset="utf-8"></script>
</html>