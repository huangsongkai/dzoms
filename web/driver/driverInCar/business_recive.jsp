<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib
	uri="/struts-tags" prefix="s"%>
<%@page import="org.springframework.web.context.support.*"%>
<%@page import="org.springframework.context.*" %>
<%@page import="org.apache.commons.collections.*" %>
<%@ page language="java"
	import="java.util.*,com.dz.module.user.User,com.dz.module.vehicle.*,com.dz.module.driver.*,com.dz.common.other.*,com.dz.common.global.*,com.opensymphony.xwork2.util.*"
	pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<s:set name="driver" value="%{@com.dz.common.other.ObjectAccess@getObject('com.dz.module.driver.Driver',#request.affect.idNumber)}"></s:set>
<s:set name="vehicle" value="%{@com.dz.common.other.ObjectAccess@getObject('com.dz.module.vehicle.Vehicle',#request.affect.carframeNum)}"></s:set>

<!DOCTYPE html>
<html lang="zh-cn">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
<meta name="renderer" content="webkit">
		<title>证照办理</title>
<link rel="stylesheet" href="/DZOMS/res/css/pintuer.css">
<link rel="stylesheet" href="/DZOMS/res/css/admin.css">
<script src="/DZOMS/res/js/jquery.js"></script>
<script src="/DZOMS/res/js/pintuer.js"></script>
<script src="/DZOMS/res/js/respond.js"></script>
<script src="/DZOMS/res/js/admin.js"></script>
<script src="/DZOMS/res/js/itemtool.js"></script>
<link rel="stylesheet" href="/DZOMS/res/css/jquery.datetimepicker.css" />
<script src="/DZOMS/res/js/jquery.datetimepicker.js"></script>
<script src="/DZOMS/res/layer-v2.1/layer/layer.js"></script>
<script src="/DZOMS/res/js/window.js"></script>
<script type="text/javascript" src="/DZOMS/res/js/JsonList.js" ></script>
<script type="text/javascript" src="/DZOMS/res/js/fileUpload.js" ></script>
<link rel="stylesheet" href="/DZOMS/res/css/jquery.bigautocomplete.css" />
<script type="text/javascript" src="/DZOMS/res/js/jquery.bigautocomplete.js" ></script>
<script>
function refresh(){
	var name = $('[name="driver.name"]').val().trim();
    if (name.length==0) {
    	return false;
    }
    var url = "/DZOMS/common/doitToUrl?"
    	+"url=%2fdriver%2fdriverInCar%2fbusiness_recive.jsp&"
    	+"condition="
    	+ encodeURI("from Driverincar where operation='证照申请' and finished=false and idNumber in"
    	+"(select idNum from Driver where name='"+name+"')");
    	
    document.location.href = url;
}
        
$(document).ready(function(){

$("[name='driver.name']").bigAutocomplete({
	url:"/DZOMS/select/driverByName",
	condition:" idNum in (select idNumber from Driverincar where finished=false and operation='证照申请') ",
	callback:function(){
		refresh();
	}
});
});

//$(document).ready(function(){
//	var licenseNum = $('[name="vehicle.licenseNum"]').val();
//	if (licenseNum.length==0) {
//		$('[name="vehicle.licenseNum"]').val("黑A");
//	}
//});



</script>
	   <style>
        .label{
            width: 130px;
            text-align: right;
        }
        .field{
        	width: 200px;
        }
        .form-group{
    		width: 340px;
    	}
    </style>
<body>
<div class="margin-big-bottom">
	<div class="adminmin-bread" style="width: 100%;">
		<ul class="bread text-main" style="font-size: larger;"> 
                <li>驾驶员</li>
                <li>证照办理</li>
                <li>办领</li>
        </ul>
        </div>
</div>
<div class="container">
    <form action="/DZOMS/driver/driverInCar/businessRecive.action" name="driverBusinessApply" method="post"
    	style="width: 100%;" class="form-inline form-tips" >
