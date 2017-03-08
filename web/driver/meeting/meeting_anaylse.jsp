<%@taglib uri="/struts-tags" prefix="s" %>
<%@ page language="java" import="java.util.*,com.dz.module.vehicle.*,com.dz.module.user.User,com.dz.module.driver.meeting.*,org.javatuples.Triplet" pageEncoding="UTF-8" %>
<%@page import="org.springframework.web.context.support.*" %>
<%@page import="org.springframework.context.*" %>
<%@page import="org.apache.commons.collections.*" %>
<% String path=request.getContextPath(); 
	String basePath=request.getScheme()+ "://"+request.getServerName()+ ":"+request.getServerPort()+path+ "/"; 
	
	ApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(getServletContext());    
  	VehicleService vms = ctx.getBean(VehicleService.class);
  	
  	Vehicle vehicle = new Vehicle();
  	vehicle.setState(1);
  	
  	MeetingDao md = ctx.getBean(MeetingDao.class);
  	
  	Meeting meeting = (Meeting)request.getAttribute("meeting");
%>

<!DOCTYPE html>
<html lang="zh-cn">

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width,initial-scale=1.0, maximum-scale=1.2, user-scalable=no" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="renderer" content="webkit" />
<title> 例会详情 </title> 
<link rel="stylesheet" href="/DZOMS/res/css/pintuer.css">
<link rel="stylesheet" href="/DZOMS/res/css/admin.css">
<link rel="stylesheet" type="text/css" href="/DZOMS/res/css/jquery.datetimepicker.css" />
<script src="/DZOMS/res/js/jquery.js"> </script> 
<script src="/DZOMS/res/js/pintuer.js"> </script> 
<script src="/DZOMS/res/js/respond.js"> </script> 
<script type="text/javascript" src="/DZOMS/res/js/itemtool.js"></script> 
<script src="/DZOMS/res/js/admin.js"> </script> 
<script>


</script>

<style>
	.label {
		width: 80 px;
		text-align: right;
	}
	.form-group {
		width: 300 px;
		margin-top: 5 px;
	}
	.changecolor {
		background-color: #0099CC;
	}
							
</style>
</head>

<body>
	<div class="margin-big-bottom">
	<div class="adminmin-bread" style="width: 100%;">
		<ul class="bread text-main" style="font-size: larger;">
			<li> 驾驶员 </li> <li> 例会 </li> <li> 例会统计</li>
		</ul> 
	</div> 
	
	<div>
		<table class="table table-hover table-striped table-bordered">
			<tr>
				<th>分公司归属</th><th>车辆总数</th><th>计划人数</th><th>应到人数</th>
				<th>首日人数</th><th>首日率</th><th>实到人数</th><th>签到比率</th>
				<th>补会后人数</th><th>补会后比率</th><th>有效收卡</th><th>未到人数</th><th>迟到人数</th>
			</tr>
