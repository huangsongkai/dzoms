<%@ page language="java"
	import="java.util.*,java.text.DecimalFormat,com.dz.module.user.User,
	com.dz.common.other.TimeComm"
	pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	request.setCharacterEncoding("utf-8");
	User user = (User) session.getAttribute("user");
%>

<!DOCTYPE html>
<html lang="zh-cn">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
<meta name="renderer" content="webkit">
<title>发票进货</title>
<link rel="stylesheet" href="/DZOMS/res/css/pintuer.css">
<link rel="stylesheet" href="/DZOMS/res/css/admin.css">
<script src="/DZOMS/res/js/jquery.js"></script>
<script src="/DZOMS/res/js/pintuer.js"></script>
<script src="DZOMS/res/js/respond.js"></script>
<script src="/DZOMS/res/js/admin.js"></script>
<script type="text/javascript">
	function fun() {
		document.getElementById("end").value = parseInt(document
				.getElementById("begin").value) + 9999;
	}
	function load() {
		var xmlhttp;
		if (window.XMLHttpRequest) {
			xmlhttp = new XMLHttpRequest();
		} else {
			xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
		}
		xmlhttp.onreadystatechange = function() {
			if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
				var tmp;
				var stock=xmlhttp.responseXML.documentElement.getElementsByTagName("stock")[0].firstChild.nodeValue;
				document.getElementById("stock").value = stock;
				var num=xmlhttp.responseXML.documentElement.getElementsByTagName("num")[0].firstChild.nodeValue;
				document.getElementById("num").value = num;
				var unit=xmlhttp.responseXML.documentElement.getElementsByTagName("unit")[0].firstChild.nodeValue;
				document.getElementById("unit").value = unit;
				var price=xmlhttp.responseXML.documentElement.getElementsByTagName("price")[0].firstChild.nodeValue;
				document.getElementById("price").value = price;
				var pricech=xmlhttp.responseXML.documentElement.getElementsByTagName("pricech")[0].firstChild.nodeValue;
				document.getElementById("pricech").value = "（大写）"+pricech;
				}			
		};
		xmlhttp.open("POST", "../invoiceReady", true);
		xmlhttp.setRequestHeader("Content-type",
				"application/x-www-form-urlencoded");
		xmlhttp.send(null);
	}
	
	function search(){
		load();
		var xmlhttp;
		if (window.XMLHttpRequest) {
			xmlhttp = new XMLHttpRequest();
		} else {
			xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
		}
		xmlhttp.onreadystatechange = function() {
			if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
				var txt = "";
				txt = xmlhttp.responseText;
				if (txt == "NOT FOUND") {
					alert("未找到数据！");
				}
				var Invoice = xmlhttp.responseXML.documentElement
						.getElementsByTagName("Invoice");
				var HTML = "<tr align = \"center\"><td colspan=\"8\">发票进货记录</td></tr><tr><td>进货编号</td><td>单价（元/卷）</td><td>数量（卷）</td><td>总价（元）</td><td>起始编号</td><td>终止编号</td><td>年份</td>";
				for (i = 0; i < Invoice.length; i++) {
					HTML=HTML + "<tr>";
					var id = Invoice[i].getElementsByTagName("Id");
					tmp=Invoice[i].getElementsByTagName("Id");
					HTML=HTML + "<td id=\"id" + (i + 1) + "\">"+ tmp[0].firstChild.nodeValue + "</td>";
					tmp=Invoice[i].getElementsByTagName("unit");
					HTML=HTML+"<td>"+tmp[0].firstChild.nodeValue+"</td>";
					tmp=Invoice[i].getElementsByTagName("amount");
					HTML=HTML+"<td>"+tmp[0].firstChild.nodeValue+"</td>";
					tmp=Invoice[i].getElementsByTagName("price");
					HTML=HTML+"<td>"+tmp[0].firstChild.nodeValue+"</td>";
					tmp=Invoice[i].getElementsByTagName("begin");
					HTML=HTML+"<td>"+tmp[0].firstChild.nodeValue+"</td>";
					tmp=Invoice[i].getElementsByTagName("end");
					HTML=HTML+"<td>"+tmp[0].firstChild.nodeValue+"</td>";
					tmp=Invoice[i].getElementsByTagName("year");
					HTML=HTML+"<td>"+tmp[0].firstChild.nodeValue+"</td></tr>";		
				}
				var page = xmlhttp.responseXML.documentElement
						.getElementsByTagName("page");
				var hasPrePage = page[0].getElementsByTagName("hasPrePage")[0].firstChild.nodeValue;
				var hasNextPage = page[0].getElementsByTagName("hasNextPage")[0].firstChild.nodeValue;
				var totalPage = page[0].getElementsByTagName("totalPage")[0].firstChild.nodeValue;
				var currentPage = page[0].getElementsByTagName("currentPage")[0].firstChild.nodeValue;
				HTML = HTML + "<tr align = \"center\"><td colspan=\"17\">";
				if (hasPrePage == "true") {
					var prePage = parseInt(currentPage) - 1;
					HTML = HTML
							+ "<a href=\"javascript:searchWithPage(1)\">首页</a>| <a href=\"javascript:searchWithPage("
							+ prePage + ")\">前一页</a>";
				} else {
					HTML = HTML + "首页 | 前一页";
				}
				HTML = HTML
						+ "<span style=\"margin-left: 50px;margin-right: 50px;\">第&nbsp;&nbsp;<input type=\"button\" class=\"btn btn-info\" disabled=\"disabled\" value=\""+currentPage+"\"/>&nbsp;&nbsp;页&nbsp;&nbsp;&nbsp;&nbsp;共&nbsp;&nbsp;<input type=\"button\" class=\"btn btn-info\" disabled=\"disabled\" value=\""+totalPage+"\"/>&nbsp;&nbsp;页</span>";
				if (hasNextPage == "true") {
					var nexPage = parseInt(currentPage) + 1;
					HTML = HTML
							+ "<a href=\"javascript:searchWithPage("
							+ nexPage
							+ ")\">后一页</a>| <a href=\"javascript:searchWithPage("
							+ totalPage + ")\">末页</a>";
				} else {
					HTML = HTML + "后一页 | 末页";
				}
				HTML = HTML + "</tr>";
				document.getElementById("invoice").innerHTML = HTML;
			}
		};
		xmlhttp.open("POST", "../invoiceSearchRecordBuy", true);
		xmlhttp.setRequestHeader("Content-type",
				"application/x-www-form-urlencoded");
		xmlhttp.send(null);
	}
	
	function searchWithPage(currentPage){
		var xmlhttp;
		if (window.XMLHttpRequest) {
			xmlhttp = new XMLHttpRequest();
		} else {
			xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
		}
		xmlhttp.onreadystatechange = function() {
			if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
				var txt = "";
				txt = xmlhttp.responseText;
				if (txt == "NOT FOUND") {
					alert("未找到数据！");
				}
				var Invoice = xmlhttp.responseXML.documentElement
						.getElementsByTagName("Invoice");
				var HTML = "<tr align = \"center\"><td colspan=\"8\">发票进货记录</td></tr><tr><td>进货编号</td><td>单价（元/卷）</td><td>数量（卷）</td><td>总价（元）</td><td>起始编号</td><td>终止编号</td><td>年份</td>";
				for (i = 0; i < Invoice.length; i++) {
					HTML=HTML + "<tr>";
					var id = Invoice[i].getElementsByTagName("Id");
					tmp=Invoice[i].getElementsByTagName("Id");
					HTML=HTML + "<td id=\"id" + (i + 1) + "\">"+ tmp[0].firstChild.nodeValue + "</td>";
					tmp=Invoice[i].getElementsByTagName("unit");
					HTML=HTML+"<td>"+tmp[0].firstChild.nodeValue+"</td>";
					tmp=Invoice[i].getElementsByTagName("amount");
					HTML=HTML+"<td>"+tmp[0].firstChild.nodeValue+"</td>";
					tmp=Invoice[i].getElementsByTagName("price");
					HTML=HTML+"<td>"+tmp[0].firstChild.nodeValue+"</td>";
					tmp=Invoice[i].getElementsByTagName("begin");
					HTML=HTML+"<td>"+tmp[0].firstChild.nodeValue+"</td>";
					tmp=Invoice[i].getElementsByTagName("end");
					HTML=HTML+"<td>"+tmp[0].firstChild.nodeValue+"</td>";
					tmp=Invoice[i].getElementsByTagName("year");
					HTML=HTML+"<td>"+tmp[0].firstChild.nodeValue+"</td></tr>";		
				}
				var page = xmlhttp.responseXML.documentElement
						.getElementsByTagName("page");
				var hasPrePage = page[0].getElementsByTagName("hasPrePage")[0].firstChild.nodeValue;
				var hasNextPage = page[0].getElementsByTagName("hasNextPage")[0].firstChild.nodeValue;
				var totalPage = page[0].getElementsByTagName("totalPage")[0].firstChild.nodeValue;
				var currentPage = page[0].getElementsByTagName("currentPage")[0].firstChild.nodeValue;
				HTML = HTML + "<tr align = \"center\"><td colspan=\"17\">";
				if (hasPrePage == "true") {
					var prePage = parseInt(currentPage) - 1;
					HTML = HTML
							+ "<a href=\"javascript:searchWithPage(1)\">首页</a>| <a href=\"javascript:searchWithPage("
							+ prePage + ")\">前一页</a>";
				} else {
					HTML = HTML + "首页 | 前一页";
				}
				HTML = HTML
						+ "<span style=\"margin-left: 50px;margin-right: 50px;\">第&nbsp;&nbsp;<input type=\"button\" class=\"btn btn-info\" disabled=\"disabled\" value=\""+currentPage+"\"/>&nbsp;&nbsp;页&nbsp;&nbsp;&nbsp;&nbsp;共&nbsp;&nbsp;<input type=\"button\" class=\"btn btn-info\" disabled=\"disabled\" value=\""+totalPage+"\"/>&nbsp;&nbsp;页</span>";
				if (hasNextPage == "true") {
					var nexPage = parseInt(currentPage) + 1;
					HTML = HTML
							+ "<a href=\"javascript:searchWithPage("
							+ nexPage
							+ ")\">后一页</a>| <a href=\"javascript:searchWithPage("
							+ totalPage + ")\">末页</a>";
				} else {
					HTML = HTML + "后一页 | 末页";
				}
				HTML = HTML + "</tr>";
				document.getElementById("invoice").innerHTML = HTML;
			}
		};
		xmlhttp.open("POST", "../invoiceSearchRecordBuy", true);
		xmlhttp.setRequestHeader("Content-type",
				"application/x-www-form-urlencoded");
		xmlhttp.send("currentPage=" + currentPage);
	}
