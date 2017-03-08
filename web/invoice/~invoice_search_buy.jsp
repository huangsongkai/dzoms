<%@ page language="java"
    import="java.util.*"
    pageEncoding="UTF-8"%>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
    request.setCharacterEncoding("utf-8");
%>

<!DOCTYPE html>
<html lang="zh-cn">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport"
    content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
<meta name="renderer" content="webkit">
<title>查询发票进货记录</title>
<link rel="stylesheet" href="/DZOMS/res/css/pintuer.css">
<link rel="stylesheet" href="/DZOMS/res/css/admin.css">
<script src="/DZOMS/res/js/jquery.js"></script>
<script src="/DZOMS/res/js/pintuer.js"></script>
<script src="DZOMS/res/js/respond.js"></script>
<script src="/DZOMS/res/js/admin.js"></script>
<script type="text/javascript">
	function fun(){
		document.getElementById("end").value = parseInt(document.getElementById("begin").value)+9999;
	}
	function search(){
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
				var HTML = "<tr><td></td><td>进货编号</td><td>单价（元/卷）</td><td>数量（卷）</td><td>起始编号</td><td>终止编号</td><td>年份</td>";
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
				var HTML = "<tr><td></td><td>进货编号</td><td>单价（元/卷）</td><td>数量（卷）</td><td>起始编号</td><td>终止编号</td><td>年份</td>";
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
                <li>查询发票进货记录</li>
        </ul>
    </div>

    <div>
        <!-- 主页面 -->
        <table class="table table-striped table-bordered table-condensed" id="invoice">
        	
        </table>	
    </div>


</body>
</html>