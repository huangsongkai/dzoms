<%@taglib uri="/struts-tags" prefix="s"%>
<%@ page language="java" import="java.util.*,com.dz.module.vehicle.*,com.dz.module.user.User" pageEncoding="UTF-8"%><!DOCTYPE html>
<%@page import="org.springframework.web.context.support.*"%>
<%@page import="org.springframework.context.*" %>
<%@page import="org.apache.commons.collections.*" %>
<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport"
	content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
	<meta name="renderer" content="webkit">
		<title>新增购置税信息</title>
	<link rel="stylesheet" href="/DZOMS/res/css/pintuer.css">
	<link rel="stylesheet" href="/DZOMS/res/css/admin.css">
	<script src="/DZOMS/res/js/jquery.js"></script>
	<script src="/DZOMS/res/js/pintuer.js"></script>
	<script src="/DZOMS/res/js/respond.js"></script>
	<script src="/DZOMS/res/js/admin.js"></script>
	<script src="/DZOMS/res/js/itemtool.js"></script>
<link rel="stylesheet" href="/DZOMS/res/css/jquery.datetimepicker.css" />
<script src="/DZOMS/res/js/jquery.datetimepicker.js"></script>

    <link rel="stylesheet" href="/DZOMS/res/css/jquery.bigautocomplete.css" />
	<script type="text/javascript" src="/DZOMS/res/js/jquery.bigautocomplete.js" ></script>
	<jsp:include page="/common/msg_info.jsp"></jsp:include>
	<script>
		$(document).ready(function(){
			$("#carframe_num").bigAutocomplete({
				url:"/DZOMS/select/vehicleById"
			});
		});
	</script>
	</head>
	<body>
<div class="adminmin-bread" style="width: 100%;">
		<ul class="bread text-main" style="font-size: larger;">
               
                <li>车辆管理</li>
                <li>新增</li>
                <li>新增购置税信息</li>
        </ul>
</div>
	
	<div class="xm5 xm2-move">
		<div class="alert alert-yellow padding">
		<span class="close rotate-hover"></span><strong>注意：</strong>录入购置信息前需要录入发票信息。</div>
		<div class="panel">
			<div class="panel-head">
				新增购置税信息
			</div>
			<div class="panel-body">
					<form action="/DZOMS/vehicle/tax_add" method="post" class="form-x form-tips">
			<input type="hidden" name="url" value="/vehicle/vehicle/tax_add.jsp" />
			<div class="form-group">
				<div class="label"><label>车架号</label></div>
				<div class="field"><input type="text" id="carframe_num"  style="width: 95%;float: left;"  name="vehicle.carframeNum" class="input" data-validate="required:必填"/>
					<span style="color:red;font-size:large;width: 5%;">*</span>
				</div>
			</div>
			<div class="form-group">
				<div class="label"><label>核发日期</label></div>
				<div class="field"><input name="vehicle.taxDate" class="input datepick"  style="width: 95%;float: left;"  data-validate="required:必填"/>
					<span style="color:red;font-size:large;width: 5%;">*</span>
				</div>
			</div>
			<div class="form-group">
				<div class="label"><label>购置税号</label></div>
				<div class="field"><input name="vehicle.taxNumber" class="input"  style="width: 95%;float: left;"  data-validate="required:必填"/>
					<span style="color:red;font-size:large;width: 5%;">*</span>
				</div>
			</div>
			<div class="form-group">
				<div class="label"><label>购置税应收</label></div>
				<div class="field"><input name="vehicle.taxMoney" class="input"  style="width: 95%;float: left;"  data-validate="required:必填"/>
					<span style="color:red;font-size:large;width: 5%;">*</span>
				</div>
			</div>
			<div class="form-group">
				<div class="label"><label>发证机关</label></div>
				<div class="field">
					<!--<input name="vehicle.taxFrom" class="input" data-validate="required:必填"/>-->
					<select  class="input" name="vehicle.taxFrom" id="vehicle_taxFrom"  style="width: 95%;float: left;"   data-validate="required:请选择,length#>=1:至少选择1项" onfocus="getList1('vehicle_taxFrom','vehicle_taxFrom');">
                	</select>
					<a class="icon icon-wrench" style="width: 5%;" href="javascript:openItem('vehicle_taxFrom','购置税发证机关')"></a>
				</div>
			</div>
			<div class="form-group">
				<div class="label"><label>登记人</label></div>
				<div class="field"><input class="input" readonly="readonly" value="<%=((User)session.getAttribute("user")).getUname()%>" />
					<input class="input" type="hidden" name="vehicle.taxRegister" value="<%=((User)session.getAttribute("user")).getUid()%>"/></div>
			</div>
			<div class="form-group">
				<div class="label"><label>登记时间</label></div>
				<div class="field"><input class="input" readonly="readonly" name="vehicle.taxRegistTime" 
						value="<%=(new  java.text.SimpleDateFormat("yyyy/MM/dd")).format(new java.util.Date()) %>"/>
			</div>
			<div class="form-button">
				
				<div class="field">
					<input type="submit" class="button bg-green" value="提交">
					<input type="button" class="button" name="backid"
							id="backid" onclick="location.href='/DZOMS/vehicle/AbandonApproval/judge.jsp'" value="取消">
			</div>
		
			
		</form>
			</div>
			
		</div>
	
	</div>
	</body>
		<script src="/DZOMS/res/js/DateTimeHelper.js"></script>
</html>

