package com.dz.module.vehicle;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import com.dz.common.global.BaseAction;
import com.dz.common.global.Page;
import com.dz.common.other.ObjectAccess;
import com.dz.common.other.PageUtil;
import com.dz.module.driver.Driver;

@Controller
@Scope("prototype")
public class InsuranceAction extends BaseAction{
	@Autowired
	private InsuranceService insuranceService;
	private Insurance insurance;
	private Vehicle vehicle;
	private Driver driver;
	
	
	public String addInsurance() {
		try{
			insuranceService.addInsurance(insurance);
		}catch(Exception e){
			return ERROR;
		}
		return SUCCESS;
		
	}

	
	public String updateInsurance() {
		try{
			insuranceService.updateInsurance(insurance);
		}catch(Exception e){
			return ERROR;
		}
		return SUCCESS;
	}

	
	public String deleteInsurance() {
		try{
			insuranceService.deleteInsurance(insurance);
		}catch(Exception e){
			return ERROR;
		}
		return SUCCESS;
	}

	public String selectByCondition(){
		int currentPage = 0;
        String currentPagestr = request.getParameter("currentPage");
        if(currentPagestr == null || "".equals(currentPagestr)){
        	currentPage = 1;
        }else{
        	currentPage=Integer.parseInt(currentPagestr);
        }
       //vehicle.setCarMode("123");
       Page page = PageUtil.createPage(15, insuranceService.selectByConditionCount(insurance), currentPage);
		List<Insurance> l = insuranceService.selectByCondition(page, insurance);
		request.setAttribute("insurance", l);
		//request.setAttribute("currentPage", currentPage);
		request.setAttribute("page", page);
		return SUCCESS;
	}
	
	public String insuranceSelectById(){
		this.insurance = (Insurance) ObjectAccess.getObject(Insurance.class, insurance.getId());
		return SUCCESS;
	}
	
	public List<Insurance> selectAll() {
		return insuranceService.selectAll();
	}

	
	public List<Insurance> selectByVehicle() {
		return insuranceService.selectByVehicle(vehicle);
	}

	
	public List<Insurance> selectByDriver() {
		return insuranceService.selectByDriver(driver);
	}


	public Insurance getInsurance() {
		return insurance;
	}


	public Vehicle getVehicle() {
		return vehicle;
	}


	public Driver getDriver() {
		return driver;
	}


	public void setInsuranceService(InsuranceService insuranceService) {
		this.insuranceService = insuranceService;
	}


	public void setInsurance(Insurance insurance) {
		this.insurance = insurance;
	}


	public void setVehicle(Vehicle vehicle) {
		this.vehicle = vehicle;
	}


	public void setDriver(Driver driver) {
		this.driver = driver;
	}
	

}
