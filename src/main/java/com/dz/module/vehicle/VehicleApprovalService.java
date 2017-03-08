package com.dz.module.vehicle;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.security.Principal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Date;
import java.util.Enumeration;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.TreeMap;

import javax.servlet.AsyncContext;
import javax.servlet.DispatcherType;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletInputStream;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpUpgradeHandler;
import javax.servlet.http.Part;

import com.dz.common.global.DateUtil;
import com.dz.common.global.ToDo;
import com.dz.common.global.WaitDeal;
import com.dz.common.global.WaitToDo;
import com.dz.common.other.ObjectAccess;
import com.dz.module.charge.ChargeDao;
import com.dz.module.contract.Contract;
import com.dz.module.contract.ContractDao;
import com.dz.module.driver.Driver;
import com.dz.module.driver.DriverService;
import com.dz.module.driver.Driverincar;
import com.dz.module.driver.Families;
import com.dz.module.user.Role;
import com.dz.module.user.User;
import com.opensymphony.xwork2.ActionContext;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.Transformer;
import org.apache.commons.lang3.BooleanUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.math.NumberUtils;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
@Service
@WaitDeal(name = "vehicleApprovalService")
public class VehicleApprovalService implements WaitToDo {
	@Autowired
	private ContractDao contractDao;
	@Autowired
	private VehicleApprovalDao vehicleApprovalDao;
	
	
	
	/**
	 * 新建审批单
	 * @param vehicleApproval
	 * @param contract 
	 * @return
	 */
	public boolean addVehicleApproval(VehicleApproval vehicleApproval, Contract contract){
		if(vehicleApproval == null)
			return false;	
		
		
		switch(vehicleApproval.getCheckType()){
			case 0:
				contract.setState((short) 2);
				contract.setAscription(vehicleApproval.getAscription());
				if(contract.getContractFrom()!=null&&contract.getContractFrom()!=0){
					//二手车    此处绑定人车
					Vehicle v = ObjectAccess.getObject(Vehicle.class, contract.getCarframeNum());
					v.setDriverId(contract.getIdNum());
					ObjectAccess.saveOrUpdate(v);
					
					if(v.getOperateCardTime()!=null){
						vehicleApproval.setOperateCardDate(v.getOperateCardTime());
					}
					
					if(v.getLicenseRegistTime()!=null){
						vehicleApproval.setOperateApplyDate(v.getLicenseRegistTime());
					}
				}
				if(!contractDao.contractWrite(contract)){
					return false;
				}
				vehicleApproval.setContractId(contract.getId());
				break;
			case 1:
				/*if(!contractDao.contractAbandon(contract)){
					return false;
				}*/
				
				Contract c = contractDao.selectById(contract.getId());
				Vehicle vehicle = (Vehicle) ObjectAccess.getObject("com.dz.module.vehicle.Vehicle", c.getCarframeNum());
				VehicleMode vehicleMode = (VehicleMode) ObjectAccess.getObject("com.dz.module.vehicle.VehicleMode",vehicle.getCarMode());
				vehicleApproval.setFueltype(vehicleMode.getFuel());
				
				c.setAbandonRequest(contract.getAbandonRequest());
				c.setAbandonReason(contract.getAbandonReason());
				ObjectAccess.saveOrUpdate(c);
				
				vehicleApproval.setContractId(contract.getId());
				break;
			default:
				return false;
		}
	
		vehicleApproval.setState(1);
		vehicleApproval.setIsFinished(false);
		
		if(BooleanUtils.isTrue(contract.getGeneByImport())){
			vehicleApproval.setBranchManagerName(1);
		}else{
			HttpServletRequest request =  ServletActionContext.getRequest();
			vehicleApproval.setBranchManagerName(((User)request.getSession().getAttribute("user")).getUid());
		}
		vehicleApproval.setBranchManagerApprovalDate(new Date());
		
		return vehicleApprovalDao.addVehicleApproval(vehicleApproval);
	}
	
