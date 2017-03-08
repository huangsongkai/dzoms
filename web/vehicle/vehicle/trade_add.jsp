<%@taglib uri="/struts-tags" prefix="s"%>
<%@ page language="java" import="java.util.*,com.dz.module.vehicle.*,com.dz.module.user.User" pageEncoding="UTF-8"%>
<%@page import="org.springframework.web.context.support.*"%>
<%@page import="org.springframework.context.*" %>
<%@page import="org.apache.commons.collections.*" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE html>
<html>
<head lang="en">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <meta name="renderer" content="webkit">
    <link rel="stylesheet" href="/DZOMS/res/css/pintuer.css">
    <link rel="stylesheet" href="/DZOMS/res/css/admin.css">
    <link rel="stylesheet" type="text/css" href="/DZOMS/res/css/jquery.datetimepicker.css"/>
    
    <script src="/DZOMS/res/js/jquery.js"></script>
    <script src="/DZOMS/res/js/pintuer.js"></script>
    <script src="/DZOMS/res/js/respond.js"></script>
    <script src="/DZOMS/res/js/admin.js"></script>
    <script type="text/javascript" src="/DZOMS/res/js/jquery.datetimepicker.js" ></script>
    <jsp:include page="/common/msg_info.jsp"></jsp:include>
	<script>
	
	
	function getCarframeNum(){
  		var lno = $('#lincenseNum').val().trim();
  					//alert(lno);
  		var cno = lincense2frame[lno];
  					
  		$('#carframeNum').val(cno);
  		
  		var blno = frame2businessLicenseNum[cno];
  		if(blno!="null")
  		$('input[name="vehicle.businessLicenseNum"]').val(blno);
  	}
  				
  	function getLicense(){
  		var cno = $('#carframeNum').val().trim();
  		var lno = frame2lincense[cno];

		$('#lincenseNum').val(lno);
  		
  		var blno = frame2businessLicenseNum[cno];
  		if(blno!="null")
  		$('input[name="vehicle.businessLicenseNum"]').val(blno);
  	}
  				
				<%ApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(getServletContext());    
  					VehicleService vms = ctx.getBean(VehicleService.class);
  					
  					List<Vehicle> vml = vms.selectAll();
  						
  					vml = (List<Vehicle>) CollectionUtils.select(vml,new Predicate(){
  						@Override
  						public boolean evaluate(Object o){
  							Vehicle v = (Vehicle) o;
  							if(v.getBusinessLicenseId()==null){
  								return true;
  							}
  							return false;
  						}
  					});
  					
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
  					
  					outstr="var frame2businessLicenseNum={";
  					for(Vehicle v:vml){
  						outstr+="\""+v.getCarframeNum()+"\":\""+v.getBusinessLicenseId()+"\",";
  					}
  					outstr=outstr.substring(0,outstr.length()-1)+"};";
  					
  					out.println(outstr);%>
  				
  				
</script>

<link rel="stylesheet" href="/DZOMS/res/css/jquery.bigautocomplete.css" />
<script type="text/javascript" src="/DZOMS/res/js/jquery.bigautocomplete.js" ></script>
<script>
	$(document).ready(function(){
		$("#carframeNum").bigAutocomplete({
			url:"/DZOMS/select/VehicleBycarframeNum",
			condition:"businessLicenseId is null",
			callback:function(){
				getLicense();
			}
		});
	});
	$(document).ready(function(){
		$("#lincenseNum").bigAutocomplete({
			url:"/DZOMS/select/VehicleBylicenseNum",
			condition:"businessLicenseId is null",
			callback:function(){
				getCarframeNum();
			}
		});
	});
</script>
</head>
<style>
	td{
		width: 300px;
	}
</style>
<body>
<div class="adminmin-bread" style="width: 100%;">
		<ul class="bread text-main" style="font-size: larger;">
               
                <li>车辆管理</li>
                <li>新增</li>
                <li>新增经营权证信息</li>
        </ul>
</div>
	<div class="alert alert-yellow padding">
		<span class="close rotate-hover"></span><strong>注意：</strong>录入计价器信息前需要录入牌照信息。</div>
