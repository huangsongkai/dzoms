package com.dz.kaiying.DTO;
// default package

import java.util.List;

/**
 * Authority entity. @author MyEclipse Persistence Tools
 */
public class SaveSelfEvaluateDTO implements java.io.Serializable {

	/**
	 *工作自评DTO
	 */
	private List<SaveSelfEvaluateDetailDTO> selfEvaluate;
	private Integer total;
	public List<SaveSelfEvaluateDetailDTO> getSelfEvaluate() {
		return selfEvaluate;
	}

	public void setSelfEvaluate(List<SaveSelfEvaluateDetailDTO> selfEvaluate) {
		this.selfEvaluate = selfEvaluate;
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