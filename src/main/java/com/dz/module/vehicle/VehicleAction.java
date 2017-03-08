package com.dz.module.vehicle;

import com.dz.common.global.BaseAction;
import com.dz.common.global.Page;
import com.dz.common.other.FileAccessUtil;
import com.dz.common.other.FileUploadUtil;
import com.dz.common.other.ObjectAccess;
import com.dz.common.other.PageUtil;
import com.dz.module.contract.Contract;
import com.dz.module.contract.ContractService;

import net.sf.json.JSONArray;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.struts2.ServletActionContext;
import org.javatuples.Triplet;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.util.List;

@Controller
@Scope(value = "prototype")
public class VehicleAction extends BaseAction{

	private Vehicle vehicle; 
    @Autowired
	private VehicleService vehicleService; 
    @Autowired
    private ContractService contractService;
    @Autowired
	private FileAccessUtil fileAccessUtil;

	private Contract contract;
	private Object jsonObject;
	
	private String photo;
	
	private String photo_tuoying;
	
	private String condition;
	
	private String driverName;
	
	//For Search
	private Date pd_begin,pd_end;
	private Date inDate_begin,inDate_end;
	private Date operateCardTime_begin,operateCardTime_end;
	
	//行车执照登记日期 审批单
	private Date getCarDate;
	
	
	public void setVehicleService(VehicleService vehicleService){
		this.vehicleService = vehicleService;
	}
	
    public void setContractService(ContractService contractService) {
		this.contractService = contractService;
	}
	
	public Vehicle getVehicle(){
		return vehicle;
	}
	
	public void setVehicle(Vehicle vehicle){
		this.vehicle = vehicle;
	}

	public String vehicleSele() {
		 int currentPage = 0;
         String currentPagestr = request.getParameter("currentPage");
         if(currentPagestr == null || "".equals(currentPagestr)){
         	currentPage = 1;
         }else{
         	currentPage=Integer.parseInt(currentPagestr);
         }
         
        String hql = " 1=1 ";
        
        if(StringUtils.isNotEmpty(condition)){
			hql+=condition;
		}
        
        if(vehicle!=null){
        	
        	hql += checkAndGenerate(vehicle,"carframeNum"," and carframeNum like '%%%s%%' ");
        	hql += checkAndGenerate(vehicle,"licenseNum"," and licenseNum like '%%%s%%' ");
        	hql += checkAndGenerate(vehicle,"engineNum"," and engineNum like '%%%s%%' ");
        	hql += checkAndGenerate(vehicle,"dept");
        	hql += checkAndGenerate(vehicle,"invoiceNumber");
        	hql += checkAndGenerate(vehicle,"taxNumber");
        	hql += checkAndGenerate(vehicle,"operateCard");
        	hql += checkAndGenerate(vehicle,"businessLicenseId");
        	//hql += checkAndGenerate(vehicle,"businessLicenseBeginDate"," and businessLicenseBeginDate >= STR_TO_DATE('%tF','%%Y-%%m-%%d') ");
        	//hql += checkAndGenerate(vehicle,"businessLicenseEndDate"," and businessLicenseEndDate <= STR_TO_DATE('%tF','%%Y-%%m-%%d') ");
        	
        	if(!StringUtils.isEmpty(driverName)){
        		hql += " and driverId in (select idNum from Driver where name ='"+driverName+"') ";
        	}
        }
         
        long count = ObjectAccess.execute("select count(*) from Vehicle where " + hql);
        
        //vehicle.setCarMode("123");
        Page page = PageUtil.createPage(15,(int)count, currentPage);
        
        List<Vehicle> l = ObjectAccess.query(Vehicle.class, hql, null, null, null, page);
        
/*		List<Vehicle> l = vehicleService.seleVehicle(page, vehicle,conditions);
*/		request.setAttribute("vehicle", l);
		//request.setAttribute("currentPage", currentPage);
		request.setAttribute("page", page);
		
		if(StringUtils.isEmpty(url))
			return "select";
		
		return "selectToUrl";
	}
	
