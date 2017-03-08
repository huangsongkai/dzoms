<%@page import="com.dz.common.other.TimeComm"%>
<%@ page language="java" import="java.util.*,com.dz.module.user.User, 
	com.dz.module.contract.BankCard"
	pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	User user = (User) session.getAttribute("user");
%>

<!DOCTYPE html>
<html lang="zh-cn">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
<meta name="renderer" content="webkit">
<title>修改月租金模版</title>
<link rel="stylesheet" href="/DZOMS/res/css/pintuer.css">
<link rel="stylesheet" href="/DZOMS/res/css/admin.css">
<script src="/DZOMS/res/js/jquery.js"></script>
<script src="/DZOMS/res/js/pintuer.js"></script>
<script src="/DZOMS/res/js/respond.js"></script>
<script src="/DZOMS/res/js/admin.js"></script>
</head>

<body>

	<div class="adminmin-bread">
		<ul class="bread">
			<li>修改月租金模版</li>
		</ul>
	</div>

	<div>
		<form action="bankCardAdd" method="post" class="definewidth m20">
			<table class="table table-bordered table-hover m10">
				
			</table>
		</form>
	</div>
</body>
</html>