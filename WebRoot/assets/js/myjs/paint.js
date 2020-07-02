//画线
var lineStatus=false;
var lineLayer;  
var drawLine;

var drawInteraction = new ol.interaction.Draw({
	type: 'Point',
	source: drawLayer.getSource()
});

function PaintLine(){
	//为绘制准备的layer和interaction
	if(!lineStatus)
	{
		lineLayer = new ol.layer.Vector({
			source: new ol.source.Vector(),
			style: new ol.style.Style({
				stroke: new ol.style.Stroke({
					color: 'blue',
					size: 5,	
				})
			})
		});
		drawLine=new ol.interaction.Draw({
			type: 'LineString',
			source: lineLayer.getSource()    // 注意设置source，这样绘制好的线，就会添加到这个source里
		});
		map.addLayer(lineLayer);
		map.addInteraction(drawLine);
		lineStatus=true;
	}else
	{
		lineStatus=false;
		map.removeInteraction(drawLine);
	}
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
