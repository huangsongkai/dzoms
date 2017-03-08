<%@taglib uri="/struts-tags" prefix="s"%>
<%@ page language="java" import="java.util.*,com.dz.module.vehicle.*,com.dz.module.user.User" pageEncoding="UTF-8"%><!DOCTYPE html>
<%@page import="org.springframework.web.context.support.*"%>
<%@page import="org.springframework.context.*" %>
<%@page import="org.apache.commons.collections.*" %>

<html>
<head lang="en">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
    <meta name="renderer" content="webkit">
    <title>
        新增牌照
    </title>
    <link rel="stylesheet" href="/DZOMS/res/css/pintuer.css">
    <link rel="stylesheet" href="/DZOMS/res/css/admin.css">
    <link rel="stylesheet" type="text/css" href="/DZOMS/res/css/jquery.datetimepicker.css"/>
    
    
    <script src="/DZOMS/res/js/jquery.js"></script>
    <script src="/DZOMS/res/js/pintuer.js"></script>
    <script src="/DZOMS/res/js/respond.js"></script>
    <script src="/DZOMS/res/js/admin.js"></script>
    <script type="text/javascript" src="/DZOMS/res/js/jquery.datetimepicker.js" ></script>
    <script src="/DZOMS/res/js/fileUpload.js"></script>
    <style>
        .label{
            text-align: right;
        }
    </style>

    <style type="text/css">
        #preview{width:400px;height:250px;border:1px solid #000;overflow:hidden;}
        #imghead {filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod=image);}
    </style>
    <script type="text/javascript">
        function previewImage()
        {
            loadTempPicture($('[name="photo"]'),$('#imghead'));
        }
       
        function deleimage(){
        	$("input[name='photo']").val("");
            $("#imghead").attr("src","");
        }
        
        $(document).ready(function(){
        	$('input[name="vehicle.isNewLicense"]').click(function(){
        		var val = $(this).val();
        		if(val=='true'){
        			$("#licenseTypeLabel").text("拍卖号");
        		}else{
        			$("#licenseTypeLabel").text("原车牌号");
        		}
        	});
        });
    </script>
    
<link rel="stylesheet" href="/DZOMS/res/css/jquery.bigautocomplete.css" />
<script type="text/javascript" src="/DZOMS/res/js/jquery.bigautocomplete.js" ></script>
<jsp:include page="/common/msg_info.jsp"></jsp:include>
<script>
	$(document).ready(function(){
		$("#carframe_num").bigAutocomplete({
			url:"/DZOMS/select/VehicleBycarframeNum",
			condition:"licenseRegNum is null"
		});
	});
</script>
</head>
<body>
<div class="adminmin-bread" style="width: 100%;">
		<ul class="bread text-main" style="font-size: larger;">
               
                <li>车辆管理</li>
                <li>新增</li>
                <li>新增牌照信息</li>
        </ul>
</div>
	<div class="alert alert-yellow padding">
		<span class="close rotate-hover"></span><strong>注意：</strong>录入牌照信息前需要录入保险信息。
	</div>