<div class="line">
	

        <div class="panel xm12">
            <div class="panel-head">
                <strong>证照信息</strong>
            </div>
            <div class="panel-body">
            	<div class="line">
            		<div class="xm2">
            			 <div class="padding">
					    	<strong>驾驶员照片</strong>
				        	<div>
		<s:if test="%{@com.dz.common.other.FileAccessUtil@exist('/data/driver/'+#driver.idNum+'/photo.jpg')}">
			<img src="/DZOMS/data/driver/<s:property value='%{#driver.idNum}'/>/photo.jpg" class="radius img-responsive" id="headimg1"  style="width: 150px;height:150px;">
    	</s:if>
    	<s:else>
    		<img src="/DZOMS/res/image/driverhead.png" class="radius img-responsive" id="headimg1"  style="width: 150px;height:150px;">
    	</s:else>
				        		
				        	</div>
				            <br/>
				            <div class="container">
				                <a class="button input-file input-file1">
				                    装入<input class="dz-file" id="readyimg1" name="drive_photo" data-target=".input-file1" sessuss-function="loadThePicture('#readyimg1','#headimg1');">
				                </a>
				                 <a class="button input-file delebutton2" data-width="50%" data-mask="1">清空</a>
				            </div>
				        	<strong>人车照片</strong>
				        	<div>
		<s:if test="%{@com.dz.common.other.FileAccessUtil@exist('/data/driver/'+#driver.idNum+'/drive_vehicle_photo.jpg')}">
			<img src="/DZOMS/data/driver/<s:property value='%{#driver.idNum}'/>/drive_vehicle_photo.jpg" class="radius img-responsive" id="headimg"  style="width: 150px;height:150px;">
    	</s:if>
    	<s:else>
    		<img src="/DZOMS/res/image/driverhead.png" class="radius img-responsive" id="headimg"  style="width: 150px;height:150px;">
    	</s:else>
				        	</div>
				            <br/>
				            <div class="container">
				                <a class="button input-file bg-green input-file2">
				                    装入<input class="dz-file" id="oldimg" name="drive_vehicle_photo" data-target=".input-file2" sessuss-function="loadThePicture('#oldimg','#headimg');">
				                </a>
				                 <a class="button input-file delebutton1" data-width="50%" data-mask="1">清空</a>
				            </div>
		                 </div>
            		</div>
            		<div class="xm10">
            			   
            			   	<div class="form-group">
					                <div class="label padding">
					                    <label>
					                        驾驶员姓名
					                    </label>
					                </div>
					                <div class="field" >
					                	<s:textfield cssClass="input"  name="driver.name" value="%{#driver.name}" />
					                </div>
					            </div>
					            
					            
					                <div class="form-group">
					                    <div class="label padding">
					                        <label>
					                            身份证号
					                        </label>
					                    </div>
					                    <div class="field">
					                        <s:textfield cssClass="input"  name="driver.idNum" value="%{#driver.idNum}"  readonly="true"/>
					                    </div>
					                </div>
					                <br/>
					                <div class="form-group">
					                <div class="label padding">
					                    <label>
					                        车牌号
					                    </label>
					                </div>                
					                <div class="field" >
					                	<s:textfield name="vehicle.licenseNum" cssClass="input" value="%{#vehicle.licenseNum}"/>
					                	<s:hidden name="driver.carframeNum" value="%{#vehicle.carframeNum}"></s:hidden>
					                </div>
					            </div>
					            <div class="form-group">
					                <div class="label padding">
					                    <label>
					                        承租人
					                    </label>
					                </div>
					                <div class="field" >
					                    <s:textfield id="vehicleOwner" value="%{@com.dz.common.other.ObjectAccess@getObject('com.dz.module.driver.Driver',#vehicle.driverId).name}" cssClass="input"  readonly="true"/>
					                </div>
					            </div>
					            <br>
					            
					
					                <div class="form-group">
					                    <div class="label padding" >
					                        <label>
					                            申请时间
					                        </label>
					                    </div>
					                    <div class="field">
					                        <s:textfield cssClass="input"  name="driver.businessApplyTime" value="%{#driver.businessApplyTime}"  readonly="true"></s:textfield>
					                    </div>
					                </div>
					                <div class="form-group">
					                    <div class="label padding" >
					                        <label>
					                            发证时间
					                        </label>
					                    </div>
					                    <div class="field">
					                        <s:textfield cssClass="input datepick"  name="driver.businessReciveTime" value="%{#driver.businessReciveTime}"></s:textfield>
					                    </div>
					                </div>
					                <br/>
					                <div class="form-group">
					                    <div class="label padding" >
					                        <label>
					                            驾驶员属性
					                        </label>
					                    </div>
					                    <div class="field">
					                    	<s:textfield cssClass="input"  name="driver.businessApplyDriverClass" readonly="readonly" value="%{#driver.businessApplyDriverClass}"></s:textfield>
					                    </div>
					                </div>
					                <div class="form-group">
					                    <div class="label padding" >
					                        <label>
					                            作息时间
					                        </label>
					                    </div>
					                    <div class="field">
					                    	<s:textfield cssClass="input"  name="driver.restTime" readonly="readonly" value="%{#driver.restTime}"></s:textfield>
					                    </div>
					                </div>
					                <br>
					                <div class="form-group">
					                    <div class="label padding" >
					                        <label>
					                            工牌号
					                        </label>
					                    </div>
					                    <div class="field">
					                        <s:textfield cssClass="input"  name="driver.employeeNum" data-validate="required:必填" value="%{#driver.employeeNum}"></s:textfield>
					                    </div>
					                </div>
					                <br />
					                <div class="form-group">
					                    <div class="label padding" >
					                        <label>
					                            录入人
					                        </label>
					                    </div>
					                    <div class="field">
					                        <input class="input" type="text" readonly="readonly" value="<%=((User)session.getAttribute("user")).getUname()%>">
					                        <input type="hidden" name="driver.businessReciveRegistrant" value="<%=((User)session.getAttribute("user")).getUid()%>"/>
					                    </div>
					                </div>
					                <div class="form-group">
					                    <div class="label padding" >
					                        <label>
					                            登记时间
					                        </label>
					                    </div>
					                    <div class="field">
					                        <input  class="input" readonly="readonly" name="driver.businessReciveRegistTime" value="<%=(new  java.text.SimpleDateFormat("yyyy/MM/dd")).format(new java.util.Date()) %>"/>
					                       
					                    </div>
					                </div>
					            </div>
					             <div class="form-group">
					            	 <div class="label padding" >
					                        <label>
					                        </label>
					                    </div>
					            	<div class="field">
					            		
					            	</div>
					             </div>
					            <div class="form-group">
					            	 <div class="label padding" >
					                        <label>
					                        </label>
					                    </div>
					            	<div class="field">
					            		 <input type="button" class="button bg-green submitbutton margin-big-left" value="提交">
					            	</div>
					             </div>
            		</div>
            	</div>
         
        </div>
        </div>
    </form>
    <script>
    
