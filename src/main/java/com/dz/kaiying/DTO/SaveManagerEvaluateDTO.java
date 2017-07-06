package com.dz.kaiying.DTO;
// default package

import java.util.List;

/**
 * Authority entity. @author MyEclipse Persistence Tools
 */
public class SaveManagerEvaluateDTO implements java.io.Serializable {

	/**
	 *工作自评DTO
	 */
	private List<SaveManagerEvaluateDetailDTO> managerEvaluate;
	private Integer total;

	public List<SaveManagerEvaluateDetailDTO> getManagerEvaluate() {
		return managerEvaluate;
	}

	public void setManagerEvaluate(List<SaveManagerEvaluateDetailDTO> managerEvaluate) {
		this.managerEvaluate = managerEvaluate;
	}

	public Integer getTotal() {

		return total;
	}

	public void setTotal(Integer total) {
		this.total = total;
	}
	//	{
//			"total":100
//			"selfEvaluate": [
//		{
//			"id": 1,
//				"inputs": [
//			"1",
//					"2"
//			],
//			"score": 1
//		}
//		]
//	}





}