</script>
</head>

<body onLoad="search()">
	<div class="adminmin-bread">
		<ul class="bread">
			<li><a href="" class="icon-home"> 开始</a></li>
			<li>发票进货</li>
		</ul>
	</div>

	<div>
		<!-- 主页面 -->
		<form action="invoiceBuy" method="post" class="definewidth m20">

			<table class="table table-bordered table-hover m10">
				<tr>
					<td class="tableleft">库存</td>
					<td><input type="text" id="stock" readonly="readonly"/></td>

					<td class="tableleft">单据编号</td>
					<td><input type="text" id="num" name="invoiceRecord.receiptNum"
						readonly="readonly"/></td>
				</tr>
				<tr>
					<td class="tableleft">经手时间</td>
					<td><input type="text" name="invoiceRecord.time"
						readonly="readonly" value="<%=TimeComm.getCurrentTime()%>" /></td>

					<td class="tableleft">经手人</td>
					<td><input type="text" name="invoiceRecord.user"
						readonly="readonly" value="<%=user.getUname()%>" /></td>
				</tr>
				<tr>
					<td class="tableleft">数量</td>
					<td><input type="text" readonly="readonly" value="100 卷" /></td>

					<td class="tableleft">单价</td>
					<td><input type="text" id="unit" name="invoiceRecord.unitPrice"
						readonly="readonly"/>元/卷</td>
				</tr>
				<tr>
					<td class="tableleft">合计金额</td>
					<td><input type="text" id="pricech" readonly="readonly"/></td>

					<td><input type="text" id="price" name="invoiceRecord.price"
						readonly="readonly"/></td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr>
					<td class="tableleft">发票起始号</td>
					<td><input type="text" id="begin"
						name="invoiceRecord.sectionBegin" onblur="fun()" /></td>

					<td class="tableleft">发票终止号</td>
					<td><input type="text" id="end"
						name="invoiceRecord.sectionEnd" readonly="readonly" /></td>
				</tr>
				<tr>
					<td class="tableleft">年份</td>
					<td><input type="text" name="invoiceRecord.yearId" /></td>

					<td><button type="submit" class="btn btn-primary">确认进货</button></td>
					<td>&nbsp;</td>
				</tr>
			</table>
		</form>
	</div>
	<br/><br/><br/><br/><br/>
		
	<table class="table table-striped table-bordered table-condensed" id="invoice">

    </table>
</body>
</html>