	public String vehicleBind(){
		Vehicle v = ObjectAccess.getObject(Vehicle.class, vehicle.getCarframeNum());
		Contract c = ObjectAccess.execute("select c from Contract c where c.idNum='"+vehicle.getDriverId()+
				"' and c.state=2 ");
		if(c==null){
			request.setAttribute("msgStr", "添加失败。请先进行新车开业，新车开业后才可进行人辆绑定。");
			return ERROR;
		}
		c.setCarframeNum(v.getCarframeNum());
		c.setCarNum(v.getLicenseNum());
		
		ObjectAccess.saveOrUpdate(c);
		
		v.setDriverId(vehicle.getDriverId());
		ObjectAccess.saveOrUpdate(v);
		
		if(v.getOperateCardTime()!=null){
			VehicleApproval approval = ObjectAccess.execute("from VehicleApproval c where c.contractId="+c.getId()+
					" and c.checkType=0 ");
			approval.setOperateCardDate(v.getOperateCardTime());
			ObjectAccess.saveOrUpdate(approval);
		}
		
		if(v.getGetCarDate()!=null){
			VehicleApproval approval = ObjectAccess.execute("from VehicleApproval c where c.contractId="+c.getId()+
					" and c.checkType=0 ");
			approval.setGetCarDate(v.getGetCarDate());
			ObjectAccess.saveOrUpdate(approval);
		}
		
		if(v.getLicenseNumRegDate()!=null){
			VehicleApproval approval = ObjectAccess.execute("from VehicleApproval c where c.contractId="+c.getId()+
					" and c.checkType=0 ");
			approval.setLicenseRegisterDate(v.getLicenseNumRegDate());
			approval.setOperateApplyDate(new Date());
			ObjectAccess.saveOrUpdate(approval);
		}
		
		return SUCCESS;
	}
	
	public void vehicleSelectValidCount() throws IOException{
		Triplet<String,String,Object> condition = new Triplet<String,String,Object>("state","<",2);
		int total = vehicleService.seleVehicleCount(null,condition);
		
		ServletActionContext.getResponse().setContentType("application/json");
		ServletActionContext.getResponse().setCharacterEncoding("utf-8");
		PrintWriter out = ServletActionContext.getResponse().getWriter();
		
		out.print(total);
		
		out.flush();
		out.close();
	}

	public String vehicleSelectAll(){
		jsonObject = vehicleService.selectAll();
		return "jsonObject";
	}
	
	public String vehicleAdd() {
		try {
			//TODO
			String basePath = System.getProperty("com.dz.root") +"data/vehicle/"+vehicle.getCarframeNum()+"/";
			File base = new File(basePath);
			if (!base.exists()) {
				base.mkdirs();
			}
			if(StringUtils.length(photo)==30){
				FileUploadUtil.store(photo, new File(base,"photo.jpg"));
			}
			
			if(StringUtils.length(photo_tuoying)==30){
				FileUploadUtil.store(photo_tuoying, new File(base,"photo_tuoying.jpg"));
			}
			
			vehicle.setState(0);
			
			
//			Contract c = ObjectAccess.execute("select c from Contract c where c.idNum='"+vehicle.getDriverId()+
//					"' and c.state=2 ");
//			if(c==null){
//				request.setAttribute("msgStr", "添加失败。请先进行新车开业，新车开业后才可录入车辆信息。");
//				return ERROR;
//			}
//			c.setCarframeNum(vehicle.getCarframeNum());
//			c.setCarNum(vehicle.getLicenseNum());
//			
//			ObjectAccess.saveOrUpdate(c);
			
//			VehicleApproval approval = ObjectAccess.execute("from VehicleApproval c where c.contractId="+c.getId()+
//					" and c.checkType=0 ");
//			approval.setGetCarDate(getCarDate);
//			ObjectAccess.saveOrUpdate(approval);
			
			vehicle.setGetCarDate(getCarDate);
			
			boolean flag = vehicleService.addVehicle(vehicle);
			if (!flag) {
				request.setAttribute("msgStr", "添加失败。");
				return ERROR;
			}
			request.setAttribute("msgStr", "添加成功。");
			vehicle=null;
			return SUCCESS;
		} catch (Exception e) {
			// TODO: handle exception
			request.setAttribute("msgStr", "添加失败。原因是"+e.getMessage());
			return ERROR;
		}
	}
	
