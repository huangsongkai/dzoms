<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="/struts-tags" prefix="s"%>
	<%@ page language="java"
	import="java.util.*,com.dz.module.user.User"
	pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <meta name="renderer" content="webkit">
    <title>合同明细</title>
    <link rel="stylesheet" href="/DZOMS/res/css/pintuer.css"/>
    <link rel="stylesheet" type="text/css" href="/DZOMS/res/css/jquery.datetimepicker.css"/>

    <script src="/DZOMS/res/js/jquery.js"></script>
    <script src="/DZOMS/res/js/pintuer.js"></script>
    <script src="/DZOMS/res/js/respond.js"></script>
    <script type="text/javascript" src="/DZOMS/res/js/JsonList.js" ></script>
    <link rel="stylesheet" href="/DZOMS/res/css/admin.css">
    <script type="text/javascript">
     function tablehide(){
            if($("#head").text()=="隐藏制定计划"){
                $("#head").text("显示制定计划");
            }
            else{
                $("#head").text("隐藏制定计划");
            }
            $(".hide").toggle();

        }
     
    $(document).ready(function(){
		$("input,textarea").attr("disabled",true);
		
		var l = '<s:property escape="false" value="%{contract.planList}"/>';
		l = $.parseJSON(l);
		for(var i=0;i<l.length;i++){
			var beginTime = l[i]["begin"];
			var endTime = l[i]["end"];
			var rentAmount = l[i]["money"];
			var comment = l[i]["comment"];
			
			var $option = $('<option></option>');
			$option.append($('<input name="beginTime" readonly="readonly" style="display:none;"/>').val(beginTime));
			
			$option.append(""+beginTime);
			
			$option.append("--");
			$option.append($('<input name="endTime" readonly="readonly" style="display:none;"/>').val(endTime));
			
			$option.append(""+endTime);
			
			$option.append("\t￥");
			$option.append($('<input name="rentAmount" style="display:none;"/>').val(rentAmount));
			
			$option.append(""+rentAmount);
			
			$option.append("\t");
			$option.append($('<input name="comment" style="display:none;"/>').val(comment));
			
			$option.append(""+comment);
			
			$("#rentList").append($option);
			
			geneRentPlanState=2;
		}
		
		var arr = $("#startdate").val().split("/");
          
            var startdate = {
            	"year":parseInt(arr[0]),
            	"month":parseInt(arr[1]),
            	"date":parseInt(arr[2])
            };
            
            arr = $("#enddate").val().split("/");
            var enddate = {
            	"year":parseInt(arr[0]),
            	"month":parseInt(arr[1]),
            	"date":parseInt(arr[2])
            };
            
            months = (enddate.year - startdate.year) * 12 + (enddate.month-startdate.month);
            
            //上月27-本月26 为一个月
            if(startdate.date<27) {
            	months++;
            	beginMonth.year = startdate.year;
            	beginMonth.month = startdate.month;
            }else{
            	if(startdate.month==12){
            		beginMonth.year = startdate.year+1;
            		beginMonth.month = 1;
            	}else{
            		beginMonth.year = startdate.year;
            		beginMonth.month = startdate.month+1;
            	}
            }
            
            if(enddate.date>=27){
            	months++;
            	if(enddate.month==12){
            		endMonth.year = enddate.year+1;
            		endMonth.month = 1;
            	}else{
            		endMonth.year = enddate.year;
            		endMonth.month = enddate.month+1;
            	}
            }else{
            	endMonth.year = enddate.year;
            	endMonth.month = enddate.month;
            }
            
            
            geneRentPlan();
		
	});
	
	var monthArr = [31,28,31,30,31,30,31,31,30,31,30,31];
		//月份从0开始
		function getDaysOfMonth(year,month){
			if(month==1&&(year%400==0||(year%100!=0&&year%4==0))){
				return monthArr[month]+1;
			}
			return monthArr[month];
		}
		
		var months;
		
		//此处月份从1开始
		var beginMonth={
			"year":0,
			"month":0
		},endMonth={
			"year":0,
			"month":0
		};
		
//计算 第month_rank月之前有几天
function calculateDays(rentDays,month_rank){
	var sum =0;
	for (var i = 0; i < month_rank; i++) {
		sum+=rentDays[i];
	}
	return sum;
}
        
