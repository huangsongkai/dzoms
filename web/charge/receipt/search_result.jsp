<%@ page import="com.dz.module.charge.receipt.ReceiptRecord" %>
<%@ page import="java.util.List" %>
<%--
  Created by IntelliJ IDEA.
  User: doggy
  Date: 15-12-28
  Time: 下午11:43
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title></title>
    <link rel="stylesheet" href="/DZOMS/res/css/pintuer.css">
	<link rel="stylesheet" href="/DZOMS/res/css/admin.css">
	<script src="/DZOMS/res/js/jquery.js"></script>
	<script src="/DZOMS/res/js/pintuer.js"></script>
	<script src="/DZOMS/res/js/respond.js"></script>
	<script src="/DZOMS/res/js/admin.js"></script>
	<script type="text/javascript" src="/DZOMS/res/layer-v2.1/layer/layer.js" ></script>
	<script type="text/javascript" src="/DZOMS/res/js/window.js" ></script>
    <script>
        function removex(x){
            var data = $(x).attr("id");
            data = data.split("|");
            var id = data[0];
            var startNum = data[1];
            var endNum = data[2];
            var style = data[3];
            validateAndRemove(id,startNum,endNum,style);
        }
        function validateAndRemove(id,startNum,endNum,style){
                    if(style == "进货"){
                        $.post("/DZOMS/charge/receipt/validateOut",{"startNum":startNum,"endNum":endNum},function(data){
                            if(data.startsWith("success")){
                                if(confirm("是否作废此发票？")){
                                    var reason = prompt("请输入作废原因");
                                    $.post("/DZOMS/charge/receipt/inRemove",{"rr.id":id,"rr.startNum":startNum,"rr.endNum":endNum,"reason":reason},function(dax){
                                        $('#form', window.parent.document).submit();
                                    });
                                }
                            }else{
                                alert("该发票段不存在或者已经售出！！！");
                            }
                        });
                    }else{
                        if(confirm("是否作废此发票？")){
                            var reason = prompt("请输入作废原因");
                            $.post("/DZOMS/charge/receipt/outRemove",{"rr.id":id,"rr.startNum":startNum,"rr.endNum":endNum,"reason":reason},function(dax){
                                $('#form', window.parent.document).submit();
                            });
                        }
                    }
        }
    </script>
</head>
<body>
	<div>
   <div class="panel  margin-small" >
          	<div class="panel-head">
          		查询结果
          	</div>
              <div class="panel-body">
<table class="table table-bordered table-hover table-striped">
  <tr>
    <th>类别</th>
    <th>车号</th>
    <th>承包人</th>
    <th>领购人</th>
    <th>日期</th>
    <th>收据编号</th>
    <th>张数</th>
    <th>单价</th>
    <th>进货数量</th>
    <th>销售数量</th>
    <th>库存</th>
    <th>总金额</th>
    <th>发票号段</th>
    <th>记录人</th>
    <th>记录时间</th>
    <th>操作</th>
  </tr>
  <%Object o = request.getAttribute("records");%>
  <%if(o != null){%>
    <%List<ReceiptRecord> rrs = (List)o;%>
    <%for(ReceiptRecord rr:rrs){%>
      <%int inNum = 0;int outNum = 0;if(rr.getStyle().equals("销货")){
        outNum = rr.getSoldNum();
      }else{
        inNum = rr.getInNum();
      }%>
      <tr>
        <td><%=rr.getStyle()%></td>
        <td><%=rr.getCarId()==null?"-":rr.getCarId()%></td>
        <td><%=rr.getRenter()==null?"-":rr.getRenter()%></td>
        <td><%=rr.getTaker()==null?"-":rr.getTaker()%></td>
        <td><%=rr.getHappenTime()==null?"-":rr.getHappenTime()%></td>
        <td><%=rr.getProveNum()==null?"-":rr.getProveNum()%></td>
        <td><%=rr.getPaperNum()==0?"0":rr.getPaperNum()%></td>
        <td><%=rr.getPrice()==null?"-":rr.getPrice()%></td>
        <td><%=inNum%></td>
        <td><%=outNum%></td>
        <td><%=rr.getStorage()%></td>
        <td><%=rr.getAllPrice()%></td>
        <td><%=rr.getStartNum()%> - <%=rr.getEndNum()%></td>
        <td><%=rr.getRecorder()==null?"-":rr.getRecorder()%></td>
        <td><%=rr.getRecordTime()==null?"-":rr.getRecordTime()%></td>
        <td><a id="<%=rr.getId()%>|<%=rr.getStartNum()%>|<%=rr.getEndNum()%>|<%=rr.getStyle()%>" onclick="removex(this)">作废</a></td>
      </tr>
    <%}%>
  <%}%>
</table>
</div>
</div>
</div>

</body>
 <script src="/DZOMS/res/js/apps.js"></script>
    <script>
    $(document).ready(function() {
        App.init();
        // $(".xdsoft_datetimepicker.xdsoft_noselect").show();
        // $("#ri-li").append($(".xdsoft_datetimepicker.xdsoft_noselect"));

    });
    </script>
</html>
