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
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->

  </head>
  
  <body>
  <form action="loginServlet" method="get">
    <table align="center" style="margin-top:300px">
    
    <tr>
    <td colspan="2" align="center"><h1>地图登录</h1></td>
    </tr>
    
    <tr>
    <td>用户名：</td>
    <td><input id="n" type="text" name="username"></td>
    </tr>
    
     <tr>
    <td>密码：</td>
    <td><input id="p" type="text" name="password"></td>
    </tr>
    
    <tr>
    <td colspan="2" align="center"><input type="button" value="登录" onclick="login()"></td>
    </tr>
    
    <tr>
    <td align="center"><a href="register.jsp">新用户注册</a></td>
    <td align="center"><a href="first.jsp" >游客浏览</a></td>
    </tr>
    </table>
  </form>

  </body>
</html>
<script>
function login(){
	var n=document.getElementById("n").value;
    var p=document.getElementById("p").value;
    	
     $.ajax({ 
    type:"get",
    data:{
    setusername:n,
    setpassword:p
    },
    url:"RegisterServlet2",
    dataType:"text",
    Success:function(result){
   	alert("登录成功！")
    },
    error:function(errorMsg){
    //window.location.href="";
    alert("服务器连接异常！");
    }
    });
    }


</script>