var geneRentPlanState = 0;
function geneRentPlan(){
	//减免 天数
	var discountDays = $('[name="contract.discountDays"]').val();
	discountDays = parseInt(discountDays);
	
	var contract_start_date_arr = $("#startdate").val().split("/");
    var contract_start_date = {
        "year":parseInt(contract_start_date_arr[0]),
        "month":parseInt(contract_start_date_arr[1]),
        "date":parseInt(contract_start_date_arr[2])
    };
    
    //计算实际收费开始日期
    for (var i = 0; i < discountDays; i++) {
    	contract_start_date.date++;
    	if ( contract_start_date.date > 30) {
    		contract_start_date.date -= 30;
    		contract_start_date.month++;
    		
    		if ( contract_start_date.month > 12) {
    			contract_start_date.month -= 12;
    			contract_start_date.year++;
    		}
    	}
    }
	
    var rentArr = [];
    var rentDays = [];
	for(var i=0;i<months;i++) rentArr.push(0);
	for(var i=0;i<months;i++) rentDays.push(0);
	
//	var planListArr=[];
//	$("#rentList option").each(function(){
//		var begin = $(this).find("input[name='beginTime']").val();
//		var end = $(this).find("input[name='endTime']").val();
//		var money = $(this).find("input[name='rentAmount']").val();
//		var comment = $(this).find("input[name='comment']").val();
//		
//		planListArr.push({"begin":begin,"end":,"end":,"money":money,"comment":comment});
//	});
//	
//	$("input[name='planList']").val($.toJSON(planListArr));
	
	$("#rentList option").each(function(){
		var begin = $(this).find("input[name='beginTime']").val();
		var end = $(this).find("input[name='endTime']").val();
		var money = $(this).find("input[name='rentAmount']").val();
		
		var beginArr = begin.split("/");
		//var beginArr = [contract_start_date.year,contract_start_date.month,contract_start_date.date];
		var endArr = end.split("/");
		//这一段时间的起始月在数组中的位置
		var month_rank = (beginArr[0]-beginMonth.year)*12 + (beginArr[1]-beginMonth.month)+(beginArr[2]>26?1:0);
		var local_months = (endArr[0] - beginArr[0]) * 12 + (endArr[1] - beginArr[1])+(beginArr[2]<27?1:0)+(endArr[2]>26?1:0);
            
       	for (var i=1;i<local_months-1;i++) {
       		rentArr[month_rank+i]+=parseFloat(money)*1.00;
       		rentDays[month_rank+i]+=30;
       	}
       	
       	if(local_months==1){
       		//这一段时间在一个月里面
       		var days = 0;
       		if(beginArr[2]==27&&endArr[2]==26){
       			days=30;
       		}else
       		if(beginArr[2]>26){
       			if(endArr[2]>26){
       				days = endArr[2] - beginArr[2] + 1;
       			}else{
       				//days = getDaysOfMonth(beginArr[0],beginArr[1]-1)-beginArr[2]+1+parseInt(endArr[2]);
       				days = 31 - beginArr[2] + parseInt(endArr[2]) + (beginArr[2]>30?1:0);
       			}
       		}else{
       			days = endArr[2] - beginArr[2] + 1;
       		}
			var planOfRent = parseFloat(money) /30 * days;
			rentArr[month_rank] += planOfRent;
			rentDays[month_rank] += days;
       	}else{
       		//这一段时间分属不同的月
       		//第一个月
       		if(beginArr[2]==27){
       			days=30;
       		}else if(beginArr[2]>27){
       			//days = getDaysOfMonth(beginArr[0],beginArr[1]-1)-beginArr[2]+27;
       			days = 57 - beginArr[2] + (beginArr[2]>30?1:0);
       		}else{
       			days = 27 - beginArr[2];
       		}
			var planOfRent = parseFloat(money) /30 * days;
			rentArr[month_rank] += planOfRent;
			rentDays[month_rank] += days;
			
			//最后一个月
			if(endArr[2]==26){
       			days=30;
       		}else if(endArr[2]>=30){
       			days = 4;
       		}else if(endArr[2]>26){
       			days = endArr[2] - 26;
       		}else{
       			//days = parseInt(getDaysOfMonth(endArr[0],endArr[1]-1))+parseInt(endArr[2])-26;
       			days = 4 + parseInt(endArr[2]);
       		}
			planOfRent = parseFloat(money) /30 * days;
			rentArr[month_rank+local_months-1] += planOfRent;
			rentDays[month_rank+local_months-1] += days;
       	}
		
	});

	$("#rentList option").each(function(){
		var begin = $(this).find("input[name='beginTime']").val();
		var end = $(this).find("input[name='endTime']").val();
		var money = $(this).find("input[name='rentAmount']").val();
		
		var beginArr = begin.split("/");
		//var beginArr = [contract_start_date.year,contract_start_date.month,contract_start_date.date];
		var endArr = end.split("/");
		//这一段时间的起始月在数组中的位置
		var month_rank = (beginArr[0]-beginMonth.year)*12 + (beginArr[1]-beginMonth.month)+(beginArr[2]>26?1:0);
		var local_months = (endArr[0] - beginArr[0]) * 12 + (endArr[1] - beginArr[1])+(beginArr[2]<27?1:0)+(endArr[2]>26?1:0);
		
		for (var i = 0; i < local_months; i++) {
			var beforeDays = calculateDays(rentDays,month_rank+i);
			
			if (beforeDays>=discountDays) {
				break;
			}else{
				var leftDays = discountDays - beforeDays;
				if (leftDays>=rentDays[month_rank+i]) {
					rentArr[month_rank+i]=0;
				}else{
					var planOfRent = parseFloat(money) /30 * leftDays;
					rentArr[month_rank+i]-=planOfRent;
					break;
				}
			}
			
		}
		
	});
	
	$("#plan tr.data-tr").remove();
	
	var $plan = $("#plan");
	var rentArrIndex=0;
	if (beginMonth.year == endMonth.year) {
		var $tr = $('<tr class="hide data-tr"></tr>').append($("<td />").text(beginMonth.year+"年"));
		for (var month = 1;month<beginMonth.month;month++) {
			var $td = $("<td />").text("  ").appendTo($tr);
		}
		for (var month = beginMonth.month;month<=endMonth.month;month++) {
			var $td = $("<td />").appendTo($tr);
			var $input = $('<input class="data-td input auto" size="10" />').val(rentArr[rentArrIndex++].toFixed(2)).appendTo($td);
		}
		for (var month = endMonth.month;month<12;month++) {
			var $td = $("<td />").text("  ").appendTo($tr);
		}
		$plan.append($tr);
	} 
	else{
		//首年
		var $tr = $('<tr class="hide data-tr"></tr>').append($("<td />").text(beginMonth.year+"年"));
		for (var month = 1;month<beginMonth.month;month++) {
			var $td = $("<td />").text("  ").appendTo($tr);
		}
		for (var month = beginMonth.month;month<=12;month++) {
			var $td = $("<td />").appendTo($tr);
			var $input = $('<input class="data-td input auto" size="10" />').val(rentArr[rentArrIndex++].toFixed(2)).appendTo($td);
		}
		$plan.append($tr);
		
		//第二年 -- 倒数第二年
		for (var year = beginMonth.year+1;year<endMonth.year;year++) {
			$tr = $('<tr class="hide data-tr"></tr>').append($("<td />").text(year+"年"));
			for (var month = 1;month<=12;month++) {
				var $td = $("<td />").appendTo($tr);
				var $input = $('<input class="data-td input auto" size="10" />').val(rentArr[rentArrIndex++].toFixed(2)).appendTo($td);
			}
			$plan.append($tr);
		}
		
		//最后一年
		$tr = $('<tr class="hide data-tr"></tr>').append($("<td />").text(endMonth.year+"年"));
		for (var month = 1;month<=endMonth.month;month++) {
			var $td = $("<td />").appendTo($tr);
			var $input = $('<input class="data-td input auto " size="10" />').val(rentArr[rentArrIndex++].toFixed(2)).appendTo($td);
		}
		for (var month = endMonth.month;month<12;month++) {
			var $td = $("<td />").text("  ").appendTo($tr);
		}
		$plan.append($tr);
	}
	
	geneRentPlanState = 1;
}		
    	
    </script>
    <style>
        .label{
            width: 120px;
            text-align: right;
        }
    </style>
