<%@ page import="com.dz.module.charge.BankRecordTmp" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%--
  Created by IntelliJ IDEA.
  User: doggy
  Date: 15-11-25
  Time: 上午12:24
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
</head>
<body>
  <%Object o = request.getAttribute("tables");%>
  <%if(o == null){%>
    <span>无数据</span>
  <%}else{%>
    <%List<BankRecordTmp> brs = (List)o;%>
    <table class="table table-bordered table-hover table-striped">
    <tr>
      <th>车牌号</th>
      <th>司机</th>
      <th>卡号</th>
      <th>金额</th>
      <th>记录人</th>
      <th>录入时间</th>
    </tr>
    <%for(BankRecordTmp brt:brs){%>
      <tr>
        <td><%=brt.getLicenseNum()%></td>
        <td><%=brt.getDriverName()%></td>
        <td><%=brt.getBankCardNum()%></td>
        <td><%=brt.getMoney()%></td>
        <td><%=brt.getRecorder()%></td>
        <td><%=brt.getRecodeTime()%></td>
      </tr>
    <%}%>
    </table>
  <%}%>
</body>
</html>
