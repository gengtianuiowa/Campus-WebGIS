<!Doctype html>
<html xmlns=http://www.w3.org/1999/xhtml>
<head>                  
    <meta http-equiv=Content-Type content="text/html;charset=utf-8"> 
    <meta http-equiv=X-UA-Compatible content="IE=edge,chrome=1">
    <meta content=always name=referrer>
    <title>OpenLayers 3µØÍ¼Ê¾Àý</title>
    <link href="ol.css" rel="stylesheet" type="text/css" />
   <script type="text/javascript" src="ol.js" charset="utf-8"></script>
</head>

<body charset="utf-8">
    <div id="navigate-container">
        <input type="button" onClick="moveToLeft();" value="×óÒÆ" />
        <input type="button" onClick="moveToRight();" value="ÓÒÒÆ" />
        <input type="button" onClick="moveToUp();" value="ÉÏÒÆ" />
        <input type="button" onClick="moveToDown();" value="ÏÂÒÆ" />
        <input type="button" onClick="moveToChengDu();" value="ÒÆµ½³É¶¼" />
        <input type="button" onClick="zoomIn();" value="·Å´ó" />
        <input type="button" onClick="zoomOut();" value="ËõÐ¡" />
          <input type="button" onClick="addJson();" value="添加geoJson" />
    </div>
    <div id="map" style="width: 100%"></div>

    <script>
      //   var map = new ol.Map({
         //   layers: [
                new ol.layer.Tile({source: new ol.source.OSM()})
      //      ],
       //     view: new ol.View({
       //         // ÉèÖÃ³É¶¼ÎªµØÍ¼ÖÐÐÄ£¬´Ë´¦½øÐÐ×ø±ê×ª»»£¬ °ÑEPSG:4326µÄ×ø±ê£¬×ª»»ÎªEPSG:3857×ø±ê£¬ÒòÎªolÄ¬ÈÏÊ¹ÓÃµÄÊÇEPSG:3857×ø±ê
                center: ol.proj.transform([104.06, 30.67], 'EPSG:4326', 'EPSG:3857'),
        //        zoom: 10
        //    }),
      //      target: 'map'
   //   });

        // Ïò×óÒÆ¶¯µØÍ¼
        function moveToLeft() {
            var view = map.getView();
            var mapCenter = view.getCenter();
            // ÈÃµØÍ¼ÖÐÐÄµÄxÖµÔö¼Ó£¬¼´¿ÉÊ¹µÃµØÍ¼Ïò×óÒÆ¶¯£¬Ôö¼ÓµÄÖµ¸ù¾ÝÐ§¹û¿É×ÔÓÉÉè¶¨
            mapCenter[0] += 50000;
            view.setCenter(mapCenter);
            map.render();
        }

        // ÏòÓÒÒÆ¶¯µØÍ¼
        function moveToRight() {
            var view = map.getView();
            var mapCenter = view.getCenter();
            // ÈÃµØÍ¼ÖÐÐÄµÄxÖµ¼õÉÙ£¬¼´¿ÉÊ¹µÃµØÍ¼ÏòÓÒÒÆ¶¯£¬¼õÉÙµÄÖµ¸ù¾ÝÐ§¹û¿É×ÔÓÉÉè¶¨
            mapCenter[0] -= 50000;
            view.setCenter(mapCenter);
            map.render();
        }

        // ÏòÉÏÒÆ¶¯µØÍ¼
        function moveToUp() {
            var view = map.getView();
            var mapCenter = view.getCenter();
            // ÈÃµØÍ¼ÖÐÐÄµÄyÖµ¼õÉÙ£¬¼´¿ÉÊ¹µÃµØÍ¼ÏòÉÏÒÆ¶¯£¬¼õÉÙµÄÖµ¸ù¾ÝÐ§¹û¿É×ÔÓÉÉè¶¨
            mapCenter[1] -= 50000;
            view.setCenter(mapCenter);
            map.render();
        }

        // ÏòÏÂÒÆ¶¯µØÍ¼
        function moveToDown() {
            var view = map.getView();
            var mapCenter = view.getCenter();
            // ÈÃµØÍ¼ÖÐÐÄµÄyÖµÔö¼Ó£¬¼´¿ÉÊ¹µÃµØÍ¼ÏòÏÂÒÆ¶¯£¬Ôö¼ÓµÄÖµ¸ù¾ÝÐ§¹û¿É×ÔÓÉÉè¶¨
            mapCenter[1] += 50000;
            view.setCenter(mapCenter);
            map.render();
        }

        // ÒÆ¶¯µ½³É¶¼
        function moveToChengDu() {
            var view = map.getView();
            // ÉèÖÃµØÍ¼ÖÐÐÄÎª³É¶¼µÄ×ø±ê£¬¼´¿ÉÈÃµØÍ¼ÒÆ¶¯µ½³É¶¼
            view.setCenter(ol.proj.transform([104.06, 30.67], 'EPSG:4326', 'EPSG:3857'));
            map.render();
        }

        // ·Å´óµØÍ¼
        function zoomIn() {
            var view = map.getView();
            // ÈÃµØÍ¼µÄzoomÔö¼Ó1£¬´Ó¶øÊµÏÖµØÍ¼·Å´ó
            view.setZoom(view.getZoom() + 1);
        }

        // ËõÐ¡µØÍ¼
        function zoomOut() {
            var view = map.getView();
            // ÈÃµØÍ¼µÄzoom¼õÐ¡1£¬´Ó¶øÊµÏÖµØÍ¼ËõÐ¡
            view.setZoom(view.getZoom() - 1);
        }
        var map,vectors_map,vector_point,geojson;  
        
        
	saoguan = new ol.Feature({  
       geometry:new ol.geom.Point(ol.proj.fromLonLat([113.5991,24.8166]))  });  
       saoguan.setStyle(new ol.style.Style({  
       image:new ol.style.Icon({  
       color:'#4271AE',  
       src: 'https://openlayers.org/en/v4.2.0/examples/data/dot.png'  
        })  
      })  ); 
      
      source = new ol.source.Vector({  
    features:[saoguan]  
});  

layer = new ol.layer.Vector({  
       source: source 
});  

rasterLayer =  new ol.layer.Tile({  
       source: new ol.source.OSM()  
   });  
   
   map = new ol.Map({  
  layers: [rasterLayer, layer],  
  target: document.getElementById('map'),  
  view: new ol.View({  
    center: ol.proj.fromLonLat([113.5991,24.8166]),  
    zoom: 3  
   })  
   });  

    </script>
</body>

</html>