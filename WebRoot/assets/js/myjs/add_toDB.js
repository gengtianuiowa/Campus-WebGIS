//增加
var drawedFeature = null;
var newId=1;
var wfsVectorLayer=null;

var imageData='';
function selectImage(file) 
{
	if (!file.files || !file.files[0]) {
		return;
	}
	var reader = new FileReader();
	reader.onload = function (evt) {
		//将图片显示在id为imagedisplay的img
		document.getElementById('imagedisplay').src = evt.target.result;
		// 将图片的base64数据存在id为imagedata的一个文本框
		imageData = evt.target.result.toString();
	};
	reader.readAsDataURL(file.files[0]);
}

function addFeature_DB()
{
//	为绘制准备的layer和interaction
	if(!lineStatus)
	{
		map.removeInteraction(drawInteraction);
		map.addInteraction(drawInteraction);

		drawInteraction.on('drawend', function(e) {
			// 绘制结束时暂存绘制的feature
			drawedFeature = e.feature;

			showSetting();
		}); 
	}else
	{
		map.removeInteraction(drawInteraction);
		lineStatus=false;	
	}
}


function comfirmSetting_DB()
{
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

	var watch1=geometry.getCoordinates()[0];
	var category = document.getElementById('insert_ctgInput').value;
	var note = document.getElementById('insert_noteInput').value;
	//servlet与服务器交互
	var type=0;//0,1，2,3对应增删查改
	var x=geometry.getCoordinates()[1];
	var y=geometry.getCoordinates()[0];
	$.ajax({
		type:"post",
		data:{type:type,x:x,y:y,note:note,category:category,imgData:imageData},
			url:"servlet/Modify",
			dataType:"text",
			success:function(result){
				alert(result);
				//queryWfs() ;
			},
			error:function(){
				alert("失败");
			}
	});

	/*// 3秒后，自动刷新页面上的feature
	setTimeout(function() {
		drawLayer.getSource().clear();
		queryWfs();
	}, 3000);*/

	lineStatus=true;
}


