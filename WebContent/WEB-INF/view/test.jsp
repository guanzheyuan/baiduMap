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
<!-- 加载Jquery -->
<script type="text/javascript" src="<%=path%>/public/js/jquery-3.0.0.js"></script>
<script type="text/javascript" src="<%=path%>/public/js/alertPopShow.js"></script>
<link rel="stylesheet" href="<%=path%>/public/css/common.css"/>
<!--加载鼠标绘制工具-->
<script type="text/javascript" src="http://api.map.baidu.com/library/DrawingManager/1.4/src/DrawingManager_min.js"></script>
<link rel="stylesheet" href="http://api.map.baidu.com/library/DrawingManager/1.4/src/DrawingManager_min.css" />
<!--加载检索信息窗口-->
<script type="text/javascript" src="http://api.map.baidu.com/library/SearchInfoWindow/1.4/src/SearchInfoWindow_min.js"></script>
<link rel="stylesheet" href="http://api.map.baidu.com/library/SearchInfoWindow/1.4/src/SearchInfoWindow_min.css" />
<style type="text/css">
	body, html{width:100%;height: 100%;overflow: hidden;margin:0;font-family:"微软雅黑";}
	#allmap {width:70%;height: 100%;overflow: hidden;margin:0;font-family:"微软雅黑";float:right;}
	#result{width: 30%;height:100%;font-family:"微软雅黑";}
	.content{padding:15px;border:1px solid #D4D4D4}
</style>
<script type="text/javascript">
$(function(){
	init();
	addPolyline();
	readMap();
	//添加点击事件
	map.addEventListener("click", function(e){
	});
})
//初始化地图
var map;
function init(){
	//百度地图API功能
    map = new BMap.Map("allmap");    // 创建Map实例
	map.centerAndZoom(new BMap.Point(116.404, 39.915), 11);  // 初始化地图,设置中心点坐标和地图级别
	map.setCurrentCity("北京");          // 设置地图显示的城市 此项是必须设置的
	map.enableScrollWheelZoom(true);     //开启鼠标滚轮缩放
	addControl();
}
//增加地图控件
function addControl(){
	//添加地图控件
	var top_left_control = new BMap.ScaleControl({anchor: BMAP_ANCHOR_TOP_LEFT});// 左上角，添加比例尺
	var top_left_navigation = new BMap.NavigationControl();  //左上角，添加默认缩放平移控件
	var top_right_navigation = new BMap.NavigationControl({anchor: BMAP_ANCHOR_BOTTOM_RIGHT, type: BMAP_NAVIGATION_CONTROL_SMALL}); //右上角，仅包含平移和缩放按钮
	map.addControl(top_left_control);        
	map.addControl(top_left_navigation);     
	map.addControl(top_right_navigation);
}
//添加折线
var overlays = [];
var polyline;
var overlaycomplete = function(e){polyline = e.overlay; overlays.push(polyline);polyline.enableEditing();getCoord();addArrow(polyline);showMessage();}
function addPolyline(){
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
						hideMap();
						return;
					}
					addContent();
					createForm(polyline);
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
					hideMap();
				}, 300);
				clearAll();
			  }
			}
		); 
  }
  //增加折线对应的名称
 var i=1;
 var name="";;
 function addContent(){
	 name = MathRand();
	 var div="<div class='content'  id='"+name+"' >第"+i+"个路线("+name+")<img alt='显示' src='<%=path%>/public/image/show.png' width='30' height='20' onclick='showMap("+name+")' style='cursor:pointer;float:right;padding-right:10px;'><img alt='隐藏' src='<%=path%>/public/image/hidden.png' width='30' height='20' onclick='hideMap("+name+")' style='cursor:pointer;float:right;padding-right:10px;'><img alt='' src='<%=path%>/public/image/delete.png' width='20' height='20' onclick='deleteMap("+name+")' style='float: right;cursor:pointer;padding-right:10px;'></div>";
	 i++;
	 $("#result").append(div);
	 doSave(name);
 }
 //展示地图
