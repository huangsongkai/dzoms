<%@taglib uri="/struts-tags" prefix="s"%>
<%@ page language="java" import="java.util.*,com.dz.module.vehicle.*,com.dz.module.user.User" pageEncoding="UTF-8"%><!DOCTYPE html>
<%@page import="org.springframework.web.context.support.*"%>
<%@page import="org.springframework.context.*" %>
<%@page import="org.apache.commons.collections.*" %>
<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport"
	content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
	<meta name="renderer" content="webkit">
	<title>新增营运信息</title>
	<link rel="stylesheet" href="/DZOMS/res/css/pintuer.css">
	<link rel="stylesheet" href="/DZOMS/res/css/admin.css">
	<script src="/DZOMS/res/js/jquery.js"></script>
	<script src="/DZOMS/res/js/pintuer.js"></script>
	<script src="/DZOMS/res/js/respond.js"></script>
	<script src="/DZOMS/res/js/admin.js"></script>
<link rel="stylesheet" href="/DZOMS/res/css/jquery.datetimepicker.css" />
<script src="/DZOMS/res/js/jquery.datetimepicker.js"></script>
<jsp:include page="/common/msg_info.jsp"></jsp:include>
<script>
	function getCarframeNum(){
  					var lno = $('#lincenseNum').find("option:selected").text();
  					//alert(lno);
  					var cno = lincense2frame[lno];
  					
  					$('#carframeNum').find("option").removeAttr("selected");
  					$('#carframeNum').find("option").each(function(){
  						if($(this).text().trim()==cno){
  							$(this).attr("selected","selected");
  						}
  					});
  					
  				}
  				
  				function getLicense(){
  					var cno = $('#carframeNum').find("option:selected").text().trim();
  					var lno = frame2lincense[cno];

					$('#lincenseNum').find("option").removeAttr("selected");
  					$('#lincenseNum').find("option").each(function(){
  						if($(this).text().trim()==lno){
  							$(this).attr("selected","selected");
  						}
  					});
  				}
  				
	<%! List<String> vmstr; %>
				<%  
					ApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(getServletContext());    
  					VehicleService vms = ctx.getBean(VehicleService.class);
  					
  					List<Vehicle> vml = vms.selectAll();
  						
  					vml = (List<Vehicle>) CollectionUtils.select(vml,new Predicate(){
  						@Override
  						public boolean evaluate(Object o){
  							Vehicle v = (Vehicle) o;
  							if(v.getOperateCard()==null||v.getOperateCard().isEmpty()){
  								return true;
  							}
  							return false;
  						}
  					});
  					
					vmstr = (List<String>)CollectionUtils.collect(vml, new Transformer(){
  						@Override
  						public Object transform(Object obj) {
               				Vehicle vm = (Vehicle) obj;
                			return vm.getCarframeNum();
           				}
  					});
  					
  					List<String> vlicense = (List<String>)CollectionUtils.collect(vml, new Transformer(){
  						@Override
  						public Object transform(Object obj) {
               				Vehicle vm = (Vehicle) obj;
                			return vm.getLicenseNum();
           				}
  					});
  					
  					vmstr.add(0, "");
  					vlicense.add(0, "");
  					
  					request.setAttribute("vmstr",vmstr);
  					request.setAttribute("vlicense",vlicense);
  					
  					
  					String outstr="var frame2lincense={";
  					for(Vehicle v:vml){
  						outstr+="\""+v.getCarframeNum()+"\":\""+v.getLicenseNum()+"\",";
  					}
  					outstr=outstr.substring(0,outstr.length()-1)+"};";
  					
  					out.println(outstr);
  					
  					outstr="var lincense2frame={";
  					for(Vehicle v:vml){
  						outstr+="\""+v.getLicenseNum()+"\":\""+v.getCarframeNum()+"\",";
  					}
  					outstr=outstr.substring(0,outstr.length()-1)+"};";
  					
  					out.println(outstr);
  				%>
  				
  				
</script>
	<style>
        .label{
        	width: 200px;
            text-align:right;
        }
    </style>
	</head>
	<body>
	<div class="adminmin-bread" style="width: 100%;">
		<ul class="bread text-main" style="font-size: larger;">
               
                <li>车辆管理</li>
                <li>新增</li>
                <li>新增营运信息</li>
        </ul>
</div>
	
<div>
<form class="form-x" method="post" action="/DZOMS/vehicle/service_right_add">
		<div class="alert alert-yellow padding">
		<span class="close rotate-hover"></span><strong>注意：</strong>录入计价器信息前需要录入牌照信息。</div>
	<div class="panel xm10 xm1-move">
		<div class="panel-head">
			新增营运证信息
		</div>
		<div class="panel-body">

