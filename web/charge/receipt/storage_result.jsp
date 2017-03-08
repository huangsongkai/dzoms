<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ page import="com.dz.module.charge.receipt.StorageItem" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.dz.module.charge.receipt.util.CountPass" %>
<%--
  Created by IntelliJ IDEA.
  User: doggy
  Date: 16-3-6
  Time: 下午4:20
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport"
        content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
  <meta name="renderer" content="webkit">
  <title>测试</title>
  <link rel="stylesheet" href="/DZOMS/res/css/pintuer.css"/>
  <link rel="stylesheet" type="text/css" href="/DZOMS/res/css/jquery.datetimepicker.css"/>

  <script src="/DZOMS/res/js/jquery.js"></script>
  <script src="/DZOMS/res/js/pintuer.js"></script>
  <script src="/DZOMS/res/js/respond.js"></script>
  <link rel="stylesheet" href="/DZOMS/res/css/admin.css">
  <script src="/DZOMS/res/js/admin.js"></script>
  <script type="text/javascript" src="/DZOMS/res/js/jquery.datetimepicker.js" ></script>
  <script>
    function showMessage(x){
      $.post("/DZOMS/charge/receipt/getNextAvaliable",{"proveNum":x},function(data){
        var x = eval(data);
        if(x == -1){
          alert("已经卖完了");
        }else{
          alert("下一个可用编号："+x);
        }
      });
    }
  </script>
</head>
<body>
	<div class="panel margin-small">
		<div class="panel-head">
			 库存结果
		</div>
		<div class="panel-body">
			 <table class="table table-hover table-bordered table-striped">
    <tr>
      <th>单位</th>
      <th>规格（张/卷）</th>
      <th>数量</th>
      <th>数量2</th>
      <th>金额</th>
      <th>年份</th>
      <th>号段</th>
      <th>经手人</th>
      <th>操作</th>
    </tr>
    <%Map<String,StorageItem> map = (Map)request.getAttribute("map");
      int totalAll = 0;
      for(Map.Entry<String,StorageItem> entry:map.entrySet()){
        int temp = 0;
    %>
      <tr>
        <td>卷</td>
        <td>100</td>
        <%for(CountPass cp:entry.getValue().getCountPasses()){
          temp += cp.getNumber();
          totalAll += cp.getNumber();
        }%>
        <td><%=temp%></td>
        <td><%=temp/100%>箱</td>
        <td><%=temp*3.6%></td>
        <td><%=entry.getValue().getRecordTime()%></td>
        <td>
          <%for(CountPass cp:entry.getValue().getCountPasses()){%>
              <%=cp.getStart()%>-<%=cp.getEnd()%>|
          <%}%>
        </td>
        <td><%=entry.getValue().getRecorder()%></td>
        <td><a class="button bg-main" onclick="showMessage('<%=entry.getValue().getProveNum()%>')">查看</a></td>
      </tr>
    <%
      }
    %>
  </table>
		</div>
		<div class="panel-foot">
			总数量：<%=totalAll%>卷    总价格：<%=totalAll*3.6%>元
		</div>
	</div>
 

</body>
</html>
