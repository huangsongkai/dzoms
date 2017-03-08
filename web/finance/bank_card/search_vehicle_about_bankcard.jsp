<%@page import="com.dz.common.other.ObjectAccess"%>
<%@page import="com.dz.module.vehicle.Vehicle"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
   	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport"
	content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
	<meta name="renderer" content="webkit">
	<title>查询银行卡和车辆的绑定情况</title>
	
	<link rel="stylesheet" href="/DZOMS/res/css/pintuer.css">
	<link rel="stylesheet" href="/DZOMS/res/css/admin.css">
	<link rel="stylesheet" href="/DZOMS/res/css/jquery.datetimepicker.css" />
	
	<script src="/DZOMS/res/js/jquery.js"></script>
	<script src="/DZOMS/res/js/pintuer.js"></script>
	<script src="/DZOMS/res/js/respond.js"></script>
	<script src="/DZOMS/res/js/admin.js"></script>
	<script type="text/javascript" src="/DZOMS/res/js/jquery.datetimepicker.js" ></script>
	
	<link rel="stylesheet" href="/DZOMS/res/css/jquery.bigautocomplete.css" />
	<script type="text/javascript" src="/DZOMS/res/js/jquery.bigautocomplete.js" ></script>
	
	<script>
	function refreshSearch(){
		$("[name='vehicleSele']").submit();
	}
	
		$(document).ready(function(){
			$("[name='vehicleSele']").find("select").change(function(){
				$("[name='vehicleSele']").submit();
			});
						
			$("[name='vehicleSele']").submit();
			
			$("[name='vehicleSele']").find("input").change(function(){
				if($(this).val().trim().length==0)
						$("[name='vehicleSele']").submit();
			});
			
			$("#driver_name").bigAutocomplete({
				url:"/DZOMS/select/driverByName",
				callback:refreshSearch
			});
			
			$("#carframe_num").bigAutocomplete({
				url:"/DZOMS/select/vehicleById",
				callback:refreshSearch
			});
			
			$("#license_num").bigAutocomplete({
				url:"/DZOMS/select/vehicleByLicenseNum",
				callback:refreshSearch
			});
			
			$("#engine_num").bigAutocomplete({
				url:"/DZOMS/select/vehicleByEngineNum",
				callback:refreshSearch
			});
			
		});
	</script>
  </head>
 <body> 
	<div class="adminmin-bread" style="width: 100%;">
		<ul class="bread text-main" style="font-size: larger;"> 
                <li>车辆管理</li>
                <li>查询</li>
                <li>查询车辆技术信息</li>
    </ul>
</div>
 
<form name="vehicleSele" action="/DZOMS/vehicle/vehicleSele" method="post"
      class="definewidth m20" target="result_form" style="width: 100%;">
      <input type="hidden" name="url" value="/finance/bank_card/search_vehicle_about_bankcard_result.jsp" />
   <div class="line">
   	<div class="panel  margin-small" >
          	<div class="panel-head">
          		查询条件
          	</div>
        <div class="panel-body">
        	<div class="line">
        		<div class="xm12 padding">
     
                <blockquote class="panel-body">
                    <table class="table" style="border: 0px;">
                        <tr>
                            <td style="border-top: 0px;">承租人</td>
                            <td style="border-top: 0px;"><input type="text" id="driver_name" name="driverName" class="input"/></td>

                            <td style="border-top: 0px;">归属部门</td>
                            <td style="border-top: 0px;"><select name="vehicle.dept" class="input">
                            	<option value="">全部</option>
                            	<option value="一部">一部</option>
                            	<option value="二部">二部</option>
                            	<option value="三部">三部</option>
                            </select></td>
                        
                            <td style="border-top: 0px;">车辆识别代码/车架号</td>
                            <td style="border-top: 0px;"><input type="text" id="carframe_num" name="vehicle.carframeNum" class="input" /></td>
                        
                            <td style="border-top: 0px;">车牌号</td>
                            <td style="border-top: 0px;"><input type="text" id="license_num" name="vehicle.licenseNum" class="input" /></td>

							<td style="border-top: 0px;">有无银行卡</td>
							<td style="border-top: 0px;">
								<input type="radio" name="condition" value=" and carframeNum in (select carNum from BankCard  where carNum is not null) " checked="checked"/>有 &nbsp;
								<input type="radio" name="condition" value=" and carframeNum not in (select carNum from BankCard where carNum is not null) "/>无
							</td>
							
							<td style="border-top: 0px;"><input type="submit" value="查询"></td>
                        </tr>
                    </table>
                </blockquote>
            </div>
        </div>
      </div>
    </div>
  </div>


</form>
<div>
    <iframe name="result_form" width="100%" height="800px" id="result_form" scrolling="no">

    </iframe>

</div>

<script type="text/javascript" src="/DZOMS/res/js/DateTimeHelper.js" ></script>
</body>
 <script src="/DZOMS/res/js/apps.js"></script>
<script>
    	function iFrameHeight() {
	try{
var ifm= document.getElementById("result_form");   
var subWeb = document.frames ? document.frames["result_form"].document : ifm.contentDocument;   
if(ifm != null && subWeb != null) {
   ifm.height = subWeb.body.scrollHeight+200;
}   }catch(e){}
}    

$(document).ready(function(){
	window.setInterval('iFrameHeight();',1000);
});

    	
       
        // $(".xdsoft_datetimepicker.xdsoft_noselect").show();
        // $("#ri-li").append($(".xdsoft_datetimepicker.xdsoft_noselect"));

    });
    </script>
</html>
