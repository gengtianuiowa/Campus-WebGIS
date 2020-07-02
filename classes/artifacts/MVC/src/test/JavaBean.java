package test;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class JavaBean {
	private String username;
	private String password;
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public boolean judge() throws ClassNotFoundException, SQLException{
//		boolean a=false,b=false;
		
		Statement stmt=JDBC.connect().createStatement();
		ResultSet r=stmt.executeQuery("select username,password from login");
		
		while(r.next())
		{
			if(this.getUsername().equals(r.getString("username"))&&this.getPassword().equals(r.getString("password")))
			{
				return true;
			}
//			else{					
//				return false;
//			}
		}
		return false;
//		for(int i=0;i<JDBC.passwordjudge.length;i++)
//		{
//			if(password==JDBC.passwordjudge[i])
//			{
//				b=true;
//				break;
//			}else{
//				b=false;
//			}
//		}
//		
//		if(a&&b){
//			return true;
//		}else{
//			return false;
//		}
	}
	
	public boolean registerJudge() throws ClassNotFoundException, SQLException{
		Statement stmt=JDBC.connect().createStatement();
		ResultSet r=stmt.executeQuery("select username,password from userlist");
		
		while(r.next())
		{
			if(this.getUsername().equals(r.getString("username")))
			{
				return false;
			}
		}
		return true;
	}
	
	public static void print() throws SQLException, ClassNotFoundException{
//		Connection connectStudent=Cnct.getConnection();//连接数据库	
		Statement check=JDBC.connect().createStatement();
		ResultSet rs = check.executeQuery("SELECT username,password FROM userlist");
	        //如果有数据，rs.next()返回true
	     while(rs.next()){
	            System.out.println(rs.getString("username")+"   "+rs.getString("password"));
	     }
	}
	public static void main(String[] args) throws ClassNotFoundException, SQLException {
		JavaBean.print();
	}
}