<%!
Triplet<String, String, Object> condition_dept1 = Triplet.with("idNum", "in (select idNum from Driver where isInCar=true and  carframeNum in (select carframeNum from Vehicle where dept='一部')) and 1=",(Object)1);
Triplet<String, String, Object> condition_dept2 = Triplet.with("idNum", "in (select idNum from Driver where isInCar=true and  carframeNum in (select carframeNum from Vehicle where dept='二部')) and 1=",(Object)1);
Triplet<String, String, Object> condition_dept3 = Triplet.with("idNum", "in (select idNum from Driver where isInCar=true and  carframeNum in (select carframeNum from Vehicle where dept='三部')) and 1=",(Object)1);
Triplet<String, String, Object> conditon_spacial = Triplet.with("checkClass", "=",(Object) "特殊情况未参加例会");
Triplet<String, String, Object> conditon_checked = Triplet.with("isChecked", "=",(Object)true);
Triplet<String, String, Object> conditon_not_dangri = Triplet.with("checkClass", "!=",(Object)"未按规定日期参加例会");
Triplet<String, String, Object> conditon_not_spacial = Triplet.with("checkClass", "!=",(Object)"特殊情况未参加例会");
Triplet<String, String, Object> dept_need = Triplet.with("idNum", "in (select idNum from Driver where dept is not null ) and 1=", (Object)1);
 %>
			<s:if test="%{meeting.meetingTimeL1!=null}">
				<tr>
					<td>
						一部
					</td>
					<td>
						<%vehicle.setDept("一部");
						out.print(vms.seleVehicleCount(vehicle));%>
					</td>
					<td>
						<%
						int planNum = md.selectMeetingCheckCount(meeting.getId(),condition_dept1); %>
						<%=planNum %>
					</td>
					<td>
						<%int leaveNum = md.selectLeaveNumber(meeting.getId(), "一部"); 
						int specialNum = md.selectMeetingCheckCount(meeting.getId(), condition_dept1,conditon_spacial); 
						int shouldNum = planNum - leaveNum - specialNum;
						%>
						<%= shouldNum %>
					</td>
					<td>
						<%
						List<MeetingCheck> dangriList = md.selectMeetingCheck(meeting.getId(),condition_dept1,conditon_checked,conditon_not_dangri,conditon_not_spacial); 
						
						dangriList = (List<MeetingCheck>)CollectionUtils.select(dangriList, new Predicate(){
							public boolean evaluate(Object object){
								MeetingCheck meetingCheck = (MeetingCheck) object;
								return !meetingCheck.isBuhui();
							}
						});
						
						int dangriNum = dangriList.size();
						%>
						<%= dangriNum %>
					</td>
					<td>
						<%if(shouldNum==0){%>
							<%= new java.text.DecimalFormat("0.00%").format(1.0)%>
						<%}else{%>
							<%= new java.text.DecimalFormat("0.00%").format((double)dangriNum/(double)shouldNum)%>
						<%}%>
					</td>
					<td>
					<% 
					List<MeetingCheck> shidaoList = md.selectMeetingCheck(meeting.getId(),condition_dept1,conditon_checked, conditon_not_spacial); 
					
					shidaoList = (List<MeetingCheck>)CollectionUtils.select(shidaoList, new Predicate(){
						public boolean evaluate(Object object){
							MeetingCheck meetingCheck = (MeetingCheck) object;
							return !meetingCheck.isBuhui();
						}
					});
					
					int shidaoNum = shidaoList.size();
						
					%>
					 <%= shidaoNum%>
					</td>
					<td>
						<%if(shouldNum==0){%>
							<%= new java.text.DecimalFormat("0.00%").format(1.0)%>
						<%}else{%>
							<%= new java.text.DecimalFormat("0.00%").format((double)shidaoNum/(double)shouldNum)%>
						<%}%>
					</td>
					<td>
					<% 
					int buhuihouNum = md.selectMeetingCheckCount(meeting.getId(),condition_dept1,conditon_checked, conditon_not_spacial); 
						
					%>
					 <%= buhuihouNum%>
					</td>
					<td>
						<%if(shouldNum==0){%>
							<%= new java.text.DecimalFormat("0.00%").format(1.0)%>
						<%}else{%>
							<%= new java.text.DecimalFormat("0.00%").format((double)buhuihouNum/(double)shouldNum)%>
						<%}%>
					</td>
					<td>
					<%=leaveNum %>
					</td>
					<td>
					<%=shouldNum-buhuihouNum %>
					</td>
					<td>
					<% 
					List<MeetingCheck> chidaoList = (List<MeetingCheck>)CollectionUtils.select(shidaoList, new Predicate(){
						public boolean evaluate(Object object){
							MeetingCheck meetingCheck = (MeetingCheck) object;
							return meetingCheck.isChidao();
						}
					});
					 %>
					 <%= chidaoList.size()%>
					</td>
				</tr>
			</s:if>
			<s:if test="%{meeting.meetingTimeL2!=null}">
				<tr>
					<td>
						二部
					</td>
					<td>
						<%vehicle.setDept("二部");
						out.print(vms.seleVehicleCount(vehicle));%>
					</td>
					<td>
						<%
						int planNum = md.selectMeetingCheckCount(meeting.getId(),condition_dept2); %>
						<%=planNum %>
					</td>
					<td>
						<%int leaveNum = md.selectLeaveNumber(meeting.getId(), "二部"); 
						@SuppressWarnings({"unchecked" })
						int specialNum = md.selectMeetingCheckCount(meeting.getId(), condition_dept2,conditon_spacial); 
						int shouldNum = planNum - leaveNum - specialNum;
						%>
						<%= shouldNum %>
					</td>
					<td>
						<%
						@SuppressWarnings({"unchecked" })
						List<MeetingCheck> dangriList = md.selectMeetingCheck(meeting.getId(),condition_dept2,conditon_checked,conditon_not_dangri,conditon_not_spacial); 
						
						dangriList = (List<MeetingCheck>) CollectionUtils.select(dangriList, new Predicate(){
							public boolean evaluate(Object object){
								MeetingCheck meetingCheck = (MeetingCheck) object;
								return !meetingCheck.isBuhui();
							}
						});
						
						int dangriNum = dangriList.size();
						%>
						<%= dangriNum %>
					</td>
					<td>
						<%if(shouldNum==0){%>
							<%= new java.text.DecimalFormat("0.00%").format(1.0)%>
						<%}else{%>
							<%= new java.text.DecimalFormat("0.00%").format((double)dangriNum/(double)shouldNum)%>
						<%}%>
					</td>
					<td>
					<% 
					List<MeetingCheck> shidaoList = md.selectMeetingCheck(meeting.getId(),condition_dept2,conditon_checked, conditon_not_spacial); 
					
					shidaoList = (List<MeetingCheck>)CollectionUtils.select(shidaoList, new Predicate(){
						public boolean evaluate(Object object){
							MeetingCheck meetingCheck = (MeetingCheck) object;
							return !meetingCheck.isBuhui();
						}
					});
					
					int shidaoNum = shidaoList.size();
						
					%>
					 <%= shidaoNum%>
					</td>
					<td>
						<%if(shouldNum==0){%>
							<%= new java.text.DecimalFormat("0.00%").format(1.0)%>
						<%}else{%>
							<%= new java.text.DecimalFormat("0.00%").format((double)shidaoNum/(double)shouldNum)%>
						<%}%>
					</td>
					<td>
					<% 
					@SuppressWarnings({"unchecked" })
					int buhuihouNum = md.selectMeetingCheckCount(meeting.getId(),condition_dept2,conditon_checked, conditon_not_spacial); 
						
					%>
					 <%= buhuihouNum%>
					</td>
					<td>
						<%if(shouldNum==0){%>
							<%= new java.text.DecimalFormat("0.00%").format(1.0)%>
						<%}else{%>
							<%= new java.text.DecimalFormat("0.00%").format((double)buhuihouNum/(double)shouldNum)%>
						<%}%>
					</td>
					<td>
					<%=leaveNum %>
					</td>
					<td>
					<%=shouldNum-buhuihouNum %>
					</td>
					<td>
					<% 
					List<MeetingCheck> chidaoList = (List<MeetingCheck>)CollectionUtils.select(shidaoList, new Predicate(){
						public boolean evaluate(Object object){
							MeetingCheck meetingCheck = (MeetingCheck) object;
							return meetingCheck.isChidao();
						}
					});
					 %>
					 <%= chidaoList.size()%>
					</td>
				</tr>
			</s:if>
			
			<s:if test="%{meeting.meetingTimeL3!=null}">
				<tr>
					<td>
						三部
					</td>
					<td>
						<%vehicle.setDept("三部");
						out.print(vms.seleVehicleCount(vehicle));%>
					</td>
					<td>
						<%
						int planNum = md.selectMeetingCheckCount(meeting.getId(),condition_dept3); %>
						<%=planNum %>
					</td>
					<td>
						<%int leaveNum = md.selectLeaveNumber(meeting.getId(), "三部"); 
						int specialNum = md.selectMeetingCheckCount(meeting.getId(), condition_dept3,conditon_spacial); 
						int shouldNum = planNum - leaveNum - specialNum;
						%>
						<%= shouldNum %>
					</td>
					<td>
						<%
						List<MeetingCheck> dangriList = md.selectMeetingCheck(meeting.getId(),condition_dept3,conditon_checked,conditon_not_dangri,conditon_not_spacial); 
						
						dangriList = (List<MeetingCheck>)CollectionUtils.select(dangriList, new Predicate(){
							public boolean evaluate(Object object){
								MeetingCheck meetingCheck = (MeetingCheck) object;
								return !meetingCheck.isBuhui();
							}
						});
						
						int dangriNum = dangriList.size();
						%>
						<%= dangriNum %>
					</td>
					<td>
						<%if(shouldNum==0){%>
							<%= new java.text.DecimalFormat("0.00%").format(1.0)%>
						<%}else{%>
							<%= new java.text.DecimalFormat("0.00%").format((double)dangriNum/(double)shouldNum)%>
						<%}%>
					</td>
					<td>
					<% 
					List<MeetingCheck> shidaoList = md.selectMeetingCheck(meeting.getId(),condition_dept3,conditon_checked, conditon_not_spacial); 
					
					shidaoList = (List<MeetingCheck>)CollectionUtils.select(shidaoList, new Predicate(){
						public boolean evaluate(Object object){
							MeetingCheck meetingCheck = (MeetingCheck) object;
							return !meetingCheck.isBuhui();
						}
					});
					
					int shidaoNum = shidaoList.size();
						
					%>
					 <%= shidaoNum%>
					</td>
					<td>
						<%if(shouldNum==0){%>
							<%= new java.text.DecimalFormat("0.00%").format(1.0)%>
						<%}else{%>
							<%= new java.text.DecimalFormat("0.00%").format((double)shidaoNum/(double)shouldNum)%>
						<%}%>
					</td>
					<td>
					<% 
					int buhuihouNum = md.selectMeetingCheckCount(meeting.getId(),condition_dept3,conditon_checked, conditon_not_spacial); 
						
					%>
					 <%= buhuihouNum%>
					</td>
					<td>
						<%if(shouldNum==0){%>
							<%= new java.text.DecimalFormat("0.00%").format(1.0)%>
						<%}else{%>
							<%= new java.text.DecimalFormat("0.00%").format((double)buhuihouNum/(double)shouldNum)%>
						<%}%>
					</td>
					<td>
					<%=leaveNum %>
					</td>
					<td>
					<%=shouldNum-buhuihouNum %>
					</td>
					<td>
					<% 
					List<MeetingCheck> chidaoList = (List<MeetingCheck>)CollectionUtils.select(shidaoList, new Predicate(){
						public boolean evaluate(Object object){
							MeetingCheck meetingCheck = (MeetingCheck) object;
							return meetingCheck.isChidao();
						}
					});
					 %>
					 <%= chidaoList.size()%>
					</td>
				</tr>
			</s:if>
			
			
			<tr>
					<td>
						全部
					</td>
					<td>
						<%vehicle.setDept(null);
						out.print(vms.seleVehicleCount(vehicle));%>
					</td>
					<td>
						<%
						int planNum = md.selectMeetingCheckCount(meeting.getId(),dept_need); %>
						<%=planNum %>
					</td>
					<td>
						<%int leaveNum = md.selectLeaveNumber(meeting.getId(),null); 
						int specialNum = md.selectMeetingCheckCount(meeting.getId(),conditon_spacial); 
						int shouldNum = planNum - leaveNum - specialNum;
						%>
						<%= shouldNum %>
					</td>
					<td>
						<%
						List<MeetingCheck> dangriList = md.selectMeetingCheck(meeting.getId(),conditon_checked,conditon_not_dangri,conditon_not_spacial); 
						
						dangriList = (List<MeetingCheck>)CollectionUtils.select(dangriList, new Predicate(){
							public boolean evaluate(Object object){
								MeetingCheck meetingCheck = (MeetingCheck) object;
								return !meetingCheck.isBuhui();
							}
						});
						
						int dangriNum = dangriList.size();
						%>
						<%= dangriNum %>
					</td>
					<td>
						<%if(shouldNum==0){%>
							<%= new java.text.DecimalFormat("0.00%").format(1.0)%>
						<%}else{%>
							<%= new java.text.DecimalFormat("0.00%").format((double)dangriNum/(double)shouldNum)%>
						<%}%>
					</td>
					<td>
					<% 
					List<MeetingCheck> shidaoList = md.selectMeetingCheck(meeting.getId(),conditon_checked, conditon_not_spacial); 
					
					shidaoList = (List<MeetingCheck>)CollectionUtils.select(shidaoList, new Predicate(){
						public boolean evaluate(Object object){
							MeetingCheck meetingCheck = (MeetingCheck) object;
							return !meetingCheck.isBuhui();
						}
					});
					
					int shidaoNum = shidaoList.size();
						
					%>
					 <%= shidaoNum%>
					</td>
					<td>
						<%if(shouldNum==0){%>
							<%= new java.text.DecimalFormat("0.00%").format(1.0)%>
						<%}else{%>
							<%= new java.text.DecimalFormat("0.00%").format((double)shidaoNum/(double)shouldNum)%>
						<%}%>
					</td>
					<td>
					<% 
					int buhuihouNum = md.selectMeetingCheckCount(meeting.getId(),conditon_checked, conditon_not_spacial); 
						
					%>
					 <%= buhuihouNum%>
					</td>
					<td>
						<%if(shouldNum==0){%>
							<%= new java.text.DecimalFormat("0.00%").format(1.0)%>
						<%}else{%>
							<%= new java.text.DecimalFormat("0.00%").format((double)buhuihouNum/(double)shouldNum)%>
						<%}%>
					</td>
					<td>
					<%=leaveNum %>
					</td>
					<td>
					<%=shouldNum-buhuihouNum %>
					</td>
					<td>
					<% 
					List<MeetingCheck> chidaoList = (List<MeetingCheck>)CollectionUtils.select(shidaoList, new Predicate(){
						public boolean evaluate(Object object){
							MeetingCheck meetingCheck = (MeetingCheck) object;
							return meetingCheck.isChidao();
						}
					});
					 %>
					 <%= chidaoList.size()%>
					</td>
				</tr>
		</table>
	</div>
</div>
</body> 
<script src="/DZOMS/res/js/jquery.datetimepicker.js"> </script>
<script type="text/javascript" src="/DZOMS/res/js/DateTimeHelper.js"> </script>
</html>