	public void vehicleSearch() throws IOException {
		ServletActionContext.getResponse().setContentType("application/json");
		ServletActionContext.getResponse().setCharacterEncoding("utf-8");
		PrintWriter out = ServletActionContext.getResponse().getWriter();
		
		int count = vehicleService.seleVehicleCount(vehicle);
		Page page = PageUtil.createPage(count,count, 0);
		List<Vehicle> l = vehicleService.seleVehicle(page, vehicle);
		
		JSONArray json = JSONArray.fromObject(l);
	
		out.print(json.toString());
		
		out.flush();
		out.close();
	}

	public String vehicleSelectByLicenseNum(){
        Vehicle v = (Vehicle)vehicleService.selectByLicenseNum(vehicle);
		v.setDriverId(v.getDriverId()+"p");
		v.setFirstDriver(v.getFirstDriver()+"p");
		v.setSecondDriver(v.getSecondDriver()+"p");
		v.setThirdDriver(v.getThirdDriver()+"p");
		v.setForthDriver(v.getForthDriver()+"p");
		System.out.println(v);
		jsonObject = v;
        return "selectByLicenseNum";
	}
	
	public String vehicleUpdate() {
		boolean flag = vehicleService.updateVehicle(vehicle);
		if(!flag) {
			request.setAttribute("msgStr", "操作失败。");
			return ERROR;
		}
		return SUCCESS;
	}
	
	public String addInvoice(){
		Vehicle v = vehicleService.selectById(vehicle);
		v.setInvoiceNumber(vehicle.getInvoiceNumber());
		v.setInvoiceDate(vehicle.getInvoiceDate());
		v.setInvoiceMoney(vehicle.getInvoiceMoney());
		v.setPurseFrom(vehicle.getPurseFrom());
		v.setInvoiceRegister(vehicle.getInvoiceRegister());
		v.setInvoiceRegistTime(vehicle.getInvoiceRegistTime());
		
		boolean flag = vehicleService.updateVehicle(v);
		if(!flag) {
			request.setAttribute("msgStr", "添加失败。");
			return ERROR;
		}
		request.setAttribute("msgStr", "添加成功。");
		return SUCCESS;
	}
	
	public String addTax(){
		Vehicle v = vehicleService.selectById(vehicle);
		v.setTaxNumber(vehicle.getTaxNumber());
		v.setTaxDate(vehicle.getTaxDate());
		v.setTaxMoney(vehicle.getTaxMoney());
		v.setTaxFrom(vehicle.getTaxFrom());
		v.setTaxRegister(vehicle.getTaxRegister());
		v.setTaxRegistTime(vehicle.getTaxRegistTime());
		
		boolean flag = vehicleService.updateVehicle(v);
		if(!flag) {
			request.setAttribute("msgStr", "添加失败。");
			return ERROR;
		}
		request.setAttribute("msgStr", "添加成功。");
		return SUCCESS;
	}
	
