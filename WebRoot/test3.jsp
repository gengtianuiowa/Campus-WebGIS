<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!doctype html>

<html>

<head>
  <title>wfs crud demo</title>
  <link rel="stylesheet" href="mapdata/ol.css" type="text/css" />
  <script src="mapdata/ol.js" type="text/javascript" charset="utf-8"></script>
  <script src="mapdata/zepto.min.js" type="text/javascript" charset="utf-8"></script>
</head>

<body>
  <input type="button" value="查询" onclick="queryWfs();" />
  <input id="select" type="checkbox" value="select" />选择
  <input id="modify" type="checkbox" value="modify" />编辑
  <input id="save" type="button" value="保存" onclick="onSave();" />

  <div id="map" style="width:100%;height:100%;"></div>

  <script>
    var wfsVectorLayer = null;
    var modifiedFeatures = null;

    // 选择器
    var selectInteraction = new ol.interaction.Select({
      style: new ol.style.Style({
        stroke: new ol.style.Stroke({
          color: 'red',
          width: 2
        })
      })
    });

    // 修改器
    var modifyInteraction = new ol.interaction.Modify({
      style: new ol.style.Style({
        stroke: new ol.style.Stroke({
          color: 'red',
          width: 5
        })
      }),
      features: selectInteraction.getFeatures()
    });
    modifyInteraction.on('modifyend', function(e) {
      // 把修改完成的feature暂存起来
      modifiedFeatures = e.features;
    });

    var map = new ol.Map({
      layers: [new ol.layer.Tile({
        source: new ol.source.OSM()
      })],
      target: 'map',
      view: new ol.View({
        center: [-73.99710639567148, 40.742270050255556],
        maxZoom: 19,
        zoom: 13,
        projection: 'EPSG:4326'
      })
    });

    // 通过wfs查询所有的要素
    function queryWfs() {
      // 支持重新查询
      if (wfsVectorLayer) {
        map.removeLayer(wfsVectorLayer);
      }

      // 创建新的图层来加载wfs的要素
      wfsVectorLayer = new ol.layer.Vector({
        source: new ol.source.Vector({
          format: new ol.format.GeoJSON({
            geometryName: 'the_geom' // 因为数据源里面字段the_geom存储的是geometry，所以需要指定
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

    $('#select').change(function() {
      if (this.checked) {
        // 勾选选择复选框时，添加选择器到地图
        map.removeInteraction(selectInteraction);
        map.addInteraction(selectInteraction);
      } else {
        // 不勾选选择复选框的情况下，移出选择器和修改器
        map.removeInteraction(selectInteraction);
        document.getElementById('modify').checked = false;
        map.removeInteraction(modifyInteraction);
        modifiedFeatures = null;
      }
    });

    $('#modify').change(function() {
      if (this.checked) {
        // 勾选修改复选框时，添加选择器和修改器到地图
        document.getElementById('select').checked = true;
        map.removeInteraction(modifyInteraction);
        map.addInteraction(modifyInteraction);
        map.removeInteraction(selectInteraction);
        map.addInteraction(selectInteraction);
      } else {
        // 不勾选修改复选框时，移出修改器
        map.removeInteraction(modifyInteraction);
        modifiedFeatures = null;
      }
    });

    // 保存已经编辑的要素
    function onSave() {
      if (modifiedFeatures && modifiedFeatures.getLength() > 0) {

        // 转换坐标
        var modifiedFeature = modifiedFeatures.item(0).clone();
        // 注意ID是必须，通过ID才能找到对应修改的feature
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
        modifyWfs([modifiedFeature]);
      }
    }

    // 把修改提交到服务器端
    function modifyWfs(features) {
      var WFSTSerializer = new ol.format.WFS();
      var featObject = WFSTSerializer.writeTransaction(null,
        features, null, {
          featureType: 'nyc_roads', 
          featureNS: 'http://geoserver.org/nyc_roads',  // 注意这个值必须为创建工作区时的命名空间URI
          srsName: 'EPSG:4326',
          featurePrefix:'feature'
        });
      // 转换为xml内容发送到服务器端
      var serializer = new XMLSerializer();
      var featString = serializer.serializeToString(featObject);
      var request = new XMLHttpRequest();
      request.open('POST', 'http://localhost:8080/geoserver/wfs?service=wfs');
      // 指定内容为xml类型
      request.setRequestHeader('Content-Type', 'text/xml');
      request.send(featString);
    }
  </script>

</body>

</html>