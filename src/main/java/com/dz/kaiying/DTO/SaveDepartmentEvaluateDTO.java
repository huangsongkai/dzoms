package com.dz.kaiying.DTO;
// default package

import java.util.List;

/**
 * Authority entity. @author MyEclipse Persistence Tools
 */
public class SaveDepartmentEvaluateDTO implements java.io.Serializable {

	/**
	 *部门评价DTO
	 */
	private List<SaveDepartmentEvaluateDetailDTO> departmentEvaluate;
	private Integer total;


	public List<SaveDepartmentEvaluateDetailDTO> getDepartmentEvaluate() {
		return departmentEvaluate;
	}

	public void setDepartmentEvaluate(List<SaveDepartmentEvaluateDetailDTO> departmentEvaluate) {
		this.departmentEvaluate = departmentEvaluate;
	}

	public Integer getTotal() {
		return total;
	}

	public void setTotal(Integer total) {
		this.total = total;
	}
	//	{
//			"personId":123
//			"total":100
//			"departmentEvaluate": [
//		{
//			"id": 1,
//			"score": 10
//		}
//		]
//	}





}