</head>
<body>
<div class="adminmin-bread">
    <ul class="bread">
        <li><a href="" class="icon-home"> 开始</a></li>
        <li>合同</li>
        <li>合同明细</li>
    </ul>
</div>
<div class="padding">
    <form method="post" action="/DZOMS/contract/contractWrite" class="form-inline" style="width: 100%">
        <s:hidden name="contract.id"></s:hidden>

        <blockquote class="border-main">
            <strong>承租人信息</strong>

            <div class="line">
                <div class="xm2 padding">
                    <img src="/DZOMS/data/driver/<s:property value="driver.idNum"/>/photo.jpg" class="radius img-responsive">
                </div>
                <div class="xm10">
                    <div class="form-group">
                        <div class="label padding">
                            <label>
                                车架号
                            </label>
                        </div>
                        <div class="field" >
                            <s:textfield name="contract.carframeNum" />
                        </div>
                    </div>

                    <br>


                    <div class="form-group">
                        <div class="label padding">
                            <label>
                                车牌号
                            </label>
                        </div>
                        <div class="field" >
                            <s:textfield cssClass="input" name="contract.carNum"></s:textfield>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="label padding">
                            <label>
                                档案号
                            </label>
                        </div>
                        <div class="field" >
                            <s:textfield cssClass="input"  name="contract.contractId"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="label padding">
                            <label>
                                经营形式
                            </label>
                        </div>
                        <div class="field" >
                            <s:textfield name="vehicle.businessForm" cssClass="input"/>
                        </div>
                    </div>

                    <br>

                    <div class="form-group">
                        <div class="label padding">
                            <label>
                                合同种类
                            </label>
                        </div>
                        <div class="field" >
                            <s:textfield cssClass="input" id="contract_businessForm" name="contract.businessForm" />
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="label padding">
                            <label>
                                营运手续归属
                            </label>
                        </div>
                        <div class="field" >
                            <s:textfield  cssClass="input" value="%{contract.ascription?'个人':'公司'}"/>
                            <s:hidden name="contract.ascription"></s:hidden>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="label padding">
                            <label>
                                违约金
                            </label>
                        </div>
                        <div class="field" >
                            <s:textfield cssClass="input" name="contract.penalty" />
                        </div>
                    </div>

                    <br>
