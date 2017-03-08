package com.dz.module.vehicle;

import com.dz.common.global.BaseAction;
import com.dz.common.other.ObjectAccess;
import com.dz.module.contract.Contract;
import com.dz.module.driver.Driver;
import com.dz.module.user.RelationUr;
import com.dz.module.user.User;
import com.dz.module.user.message.Message;
import com.dz.module.user.message.MessageToUser;

import net.sf.json.JSONObject;

import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.util.List;
@Controller
@Scope(value = "prototype")
public class VehicleApprovalAction extends BaseAction{

	private VehicleApproval vehicleApproval;
	@Autowired
	private VehicleApprovalService vehicleApprovalService;
	private Contract contract;
	
	private Integer state;
	private Integer approvalId;	
	
	private String url;

	/**
	 * 新建审批单
	 * @return
	 */
	public String vehicleApprovalCreate() {
		boolean flag = vehicleApprovalService.addVehicleApproval(vehicleApproval,contract);		
		if (flag) {
			return SUCCESS;
		}
		return ERROR;
	}
	
	/**
	 * 按ID查找审批单
	 * @return
	 * @throws IOException
	 */
	public void vehicleApprovalId() throws IOException {
		ServletActionContext.getResponse().setContentType("application/json");
		ServletActionContext.getResponse().setCharacterEncoding("utf-8");
		PrintWriter out = ServletActionContext.getResponse().getWriter();
		
		VehicleApproval va = vehicleApprovalService.queryVehicleApprovalById(approvalId);
		this.setVehicleApproval(va);
		
		JSONObject json = JSONObject.fromObject(va);
		
		out.print(json.toString());
		
		out.flush();
		out.close();
	}
	
	public String vehicleApprovalInterrupt(){
		vehicleApproval = vehicleApprovalService.queryVehicleApprovalById(vehicleApproval.getId());
		Contract c = ObjectAccess.getObject(Contract.class, vehicleApproval.getContractId());
		c.setState((short) -2);
		ObjectAccess.saveOrUpdate(c);
		vehicleApproval.setState(-1);
		vehicleApproval.setInterruptTime(new Date());
		ObjectAccess.saveOrUpdate(vehicleApproval);
		
		Message msg = new Message();
		msg.setCarframeNum(c.getCarframeNum());
		msg.setIdNum(c.getIdNum());
		msg.setFromUser(vehicleApproval.getInterruptPerson());
		msg.setTime(vehicleApproval.getInterruptTime());
		
		User u = ObjectAccess.getObject(User.class, vehicleApproval.getInterruptPerson());
		
		if(vehicleApproval.getCheckType()==0){
			msg.setType("开业审批中止");
		}else{
			msg.setType("废业审批中止");
		}
		
		Driver d = ObjectAccess.getObject(Driver.class, c.getIdNum());
		
		msg.setMsg(String.format("%tF %s发：\n"
				+ "现有车%s(%s) 承包人 %s(%s) 因%s 中止审批，特此通知。", 
				msg.getTime(),u.getUname(),
				c.getCarNum(),c.getCarframeNum(),d.getName(),c.getIdNum(),vehicleApproval.getInterruptReason()));
		
		ObjectAccess.saveOrUpdate(msg);
		
		List<RelationUr> users;
		if(vehicleApproval.getCheckType()==0){
			users = ObjectAccess.query(RelationUr.class, String.format(
					" rid in (select rid from Role where rname in ('%s','%s','%s','%s','%s','%s','%s') "
					, "分部经理","运营部经理","副总经理","保险员","财务负责人","财务经理","办公室主任"));
		}else{
			users = ObjectAccess.query(RelationUr.class, String.format(
					" rid in (select rid from Role where rname in ('%s','%s','%s','%s','%s','%s','%s') "
					, "分部经理","运营部经理","副总经理","保险员","财务负责人","财务经理","办公室主任"));
		}
		
		for (RelationUr relationUr : users) {
			MessageToUser mu = new MessageToUser();
			mu.setUid(relationUr.getUid());
			mu.setMid(msg.getId());
			mu.setAlreadyRead(false);
			ObjectAccess.saveOrUpdate(mu);
		}
		
		return SUCCESS;
	}
	
	public void vehicleApprovalByContract() throws IOException{
		ServletActionContext.getResponse().setContentType("application/json");
		ServletActionContext.getResponse().setCharacterEncoding("utf-8");
		PrintWriter out = ServletActionContext.getResponse().getWriter();
		
		VehicleApproval va = vehicleApprovalService.queryVehicleApprovalByContractId(contract.getId());
		this.setVehicleApproval(va);
		
		JSONObject json = JSONObject.fromObject(va);
		
		out.print(json.toString());
		
		out.flush();
		out.close();
	}
	
	public String vehicleApprovalPreUpdate() {
		vehicleApproval = vehicleApprovalService.queryVehicleApprovalById(vehicleApproval.getId());
		contract = (Contract) ObjectAccess.getObject("com.dz.module.contract.Contract", vehicleApproval.getContractId());
		if(vehicleApproval.getCheckType()==0){
			url = "/vehicle/CreateApproval/vehicle_approval0"+(vehicleApproval.getState()+1)+".jsp";
		}else{
			url = "/vehicle/AbandonApproval/vehicle_abandon0"+(vehicleApproval.getState()+1)+".jsp";
		}
		
		return SUCCESS;
	}
	
	public String vehicleApprovalPreAbandond(){
		contract = (Contract) ObjectAccess.getObject("com.dz.module.contract.Contract", contract.getId());
		request.setAttribute("contract", contract);
		return SUCCESS;
	}
	
	public String vehicleApprovalPreCreate(){
		Contract c = (Contract) ObjectAccess.getObject("com.dz.module.contract.Contract", contract.getContractFrom());
		request.setAttribute("contractFrom", c);
		return SUCCESS;
	}
	
	/**
	 * 更新审批单
	 * @return
	 */
	public String vehicleApprovalUpdate() {
		if (vehicleApprovalService.updateVehicleApproval(vehicleApproval)){
			request.setAttribute("msgStr", "操作成功。");
		}else{
			if(request.getAttribute("msgStr")==null){
				request.setAttribute("msgStr", "操作失败。");
			}
		}
		return SUCCESS;
	}
	
	public VehicleApproval getVehicleApproval() {
		return vehicleApproval;
	}

	public void setVehicleApproval(VehicleApproval vehicleApproval) {
		this.vehicleApproval = vehicleApproval;
	}
	
	public VehicleApprovalService getVehicleApprovalService() {
		return vehicleApprovalService;
	}

	public void setVehicleApprovalService(
			VehicleApprovalService vehicleApprovalService) {
		this.vehicleApprovalService = vehicleApprovalService;
	}

	public Contract getContract() {
		return contract;
	}

	public Integer getState() {
		return state;
	}

	public Integer getApprovalId() {
		return approvalId;
	}

	public void setContract(Contract contract) {
		this.contract = contract;
	}

	public void setState(Integer state) {
		this.state = state;
	}

	public void setApprovalId(Integer approvalId) {
		this.approvalId = approvalId;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}
}
