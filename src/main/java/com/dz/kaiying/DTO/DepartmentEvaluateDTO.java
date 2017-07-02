package com.dz.kaiying.DTO;
// default package

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * Authority entity. @author MyEclipse Persistence Tools
 */
public class DepartmentEvaluateDTO implements java.io.Serializable {

	/**
	 *部门考评DTO
	 */
	private static final long serialVersionUID = -7885510207958408068L;
	private Map<Integer, String> inputs;
	private Integer ziping;//分数
	HttpServletRequest request;

	public HttpServletRequest getRequest() {
		return request;
	}


}