package com.dz.module.user;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.Predicate;
import org.apache.commons.lang.StringUtils;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import com.dz.common.global.BaseAction;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@Scope("prototype")
public class UserAction extends BaseAction {

	private final class AuthorityPredicate implements Predicate {
		private String mname,tname;
		
		@SuppressWarnings("unused")
		public AuthorityPredicate(String mname) {
			this(mname,null);
		}
		
		public AuthorityPredicate(String mname,String tname) {
			this.mname=mname;
			this.tname=tname;
			
		}

		@Override
		public boolean evaluate(Object arg0) {
			Authority authority = (Authority) arg0;
			
			return StringUtils.equals(mname, authority.getMname())
					&& StringUtils.equals(tname, authority.getTname());
		}
	}

	private User user; // 定义值对象
	@Autowired
	private UserService userService; // 定义值对象
	
	private int theme;

	public UserService getUserService() {
		return userService;
	}

	public void setUserService(UserService userService) {
		this.userService = userService;
	}

	/**
	 * 通过DomainModel方式接收参数
	 * 
	 * @param user
	 */
	public void setUser(User user) {
		this.user = user;
	}

	public User getUser() {
		return user;
	}

	/*
	 * public String userSave() { System.out.println(user);
	 * 
	 * public String userSave() { boolean flag = userService.saveUser(user); if
	 * (!flag) { return ERROR; }
	 * 
	 * return SUCCESS; }
	 */

	public String userLogin() {
		request = ServletActionContext.getRequest();
		session = request.getSession();
		
		String result = userService.userLogin(user);
		Relation_urDaoImpl relation = new Relation_urDaoImpl();
		if (result.equals("error_uname")) {
			request.setAttribute("msgStr", "用户名不存在！");
			return "login_failed";
		} else if (result.equals("error_upwd")) {
			request.setAttribute("msgStr", "密码不正确！");
			return "login_failed";
		} else{
			Map<String, List<Authority>> menuItems = new HashMap<String, List<Authority>>();
			ArrayList<Authority> authority  = relation.queryAuthorityByUser(result);
			session.setAttribute("currentmatter",userService.getCurrentMatter(authority));
			session.setAttribute("authority", authority);
			User _user = userService.getUser(user);
			session.setAttribute("user",_user);

			List<Role> roles = relation.queryRoleByUser(""+_user.getUid());
			session.setAttribute("roles", roles);
			
			for(int i = 0;i<authority.size();i++)
			{
				String gname = authority.get(i).getGname();
				String mname = authority.get(i).getMname();
				String tname = authority.get(i).getTname();
				
				if(!menuItems.containsKey(gname))		//添加一级菜单项
				{
					menuItems.put(gname, new ArrayList<Authority>());
				}
				
				
				if(!CollectionUtils.exists(menuItems.get(gname), new AuthorityPredicate(mname,tname)))	//添加二级菜单项
				{
					menuItems.get(gname).add(authority.get(i));
				}
			}
			session.setAttribute("menuItems", menuItems);
			return "login_success";
		}
	}
	
	/*通过.NET客户端登陆*/
	public void userLoginFromOut() throws IOException{
		request = ServletActionContext.getRequest();
		session = request.getSession();
		
		ServletActionContext.getResponse().setContentType("application/json");
		ServletActionContext.getResponse().setCharacterEncoding("utf-8");
		PrintWriter out = ServletActionContext.getResponse().getWriter();
		
		JSONObject json = new JSONObject();
		
		String result = userService.userLogin(user);
		Relation_urDaoImpl relation = new Relation_urDaoImpl();
		if (result.equals("error_uname")) {
			json.put("state", "error");
			json.put("msg",  "用户名不存在！");
		} else if (result.equals("error_upwd")) {
			json.put("state", "error");
			json.put("msg",  "密码不正确！");
		} else{
			User _user = userService.getUser(user);
			session.setAttribute("user",_user);

			List<Role> roles = relation.queryRoleByUser(""+_user.getUid());
			session.setAttribute("roles", roles);
			
			JSONArray jarr = new JSONArray();
			for (Role role : roles) {
				if(role.getRname().equals("聘用录入")){
					jarr.add("聘用录入");
				}else if(role.getRname().equals("发票销售")){
					jarr.add("发票销售");
				}else if(role.getRname().equals("驾驶员修改")){
					jarr.add("驾驶员修改");
				}
			}
			
			json.put("state","success");
			json.put("msg",  "登录成功！");
			json.put("roles", jarr);	
		}
		
		out.print(json.toString());
		out.flush();
		out.close();
	}
	
	public String userLogout(){
		session.removeAttribute("user");
		request.setAttribute("msgStr", "账户已退出！");
		return "login_failed";
	}

	public int getTheme() {
		return theme;
	}

	public void setTheme(int theme) {
		this.theme = theme;
	}
	
	
}
