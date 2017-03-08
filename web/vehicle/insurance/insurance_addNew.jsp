<%@taglib uri="/struts-tags" prefix="s"%>
<%@ page language="java" import="java.util.*,com.dz.module.vehicle.*,com.dz.module.user.User" pageEncoding="UTF-8"%>
<%@page import="org.springframework.web.context.support.*"%>
<%@page import="org.springframework.context.*" %>
<%@page import="org.apache.commons.collections.*" %>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"
            />
    <meta name="renderer" content="webkit">
    <title>
        添加保险
    </title>
    <link rel="stylesheet" href="/DZOMS/res/css/pintuer.css">
	<link rel="stylesheet" href="/DZOMS/res/css/admin.css">
	<script src="/DZOMS/res/js/jquery.js"></script>
	<script src="/DZOMS/res/js/pintuer.js"></script>
	<script src="/DZOMS/res/js/respond.js"></script>
	<script src="/DZOMS/res/js/admin.js"></script>
<link rel="stylesheet" href="/DZOMS/res/css/jquery.datetimepicker.css" />
<script type="text/javascript" src="/DZOMS/res/js/itemtool.js" ></script>
<script src="/DZOMS/res/js/jquery.datetimepicker.js"></script>
<script>
	$(document).ready(function(){
		getList1('insuranceCompany','insuranceCompany');
		getList1('insuranceMoney','insuranceMoney');
	})
</script>
<link rel="stylesheet" href="/DZOMS/res/css/jquery.bigautocomplete.css" />
<script type="text/javascript" src="/DZOMS/res/js/jquery.bigautocomplete.js" ></script>
<script>
	$(document).ready(function(){
		$("#carframe_num").bigAutocomplete({
			url:"/DZOMS/select/VehicleBycarframeNum",
			callback:function(){
				$.post("/DZOMS/common/doit",{"condition":"from Vehicle where carframeNum='"+$("#carframe_num").val()+"' "},function(data){
					if (data!=undefined &&data["affect"]!=undefined ) {
						var vehicle = data["affect"];
						$("#licenseNum").val(vehicle["licenseNum"]);
					}
				});
			}
		});
		
		$("#licenseNum").bigAutocomplete({
			url:"/DZOMS/select/VehicleBylicenseNum",
			callback:function(){
				$.post("/DZOMS/common/doit",{"condition":"from Vehicle where licenseNum='"+$("#licenseNum").val()+"' "},function(data){
					if (data!=undefined &&data["affect"]!=undefined ) {
						var vehicle = data["affect"];
						$("#carframe_num").val(vehicle["carframeNum"]);
					}
				});
			}
		});
	});
</script>
    <style>
        .label{
             white-space:pre-line;
        }
    </style>
</head>
<body>
<div class="adminmin-bread" style="width: 100%;">
		<ul class="bread text-main" style="font-size: larger;">
               
                <li>车辆管理</li>
                <li>新增</li>
                <li>新增保险信息</li>
        </ul>