<input type="hidden" name="url" value="/vehicle/vehicle/service_right_add.jsp" />
   
        <table class="table table-condensed">
            <tr>
                <td>
                    <div class="form-group">
                        <div class="label padding">
                            <label>
                                车架号
                            </label>
                        </div>
                        <div class="field">
			<s:select cssClass="input" theme="simple" id="carframeNum" name="vehicle.carframeNum" list="#request.vmstr" onchange="getLicense()"></s:select>
                        </div>

                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <div class="form-group">
                        <div class="label padding">
                            <label>
                                车牌号
                            </label>
                        </div>
                        <div class="field">
						
			<s:select cssClass="input" theme="simple" id="lincenseNum" name="vehicle.lincenseNum" list="#request.vlicense" onchange="getCarframeNum()"></s:select>
                        </div>
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <div class="form-group">
                        <div class="label padding">
                            <label>
                                营运证号
                            </label>
                        </div>
                        <div class="field">
                            <input class="input" name="vehicle.operateCard" data-validate="required:必填"/>
                        </div>
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <div class="form-group">
                        <div class="label padding">
                            <label>
                                营运证发放日期
                            </label>
                        </div>
                        <div class="field">
                            <input class="input datepick"  name="vehicle.operateCardTime" data-validate="required:必填"/>
                        </div>
                    </div>
                </td>
            </tr>
            <!--
            <tr>
                <td>
                    <div class="form-group">
                        <div class="label padding">
                            <label>
                                经营权证号
                            </label>
                        </div>
                        <div class="field">
                            <input class="input" name="vehicle.businessLicenseNum" data-validate="required:必填"/>
                        </div>
                    </div>
                </td>
            </tr>-->
            <tr>
                <td>
                    <div class="form-group">
                        <div class="label padding">
                            <label>
                                登记人
                            </label>
                        </div>
                        <div class="field">
                            <input class="input" readonly="readonly" value="<%=((User)session.getAttribute("user")).getUname()%>" />
					<input type="hidden" name="vehicle.serviceRightRegister" value="<%=((User)session.getAttribute("user")).getUid()%>"/>
                        </div>
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <div class="form-group">
                        <div class="label padding">
                            <label>
                                登记时间
                            </label>
                        </div>
                        <div class="field">
                            <input class="input" readonly="readonly" name="vehicle.serviceRightRegistDate" 
						value="<%=(new  java.text.SimpleDateFormat("yyyy/MM/dd")).format(new java.util.Date()) %>"/>
                        </div>
                    </div>
                </td>
            </tr>
            <tr>
				<td class="tableleft"></td>
				<td colspan="3" style="text-align:right;">
					<input type="submit" class="button bg-main" value="提交">
					<input type="button" class="button" name="backid"
							id="backid" onclick="location.href='#'" value="取消">
				</td>
			</tr>
			</table>
	
	
		

		</div>
	</div>
</form>
		</div>	
	<script type="text/javascript" src="/DZOMS/res/js/DateTimeHelper.js" ></script>
	<script>
$('[name="vehicle.twiceSupplyDate"]').datetimepicker({
	lang:"ch",           //语言选择中文
	format:"Y/m/d",      //格式化日期
	timepicker:false,    //关闭时间选项
	yearStart:2000,     //设置最小年份
	yearEnd:2050,        //设置最大年份
	//todayButton:false    //关闭选择今天按钮
	onClose:function(){
		var arr = $('[name="vehicle.twiceSupplyDate"]').val().split("/");
		arr[0] = parseInt(arr[0])+1;
		$('[name="vehicle.nextSupplyDate"]').val(""+arr[0]+"/"+arr[1]+"/"+arr[2]);
	}
});

$('[name="vehicle.moneyCountorTime"]').datetimepicker({
	lang:"ch",           //语言选择中文
	format:"Y/m/d",      //格式化日期
	timepicker:false,    //关闭时间选项
	yearStart:2000,     //设置最小年份
	yearEnd:2050,        //设置最大年份
	//todayButton:false    //关闭选择今天按钮
	onClose:function(){
		var arr = $('[name="vehicle.moneyCountorTime"]').val().split("/");
		arr[0] = parseInt(arr[0])+1;
		$('[name="vehicle.moneyCountorNextDate"]').val(""+arr[0]+"/"+arr[1]+"/"+arr[2]);
	}
});
	</script>
	</body>
</html>