<s:hidden name="contract.discountDays"></s:hidden>

                    <div class="form-group">
                        <div class="label padding">
                            <label>
                                一次性预付租金
                            </label>
                        </div>
                        <div class="field" >
                            <s:textfield cssClass="input" name="contract.rentFirst" />
                        </div>
                    </div>
                    <!--<div class="form-group">
                        <div class="label padding">
                            <label>
                                月租金
                            </label>
                        </div>
                        <div class="field" >
                            <s:textfield cssClass="input" name="contract.rent" />
                        </div>
                    </div>-->
                    <div class="form-group">
                        <div class="label padding">
                            <label>
                                定金
                            </label>
                        </div>
                        <div class="field" >
                            <s:textfield cssClass="input" name="contract.deposit" />
                        </div>
                    </div>

                    <br>

                    <div class="form-group">
                        <div class="label padding">
                            <label>
                                服务保证金
                            </label>
                        </div>
                        <div class="field" >
                            <s:textfield cssClass="input" name="contract.feeAlter"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="label padding">
                            <label>
                                起始日期
                            </label>
                        </div>
                        <div class="field" >
                            <s:textfield cssClass="input datepick"  id="startdate" onBlur="set_date()" name="contract.contractBeginDate" />
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="label padding">
                            <label>
                                终止日期
                            </label>
                        </div>
                        <div class="field" >
                            <s:textfield cssClass="input datepick" id="enddate" onchange="dateRefresh()" name="contract.contractEndDate" />
                        </div>
                    </div>