<div class="panel xm10 xm1-move">
	<div class="panel-head">
		新增经营权证信息
	</div>
	<div class="panel-body">
		<form class="form-x"  action="/DZOMS/vehicle/trade_add">
	<input type="hidden" name="url" value="/vehicle/vehicle/trade_add.jsp" />
   
        <table class="table table-condensed">
            <tr>
                <td>
                    <div class="form-group">
                        <div class="label padding">
                            <label>
                                车牌号
                            </label>
                        </div>
                        <div class="field" style="width: auto;">
                           <s:textfield  cssClass="input"  value="黑A"  theme="simple" id="lincenseNum" name="vehicle.lincenseNum" data-validate="required:必填"></s:textfield>
                        </div>
                    </div>
                </td>
                <td>
                    <div class="form-group">
                        <div class="label padding">
                            <label>
                                车架号
                            </label>
                        </div>
                        <div class="field" style="width: auto;">
                            <s:textfield cssClass="input" theme="simple" id="carframeNum" name="vehicle.carframeNum" data-validate="required:必填"></s:textfield>
                        </div>
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <div class="form-group">
                        <div class="label padding" style="width: 40%;">
                            <label>
                                经营权证号
                            </label>
                        </div>
                        <div class="field" style="width: 60%;">
                            <input class="input" name="businessLicense.licenseNum" data-validate="required:必填">
                        </div>
                    </div>
                </td>
                <td>
                    <div class="form-group">
                        <div class="label padding">
                            <label>
                                起始日期
                            </label>
                        </div>
                        <div class="field" style="width: auto;">
                            <input class="input" name="businessLicense.beginDate" data-validate="required:必填">
                        </div>
                    </div>
                </td>
                <td>
                    <div class="form-group">
                        <div class="label padding">
                            <label>
                                终止日期
                            </label>
                        </div>
                        <div class="field" style="width: auto;">
                            <input class="input datepick" name="businessLicense.endDate" data-validate="required:必填">
                        </div>
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <div class="form-group">
                        <div class="label padding" style="width: 12%">
                            <label>
                                备注
                            </label>
                        </div>
                        <div class="field">
                        <textarea  class="input" rows="5" name="vehicle.businessLicenseComment"></textarea>
                        </div>
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <div class="form-group">
                        <div class="label padding" >
                            <label>
                                登记人
                            </label>
                        </div>
                        <div class="field">
                        <input class="input" readonly="readonly" value="<%=((User)session.getAttribute("user")).getUname()%>" />
						<input type="hidden" name="businessLicense.register" value="<%=((User)session.getAttribute("user")).getUid()%>"/>
                        </div>
                    </div>
                </td>
                <td>
                    <div class="form-group">
                        <div class="label padding" >
                            <label>
                                登记时间
                            </label>
                        </div>
                        <div class="field">
                            <input class="input" readonly="readonly" name="businessLicense.registDate" 
						value="<%=(new  java.text.SimpleDateFormat("yyyy/MM/dd")).format(new java.util.Date()) %>"/>
                        </div>
                    </div>
                </td>
            </tr>
            <tr>
            	<td></td>
            	<td>
            		<input type="submit" class="button bg-green" value="提交"/>
            		<input type="button"  class="button" value="取消"/>
            	</td>
            </tr>
        </table>
    
</form>
	</div>
	
</div>

	<script type="text/javascript" src="/DZOMS/res/js/DateTimeHelper.js" ></script>
<script>
$('[name="businessLicense.beginDate"]').datetimepicker({
	lang:"ch",           //语言选择中文
	format:"Y/m/d",      //格式化日期
	timepicker:false,    //关闭时间选项
	yearStart:2000,     //设置最小年份
	yearEnd:2050,        //设置最大年份
	//todayButton:false    //关闭选择今天按钮
	onClose:function(){
		var arr = $('[name="businessLicense.beginDate"]').val().split("/");
		arr[0] = parseInt(arr[0])+8;
		$('[name="businessLicense.endDate"]').val(""+arr[0]+"/"+arr[1]+"/"+arr[2]);
	}
});
</script>
</body>
</html>