function showMap(name){
	var objPolyline= getPolyline(name);
	map.addOverlay(objPolyline);//增加折线
	objPolyline.enableEditing();
	addArrow(objPolyline);
 }
//隐藏覆盖
function  hideMap(name){
	var objPolyline= getPolyline(name);
	var flag = true;
	for(var i =0;i<overlays.length;i++){
	}
	map.clearOverlays();  
}
//得到折线的坐标
function getCoord(){
	 var path =polyline.getPath();//Array<Point> 返回多边型的点数组
	 var val="";
     for(var i=0;i<path.length;i++){
       val+=path[i].lng+":"+path[i].lat+",";
     }
     $("#addresss").val(' ');
     $("#addresss").attr('value',val);
}
//保存轨迹
var sort= 0;
 function doSave(name){
	 sort ++;
	  $.ajax({
		type:'post',
		url:'<%=path%>/doSavePath.do?coord='+$("#addresss").val()+'&name='+name+'&sort='+sort,
		success:function(data){}
	});
 }
 //修改节点内容
 function doUpdate(){
	 $.ajax({
		 type:'post',
		 url:'<%=path%>/doUpdateMap.do?name='+name+'&trackname='+$("#trackname").val()+'&describe='+$("#describe").val()+'&coord='+$("#addresss").val(),
		 success:function(data){ 
			 if(data.success){
				 webToast("添加成功","bottom", 3000);
				 map.getInfoWindow().close();
				 $("div").remove("#"+data.result.id);
				 var div="<div class='content' title='"+data.result.describe+"'   id='"+data.result.id+"' >"+data.result.name.substring(0,16)+"..."+"<img alt='显示' src='<%=path%>/public/image/show.png' width='30' height='20' onclick='showMap("+data.result.id+")' style='cursor:pointer;float:right;padding-right:10px;'><img alt='隐藏' src='<%=path%>/public/image/hidden.png' width='30' height='20' onclick='hideMap("+data.result.id+")' style='cursor:pointer;float:right;padding-right:10px;'><img alt='' src='<%=path%>/public/image/delete.png' width='20' height='20' onclick='deleteMap("+data.result.id+")' style='float: right;cursor:pointer;padding-right:10px;'></div>";
				 $("#result").append(div);
			 }
		 }
	 }); 
 }
 //得到折线对象j
