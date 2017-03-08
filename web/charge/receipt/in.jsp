<%@ taglib prefix="s" uri="/struts-tags" %>
<%--
  Created by IntelliJ IDEA.
  User: doggy
  Date: 15-12-28
  Time: 下午11:37
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title></title>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport"
        content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
  <meta name="renderer" content="webkit">
  <title>大众信息化管理平台</title>
  <link rel="stylesheet" href="/DZOMS/res/css/pintuer.css"/>
  <link rel="stylesheet" type="text/css" href="/DZOMS/res/css/jquery.datetimepicker.css"/>

  <script src="/DZOMS/res/js/jquery.js"></script>
  <script src="/DZOMS/res/js/pintuer.js"></script>
  <script src="/DZOMS/res/js/respond.js"></script>
  <link rel="stylesheet" href="/DZOMS/res/css/admin.css">
  <script src="/DZOMS/res/js/admin.js"></script>
  <script type="text/javascript" src="/DZOMS/res/js/jquery.datetimepicker.js" ></script>
  <jsp:include page="/common/msg_info.jsp"></jsp:include>
  <script>
	  $(document).ready(function (){
		  var time = new Date();
		  $("#recordTime").val(time.toLocaleDateString());
		  $.post("/DZOMS/common/getIndex?kind=0",[],function(data){
			  var wei = data.length;
			  var s = "fapiaojinhuo";
			  for(i = 0;i < 7-wei;i++){
				  s += "0";
			  }
			  s+=data;
			  $("#proveNum").val(s);
			  $("#hp").val(s);
			  $("#show_form").submit();
		  });
		  $.post("/DZOMS/charge/receipt/getStorage",{},function(data){
			  data = parseInt(data);
			  var txt = "";
			  var num = data * 100;
			  var box = num / 10000;
			  box = Math.floor(box);
			  if(box >= 1){
				  txt = txt+box+"箱";
			  }
			  var bag = (num-box*10000) / 1000;
			  bag = Math.floor(bag);
			  if(bag >= 1){
				  txt = txt+bag+"袋";
			  }
			  var roll = (num-box*10000-bag*1000) / 100;
			  roll = Math.floor(roll);
			  if(roll >= 1){
				  txt = txt+roll+"卷";
			  }
			  $("#storage").val(txt);
		  });
		  $('.datetimepicker').datetimepicker({
			  lang:"ch",           //语言选择中文
			  format:"Y/m/d",      //格式化日期
			  timepicker:false,    //关闭时间选项
			  yearStart:2000,     //设置最小年份
			  yearEnd:2050,        //设置最大年份
			  //todayButton:false    //关闭选择今天按钮

		  });
	  });
    function fillEnd(){
      var startNum = $("#startNum").val();
      $("#endNum").val(eval(startNum)+9999);
      $("#showNum").html("1箱");
      
      var startNum = $("#startNum").val();
      var endNum = $("#endNum").val();
      var num = eval(endNum)-eval(startNum)+1;
      if(num%100!=0){
      	alert("出售数量应为整袋！");
      	$("#endNum").val("");
      }else{
      	$("input[name='rr.allPrice']").val(num/100*eval($("input[name='rr.price']").val()));
      }
    }
    
    function calNum(){
      var startNum = $("#startNum").val();
      var endNum = $("#endNum").val();
      var num = eval(endNum)-eval(startNum)+1;
      
      if(num%100!=0){
      	alert("出售数量应为整袋！");
      	$("#endNum").val("");
      }else{
      	$("input[name='rr.allPrice']").val(num/100*eval($("input[name='rr.price']").val()));
      }
      
      var txt = "";
      var box = num / 10000;
      box = Math.floor(box);
      if(box >= 1){
        txt = txt+box+"箱";
      }
      var bag = (num-box*10000) / 1000;
      bag = Math.floor(bag);
      if(bag >= 1){
        txt = txt+bag+"袋";
      }
      var roll = (num-box*10000-bag*1000) / 100;
      roll = Math.floor(roll);
      if(roll >= 1){
        txt = txt+roll+"卷";
      }
      $("#showNum").html(txt);
    }
    
    function validate(){
      var startNum = $("#startNum").val();
      var endNum = $("#endNum").val();
		var time = $("#time").val();
		if(time == undefined || time ==""){
			alert("时间必填！");
			return false;
		}
      if(startNum == undefined || startNum==""||endNum==undefined||endNum==""){
        alert("发票开始编号与结束编号必填！！！");
        return false;
      }else{
        if((eval(endNum)-eval(startNum)+1)%100 != 0){
          alert("发票开始编号与结束编号错误！！！");
        }else{
          $.post("/DZOMS/charge/receipt/validateIn",{"startNum":startNum,"endNum":endNum},function(data){
//            alert(data);
            if(data.startsWith("success") ){
              $("#form").submit();
            }else{
              alert("该发票段已经存在于数据库中！！！");
            }
          })
        }
      }
    }
  </script>
  <style>
  	.label{
  		width: 100px;
  		text-align: right;
  	}
  </style>
