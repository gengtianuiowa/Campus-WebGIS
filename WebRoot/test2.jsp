<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!doctype html>
<html>

<head>
  <title>wfs add demo</title>
  <link rel="stylesheet" href="mapdata/ol.css" type="text/css" />
  <script src="mapdata/ol.js" type="text/javascript" charset="utf-8"></script>
  <script src="mapdata/zepto.min.js" type="text/javascript" charset="utf-8"></script>
</head>

<body>
  <input type="button" value="查询" onclick="queryWfs();" />
  <input id="add" type="checkbox" value="add" />新增
  <input id="saveNew" type="button" value="保存" onclick="onSaveNew();" />

  <div id="map" style="width:100%;height:100%;"></div>

  <script>
    var newId = 1;
    var wfsVectorLayer = null;
    var drawedFeature = null;

    // 创建用于新绘制feature的layer
    var drawLayer = new ol.layer.Vector({
      source: new ol.source.Vector(),
      style: new ol.style.Style({
        stroke: new ol.style.Stroke({
          color: 'blue',
          width: 5
        })
      })
    });

    // 添加绘制新图形的interaction，用于添加新的线条
    var drawInteraction = new ol.interaction.Draw({
      type: 'LineString', // 设定为线条
      style: new ol.style.Style({
        stroke: new ol.style.Stroke({
          color: 'red',
          width: 10
        })
      }),
      source: drawLayer.getSource()
    });
    drawInteraction.on('drawend', function(e) {
      // 绘制结束时暂存绘制的feature
      drawedFeature = e.feature;
      // 转换坐标
      var geometry = drawedFeature.getGeometry().clone();
      geometry.applyTransform(function(flatCoordinates, flatCoordinates2, stride) {
        for (var j = 0; j < flatCoordinates.length; j += stride) {
          var y = flatCoordinates[j];
          var x = flatCoordinates[j + 1];
          flatCoordinates[j] = x;
          flatCoordinates[j + 1] = y;
        }
      });

      // 设置feature对应的属性，这些属性是根据数据源的字段来设置的
      var newFeature = new ol.Feature();
      newFeature.setId('nyc_roads.new.' + newId);
      newFeature.setGeometryName('the_geom');
      newFeature.set('the_geom', null);
      newFeature.set('name', newFeature.getId());
      newFeature.set('modified', newFeature.getId());
      newFeature.set('vsam', 0);
      newFeature.set('sourcedate', '');
      newFeature.set('sourcetype', '');
      newFeature.set('source_id', newId);
      newFeature.set('borough', '');
      newFeature.set('feat_code', 0);
      newFeature.set('feat_desc', '11');
      newFeature.set('feat_type', 0);
      newFeature.set('exported', 'true');
      var value=geometry.getCoordinates();
      newFeature.setGeometry(new ol.geom.MultiLineString([geometry.getCoordinates()]));

      addWfs([newFeature]);
      // 更新id
      newId = newId + 1;
      // 3秒后，自动刷新页面上的feature
      setTimeout(function() {
        drawLayer.getSource().clear();
        queryWfs();
      }, 3000);
    });

    var map = new ol.Map({
      layers: [new ol.layer.Tile({
        source: new ol.source.OSM()
      }), drawLayer],
      target: 'map',
      view: new ol.View({
        center: [-73.99710639567148, 40.742270050255556],
        maxZoom: 19,
        zoom: 13,
        projection: 'EPSG:4326'
      })
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
          url: 'http://localhost:8080/geoserver/wfs?service=wfs&version=1.1.0&request=GetFeature&typeNames=nyc_roads:nyc_roads&outputFormat=application/json&srsname=EPSG:4326'
        }),
        style: function(feature, resolution) {
          return new ol.style.Style({
            stroke: new ol.style.Stroke({
              color: 'blue',
              width: 5
            })
          });
        }
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
      geometry.applyTransform(function(flatCoordinates, flatCoordinates2, stride) {
        for (var j = 0; j < flatCoordinates.length; j += stride) {
          var y = flatCoordinates[j];
          var x = flatCoordinates[j + 1];
          flatCoordinates[j] = x;
          flatCoordinates[j + 1] = y;
        }
      });

      // 设置feature对应的属性，这些属性是根据数据源的字段来设置的
      var newFeature = new ol.Feature();
      newFeature.setId('nyc_roads.new.' + newId);
      newFeature.setGeometryName('the_geom');
      newFeature.set('the_geom', null);
      newFeature.set('name', newFeature.getId());
      newFeature.set('modified', newFeature.getId());
      newFeature.set('vsam', 0);
      newFeature.set('sourcedate', '');
      newFeature.set('sourcetype', '');
      newFeature.set('source_id', newId);
      newFeature.set('borough', '');
      newFeature.set('feat_code', 0);
      newFeature.set('feat_desc', '11');
      newFeature.set('feat_type', 0);
      newFeature.set('exported', 'true');
      var watch=new ol.geom.MultiLineString([geometry.getCoordinates()]);
      var value=geometry.getCoordinates();
      newFeature.setGeometry(new ol.geom.MultiLineString([geometry.getCoordinates()]));

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
          featureType: 'nyc_roads',
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
  </script>

</body>

</html>