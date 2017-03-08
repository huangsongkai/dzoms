<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ page import="com.dz.module.charge.CheckChargeTable" %>
<%@ page import="java.util.List" %>
<%--
  Created by IntelliJ IDEA.
  User: doggy
  Date: 15-11-21
  Time: 下午10:48
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
  <script>

  </script>
</head>
<body>
<div class="panel">
  <div class="panel-body bg-white">
    <table class="table table-bordered table-hover table-striped">
      <tr>
        <th>车牌号</th>
        <th>司机</th>
        <th>部门</th>
        <th>计划总额</th>
        <th>现金收入</th>
        <th>银行收入</th>
        <th>油补转入</th>
        <th>保险转入</th>
        <th>收入合计</th>
        <th>本月欠款</th>
        <th>上月累欠</th>
        <th>本月存款</th>
        <th>本月累欠</th>
      </tr>
      <%List<CheckChargeTable> tables = (List<CheckChargeTable>)request.getAttribute("tables");%>
      <%for(CheckChargeTable record:tables){%>
      <tr>
        <td><%=record.getCarNumber()%></td>
        <td><%=record.getDriverName()%></td>
        <td><%=record.getDept()%></td>
        <td><%=record.getPlanAll()%></td>
        <td><%=record.getCash()%></td>
        <td><%=record.getBank()%></td>
        <td><%=record.getOilAdd()%></td>
        <td><%=record.getInsurance()%></td>
        <td><%=record.getTotal()%></td>
        <td><%=record.getThisMonthOwe()%></td>
        <td><%=record.getLastMonthOwe()%></td>
        <td><%=record.getThisMonthLeft()%></td>
        <td><%=record.getThisMonthTotalOwe()%></td>
      </tr>
      <%}%>

    </table>
    <div class="line">
      <div class="xm4 xm4-move">
        <a href="javascript:void beforePage();" class="button">上一页</a>
        <input type="text" id="ps" onblur="toPage();" class="input input-auto" size="3">
        <a href="javascript:void nextPage();" class="button">下一页</a>
      </div>

    </div>
  </div>
</div>


<form action="/DZOMS/charge/mainCharge" method="post" id="form">
  <s:hidden type="hidden" id="currentPage" value="%{currentPage}" name="currentPage" />
</form>
<script>
  var totalPage = <s:property value="%{pageLimit}"/>;
  function beforePage(){
    var currentPage = $("#currentPage").val();
    currentPage--;
    if(currentPage <= 0){
      alert("没有更多数据了.");
    }else{
      $("#currentPage").val(currentPage);
      $("#form").submit();
    }
  }
  function nextPage(){
    var currentPage = $("#currentPage").val();
    currentPage++;
    if(currentPage > totalPage){
      alert("没有更多数据了.");
    }else{
      $("#currentPage").val(currentPage);
      $("#form").submit();
    }
  }
  function toPage(){
    var pi = $("#ps").val();
    if(1 <= pi && pi <= totalPage){
      $("#currentPage").val(pi);
      $("#form").submit();
    }else{
      alert("没有更多数据");
      $("#ps").val("");
    }
  }
  $(document).ready(function(){
    $("#ps").attr("placeholder",$("#currentPage").val()+"/"+totalPage);
  });

</script>
</body>
</html>
