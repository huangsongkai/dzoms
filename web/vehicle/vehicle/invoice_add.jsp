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
		<title>新增发票信息</title>
		<link rel="stylesheet" href="/DZOMS/res/css/pintuer.css">
	<link rel="stylesheet" href="/DZOMS/res/css/admin.css">
	<script src="/DZOMS/res/js/jquery.js"></script>
	<script src="/DZOMS/res/js/pintuer.js"></script>
	<script src="/DZOMS/res/js/respond.js"></script>
	<script src="/DZOMS/res/js/admin.js"></script>
	<script type="text/javascript" src="/DZOMS/res/js/itemtool.js" ></script>
<link rel="stylesheet" href="/DZOMS/res/css/jquery.datetimepicker.css" />
<script src="/DZOMS/res/js/jquery.datetimepicker.js"></script>

	<link rel="stylesheet" href="/DZOMS/res/css/jquery.bigautocomplete.css" />
	<script type="text/javascript" src="/DZOMS/res/js/jquery.bigautocomplete.js" ></script>
	<jsp:include page="/common/msg_info.jsp"></jsp:include>
	<script>
		$(document).ready(function(){
			$("#carframe_num").bigAutocomplete({
				url:"/DZOMS/select/VehicleBycarframeNum",
				condition:"invoiceNumber is null"
			});
			//getList1('vehicle_purseFrom','vehicle_purseFrom');
		
			
			
		});
	</script>
<style>
	.tableleft{
		text-align: right;
	}
</style>
</head>
<body>
<div class="adminmin-bread" style="width: 100%;">
		<ul class="bread text-main" style="font-size: larger;">
               
                <li>车辆管理</li>
                <li>新增</li>
                <li>新增发票信息</li>
        </ul>
</div>

	<div class="xm5 xm2-move">
		<div class="alert alert-yellow padding">
		<span class="close rotate-hover"></span><strong>注意：</strong>录入发票信息前需要录入车辆技术信息文字。</div>
		<div class="panel">
			<div class="panel-head">
				新增发票信息
			</div>
			<div class="panel-body">
			<form action="/DZOMS/vehicle/invoice_add" method="post" class="form-x form-tips">
			<input type="hidden" name="url" value="/vehicle/vehicle/invoice_add.jsp" />
			<div class="form-group">
				<div class="label"><label>车架号</label></div>
				<div class="field"><input type="text" id="carframe_num" style="width: 95%;float: left;" name="vehicle.carframeNum" class="input" data-validate="required:必填"/>
					<span style="color:red;font-size:large;width: 5%;">*</span>
				</div>
			</div>
			<div class="form-group">
				<div class="label"><label>开票日期</label></div>
				<div class="field"><input name="vehicle.invoiceDate" class="input datepick" style="width: 95%;float: left;" data-validate="required:必填"/>
					<span style="color:red;font-size:large;width: 5%;">*</span>
				</div>
			</div>
			<div class="form-group">
				<div class="label"><label>发票号码</label></div>
				<div class="field"><input name="vehicle.invoiceNumber" style="width: 95%;float: left;" class="input" data-validate="required:必填"/>
					<span style="color:red;font-size:large;width: 5%;">*</span>
				</div>
			</div>
			<div class="form-group">
				<div class="label"><label>计税合计</label></div>
				<div class="field"><input name="vehicle.invoiceMoney" class="input" style="width: 95%;float: left;" data-validate="required:必填"/>
					<span style="color:red;font-size:large;width: 5%;">*</span>
				</div>
			</div>
			<div class="form-group">
				<div class="label"><label>销货单位名称</label></div>
				<div class="field">
<!--					<input name="vehicle.purseFrom" class="input" data-validate="required:必填"/>
-->					<select class="input itemtool" style="width: 95%;float: left;" name="vehicle.purseFrom" data-validate="required:请选择,length#>=1:至少选择1项" item-key="vehicle_purseFrom">
                	</select>
					<a style="width: 5%;" class="icon icon-wrench" href="javascript:openItem('vehicle_purseFrom','销货单位名称')"></a>
				</div>
			</div>
			<div class="form-group">
				<div class="label"><label>登记人</label></div>
				<div class="field"><input class="input" readonly="readonly" value="<%=((User)session.getAttribute("user")).getUname()%>" />
					<input class="input" type="hidden" name="vehicle.invoiceRegister" value="<%=((User)session.getAttribute("user")).getUid()%>"/></div>
			</div>
			<div class="form-group">
				<div class="label"><label>登记时间</label></div>
				<div class="field"><input class="input" readonly="readonly" name="vehicle.invoiceRegistTime" 
						value="<%=(new  java.text.SimpleDateFormat("yyyy/MM/dd")).format(new java.util.Date()) %>"/>
			</div>
			<div class="form-button padding">
				
				<div class="field"><input type="submit" class="button bg-main" value="提交">
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