var objPolyline;
 function getPolyline(name){
	 $.ajax({
		 type:'post',
		 url:'<%=path%>/doReadMap.do?name='+name,
		 async: false,
		 success:function(data){
			 if(data.result){
				 var result = data.result;
				 var polylinePointsArray = [];
				  for(var i = 0;i<result.length;i++){
					  polylinePointsArray.push(new BMap.Point(result[i].lng,result[i].lat));
				  }
				  objPolyline = new BMap.Polyline(polylinePointsArray, {strokeColor:"#4B0082", strokeWeight:3, strokeOpacity:0.8,fillOpacity: 0.6, strokeStyle: 'solid' });
			 }
		 }
	 });
	 return objPolyline;
 }
 //读取保存的地图轨迹
 function readMap(){
	 var jsonCoor = '${coorList}';
	 if(jsonCoor.length>0){
		 var obj  = eval("("+jsonCoor+")");
			 for(var i = 0;i<obj.length;i++){
				var div="<div class='content' ' title='"+obj[i].describe+"' id='"+obj[i].id+"' >"+obj[i].name.substring(0,16)+"...<img alt='隐藏' src='<%=path%>/public/image/show.png' width='30' height='20' onclick='showMap("+obj[i].id+")'  style='cursor:pointer;float:right;padding-right:10px;'><img alt='隐藏' src='<%=path%>/public/image/hidden.png' width='30' height='20' onclick='hideMap("+obj[i].id+")' style='cursor:pointer;float:right;padding-right:10px;'><img alt='' src='<%=path%>/public/image/delete.png' width='20' height='20'  onclick='deleteMap("+obj[i].id+")' style='float: right;cursor:pointer;padding-right:10px;'></div>";
				$("#result").append(div);
			}
		}
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
				 map.clearOverlays();  
				$("div").remove("#"+name);
				webToast("删除成功","bottom", 3000);
			 }
		 }
	 });
 }
 //增加标签
 function addArrow(objPolyline){
	 var linePoint=objPolyline.getPath();//线的坐标串  
	 var arrowCount=linePoint.length;  
	 var end = new BMap.Marker(linePoint[linePoint.length-1]);  // 创建标注
	 map.addOverlay(end);               // 将标注添加到地图中  
     end.setAnimation(BMAP_ANIMATION_BOUNCE); //跳动的动画
     var myIcon = new BMap.Icon("http://api0.map.bdimg.com/images/stop_icon.png", new BMap.Size(11,11));  
     for(var i =0;i<arrowCount;i++){ //在拐点处添加标注  
         var marker = new BMap.Marker(linePoint[i],{icon:myIcon});  // 创建标注  
         map.addOverlay(marker);              // 将标注添加到地图中  
         var label;
         if(0 == i){
        	 	 label = new BMap.Label("起点",{offset:new BMap.Size(20,-10)});
        	 	 label.setStyle({  
                     color : "blue",  
                     fontSize : "10px",  
                     height : "15px",  
                     lineHeight : "15px",  
                     backgroundColor:"rgba(255, 255, 255, 0.8) none repeat scroll 0 0 !important",//设置背景色透明  
                     border:"1px solid blue"  
                 });  
        	 	  marker.setLabel(label);  
        	 }
         if(arrowCount-1 == i){
        	 	 label = new BMap.Label("终点",{offset:new BMap.Size(20,-10)}); 
        	 	 label.setStyle({  
                     color : "blue",  
                     fontSize : "10px",  
                     height : "15px",  
                     lineHeight : "15px",  
                     backgroundColor:"rgba(255, 255, 255, 0.8) none repeat scroll 0 0 !important",//设置背景色透明  
                     border:"1px solid blue"  
                 });  
        	 	  marker.setLabel(label);  
        	 }
     }  
 }
//创建表单信息
 function createForm(objPolyline){
 	var sContent = "<table width='100%' height='100%'  border='0' align='center'  ><tr><td colspan='3'><input type='text' placeholder='名称' id='trackname'  style='margin-top:10px;width:200px'></td>"+
 	"</tr><tr><td><textarea rows='2'cols='26'placeholder='描述' id='describe'></textarea></td></tr><tr align='center'><td><input type='button' value='保存' style='' onclick='doUpdate()'/></td></tr></table>";
 	var linePoint=objPolyline.getPath();//线的坐标串  
 	var infoWindow = new BMap.InfoWindow(sContent);  // 创建信息窗口对象
 	var opts = {
                 enableMessage: false
      };
      var infoWindow = new BMap.InfoWindow(sContent, opts);
      map.openInfoWindow(infoWindow,linePoint[linePoint.length-1]);
 }
//清除所有覆盖物
function clearAll(){
	for(var i = 0; i < overlays.length; i++){
        map.removeOverlay(overlays[i]);
    }
	overlays.length = 0  
}
//随机数
function MathRand() { 
  	var num=""; 
  	num=(Math.floor(Math.random()*10000) % 9+1).toString();
  	for(var i=0;i<5;i++) { 
  		num+=Math.floor(Math.random()*10); 
  	} 
  	return num;
}
</script>
</head>
<body>
<div id="allmap">
		<div id="map" style="height:100%;-webkit-transition: all 0.5s ease-in-out;transition: all 0.5s ease-in-out;"></div>
</div>
<div id="result"  >	
	<input id="addresss" type="hidden" />
</div>
</body>
</html>