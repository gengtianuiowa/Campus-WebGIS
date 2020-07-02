var editStatus=false;
var mapStatus=1;//1图像，2矢量
var select,modify;
function Edit(){
	if(editStatus===false)
	{
		if(mapStatus===1)
		{
			alert("请先转换格式");
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