<div  style="width: 100%">
           				<div class="float-left" style="width: 120px; text-align: right;">
           							 	<strong>租金计划</strong>
           				</div>
            			<div class="float-left">
                			<select  id="rentList" size="5" style="width: 400px;"  class="float-left">
                				
                			</select>
                		</div>
            	
        							
		                      <div class="form-group margin-small" style="display: none;">
                                   <div>
                                   		<a id="add_rent_but"  class="button dialogs  float-left" data-toggle="click" data-target="#mydialog" data-mask="1" data-width="50%">添加</a>
                                       <a class="button input-file " href="javascript:void(0);" onclick="delRentPlan()">删除</a> 
                                   </div>
                                    <div>
                                        
                                     </div>
                                    <div style="display: none;">
                                       <a class="button input-file " href="javascript:void(0);" onclick="geneRentPlan()">生成租金计划</a>
                                    </div>
                              </div>
                    </div>
                    <br>

                    <div class="form-group">
                        <div class="label padding">
                            <label>
                                分公司归属
                            </label>
                        </div>
                        <div class="field" >
                            <s:textfield name="contract.branchFirm" cssClass="input"/>
                        </div>
                    </div>

                    <br>

                    <div class="form-group">
                        <div class="label padding">
                            <label>
                                身份证号
                            </label>
                        </div>
                        <div class="field" >
                            <s:textfield cssClass="input"  name="driver.idNum" />
                            <s:hidden name="contract.idNum" />
                        </div>
                    </div>

                    <br>

                    <div class="form-group">
                        <div class="label padding">
                            <label>
                                承包人
                            </label>
                        </div>
                        <div class="field" >
                            <s:textfield cssClass="input"  name="driver.name" />
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="label padding">
                            <label>
                                性别
                            </label>
                        </div>
                        <div class="field" >
                            <s:select cssClass="input"  name="driver.sex"
                                      list="@com.dz.common.other.JsonListReader@getList('driver/driver.json','driver.sex')"></s:select>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="label padding">
                            <label>
                                电话号码
                            </label>
                        </div>
                        <div class="field" >
                            <s:textfield cssClass="input"  name="driver.phoneNum1" />
                        </div>
                    </div>

                    <br>

                    <div class="form-group">
                        <div class="label padding">
                            <label>
                                驾驶证号
                            </label>
                        </div>
                        <div class="field" >
                            <s:textfield cssClass="input"  name="driver.drivingLicenseNum" />
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="label padding">
                            <label>
                                资格证号
                            </label>
                        </div>
                        <div class="field" >
                            <s:textfield cssClass="input"  name="driver.qualificationNum" />
                        </div>
                    </div>

                    <br>

                    <div class="form-group">
                        <div class="label padding">
                            <label>
                                证件地址
                            </label>
                        </div>
                        <div class="field" >
                            <s:textfield cssClass="input input-auto" size="40" name="driver.accountLocation" />
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="label padding">
                            <label>
                                归属区域
                            </label>
                        </div>
                        <div class="field" >
                            <s:textfield cssClass="input input-auto" size="40"  name="driver.accountLocation" />
                        </div>
                    </div>

                    <br>

                    <div class="form-group">
                        <div class="label padding">
                            <label>
                                现居住地
                            </label>
                        </div>
                        <div class="field" >
                            <s:textfield cssClass="input input-auto" size="40"  name="driver.address" />
                        </div>
                    </div>

                    <br>

                    <div class="form-group">
                        <div class="label padding">
                            <label>
                                备注
                            </label>
                        </div>
                        <div class="field">
                            <s:textarea id="licenseNum" name="vehicle.licenseNum" class="input" disabled="disabled"></s:textarea>
                        </div>
                    </div>
                </div>
            </div>
            </div>
        </blockquote>
        <br>
        <blockquote class="border-main">
            <strong>承担人信息</strong>
            <div class="line">
                <div class="xm2 padding">
                    <img src="/DZOMS/data/driver/<s:property value="driver.idNum"/>/guarantor_photo.jpg" class="radius img-responsive">
                </div>
                <div class="xm10">
                    <div class="form-group">
                        <div class="label padding">
                            <label>
                                身份证号
                            </label>
                        </div>
                        <div class="field" >
                            <s:textfield cssClass="input" name="contract.identityGuarantor"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="label padding">
                            <label>
                                担保人
                            </label>
                        </div>
                        <div class="field" >
                            <s:textfield cssClass="input" name="contract.guarantorName" />
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="label padding">
                            <label>
                                电话号码
                            </label>
                        </div>
                        <div class="field" >
                            <s:textfield cssClass="input" name="contract.phoneNumGuarantor" />
                        </div>
                    </div>

                    <br>

                    <div class="form-group">
                        <div class="label padding">
                            <label>
                                证件地址
                            </label>
                        </div>
                        <div class="field" >
                            <s:textfield cssClass="input input-auto" size="40" name="contract.addressLicenseGuarantor" />
                        </div>
                    </div>

                    <br>

                    <div class="form-group">
                        <div class="label padding">
                            <label>
                                现居地址
                            </label>
                        </div>
                        <div class="field">
                            <s:textfield cssClass="input input-auto" name="contract.addressCurrentGuarantor"  size="40"/>
                        </div>
                    </div>

                </div>
            </div>
        </blockquote>
        <br>
    </form>
<div class="line" style="overflow: auto;">
	<table class="table table-bordered table-hover m10" id="plan">
<tr></th><th colspan=14 onclick='tablehide()'><h4  id='head'><p>隐藏制定计划</p></h4></th></tr>
<tr class='hide'><th></th><th>1月</th><th>2月</th><th>3月</th><th>4月</th><th>5月</th><th>6月</th><th>7月</th><th>8月</th><th>9月</th><th>10月</th><th>11月</th><th>12月</th></tr>
</table>
</div>   
</div>

</body>
<script src="/DZOMS/res/js/jquery.datetimepicker.js"></script>
<script type="text/javascript" src="/DZOMS/res/js/DateTimeHelper.js" ></script>
</html>