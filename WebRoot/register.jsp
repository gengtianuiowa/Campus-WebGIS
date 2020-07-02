<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
      <script src="http://apps.bdimg.com/libs/jquery/2.1.4/jquery.min.js"></script>
    <title>注册界面</title>
    
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
  <form  method="get"  onsubmit="return checkpassword()">
    <table align="center" style="margin-top:300px">
    
    <tr>
    <td colspan="2" align="center"><h1>用户注册</h1></td>
    </tr>

    <tr>
    <td>用户名：</td>
    <td><input type="text" name="setusername" id="n"></td>
    </tr>
  
     <tr>
    <td>密码：</td>
    <td><input type="text" name="setpassword" id="p"></td>
    </tr>
    
      <tr>
    <td>确认密码：</td>
    <td><input type="text" name="passwordconfirm"></td>
    </tr>
            
    <tr>
    <td colspan="2" align="center"><p id="alert"></p></td>
    </tr>
    
    <tr>
    <td align="center"><input type="button" value="注册" onclick="checkpassword()"></td>
    <td align="center"><button type="reset">重设</button></td>
    </tr>
    
    <tr>
    <td align="center"  colspan="2"><a href="login.jsp">返回登录界面</a></td>
    </tr>
    </table>
    </form>
    <script>
    
    function checkpassword(){
    	if(document.getElementsByName("setpassword")[0].value!=document.getElementsByName("passwordconfirm")[0].value)
    	{
    		//alert("两次输入的密码不一致！");
    		document.getElementById("alert").innerHTML="两次输入的密码不一致！";
    		document.getElementById("alert").style.color="red";
    	}
    	else{
    var n=document.getElementById("n").value;
    var p=document.getElementById("p").value;
    	
     $.ajax({ 
    type:"get",
    data:{
    setusername:n,
    setpassword:p
    },
    url:"RegisterServlet",
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
    	}

    </script>
  </body>
</html>