	public String addLicence(){
		Vehicle v = vehicleService.selectById(vehicle);
		
		if(v==null){
			request.setAttribute("msgStr", "添加失败。车架号错误，该车不存在！");
			return ERROR;
		}
		
		v.setLicenseNum(vehicle.getLicenseNum());
		v.setLicenseNumRegDate(vehicle.getLicenseNumRegDate());
		v.setLicensePurseNum(vehicle.getLicensePurseNum());
		v.setLicenseRegister(vehicle.getLicenseRegister());
		v.setLicenseRegistTime(vehicle.getLicenseRegistTime());
		v.setLicenseRegNum(vehicle.getLicenseRegNum());
		v.setIsNewLicense(vehicle.getIsNewLicense());
		
		Contract c = ObjectAccess.execute("select c from Contract c where c.state in (2,3) and c.idNum='"+v.getDriverId()+
				"' and c.carframeNum='"+v.getCarframeNum()+"' ");
		
		if(c!=null){
			c.setCarNum(vehicle.getLicenseNum());
			
			ObjectAccess.saveOrUpdate(c);
			
			VehicleApproval approval = ObjectAccess.execute("from VehicleApproval c where c.contractId="+c.getId()+
					" and c.checkType=0 ");
			approval.setLicenseRegisterDate(v.getLicenseNumRegDate());
			approval.setOperateApplyDate(new Date());
			ObjectAccess.saveOrUpdate(approval);
		}
		
		boolean flag = vehicleService.updateVehicle(v);
		if(!flag) {
			request.setAttribute("msgStr", "添加失败。");
			return ERROR;
		}
		request.setAttribute("msgStr", "添加成功。");
		return SUCCESS;
	}
	
	/**
	 * 添加计价器信息
	 */
	public String addService(){
		Vehicle v = vehicleService.selectById(vehicle);
		
		//v.setOperateCard(vehicle.getOperateCard());
		v.setOperateCardRegistDate(vehicle.getOperateCardRegistDate());
		v.setOperateCardRegister(vehicle.getOperateCardRegister());
		//v.setOperateCardTime(vehicle.getOperateCardTime());
		v.setTwiceSupplyDate(vehicle.getTwiceSupplyDate());
		v.setNextSupplyDate(vehicle.getNextSupplyDate());
		v.setMoneyCountor(vehicle.getMoneyCountor());
		v.setMoneyCountorNextDate(vehicle.getMoneyCountorNextDate());
		v.setMoneyCountorTime(vehicle.getMoneyCountorTime());
		//v.setBusinessLicenseNum(vehicle.getBusinessLicenseNum());
		
		Contract c = ObjectAccess.execute("select c from Contract c where c.idNum='"+v.getDriverId()+
				"' and c.carframeNum='"+v.getCarframeNum()+"' ");
		
		if(c!=null){
			VehicleApproval approval = ObjectAccess.execute("from VehicleApproval c where c.contractId="+c.getId()+
					" and c.checkType=0 ");
			approval.setOperateCardDate(v.getOperateCardTime());
			ObjectAccess.saveOrUpdate(approval);
		}
		
		boolean flag = vehicleService.updateVehicle(v);
		if(!flag) {
			request.setAttribute("msgStr", "添加失败。");
			return ERROR;
		}
		request.setAttribute("msgStr", "添加成功。");
		return SUCCESS;
	}
	/**
	 * 添加经营权信息
	 */
	public String addServiceRight(){
		Vehicle v = vehicleService.selectById(vehicle);
		
		v.setOperateCard(vehicle.getOperateCard());
		v.setServiceRightRegistDate(vehicle.getServiceRightRegistDate());
		v.setServiceRightRegister(vehicle.getServiceRightRegister());
		v.setOperateCardTime(vehicle.getOperateCardTime());
		
		Contract c = ObjectAccess.execute("select c from Contract c where c.idNum='"+v.getDriverId()+
				"' and c.carframeNum='"+v.getCarframeNum()+"' ");
		
		if(c!=null){
			VehicleApproval approval = ObjectAccess.execute("from VehicleApproval c where c.contractId="+c.getId()+
					" and c.checkType=0 ");
			approval.setOperateCardDate(v.getOperateCardTime());
			ObjectAccess.saveOrUpdate(approval);
		}
		
		boolean flag = vehicleService.updateVehicle(v);
		if(!flag) {
			request.setAttribute("msgStr", "添加失败。");
			return ERROR;
		}
		request.setAttribute("msgStr", "添加成功。");
		return SUCCESS;
	}
	
