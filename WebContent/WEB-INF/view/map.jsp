<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%String path = request.getContextPath();%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>地图展示</title>
<meta charset="UTF-8">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=A5KDCk9IQZULG0LNauvyUMbwKLveDF3D"></script>
<!--加载鼠标绘制工具-->
<script type="text/javascript" src="http://api.map.baidu.com/library/DrawingManager/1.4/src/DrawingManager_min.js"></script>
<link rel="stylesheet" href="http://api.map.baidu.com/library/DrawingManager/1.4/src/DrawingManager_min.css" />
<!--加载检索信息窗口-->
<script type="text/javascript" src="http://api.map.baidu.com/library/SearchInfoWindow/1.4/src/SearchInfoWindow_min.js"></script>
<link rel="stylesheet" href="http://api.map.baidu.com/library/SearchInfoWindow/1.4/src/SearchInfoWindow_min.css" />
<!-- 加载Jquery -->
<script type="text/javascript" src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script type="text/javascript" src="<%=path%>/public/js/alertPopShow.js"></script>
<link rel="stylesheet" href="<%=path%>/public/css/common.css"/>
<style type="text/css">
	body, html{width:100%;height: 100%;overflow: hidden;margin:0;font-family:"微软雅黑";}
	#allmap {width:80%;height: 100%;overflow: hidden;margin:0;font-family:"微软雅黑";float:right;}
	#result{width: 20%;height:100%;font-family:"微软雅黑";}
	.content{padding:15px;border:1px solid #D4D4D4}
</style>
</head>
<body>
<div id="allmap">
		<div id="map" style="height:100%;-webkit-transition: all 0.5s ease-in-out;transition: all 0.5s ease-in-out;"></div>
</div>
<div id="result" >	
	<input id="addresss" type="hidden"/>
</div>
</body>
</html>
<script type="text/javascript">
	// 百度地图API功能
	var map = new BMap.Map("allmap");    // 创建Map实例
	map.centerAndZoom(new BMap.Point(116.404, 39.915), 11);  // 初始化地图,设置中心点坐标和地图级别
	map.setCurrentCity("北京");          // 设置地图显示的城市 此项是必须设置的
	//添加地图控件
	var top_left_control = new BMap.ScaleControl({anchor: BMAP_ANCHOR_TOP_LEFT});// 左上角，添加比例尺
	var top_left_navigation = new BMap.NavigationControl();  //左上角，添加默认缩放平移控件
	var top_right_navigation = new BMap.NavigationControl({anchor: BMAP_ANCHOR_BOTTOM_RIGHT, type: BMAP_NAVIGATION_CONTROL_SMALL}); //右上角，仅包含平移和缩放按钮
	map.addControl(top_left_control);        
	map.addControl(top_left_navigation);     
	map.addControl(top_right_navigation);  
	//添加折线
	var overlays = [];
	var val="";
	var overlaycomplete = function(e){
		overlays.push(e.overlay);
		e.overlay.enableEditing();
        var path = e.overlay.getPath();//Array<Point> 返回多边型的点数组
        for(var i=0;i<path.length;i++){
          val+=path[i].lng+":"+path[i].lat+",";
        }
        $("#addresss").val(' ');
        $("#addresss").attr('value',val);
        showMessage();
     };
     var styleOptions = {
    	        strokeColor:"#4B0082",    //边线颜色。
    	        fillColor:"red",      //填充颜色。当参数为空时，圆形将没有填充效果。
    	        strokeWeight: 3,       //边线的宽度，以像素为单位。
    	        strokeOpacity: 0.8,	   //边线透明度，取值范围0 - 1。
    	        fillOpacity: 0.6,      //填充的透明度，取值范围0 - 1。
    	        strokeStyle: 'solid' //边线的样式，solid或dashed。
    	  }
      //实例化鼠标绘制工具
      var drawingManager = new BMapLib.DrawingManager(map, {
          isOpen: false, //是否开启绘制模式
          enableDrawingTool: true, //是否显示工具栏
          drawingToolOptions: {
              anchor: BMAP_ANCHOR_TOP_RIGHT, //位置
              offset: new BMap.Size(5, 5), //偏离值
              drawingModes: [            
                       BMAP_DRAWING_POLYLINE
                ]
          },
          polylineOptions: styleOptions, //线的样式
      });  
    	 //添加鼠标绘制工具监听事件，用于获取绘制结果
    	  drawingManager.addEventListener('overlaycomplete', overlaycomplete);
    	 //清除地图
  	  function clearAll() {
  			for(var i = 0; i < overlays.length; i++){
  	            map.removeOverlay(overlays[i]);
  	        }
  			overlays.length=0;
  	   }
  	  //提示验证信息
  	  function showMessage(){
  		var code ='13815892591';
  		var html = "<label>授权码：<input class='confirm_input' placeholder='请输入'></label>";
			popTipShow.confirm('授权码',html,['确 定','取 消'],
				function(e){
				  //callback 处理按钮事件
				  var button = $(e.target).attr('class');
				  if(button == 'ok'){
					if(null==$(".confirm_input").val() || ""==$(".confirm_input").val()){
						webToast("授权码不能为空！","bottom", 3000);
						return;
					}	
					this.hide();
					setTimeout(function() {
						if($(".confirm_input").val() != code){
							webToast("授权码错误！","bottom", 3000);
							clearAll();
							return;
						}
						addContent();
					}, 300);
					//按下确定按钮执行的操作
					//todo ....		
				  }
				  if(button == 'cancel') {
					//按下取消按钮执行的操作
					//todo ....
					this.hide();
					setTimeout(function() {
						webToast("您选择“取消”了","top", 2000);
					}, 300);
					clearAll();
				  }
				}
			);
  	  }
  	  //增加
  	  var name="";
  	  var i=1;
  	  function addContent(){
  		name = MathRand();
  		var div="<div class='content'  id='"+name+"' >第"+i+"个路线("+name+")<img alt='显示' src='<%=path%>/public/image/show.png' width='30' height='20' onclick='showMap("+name+")' style='padding-left:10px;cursor:pointer'><img alt='隐藏' src='<%=path%>/public/image/hidden.png' width='30' height='20' onclick='cleanMap()' style='padding-left:10px;cursor:pointer'><img alt='' src='<%=path%>/public/image/delete.png' width='20' height='20' onclick='deleteMap("+name+")' style='float: right;cursor:pointer;'></div>";
  		 $("#result").append(div);
  		  i++;
  		doSave();
  	  }
  	  //删除覆盖物
  	 function clearAll() {
 		for(var i = 0; i < overlays.length; i++){
             map.removeOverlay(overlays[i]);
         }
 		overlays.length = 0  
     }
  	 //保存轨迹
  	 function doSave(){
  		  $.ajax({
  			type:'post',
  			url:'<%=path%>/doSavePath.do?coord='+$("#addresss").val()+'&name='+name,
  			success:function(data){
  			}
  		});  
  	 }
  	 //随机数
  	function MathRand() { 
	  	var num=""; 
	  	for(var i=0;i<6;i++) { 
	  		num+=Math.floor(Math.random()*10); 
	  	} 
	  	return num;
  	}
	 var polyline;
  	 //初始化加载
  	 $(function(){
  		var names="${name}";
  		if(names.length>0){
  			var arrVal = names.split(",");
  			for(var i=0;i<arrVal.length;i++){
  				if(arrVal[i].length>0){
  					addMap(arrVal[i]);
  					var div="<div class='content' id='"+arrVal[i]+"' >第"+(i+1)+"个路线("+arrVal[i]+")<img alt='隐藏' src='<%=path%>/public/image/show.png' width='30' height='20' onclick='showMap("+arrVal[i]+")'  style='padding-left:10px;cursor:pointer'><img alt='隐藏' src='<%=path%>/public/image/hidden.png' width='30' height='20' onclick='cleanMap()' style='padding-left:10px;cursor:pointer'><img alt='' src='<%=path%>/public/image/delete.png' width='20' height='20'  onclick='deleteMap("+arrVal[i]+")' style='float: right;cursor:pointer;'></div>";
  		  		  	$("#result").append(div);
  				}
  			}
  		}
  		//添加缩放事件
  		map.addEventListener("zoomend", function(e){    
  			map.addOverlay(polyline);   
		});
  		//添加点击事件
  		map.addEventListener("click", function(e){
  			clearAll();
  		});
  	 });
  	 //创建折线
  	 function getPolyline(name){
  		 $.ajax({
 			type:'post',
 			url:'<%=path%>/doReadMap.do?name='+name,
 			success:function(data){
 				  if(data.result){
 					  var arrVal = data.result.split("&");
 					  var polylinePointsArray = [];
 					  for(var i = 0;i<arrVal.length;i++){
	  						  if(arrVal[i].length>0){
		  							 var arrVal1=arrVal[i].split(",");
		  							 for(var j = 0;j<arrVal1.length-1;j++){
		  								 var x = arrVal1[j];
		  								 var y = arrVal1[j+1];
		  								polylinePointsArray[i] = new BMap.Point(x,y);
		  							 }
	  						  }
					 }
					polyline = new BMap.Polyline(polylinePointsArray, {strokeColor:"#4B0082", strokeWeight:3, strokeOpacity:0.8,fillOpacity: 0.6, strokeStyle: 'solid' });
					polyline.enableEditing();
 				  }
 			  }
 		  });
  	 }
  	 //增加折线对象
  	 function addMap(name){
  		getPolyline(name);
  		setTimeout(function() {
  			map.addOverlay(polyline); //增加折线
  	  		polyline.hide();
		}, 300);
  	 }
  	 //展示地图
  	 function showMap(name){
  		getPolyline(name);
  		setTimeout(function() {
  			overlays.push(polyline);
  	  		map.addControl(polyline);   
		}, 300);
  	 }
  	 //隐藏覆盖
  	 function  cleanMap(){
  		clearAll();
  	 }
  	 //删除地图轨迹
  	 function deleteMap(name){
  		getPolyline(name);
  		overlays.push(polyline);
  		 $.ajax({
  			 type:'post',
  			 url:'<%=path%>/doDeleteMap.do?name='+name,
  			 success:function(data){
  				 if(data.result){
  					clearAll();
  					$("div").remove("#"+name);
  					webToast("删除成功","bottom", 3000);
  				 }
  			 }
  		 });
  	 }
	</script>