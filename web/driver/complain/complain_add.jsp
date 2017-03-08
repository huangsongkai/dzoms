<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
	<%@taglib uri="/struts-tags" prefix="s" %>
		<%@ page language="java" import="java.util.*,com.dz.module.user.User" pageEncoding="UTF-8" %>
			<% String path=request.getContextPath(); String basePath=request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/"; %>
				<!doctype html>
				<html lang="zh-cn">

				<head>
					<meta charset="utf-8">
					<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
					<meta http-equiv="X-UA-Compatible" content="IE=edge">
					<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
					<meta name="renderer" content="webkit">
					<title>添加投诉信息</title>
					<link rel="stylesheet" href="/DZOMS/res/css/pintuer.css" />
					<link rel="stylesheet" href="/DZOMS/res/css/admin.css" />
					<link rel="stylesheet" href="/DZOMS/res/css/jquery.datetimepicker.css" />
					<script src="/DZOMS/res/js/jquery.js"></script>
					<script src="/DZOMS/res/js/pintuer.js"></script>
					<script src="/DZOMS/res/js/respond.js"></script>
					<script src="/DZOMS/res/js/admin.js"></script>

					<script type="text/javascript" src="/DZOMS/res/js/JsonList.js"></script>
					<script src="/DZOMS/res/js/itemtool.js"></script>
					<script type="text/javascript" src="/DZOMS/res/js/TableList.js"></script>

					<script>
		var i =0;
        function addfilename(){
            var txt=$("<option class='filename'></option>").text($(".addFile:first").val());
            $("#filename").append(txt)
        }
        function addfile(){
            var txt='<input size="100" type="file" class="addFile" name="uploads" onchange="addfilename()" style="display:none"/>';
            $(add).after(txt);
            $(".addFile:first").click();
            i=i+1;
        }
        function delefile(){
            for(j=0;j<=i;j++){
                if( $(".filename:selected").val()==$("input.addFile").eq(i).val()){
                    $(".filename:selected").remove();
                    $("input.addFile").eq(i).remove();
                }
                else{
                    file = $("file").next();
                    i=i-1;
                }
            }
        }
        
						function hidden_show(){
							
							if($('[name="complain.complainClass"]').val()=="违反营运规定"){
								$(".hidden_input").val("");
								$(".hidden_input").attr("disabled",true);
							}
							else{
								$(".hidden_input").val("");
								$(".hidden_input").attr("disabled",false);
								
							}
						}
						$(document).ready(function() {
							getJsonList("/DZOMS/driver/complain/complain.json", [/*"complain.complainClass", "complain.complainType",*/ "complain.complainPersonSex"]);
							getTableList("complain.complainObject", ["complainObject2", "complain.complainObject"]); //投诉项目
							getSingleList("complain.complainFromIn", "complain.complainFromIn", ["complainFromIn3", "complainFromIn2"]);
							var $licenseNumSelection = $('select[name="complain.vehicleId"]');
							$licenseNumSelection.html("");
							$.post("/DZOMS/vehicle/vehicleSearch", {
								"vehicle.state": 1
							}, function(data) {
								$licenseNumSelection.append("<option></option>");
								for (var i = 0; i < data.length; i++) {
									var option = '<option value="' + data[i]["carframeNum"] + '">' + data[i]["licenseNum"] + '</option>';
									$licenseNumSelection.append(option);
								}
							});
							$licenseNumSelection.change(function() {
								var $selected_option = $licenseNumSelection.find("option:selected");
								var carframeNum = $selected_option.val();
								$.post("/DZOMS/common/getObject", {
									"className": "com.dz.module.vehicle.Vehicle",
									"id": carframeNum,
									"isString": true
								}, function(data) {
									var vehicle = data; //$.parseJSON(data);
									var driverId = vehicle["driverId"];
									$.post("/DZOMS/common/getObject", {
										"className": "com.dz.module.driver.Driver",
										"id": driverId,
										"isString": true
									}, function(data2) {
										var driver = data2; //$.parseJSON(data2);
										$('input[name="idNum"]').val(driver["name"]);
										$('input[name="telephone"]').val(driver["phoneNum1"]);
									});
									$('input[name="company"]').val(vehicle["dept"]);
								});
							});
						});
					</script>
					<script src="/DZOMS/res/js/jquery.datetimepicker.js"></script>
					<style>
						.label{
							width: 80px;
							text-align: right;
						}

						.form-group{
							width: 300px;
						}
						
						td{
							text-align: left;
						}
					</style>

				</head>

				<body>
<div class="margin-big-bottom">
	<div class="adminmin-bread" style="width: 100%;">
		<ul class="bread text-main" style="font-size: larger;"> 
                <li>驾驶员</li>
                <li>投诉</li>
                <li>投诉添加</li>
        </ul>
        </div>