	private BusinessLicense businessLicense;

	public String addTrade(){
		Vehicle v = vehicleService.selectById(vehicle);
		
		ObjectAccess.saveOrUpdate(businessLicense);
		
		if(businessLicense==null||businessLicense.getId()==null||businessLicense.getId()==0){
			request.setAttribute("msgStr", "添加失败。");
			return SUCCESS;
		}
		
		v.setBusinessLicenseComment(vehicle.getBusinessLicenseComment());
		v.setBusinessLicenseId(businessLicense.getId());
		
		boolean flag = vehicleService.updateVehicle(v);
		if(!flag) {
			request.setAttribute("msgStr", "添加失败。");
			return SUCCESS;
		}
		request.setAttribute("msgStr", "添加成功。");
		return SUCCESS;
	}
	
	public String vehicleSelectById(){
		Vehicle vs = vehicleService.selectById(vehicle);
		vs.setFirstDriver(vs.getFirstDriver()+ " ");
		vs.setSecondDriver(vs.getSecondDriver()+" ");
		vs.setThirdDriver(vs.getThirdDriver()+" ");
		vs.setForthDriver(vs.getForthDriver()+" ");
		jsonObject = vs;
		this.vehicle = (Vehicle) jsonObject;
		vehicle.setDriverId(vehicle.getDriverId()+" ");
		return "selectById";
	}

    public Object getJsonObject() {
        return jsonObject;
    }

    public void setJsonObject(Object jsonObject) {
        this.jsonObject = jsonObject;
    }

	public Contract getContract() {
		return contract;
	}

	public void setContract(Contract contract) {
		this.contract = contract;
	}

	public String getPhoto() {
		return photo;
	}

	public void setPhoto(String photo) {
		this.photo = photo;
	}

	public String getPhoto_tuoying() {
		return photo_tuoying;
	}

	public void setPhoto_tuoying(String photo_tuoying) {
		this.photo_tuoying = photo_tuoying;
	}

	public void setFileAccessUtil(FileAccessUtil fileAccessUtil) {
		this.fileAccessUtil = fileAccessUtil;
	}

	public Date getPd_begin() {
		return pd_begin;
	}

	public void setPd_begin(Date pd_begin) {
		this.pd_begin = pd_begin;
	}

	public Date getPd_end() {
		return pd_end;
	}

	public void setPd_end(Date pd_end) {
		this.pd_end = pd_end;
	}

	public Date getInDate_begin() {
		return inDate_begin;
	}

	public void setInDate_begin(Date inDate_begin) {
		this.inDate_begin = inDate_begin;
	}

	public Date getInDate_end() {
		return inDate_end;
	}

	public void setInDate_end(Date inDate_end) {
		this.inDate_end = inDate_end;
	}

	public Date getOperateCardTime_begin() {
		return operateCardTime_begin;
	}

	public void setOperateCardTime_begin(Date operateCardTime_begin) {
		this.operateCardTime_begin = operateCardTime_begin;
	}

	public Date getOperateCardTime_end() {
		return operateCardTime_end;
	}

	public void setOperateCardTime_end(Date operateCardTime_end) {
		this.operateCardTime_end = operateCardTime_end;
	}

	public String getDriverName() {
		return driverName;
	}

	public void setDriverName(String driverName) {
		this.driverName = driverName;
	}

	public String getCondition() {
		return condition;
	}

	public void setCondition(String condition) {
		this.condition = condition;
	}

	public Date getGetCarDate() {
		return getCarDate;
	}

	public void setGetCarDate(Date getCarDate) {
		this.getCarDate = getCarDate;
	}

	public BusinessLicense getBusinessLicense() {
		return businessLicense;
	}

	public void setBusinessLicense(BusinessLicense businessLicense) {
		this.businessLicense = businessLicense;
	}
	
}