<div class="panel xm10 xm1-move">
	
	<div class="panel-head">
		新增牌照信息
	</div>
	<div class="panel-body">
		<form class="form-x" method="post" action="/DZOMS/vehicle/licence_add">
	<input type="hidden" name="url" value="/vehicle/vehicle/licence_add.jsp" />
      <table class="table">
          <tr>
              <td>
                  <div class="form-group">
                      <div class="label padding">
                          <label>
                              车架号
                          </label>
                      </div>
                      <div class="field">
                      	<%! List<String> vmstr; %>
				<%  
					ApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(getServletContext());    
  					VehicleService vms = ctx.getBean(VehicleService.class);
  					
  					List<Vehicle> vml = vms.selectAll();
  						
  					vml = (List<Vehicle>) CollectionUtils.select(vml,new Predicate(){
  						@Override
  						public boolean evaluate(Object o){
  							Vehicle v = (Vehicle) o;
  							if(v.getLicenseRegNum()==null||v.getLicenseRegNum().isEmpty()){
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
  					
  					vmstr.add(0, "");
  					
  					request.setAttribute("vmstr",vmstr);
  					System.out.println(vmstr);
  				%>
                          <s:textfield cssClass="input" id="carframe_num" theme="simple" name="vehicle.carframeNum" list="#request.vmstr" data-validate="required:必填" ></s:textfield>
                      </div>
                  </div>
              </td>
              <td>
                  <strong>车体照片</strong>
              </td>
              <td rowspan="9">
                  <div id="preview">
                      <img id="imghead" src="/DZOMS/data/vehicle/<s:property value="vehicle.carframeNum"/>/photo.jpg" width="400" height="250" />
                  </div>
                  <div class="line">
                  	<div class="xm3 padding" id="vehicleimage">
                      <a class="button input-file addbtn1" href="javascript:void(0);">
                          + 上传
                          <input class="dz-file" name="photo" data-target=".addbtn1" sessuss-function="previewImage();">
                      </a>
                  </div>
                  <div class="xm1 padding">
                      <input type="button" class="button" onclick="deleimage()" value="清除">
                  </div>
                  </div>
                  
                  
              </td>
          </tr>
          <tr>
              <td>
                  <div class="form-group">
                      <div class="label padding" style="width: 40%;">
                          <label>
                              登记证书号
                          </label>
                      </div>
                      <div class="field" style="width: 60%;">
                          <input class="input" name="vehicle.licenseRegNum" data-validate="required:必填">
                      </div>
                  </div>
              </td>
          </tr>
          <tr>
              <td>
                  <div class="form-group">
                      <div class="label padding" style="width: 40%;">
                          <label>
                              行驶证注册日期
                          </label>
                      </div>
                      <div class="field" style="width: 60%;">
                          <input class="input datepick" name="vehicle.licenseNumRegDate" data-validate="required:必填">
                      </div>
                  </div>
              </td>
          </tr>
          <tr>
              <td style="text-align: center">
                  <s:radio name="vehicle.isNewLicense" list="#{'true':'拍卖','false':'更新'}" value="false"/>
                  
              </td>
          </tr>
          <tr>
              <td>
                  <div class="form-group">
                      <div class="label padding">
                          <label id="licenseTypeLabel">
                              原车牌号
                          </label>
                      </div>
                      <div class="field">
                          <input class="input" name="vehicle.licensePurseNum" data-validate="required:必填">
                      </div>
                  </div>
              </td>
          </tr>
          <!--<tr>
              <td> 
                  <div class="form-group">
                      <div class="label padding">
                          <label>
                              旧车牌号
                          </label>
                      </div>
                      <div class="field">
                          <input class="input" name="vehicle.">
                      </div>
                  </div>
              </td>
          </tr>-->
          <tr>
              <td>
                  <div class="form-group">
                      <div class="label padding">
                          <label>
                              新车牌号
                          </label>
                      </div>
                      <div class="field">
                          <input class="input" name="vehicle.licenseNum" value="黑A" data-validate="required:必填">
                      </div>
                  </div>
              </td>
          </tr>
          <!--<tr>
              <td style="text-align: center">
                  <input type="radio" name="dy">抵押
                  <input type="radio" name="dy">不抵押
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
					<input type="hidden" name="vehicle.licenseRegister" value="<%=((User)session.getAttribute("user")).getUid()%>"/>
                      </div>
                  </div>
              </td>
          </tr>
          <tr>
              <td> <div class="form-group">
                  <div class="label padding">
                      <label>
                          登记时间
                      </label>
                  </div>
                  <div class="field">
                       <input class="input" readonly="readonly" name="vehicle.licenseRegistTime" 
						value="<%=(new  java.text.SimpleDateFormat("yyyy/MM/dd")).format(new java.util.Date()) %>"/>
                  </div>
              </div>

              </td>
          </tr>
            <tr>
				<td class="tableleft"></td>
				<td colspan="2">
					<input type="submit" class="button bg-main" value="提交">
					<input type="button" name="backid" class="button"
							id="backid" onclick="location.href='#'" value="取消">
				</td>
			</tr>
      </table>
</form>
	</div>
</div>

<div>
	<script type="text/javascript" src="/DZOMS/res/js/DateTimeHelper.js" ></script>

</div>


</body>
</html>