</head>
<body>
<div class="margin-big-bottom">
	<div class="adminmin-bread" style="width: 100%;">
		<ul class="bread text-main" style="font-size: larger;"> 
                <li>财务管理</li>
                <li>发票进货</li>
    </ul>
    </div>
</div>
<div class="line">
	<div class="panel margin-small" >
          	<div class="panel-head">
          		发票进货
          	</div>
          	<div class="panel-body">
          		 <form action="/DZOMS/charge/receipt/addRecord" method="post" id="form" class="form-inline form-tips" style="width: 100%;">
					 <div class="form-group">
						 <div class="label">
							 <label>库存:</label>
						 </div>
						 <div class="field">
							 <input type="text" class="input input-auto" id="storage" readonly>
						 </div>
					 </div>
					 <br/>
          		       	   <div class="form-group">
          		       	      <div class="label">
          		       	   	     <label>记录日期:</label>
          		       	      </div>
          		       	    <div class="field">
          		       	   	  <input type="text"  name="rr.recordTime" id="recordTime" class="input input-auto" size="20" readonly/>
          		       	    </div>
          		       	    </div>
          		       	    
          		       	    <div class="form-group">
          		       	      <div class="label">
          		       	   	     <label>记录人员:</label>
          		       	      </div>
          		       	    <div class="field">
          		       	    	<s:textfield  value="%{#session.user.uname}" name="rr.recorder" cssClass="input input-auto" size="20"  readonly="true"/>
          		       	    </div>
          		       </div>
          		       	
          		       
          		    
          		       <div class="form-group">
          		       	   <div class="label">
          		       	   	  <label>单据编号:</label>
          		       	   </div>
          		       	   <div class="field">
          		       	   	 <input type="text" readonly name="rr.proveNum" class="input input-auto" size="20" id="proveNum">
          		       	   </div>
          		       </div>
					 <br/>
					 <div class="form-group">
						 <div class="label">
							 <label>单位:</label>
						 </div>
						 <div class="field">
							 <input type="text" class="input input-auto" size="20" value="卷" readonly>
						 </div>
					 </div>
					 <div class="form-group">
						 <div class="label">
							 <label>张数:</label>
						 </div>
						 <div class="field">
							 <input type="text" class="input input-auto" size="20" value="100" readonly>
						 </div>
					 </div>
          		     
          		       <div class="form-group">
          		       	   <div class="label">
          		       	   	  <label>单价:</label>
          		       	   </div>
          		       	   <div class="field">
          		       	   	 <input type="text" value="3.6" name="rr.price" class="input input-auto" size="20" readonly>
          		       	   	 
          		       	   </div>
          		       </div>
          		       <br>
          		       <div class="form-group">
          		       	   <div class="label">
          		       	   	  <label>备注:</label>
          		       	   </div>
          		       	   <div class="field">
          		       	   	 <input type="text" name="rr.comment" class="input input-auto" size="60">
          		       	   </div>
          		       </div>
          		       <br>
          		       <div class="form-group">
          		       	   <div class="label">
          		       	   	  <label>年月:</label>
          		       	   </div>
          		       	   <div class="field">
          		       	   	 <input type="text" name="rr.happenTime" class="input input-auto datetimepicker" size="20" data-validate="required:必填" id="time">
          		       	   </div>
          		       </div>
          		      <br>
          		       <div class="form-group">
          		       	   <div class="label">
          		       	   	  <label>起始号:</label>
          		       	   </div>
          		       	   <div class="field">
          		       	   	<input type="text" name="rr.startNum" id="startNum" onblur="fillEnd()" class="input input-auto" size="20">
          		       	   </div>
          		       </div>
          		        <div class="form-group">
          		       	   <div class="label">
          		       	   	  <label>结束号:</label>
          		       	   </div>
          		       	   <div class="field">
          		       	   	 <input type="text" name="rr.endNum" id="endNum" onchange="calNum()" class="input input-auto" size="20">
          		       	   </div>
          		       </div>
          		       <br>
          		       <div class="form-group">
          		       	   <div class="label">
          		       	   	  <label>金额:</label>
          		       	   </div>
          		       	   <div class="field">
          		       	   	 <input type="text" name="rr.allPrice" class="input input-auto" size="20">
          		       	   </div>
          		       </div>
          		       <div class="form-group">
          		       	   <div class="label">
          		       	   	  <label>数量:</label>
          		       	   </div>
          		       	   <div class="field">
          		       	   	  <strong id="showNum"></strong>
          		       	   </div>
          		       </div>
          		       <input type="hidden" name="rr.style" value="进货">
          		       	<br>
          		          <s:actionmessage/>
          		           <div class="form-group">
          		       	   <div class="label">
          		       	   	  <label></label>
          		       	   </div>
          		       	   <div class="field">
          		       	   	 <input type="button" value="添加" class="button" onclick="validate()">
          		       	   </div>
          		       </div>        
          		 </form>
          		 	
				
			
				</div>
        <form method="post" action="/DZOMS/charge/receipt/searchRecordsByProveNum" target="show" id="show_form" >
					<input type="hidden" name="rr.proveNum" id="hp"/>
				</form>
				
        </div>
  </div>
  