</div>
	

    <div class="xm7 xm2-move">
    	<div class="panel">
    		
    		<div class="panel-head">新增保险信息</div>
    		<div class="panel-body">
    			<form class="form-x" action="/DZOMS/vehicle/insurance_add" method="post">
    			      <div class="form-group">
            <div class="label">
                <label>
                    保险类别
                </label>
            </div>
            <div class="field">
                <select class="input" name="insurance.insuranceClass" data-validate="required:请选择,length#>=1:至少选择1项">
					<option>商业保险单</option>
					<option>交强险</option>
                </select>
            </div>
        </div>
        <div class="form-group">
            <div class="label">
                <label>
                    车架号
                </label>
            </div>
            <div class="field">
  				<s:textfield cssClass="input" id="carframe_num" theme="simple" name="insurance.carframeNum" data-validate="required:请选择,length#>=1:必填"></s:textfield>
            </div>
        </div>
         <div class="form-group">
            <div class="label">
                <label>
                    车牌号
                </label>
            </div>
            <div class="field">
            	<s:if test="%{insurance.carframeNum!=null}">
  				<s:textfield cssClass="input" id="licenseNum" theme="simple" value="%{@com.dz.common.other.ObjectAccess@getObject('com.dz.module.vehicle.Vehicle',insurance.carframeNum).licenseNum}" data-validate="required:请选择,length#>=1:必填"></s:textfield>
            	</s:if>
            	<s:else>
            	<s:textfield cssClass="input" id="licenseNum" theme="simple" value="黑A" data-validate="required:请选择,length#>=1:必填"></s:textfield>
            	</s:else>
            </div>
        </div>
        <div class="form-group">
            <div class="label">
                <label>
                    保单号
                </label>
            </div>
            <div class="field">
                <input class="input" type="text" placeholder=""
                       name="insurance.insuranceNum" data-validate="">
            </div>
        </div>
        <div class="form-group">
            <div class="label">
                <label>
                    保险公司
                </label>
            </div>
            <div class="field form-inline">
                <select  class="input" name="insurance.insuranceCompany" id="insuranceCompany"  data-validate="required:请选择,length#>=1:至少选择1项" onfocus="getList1('insuranceCompany','insuranceCompany')">
                </select>
                <a class="icon icon-wrench" href="javascript:openItem('insuranceCompany','保险公司')"></a>
            </div>

        </div>
        <div class="form-group" >
            <div class="label">
                <label>
                    保险金额
                </label>
            </div>
            <div class="field form-inline">
                <select  class="input" name="insurance.insuranceMoney" id="insuranceMoney" data-validate="required:请选择,length#>=1:至少选择1项" data-validate="required:请选择,length#>=1:至少选择1项" onfocus="getList1('insuranceMoney','insuranceMoney');">
                </select>
                <a class="icon icon-wrench" href="javascript:openItem('insuranceMoney','保险金额')"></a>
            </div>
        </div>
        <div class="form-group">
            <div class="label">
                <label>
                    起始时间
                </label>
            </div>
            <div class="field">
                <input class="input" type="text" placeholder="选择日期时间" name="insurance.beginDate"
                       data-validate="required:请填选择日期时间,datetime:请输入日期时间，如：2015-05-06 00:00:00">
            </div>
        </div>
        <div class="form-group">
            <div class="label">
                <label>
                    终止时间
                </label>
            </div>
            <div class="field">
                <input class="input datetimepick" type="text" placeholder="选择日期时间" name="insurance.endDate"
                       data-validate="required:请填选择日期时间,datetime:请输入日期时间，如：2015/05/06">
               
            </div>
        </div>
        <div class="form-group" >
            <div class="label">
                <label>
                    签单日期
                </label>
            </div>
            <div class="field">
                <input class="input datetimepick" type="text" placeholder="选择日期时间" name="insurance.signDate"
                       data-validate="required:请填选择日期时间,datetime:请输入日期时间，如：2015/05/06">
                
            </div>
        </div>
        <div class="form-group">
            <div class="label">
                <label>
                    被保险人
                </label>
            </div>
            <div class="field">
                <input class="input" type="text"  placeholder="输入汉字" name="insurance.driverId"
                   value="哈尔滨大众交通运输有限责任公司"    data-validate="required:请填写姓名,chinesename:请输入汉字">
            </div>
        </div>
        <div class="form-group">
            <div class="label">
                <label>
                    联系电话
                </label>
            </div>
            <div class="field">
                <input class="input" type="text" name="insurance.phone" value="18759060669">
            </div>       
        </div>
        <div class="form-group">
        	 <div class="label">
                <label>
                    身份证号/组织机构代码
                </label>
            </div>
            <div class="field">
                <input class="input" type="text" name="insurance.enterpriseID" value="12759066-9">
            </div>
        </div>
         <div class="form-group">
        	 <div class="label">
                <label>
                    被保险人地址
                </label>
            </div>
            <div class="field">
                <input class="input" name="insurance.address" type="text" value="哈尔滨">
            </div>
        </div>
        <div class="form-group">
            <div class="label">
                <label>
                    登记人
                </label>
            </div>
            <div class="field">
               <input class="input" readonly="readonly" value="<%=((User)session.getAttribute("user")).getUname()%>" />
					<input type="hidden" name="insurance.register" value="<%=((User)session.getAttribute("user")).getUid()%>"/>
            </div>
        </div>
        <div class="form-group">
            <div class="label">
                <label>
                    登记时间
                </label>
            </div>
            <div class="field">
               <input class="input" readonly="readonly" name="insurance.registTime" 
						value="<%=(new  java.text.SimpleDateFormat("yyyy/MM/dd")).format(new java.util.Date()) %>"/>
            </div>
        </div>
        <div class="xm6-move">
            <input type="submit" class="button bg-green" value="提交">
					<input type="button" class="button" name="backid"
							id="backid" onclick="location.href='/DZOMS/vehicle/AbandonApproval/judge.jsp'" value="取消">
        </div>
        </form>
    		</div>
    		
    	</div>
  
       <!-- <div class="form-group">
            <div class="label">
                <label>
                    联系电话
                </label>
            </div>
            <div class="field">
                <input class="input" type="text" maxlength="12" placeholder="输入手机号码/联系电话"
                       name="insurance.carframeNum" data-validate="tel:请填写手机号/电话号">
            </div>
        </div>-->
    </div>
			

</body>
<script type="text/javascript" src="/DZOMS/res/js/DateTimeHelper.js" ></script>
<script>
$('[name="insurance.beginDate"]').datetimepicker({
	lang:"ch",           //语言选择中文
	format:"Y/m/d H:i",      //格式化日期
	timepicker:false,    //关闭时间选项
	yearStart:2000,     //设置最小年份
	yearEnd:2050,        //设置最大年份
	//todayButton:false    //关闭选择今天按钮
	onClose:function(){
		$('[name="insurance.signDate"]').val($('[name="insurance.beginDate"]').val());
		var dts = $('[name="insurance.beginDate"]').val().split(" ");
		var arr = dts[0].split("/");
		arr[0] = parseInt(arr[0])+1;
		var date = new Date();
		date.setFullYear(arr[0],arr[1]-1,arr[2]);
		date = new Date(date.getTime()-24*60*60*1000);
		$('[name="insurance.endDate"]').val(date.format("yyyy/MM/dd")+" "+dts[1]);
	}
});
</script>

</html>