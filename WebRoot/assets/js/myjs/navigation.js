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