function beforeSubmit(){
	var rawFirstDriver='<s:property value="%{#vehicle.firstDriver}"/>';
	var rawSecondDriver='<s:property value="%{#vehicle.secondDriver}"/>';
	var rawThirdDriver='<s:property value="%{#vehicle.thirdDriver}"/>';
	var rawTempDriver='<s:property value="%{#vehicle.tempDriver}"/>';
	var newIdNum='<s:property value="%{#driver.idNum}"/>';
	
	var rawIdNum='';
	var driverClass=$('[name="driver.businessApplyDriverClass"]').val();
	
	if(newIdNum.length==0){
		alert("您的数据录入不全!!!");
		return;
	}
	
	if(driverClass.length==0){
		alert("请选择驾次！");
		return;
	}
	
	switch (driverClass){
		case "主驾":
			rawIdNum=rawFirstDriver;
			break;
		case "副驾":
			rawIdNum=rawSecondDriver;
			break;
		case "三驾":
			rawIdNum=rawThirdDriver;
			break;
		default:
			break;
	}
	
	if(rawIdNum.length==0){
		driverReady++;
	}else{
		var condition2 = " from Driver where idNum ='" + rawIdNum +"'";
	$.post("/DZOMS/common/doit",{"condition":condition},function(result){
		if (result!=undefined&&result["affect"]!=undefined) {
			var driver = result["affect"];
			if(driver["businessApplyCancelState"]==1){
				
				alert("该车原驾驶员"+driver["name"]+"存在未办理的证照注销事务，请先进行办理！");
				driverReady=0;
			}else{
				driverReady++;
				checkDriverReady();
			}
		}
	});
	}
	
	var condition = " from Driver where idNum ='" + newIdNum +"'";
	$.post("/DZOMS/common/doit",{"condition":condition},function(result){
		if (result!=undefined&&result["affect"]!=undefined) {
			var driver = result["affect"];
			if(driver["businessApplyCancelState"]==1){
				alert("该驾驶员存在未办理的证照注销事务，请先进行办理！");
				driverReady=0;
			}else{
				driverReady++;
				checkDriverReady();
			}
			
		}
	});

}

function checkDriverReady(){
	if (driverReady==2) {
		document.driverBusinessApply.submit();
	}
}

button_bind(".submitbutton","确定提交?","beforeSubmit();");

$(function(){
	$showdialogs=function(e){
		var trigger=e.attr("data-toggle");
		var getid=e.attr("data-target");
		var data=e.attr("data-url");
		var mask=e.attr("data-mask");
		var width=e.attr("data-width");
		var detail="";
		var masklayout=$('<div class="dialog-mask"></div>');
		if(width==null){width="80%";}
		
		if (mask=="1"){
			$("body").append(masklayout);
		}
		detail='<div class="dialog-win" style="position:fixed;width:'+width+';z-index:11;">';
		if(getid!=null){detail=detail+$(getid).html();}
		if(data!=null){detail=detail+$.ajax({url:data,async:false}).responseText;}
		detail=detail+'</div>';
		
		var win=$(detail);
		win.find(".dialog").addClass("open");
		$("body").append(win);
		
		/**
		 * Show next to selector
		 */
		var e_top = e.offset().top-win.outerHeight();
		
		var x=parseInt($(window).width()-win.outerWidth())/2;
		//var y=parseInt($(window).height()-win.outerHeight())/2;
		var y = e_top;
		if (y<=10){y="10"}
		win.css({"left":x,"top":y});
		win.find(".dialog-close,.close").each(function(){
			$(this).click(function(){
				win.remove();
				$('.dialog-mask').remove();
			});
		});
		masklayout.click(function(){
			win.remove();
			$(this).remove();
		});
	};
});

    var driverReady=0;
    
</script>
<script type="text/javascript" src="/DZOMS/res/js/DateTimeHelper.js" ></script>
</div>
</body>
</html>
