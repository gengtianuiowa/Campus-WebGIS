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
  <input id="delete" type="button" value="删除选中Feature" onclick="onDeleteFeature();" />

  <div id="map" style="width:100%;height:100%;"></div>

  <script>
    var wfsVectorLayer = null;

    // 选择器
    var selectInteraction = new ol.interaction.Select({
      style: new ol.style.Style({
        stroke: new ol.style.Stroke({
          color: 'red',
          width: 10
        })
      })
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

    $('#select').change(function() {
      if (this.checked) {
        map.removeInteraction(selectInteraction);
        map.addInteraction(selectInteraction);
      } else {
        map.removeInteraction(selectInteraction);
      }
    });

    function onDeleteFeature() {
      // 删选择器选中的feature
      if (selectInteraction.getFeatures().getLength() > 0) {
        deleteWfs([selectInteraction.getFeatures().item(0)]);
        // 3秒后自动更新features
        setTimeout(function() {
          selectInteraction.getFeatures().clear();
          queryWfs();
        }, 3000);
      }
    }

    // 在服务器端删除feature
    function deleteWfs(features) {
      var WFSTSerializer = new ol.format.WFS();
      var featObject = WFSTSerializer.writeTransaction(null,
        null, features, {
          featureType: 'nyc_roads',
          featureNS: 'http://geoserver.org/nyc_roads',
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
  </script>

</body>

</html>