</div>
<div class="panel margin-small">
	<div class="panel-head">
		<form action="/DZOMS/common/incIndex?kind=0" method="post" class="form-inline">
				<input type="submit" value="完成" class="button bg-main">
    </form>
	</div>
	<div class="panel-body">
		<iframe name="show" style="width: 100%;height: 400px;"/>
	</div>
  	
</div>
	
	
	
  <!--<form action="/DZOMS/charge/receipt/addRecord" method="post" id="form">
    <input type="hidden" name="rr.style" value="进货">
    <span>记录日期</span><input type="text" name="rr.recordTime"><span>记录人员</span><input type="text" name="rr.recorder"><br/>
    <span>单据编号</span><input type="text" name="rr.proveNum"><br/>
    <span>单位：卷</span><br/>
    <span>单价：</span><input type="text" name="rr.price"><br/>
    <span>备注</span><input type="text" name="rr.comment"><br/>
    <span>年份</span><input type="text" name="rr.happenTime"><br/>
    <span>起始号</span><input type="text" name="rr.startNum" id="startNum" onblur="fillEnd()"><br/>
    <span>结束号</span><input type="text" name="rr.endNum" id="endNum" onchange="calNum()"><br/>
    <span>合计金额</span><input type="text" name="rr.allPrice"><br/>
    <span id="showNum">数量</span><br/>
    <s:actionmessage/>
    <input type="button" value="提交" onclick="validate()">
  </form>-->
  <script type="text/javascript" src="/DZOMS/res/js/DateTimeHelper.js" ></script>
</body>
</html>