</div>
<div class="panel margin-big">
	<div class="panel-head">投诉添加</div>
	<div class="panel-body">
		<form class="form-inline form-tips" style="width: 100%;" name="addComplain" action="/DZOMS/driver/complain/addComplain" method="post">
        <table>
        	<tr>
        		<td style="width: 210px;">
        			<div class="form-group" style="width: 210px;">
									<div class="label" style="width:80px;">
										<label>
											投诉时间:</label>
									</div>
									<div class="field" style="width: 120px;">
										<input class="datepick input setTimeToday" type="text" name="complain.complainTime" style="width: 120px;">
									</div>
			       </div>
        		</td>
        		<td style="width: 210px;">
        			<div class="form-group" style="width: 210px;">
									<div class="label" style="width:80px;">
										<label>
											投诉类别:</label>
									</div>
									<div class="field" style="width: 120px;">
										<select class="input" style="width: 100px;" name="complain.complainType" id="complainType" onfocus="getList1('complainType','complainType')"></select>
										<a class="icon icon-wrench" href="javascript:openItem('complainType','投诉类别')"></a>
									</div>
			       </div>
        		</td>
        		<td style="width: 210px;">
        			<div class="form-group" style="width: 210px;">
									<div class="label" style="width:80px;">
										<label>
											投诉类型:</label>
									</div>
									<div class="field" style="width: 120px;">
									<select class="input" style="width: 100px;" name="complain.complainClass" onchange="hidden_show()" id="complainClass" onfocus="getList1('complainClass','complainClass')"></select>
										<a class="icon icon-wrench" href="javascript:openItem('complainClass','投诉类型')"></a>
									</div>
			       </div>
        		</td>
        	</tr>
        	<tr>
        		<td style="width: 630px;" colspan="3">
        			<div class="form-group" style="width: 630px;">
									<div class="label" style="width: 80px;">
										<label>投诉项目:</label>
									</div>
									<div class="field" style="width: 540px;">
										<select class="input float-left" name="complainObject2" style="width: 120px;"></select>
										<select class="input" name="complain.complainObject" style="width: 400px"></select>
										<a class="icon icon-wrench" href="javascript:setTableList('complain.complainObject',2)"></a>
									</div>
					</div>
        		</td>
        		<td style="width: 210px;">
        			<div class="form-group" style="width: 210px;">
									<div class="label" style="width: 80px;">
										<label>分值:</label>
									</div>
									<div class="field" style="width: 120px;">
										<input class="input" style="width:120px"/>
									</div>
								</div>
        		</td>
        	</tr>
        	<tr>
        		<td style="width: 210px;">
        			<div class="form-group" style="width: 210px;">
									<div class="label" style="width: 80px;">
										<label>信息来源:</label>
									</div>
									<div class="field" style="width: 120px;">
										<select class="input" style="width: 100px;" name="complain.complainFromOut" id="complainFromOut" onfocus="getList1('complainFromOut','complainFromOut')"></select>
										<a class="icon icon-wrench" href="javascript:openItem('complainFromOut','信息来源')"></a>
									</div>
								</div>
        		</td>
        		<td>
        			<div class="form-group" style="width: 210px;">
									<div class="label" style="width: 80px;">
										<label>姓名:</label>
									</div>
									<div class="field" style="width: 120px;">
										<select class="input" style="width: 100px;" name="complain.complainFromIn"></select>
										<a class="icon icon-wrench" href="javascript:setSingleList('complain.complainFromIn',['complain.complainFromIn','complainFromIn3','complainFromIn2'],['姓名','手机','电话'])"></a>
									</div>
								</div>
        		</td>
        		<td>
        			<div class="form-group" style="width: 210px;">
									<div class="label" style="width: 80px;">
										<label>电话:</label>
									</div>
									<div class="field" style="width: 120px;">
										<input class="input" name="complainFromIn2" style="width: 120px;"/>
									</div>
								</div>
        		</td>
        		<td>
        			<div class="form-group" style="width: 210px;">
									<div class="label" style="width: 80px;">
										<label>手机:</label>
									</div>
									<div class="field" style="width: 120px;">
										<input class="input" name="complainFromIn3"  style="width: 120px;"/>
									</div>
								</div>
        		</td>
        	</tr>
        	<tr>
        		<td>
        			<div class="form-group" style="width: 210px;">
									<div class="label" style="width: 80px;">
										<label>车牌号:</label>
									</div>
									<div class="field" style="width: 120px;">
										<select class="input" name="complain.vehicleId"style="width: 120px;"></select> 
									</div>
								</div>
        		</td>
        		<td>
        			<div class="form-group" style="width: 210px;">
									<div class="label" style="width: 80px;">
										<label>承租人:</label>
									</div>
									<div class="field" style="width: 120px;">
										<input class="input" name="idNum" style="width: 120px;">
									</div>
								</div>
        		</td>
        		<td>
        			<div class="form-group" style="width: 210px;">
									<div class="label" style="width: 80px;">
										<label>电话:</label>
									</div>
									<div class="field" style="width: 120px;">
										<input class="input" name="telephone"  style="width: 120px;">
									</div>
								</div>
        		</td>
        		<td>
        			<div class="form-group" style="width: 210px;">
									<div class="label" style="width: 80px;">
										<label>分公司归属:</label>
									</div>
									<div class="field" style="width: 120px;">
									<input class="input" name="company"   style="width: 120px;">
									</div>
								</div>
        		</td>
        	</tr>
        	<tr>
        		<td>
        			<div class="form-group" style="width: 210px;">
									<div class="label" style="width: 80px;">
										<label>投诉人姓名:</label>
									</div>
									<div class="field" style="width: 120px;">
									<input class="input hidden_input" name="complain.complainPersonName"  style="width: 120px;">
									</div>
								</div>
        		</td>
        		<td>
        			<div class="form-group" style="width: 210px;">
									<div class="label" style="width: 80px;">
										<label>投诉人性别:</label>
									</div>
									<div class="field" style="width: 120px;">
									<select class="input hidden_input" name="complain.complainPersonSex" style="width: 80px;">
									</select>
									</div>
								</div>
        		</td>
        		<td>
        			<div class="form-group" style="width: 210px;">
									<div class="label" style="width: 80px;">
										<label>投诉人电话:</label>
									</div>
									<div class="field" style="width: 120px;">
									<input class="input hidden_input" name="complain.complainPersonPhone" style="width: 120px;" />
									</div>
								</div>
        		</td>
        		<td>
        			<div class="form-group" style="width: 210px;">
									<div class="label" style="width: 80px;">
										<label>发票号:</label>
									</div>
									<div class="field" style="width: 120px;">
									<input class="input" name="complain.ticketNumber"  style="width: 120px;" />
									</div>
								</div>
        		</td>
        	</tr>
        	<tr>
        		<td colspan="3">
        			<div  style="width: 100%">
           							 <div class="float-left" style="width: 80px; text-align: right;">
           							 	<strong>添加文件:</strong>
           							 </div>
            							<div class="float-left">
                							<select  id="filename" size="5" style="width: 400px;border: 1px solid rgb(221, 221, 221); border-image: none;"  class="float-left"></select>
                						</div>
                	
            					</div>
            					  <div class="margin-small">
                                   <div class="margin-small">
                                         <a id="add" class="button input-file" href="javascript:addfile();">添加</a>
                                    </div>
                                    <div class="margin-small">
                                           <a  class="button input-file" href="javascript:void(0);" onclick="delefile()">删除</a>
                                     </div>
                              </div>
        		</td>
        		
        	</tr>
        	<tr>
        		<td colspan="3">
        			 <div style="width: 100%;" class="margin-small">
								
										<div class="float-left" style="width: 80px; text-align: right;">
											<strong>投诉内容:</strong>
										</div>
									
									<div class="field">
										<textarea style="width: 400px;" rows="5" class="input" placeholder="多行文本" name="complain.complainContext"></textarea>
									</div>
								</div>
        		</td>
        	</tr>
        	<tr>
        		<td>
        			 <div class="form-group" style="width: 210px;">
									<div class="label" style="width: 80px">
										<label>登记人:</label>
									</div>
									<div class="field" style="width: 120px;">
										<input style="width: 120px;" class="input " type="text" readonly="readonly" value="<%=((User)session.getAttribute( "user")).getUname()%>">
										<input type="hidden" name="complain.register" value="<%=((User)session.getAttribute("user")).getUid()%>"/>
									</div>
								</div>
        		</td>
        		<td>
        			<div class="form-group" style="width: 210px;">
									<div class="label" style="width: 80px;">
										<label>登记时间</label>
									</div>
									<div class="field" style="width: 120px;">
										<input class="input" style="width: 120px;" readonly="readonly" name="complain.registTime" value="<%=(new  java.text.SimpleDateFormat(" yyyy/MM/dd ")).format(new java.util.Date()) %>"/>
									</div>
								</div>
        		</td>
        	</tr>
        	<tr>
        		<td colspan="3" style="text-align: right;">
        			<button type="submit" class="button bg-main">提交</button>
								<button type="reset" class="button bg-red">重置</button>
        		</td>
        	</tr>
        </table>	
	
	</form>
	</div>
	
</div>
<script src="/DZOMS/res/js/DateTimeHelper.js"></script>
</body>
</html>