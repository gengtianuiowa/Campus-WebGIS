<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>登录界面</title>
    <script src="http://apps.bdimg.com/libs/jquery/2.1.4/jquery.min.js"></script>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	
	<!-- 修改页面图标 -->
	<link rel="shortcut icon"href="images/favicon.ico">
	
	<!-- 导入SS文件 -->
	<!-- <link href="css/style.css" rel='stylesheet' type='text/css' /> -->
	
  </head>
  
<body>
	<div class="main">
		<div class="login-form">
			<h1>MrFrostMap 欢迎您</h1>
			
			<form name="loginform" action="loginServlet" method="get">
				<input type="text" id="username" name="username"  class="text" name="username" value="请输入用户名" onfocus="this.value = '';" onblur="if (this.value == '') {this.value = '请输入用户名';}">
			<input type="password" id="password" name="password" value="Password"  name="password" onfocus="this.value = '';" onblur="if (this.value == '') {this.value = 'Password';}">
				<input type="submit" value="登录" >
				<p><a href="register.jsp">新用户注册</a><a>|      |</a>	<a href="ForVisitor.jsp" >游客浏览</a></p>
			</form>
			
		</div>
	</div>
 </body>
 <script>
	function login()
			 {
			 	var username=document.getElementById("username").value;
			 	var password=document.getElementById("password").value;
	        	$.ajax({
	        		type:"GET",
	        		data:{username:username,
	        		password:password},
	        		url:"servlet/loginServlet",
	        		dataType:"text",
	        		success:function(result){
	        				if(result=="right")
	        				{
	        					window.location.href="map.jsp";
	        				}
	        				else
	        				{
	        					alert("密码错误");
	        				}

            				}
            				
            			});
			 }
</script>
</html>