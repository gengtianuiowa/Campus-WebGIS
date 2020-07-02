<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<% 
			session.setAttribute("username","游客");
			session.setAttribute("flag", false);
        	pageContext.forward("map.jsp");
%>
