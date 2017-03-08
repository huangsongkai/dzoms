package com.dz.common.global;

import java.lang.reflect.InvocationTargetException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.struts2.interceptor.ServletRequestAware;

public abstract class BaseAction implements ServletRequestAware{
	protected HttpServletRequest request;
	protected HttpSession session;

	@Override
	public void setServletRequest(HttpServletRequest request) {
		this.request = request;
		this.session = request.getSession();
	}
	
	public static final String SUCCESS = "success";
	public static final String ERROR = "error";
	
	public static String checkAndGenerate(Object obj,String field,String format){
		if(obj!=null){
			try {
				Object prop = BeanUtils.getProperty(obj, field);
				if(prop!=null&&!StringUtils.isEmpty(prop.toString())){
					return String.format(format, prop.toString());
				}
			} catch (IllegalAccessException | InvocationTargetException
					| NoSuchMethodException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return "";
	}
	
	public static String checkAndGenerate(Object obj,String field){
		return checkAndGenerate(obj,field," and "+field+" = '%s' ");
	}
	
	protected String url;

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}
}