	/**
	 * 更新审批单
	 * @param _vehicleApproval
	 * @return
	 */
	public boolean updateVehicleApproval(VehicleApproval _vehicleApproval)
	{
		HttpServletRequest request =  null;
		int uName = 1;
		
		VehicleApproval vehicleApproval = vehicleApprovalDao.queryVehicleApprovalById(_vehicleApproval.getId());
		int state = vehicleApproval.getState();
		
		Contract contract = (Contract) ObjectAccess.getObject("com.dz.module.contract.Contract", vehicleApproval.getContractId());
		
		if(BooleanUtils.isTrue(contract.getGeneByImport())){
			request = new HttpServletRequest(){
				@Override
				public AsyncContext getAsyncContext() {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public Object getAttribute(String name) {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public Enumeration<String> getAttributeNames() {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public String getCharacterEncoding() {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public int getContentLength() {
					// TODO Auto-generated method stub
					return 0;
				}

				@Override
				public long getContentLengthLong() {
					// TODO Auto-generated method stub
					return 0;
				}

				@Override
				public String getContentType() {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public DispatcherType getDispatcherType() {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public ServletInputStream getInputStream() throws IOException {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public String getLocalAddr() {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public String getLocalName() {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public int getLocalPort() {
					// TODO Auto-generated method stub
					return 0;
				}

				@Override
				public Locale getLocale() {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public Enumeration<Locale> getLocales() {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public String getParameter(String name) {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public Map<String, String[]> getParameterMap() {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public Enumeration<String> getParameterNames() {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public String[] getParameterValues(String name) {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public String getProtocol() {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public BufferedReader getReader() throws IOException {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public String getRealPath(String path) {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public String getRemoteAddr() {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public String getRemoteHost() {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public int getRemotePort() {
					// TODO Auto-generated method stub
					return 0;
				}

				@Override
				public RequestDispatcher getRequestDispatcher(String path) {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public String getScheme() {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public String getServerName() {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public int getServerPort() {
					// TODO Auto-generated method stub
					return 0;
				}

				@Override
				public ServletContext getServletContext() {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public boolean isAsyncStarted() {
					// TODO Auto-generated method stub
					return false;
				}

				@Override
				public boolean isAsyncSupported() {
					// TODO Auto-generated method stub
					return false;
				}

				@Override
				public boolean isSecure() {
					// TODO Auto-generated method stub
					return false;
				}

				@Override
				public void removeAttribute(String name) {
					// TODO Auto-generated method stub
					
				}

				@Override
				public void setAttribute(String name, Object o) {
					// TODO Auto-generated method stub
					
				}

				@Override
				public void setCharacterEncoding(String env)
						throws UnsupportedEncodingException {
					// TODO Auto-generated method stub
					
				}

				@Override
				public AsyncContext startAsync() throws IllegalStateException {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public AsyncContext startAsync(ServletRequest servletRequest,
						ServletResponse servletResponse)
						throws IllegalStateException {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public boolean authenticate(HttpServletResponse response)
						throws IOException, ServletException {
					// TODO Auto-generated method stub
					return false;
				}

				@Override
				public String changeSessionId() {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public String getAuthType() {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public String getContextPath() {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public Cookie[] getCookies() {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public long getDateHeader(String name) {
					// TODO Auto-generated method stub
					return 0;
				}

				@Override
				public String getHeader(String name) {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public Enumeration<String> getHeaderNames() {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public Enumeration<String> getHeaders(String name) {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public int getIntHeader(String name) {
					// TODO Auto-generated method stub
					return 0;
				}

				@Override
				public String getMethod() {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public Part getPart(String name) throws IOException,
						ServletException {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public Collection<Part> getParts() throws IOException,
						ServletException {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public String getPathInfo() {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public String getPathTranslated() {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public String getQueryString() {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public String getRemoteUser() {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public String getRequestURI() {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public StringBuffer getRequestURL() {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public String getRequestedSessionId() {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public String getServletPath() {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public HttpSession getSession() {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public HttpSession getSession(boolean create) {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public Principal getUserPrincipal() {
					// TODO Auto-generated method stub
					return null;
				}

				@Override
				public boolean isRequestedSessionIdFromCookie() {
					// TODO Auto-generated method stub
					return false;
				}

				@Override
				public boolean isRequestedSessionIdFromURL() {
					// TODO Auto-generated method stub
					return false;
				}

				@Override
				public boolean isRequestedSessionIdFromUrl() {
					// TODO Auto-generated method stub
					return false;
				}

				@Override
				public boolean isRequestedSessionIdValid() {
					// TODO Auto-generated method stub
					return false;
				}

				@Override
				public boolean isUserInRole(String role) {
					// TODO Auto-generated method stub
					return false;
				}

				@Override
				public void login(String username, String password)
						throws ServletException {
					// TODO Auto-generated method stub
					
				}

				@Override
				public void logout() throws ServletException {
					// TODO Auto-generated method stub
					
				}

				@Override
				public <T extends HttpUpgradeHandler> T upgrade(
						Class<T> handlerClass) throws IOException,
						ServletException {
					// TODO Auto-generated method stub
					return null;
				}
				
			};
		}else{
			request =  ServletActionContext.getRequest();
			uName = ((User)request.getSession().getAttribute("user")).getUid();
		}
		
		if(vehicleApproval.getCheckType()==0){
			if(state==6)//综合办公室审批
			{			
				vehicleApproval.setApprovalOfficeDate(new Date());
				vehicleApproval.setState(8);
				vehicleApproval.setOfficeName(uName);
				vehicleApproval.setOfficeRemark(_vehicleApproval.getOfficeRemark());
				vehicleApproval.setIsapprovalOffice(_vehicleApproval.getIsapprovalOffice());
				
				contractDao.changeState(_vehicleApproval.getContractId(),3);
				
				return vehicleApprovalDao.executeUpdate(vehicleApproval);
			}
			else if(state==3)//计财部审批
			{
				vehicleApproval.setApprovalFinanceDate(new Date());
				vehicleApproval.setState(4);
				vehicleApproval.setFinanceName(uName);
				vehicleApproval.setFinanceRemark(_vehicleApproval.getFinanceRemark());
				vehicleApproval.setIsapprovalFinance(_vehicleApproval.getIsapprovalFinance());
				return vehicleApprovalDao.executeUpdate(vehicleApproval);		
			}
			else if(state==4)//计财部审批
			{
				if(!BooleanUtils.isTrue(contract.getGeneByImport())){
					ActionContext context = ActionContext.getContext();
					String[] rentStr = (String[]) context.getParameters().get("contract.rent");
					if(rentStr!=null&&rentStr.length>0){
						double rent = NumberUtils.toDouble(rentStr[0]);
						contract.setRent(rent);
						ObjectAccess.saveOrUpdate(contract);
					}
				}
				
				vehicleApproval.setFinanceManagerApprovalDate(new Date());
				vehicleApproval.setState(5);
				vehicleApproval.setFinanceManagerName(uName);
				vehicleApproval.setFinanceManagerRemark(_vehicleApproval.getFinanceManagerRemark());
				vehicleApproval.setIsapprovalFinanceManager(_vehicleApproval.getIsapprovalFinanceManager());
				return vehicleApprovalDao.executeUpdate(vehicleApproval);		
			}
//			else if(state==4)//运营管理部-分部经理审批
//			{
//				vehicleApproval.setBranchManagerApprovalDate(new java.util.Date());
//				vehicleApproval.setState(5);
//				vehicleApproval.setBranchManagerName(uName);
//				vehicleApproval.setBranchManagerRemark(_vehicleApproval.getBranchManagerRemark());
//				vehicleApproval.setIsapprovalBranchManager(_vehicleApproval.getIsapprovalBranchManager());
//				return vehicleApprovalDao.executeUpdate(vehicleApproval);		
//			}
			else if(state==1)//运营管理部-保险管理员审批
			{
				String carframeNum = contract.getCarframeNum();
				if(StringUtils.isEmpty(carframeNum)){
					request.setAttribute("msgStr", "车辆信息未录入，无法审批。");
					return false;
				}
				
				List<Insurance> ilist = ObjectAccess.query(Insurance.class, " carframeNum='"+contract.getCarframeNum()+"'");
				boolean hasJQX=false,hasSX = false;
				for(Insurance insurance:ilist){
					if(StringUtils.equalsIgnoreCase(insurance.getInsuranceClass(),"交强险")){
						if(new Date().before(insurance.getEndDate())){
							hasJQX = true;
						}
					}else if (StringUtils.equalsIgnoreCase(insurance.getInsuranceClass(), "商业保险单")) {
						if(new Date().before(insurance.getEndDate())){
							hasSX = true;
						}
					}
				}
				
				if(!hasJQX){
					request.setAttribute("msgStr", "交强险未录入，无法审批。");
					return false;
				}
				
				if(!hasSX){
					request.setAttribute("msgStr", "商险未录入，无法审批。");
					return false;
				}
				
				vehicleApproval.setAssurerApprovalDate(new Date());
				vehicleApproval.setState(2);
				vehicleApproval.setAssurerName(uName);
				vehicleApproval.setAssurerRemark(_vehicleApproval.getAssurerRemark());
				vehicleApproval.setIsapprovalAssurer(_vehicleApproval.getIsapprovalAssurer());
				
				vehicleApproval.setDamageInsurance(_vehicleApproval.getDamageInsurance());
				vehicleApproval.setOnetimeAfterpay(_vehicleApproval.getOnetimeAfterpay());
				
				return vehicleApprovalDao.executeUpdate(vehicleApproval);		
			}
			else if(state==2)//运营管理部-部门经理审批
			{
//				String carframeNum = contract.getCarframeNum();
//				if(StringUtils.isEmpty(carframeNum)){
//					request.setAttribute("msgStr", "车辆信息未录入，无法审批。");
//					return false;
//				}
//				
//				List<Insurance> ilist = ObjectAccess.query(Insurance.class, " carframeNum='"+contract.getCarframeNum()+"'");
//				boolean hasJQX=false,hasSX = false;
//				for(Insurance insurance:ilist){
//					if(StringUtils.equalsIgnoreCase(insurance.getInsuranceClass(),"交强险")){
//						if(new Date().before(insurance.getEndDate())){
//							hasJQX = true;
//						}
//					}else if (StringUtils.equalsIgnoreCase(insurance.getInsuranceClass(), "商业保险单")) {
//						if(new Date().before(insurance.getEndDate())){
//							hasSX = true;
//						}
//					}
//				}
//				
//				if(!hasJQX){
//					request.setAttribute("msgStr", "交强险未录入，无法审批。");
//					return false;
//				}
//				
//				if(!hasSX){
//					request.setAttribute("msgStr", "商险未录入，无法审批。");
//					return false;
//				}
//				
//				if(vehicleApproval.getOperateCardDate()==null){
//					request.setAttribute("msgStr", "营运信息未录入，无法审批。");
//					return false;
//				}
				
				vehicleApproval.setManagerApprovalDate(new Date());
				vehicleApproval.setState(3);
				vehicleApproval.setManagerName(uName);
				vehicleApproval.setManagerRemark(_vehicleApproval.getManagerRemark());
				vehicleApproval.setIsapprovalManager(_vehicleApproval.getIsapprovalManager());
				return vehicleApprovalDao.executeUpdate(vehicleApproval);		
			}
			else if(state==5)//主管副总经理审批
			{
				String carframeNum = contract.getCarframeNum();
				if(StringUtils.isEmpty(carframeNum)){
					request.setAttribute("msgStr", "车辆信息未录入，无法审批。");
					return false;
				}
				
				List<Insurance> ilist = ObjectAccess.query(Insurance.class, " carframeNum='"+contract.getCarframeNum()+"'");
				boolean hasJQX=false,hasSX = false;
				for(Insurance insurance:ilist){
					if(StringUtils.equalsIgnoreCase(insurance.getInsuranceClass(),"交强险")){
						if(new Date().before(insurance.getEndDate())){
							hasJQX = true;
						}
					}else if (StringUtils.equalsIgnoreCase(insurance.getInsuranceClass(), "商业保险单")) {
						if(new Date().before(insurance.getEndDate())){
							hasSX = true;
						}
					}
				}
				
				if(!hasJQX){
					request.setAttribute("msgStr", "交强险未录入，无法审批。");
					return false;
				}
				
				if(!hasSX){
					request.setAttribute("msgStr", "商险未录入，无法审批。");
					return false;
				}
				
				if(vehicleApproval.getOperateCardDate()==null){
					request.setAttribute("msgStr", "营运信息未录入，无法审批。");
					return false;
				}
				
				vehicleApproval.setApprovalDirectorDate(new Date());
				vehicleApproval.setState(6);
				vehicleApproval.setDirectorName(uName);
				vehicleApproval.setDirectorRemark(_vehicleApproval.getDirectorRemark());
				vehicleApproval.setIsapprovalDirector(_vehicleApproval.getIsapprovalDirector());
				vehicleApproval.setDiscountDays(_vehicleApproval.getDiscountDays());
				
				contract.setDiscountDays(vehicleApproval.getDiscountDays());
				ObjectAccess.saveOrUpdate(contract);
				
//				contractDao.changeState(_vehicleApproval.getContractId(),3);
				
				return vehicleApprovalDao.executeUpdate(vehicleApproval);		
			}
			else
				return false;
		}else if(vehicleApproval.getCheckType()==1){
			
			if (state == 1) {
				contract.setAbandonedTime(contract.getAbandonedTime() == null?new Date():contract.getAbandonedTime());
				ObjectAccess.saveOrUpdate(contract);
				vehicleApproval.setAssurerRemark(_vehicleApproval.getAssurerRemark());
				vehicleApproval.setAssurerName(uName);
				vehicleApproval.setAssurerApprovalDate(new Date());
				vehicleApproval.setIsapprovalAssurer(_vehicleApproval.getIsapprovalAssurer());
				vehicleApproval.setState(3);//直接跳过收款员
			} else if (state == 2) {
				vehicleApproval.setCashierRemark(_vehicleApproval.getCashierRemark());
				vehicleApproval.setCashierName(uName);
				vehicleApproval.setCashierApprovalDate(new Date());
				vehicleApproval.setState(3);
			} else if (state == 3) {
				String carframeNum = contract.getCarframeNum();
				
				long count = ObjectAccess.execute(String.format("select count(*) from Accident where carId='%s' and status!=3 ",carframeNum));
				if(count>0){
					request.setAttribute("msgStr", "有事故未处理，无法继续审批。");
					return false;
				}
				
				vehicleApproval.setManagerRemark(_vehicleApproval.getManagerRemark());
				vehicleApproval.setManagerName(uName);
				vehicleApproval.setManagerApprovalDate(new Date());
				vehicleApproval.setState(4);
				vehicleApproval.setIsapprovalManager(_vehicleApproval.getIsapprovalManager());
			}else if (state == 4) {
				vehicleApproval.setOfficeRemark(_vehicleApproval.getOfficeRemark());
				vehicleApproval.setOfficeName(uName);
				vehicleApproval.setApprovalOfficeDate(new Date());
				vehicleApproval.setState(5);
				vehicleApproval.setIsapprovalOffice(_vehicleApproval.getIsapprovalOffice());
			} else if (state == 5) {
				vehicleApproval.setFinanceRemark(_vehicleApproval.getFinanceRemark());
				vehicleApproval.setFinanceName(uName);
				vehicleApproval.setApprovalFinanceDate(new Date());
				vehicleApproval.setState(6);
				vehicleApproval.setIsapprovalFinance(_vehicleApproval.getIsapprovalFinance());
			} else if (state == 6) {
				ActionContext context = ActionContext.getContext();
				String[] rentStr = (String[]) context.getParameters().get("contract.rent");
				if(rentStr!=null&&rentStr.length>0){
					double rent = NumberUtils.toDouble(rentStr[0]);
					contract.setRent(rent);
					ObjectAccess.saveOrUpdate(contract);
				}
				
				vehicleApproval.setFinanceManagerRemark(_vehicleApproval.getFinanceManagerRemark());
				vehicleApproval.setFinanceManagerName(uName);
				vehicleApproval.setFinanceManagerApprovalDate(new Date());
				vehicleApproval.setState(7);
				vehicleApproval.setIsapprovalFinanceManager(_vehicleApproval.getIsapprovalFinanceManager());
			}  else if (state == 7) {
				vehicleApproval.setDirectorRemark(_vehicleApproval.getDirectorRemark());
				vehicleApproval.setDirectorName(uName);
				vehicleApproval.setApprovalDirectorDate(new Date());
				vehicleApproval.setState(8);
				vehicleApproval.setIsapprovalDirector(_vehicleApproval.getIsapprovalDirector());
				
				Vehicle vehicle = ObjectAccess.getObject(Vehicle.class, contract.getCarframeNum());
				vehicle.setDriverId(null);
				
				if(_vehicleApproval.getHandleMatter()){
					vehicle.setState(3);
				}else{
					vehicle.setState(2);
					chargeDao.planTransfer(contract.getId(), DateUtil.getNextMonth(contract.getAbandonedTime()),contract.getId(),contract.getAbandonedTime());
					List<String> dl = Arrays.<String>asList(vehicle.getFirstDriver(),vehicle.getSecondDriver(),vehicle.getTempDriver());

					for(int i=0;i<dl.size();i++){
						String idNum = dl.get(i);
						if(!StringUtils.isEmpty(idNum)) {
							Driver d = ObjectAccess.getObject(Driver.class, idNum);
							if (d != null && d.getDriverClass() != null) {
								if (d.getDriverClass().equals("主驾")) {
									vehicle.setFirstDriver(null);
								} else if (d.getDriverClass().equals("副驾")) {
									vehicle.setSecondDriver(null);
								} else if (d.getDriverClass().equals("临驾")) {
									vehicle.setTempDriver(null);
								}


								Driverincar record = new Driverincar(d.getCarframeNum(), d.getIdNum(), "下车", new Date());
								driverService.addDriverInCarRecord(record);

								d.setIsInCar(false);

								d.setRestTime(null);
								d.setCarframeNum(null);
								d.setDriverClass(null);
								d.setBusinessApplyTime(null);
								d.setBusinessApplyRegistrant(null);
								d.setBusinessApplyRegistTime(null);

								d.setBusinessReciveTime(null);
								d.setBusinessReciveRegistrant(null);
								d.setBusinessReciveRegistTime(null);

								d.setBusinessApplyCancelTime(null);
								d.setBusinessApplyCancelRegistrant(null);
								d.setBusinessApplyCancelRegistTime(null);

								d.setDept(null);

								ObjectAccess.saveOrUpdate(d);
							}
						}
					}

					ObjectAccess.saveOrUpdate(vehicle);

					contract.setAbandonedFinalTime(new Date());
				}
								
//				switch(contract.getAbandonReason()){
//				case "合同终止":
//					vehicle.setState(2);
//					break;
//				case "欠费":
//				case "转租":
//					vehicle.setState(3);
//					break;
//				}
				

				ObjectAccess.saveOrUpdate(contract);
				
				contractDao.changeState(_vehicleApproval.getContractId(),1);
			} 
			
			return vehicleApprovalDao.executeUpdate(vehicleApproval);		
		}else{
			return false;
		}
	}
	@Autowired
	private ChargeDao chargeDao;
	@Autowired
	private DriverService driverService;

	public void setDriverService(DriverService driverService) {
		this.driverService = driverService;
	}

	public VehicleApproval queryVehicleApprovalById(Integer approvalId) {
		return vehicleApprovalDao.queryVehicleApprovalById(approvalId);
	}
	
	public VehicleApproval queryVehicleApprovalByContractId(Integer contractId){
		return vehicleApprovalDao.queryVehicleApprovalByContractId(contractId);
	}
	
	public void setContractDao(ContractDao contractDao) {
		this.contractDao = contractDao;
	}

	public void setVehicleApprovalDao(VehicleApprovalDao vehicleApprovalDao) {
		this.vehicleApprovalDao = vehicleApprovalDao;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, List<ToDo>> waitToDo(Role role) {
		Map<String, List<ToDo>> map = new TreeMap<String, List<ToDo>>();
		List<ToDo> toDolist = new ArrayList<ToDo>();
		List<VehicleApproval> approvalList;
		
		switch(role.getRname()){
		case "分部经理":
			break;
		case "运营部经理":
			approvalList = vehicleApprovalDao.queryVehicleApprovalByState((short) 0,2);
			toDolist.addAll((List<ToDo>) CollectionUtils.collect(approvalList, new VehicleApprovalWaitDealTransformer()));
			break;
		case "副总经理":
			approvalList = vehicleApprovalDao.queryVehicleApprovalByState((short) 0,5);
			toDolist.addAll((List<ToDo>) CollectionUtils.collect(approvalList, new VehicleApprovalWaitDealTransformer()));
			break;
		case "保险员":
			approvalList = vehicleApprovalDao.queryVehicleApprovalByState((short) 0,1);
			toDolist.addAll((List<ToDo>) CollectionUtils.collect(approvalList, new VehicleApprovalWaitDealTransformer()));
			break;
		case "收款员":
			
			break;
		case "财务负责人":
			approvalList = vehicleApprovalDao.queryVehicleApprovalByState((short) 0,3);
			toDolist.addAll((List<ToDo>) CollectionUtils.collect(approvalList, new VehicleApprovalWaitDealTransformer()));
			break;
		case "财务经理":
			approvalList = vehicleApprovalDao.queryVehicleApprovalByState((short) 0,4);
			toDolist.addAll((List<ToDo>) CollectionUtils.collect(approvalList, new VehicleApprovalWaitDealTransformer()));
			break;
		case "办公室主任":
			approvalList = vehicleApprovalDao.queryVehicleApprovalByState((short) 0,6);
			toDolist.addAll((List<ToDo>) CollectionUtils.collect(approvalList, new VehicleApprovalWaitDealTransformer()));
			break;
		case "证照员":
		
			break;
		default:
			break;
		}
		map.put("开业审批", toDolist);
		
		toDolist = new ArrayList<ToDo>();
		switch(role.getRname()){
		case "分部经理":
			break;
		case "运营部经理":
			approvalList = vehicleApprovalDao.queryVehicleApprovalByState((short) 1,3);
			toDolist.addAll((List<ToDo>) CollectionUtils.collect(approvalList, new VehicleApprovalWaitDealTransformer("废业审批")));
			break;
		case "副总经理":
			approvalList = vehicleApprovalDao.queryVehicleApprovalByState((short) 1,7);
			toDolist.addAll((List<ToDo>) CollectionUtils.collect(approvalList, new VehicleApprovalWaitDealTransformer("废业审批")));
			break;
		case "保险员":
			approvalList = vehicleApprovalDao.queryVehicleApprovalByState((short) 1,1);
			toDolist.addAll((List<ToDo>) CollectionUtils.collect(approvalList, new VehicleApprovalWaitDealTransformer("废业审批")));
			break;
		case "收款员":
			//approvalList = vehicleApprovalDao.queryVehicleApprovalByState((short) 1,2);
			//toDolist.addAll((List<ToDo>) CollectionUtils.collect(approvalList, new VehicleApprovalWaitDealTransformer("废业审批")));
			break;
		case "财务负责人":
			approvalList = vehicleApprovalDao.queryVehicleApprovalByState((short) 1,5);
			toDolist.addAll((List<ToDo>) CollectionUtils.collect(approvalList, new VehicleApprovalWaitDealTransformer("废业审批")));
			break;
		case "财务经理":
			approvalList = vehicleApprovalDao.queryVehicleApprovalByState((short) 1,6);
			toDolist.addAll((List<ToDo>) CollectionUtils.collect(approvalList, new VehicleApprovalWaitDealTransformer("废业审批")));
			break;
		case "办公室主任":
			approvalList = vehicleApprovalDao.queryVehicleApprovalByState((short) 1,4);
			toDolist.addAll((List<ToDo>) CollectionUtils.collect(approvalList, new VehicleApprovalWaitDealTransformer("废业审批")));
			break;
		case "证照员":
			break;
		default:
			break;
		}
		map.put("废业审批", toDolist);
		
		return map;
	}
	
	
	private static class VehicleApprovalWaitDealTransformer implements Transformer {
		private String base;
		
		public VehicleApprovalWaitDealTransformer(){
			this("开业审批");
		}
		
		public VehicleApprovalWaitDealTransformer(String base){
			this.base = base;
		}
		
		@Override
		public Object transform(Object arg0) {
			VehicleApproval comp =(VehicleApproval) arg0;
			String msg = base + geneMsg(comp);
		
			return new ToDo(msg,"待审核","/DZOMS/vehicle/vehicleApprovalPreUpdate.action?vehicleApproval.id="+comp.getId());
		}

		protected String geneMsg(VehicleApproval comp) {
			String msg = "";
			try{
				int cid = comp.getContractId();
				Contract c = (Contract) ObjectAccess.getObject("com.dz.module.contract.Contract", cid);
				List<String> sl = new ArrayList<String>();
				
				if(StringUtils.isNotEmpty(c.getCarframeNum()))
					sl.add("车架号:"+c.getCarframeNum());
				if(StringUtils.isNotEmpty(c.getCarNum()))
					sl.add("车牌号:"+c.getCarNum());
				if(StringUtils.isNotEmpty(c.getIdNum())){
					Driver d = (Driver) ObjectAccess.getObject("com.dz.module.driver.Driver", c.getIdNum());
					sl.add("承租人:"+d.getName());
				}
					
				msg = sl.toString();
			}catch(Exception e){
				e.printStackTrace();
			}
			return msg;
		}
	}
 }
