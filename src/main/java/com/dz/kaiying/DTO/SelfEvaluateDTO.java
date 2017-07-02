package com.dz.kaiying.DTO;
// default package

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * Authority entity. @author MyEclipse Persistence Tools
 */
public class SelfEvaluateDTO implements java.io.Serializable {

	/**
	 *工作自评DTO
	 */
	private static final long serialVersionUID = -7885510207958408068L;
	private Map<Integer, String> inputs;
	private Integer ziping;//分数
	HttpServletRequest request;

	public HttpServletRequest getRequest() {
		return request;
	}

	public void setRequest(HttpServletRequest request) {
		this.request = request;
	}

	public static long getSerialVersionUID() {
		return serialVersionUID;
	}

	public Map<Integer, String> getInputs() {
		return inputs;
	}

	public void setInputs(Map<Integer, String> inputs) {
		this.inputs = inputs;
	}

	public Integer getZiping() {
		return ziping;
	}

	public void setZiping(Integer ziping) {
		this.ziping = ziping;
	}
}