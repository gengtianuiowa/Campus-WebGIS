package test;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class Register {
	private static final String URL="jdbc:postgresql://localhost:5432/login";
	private static final String DATABASENAME="postgres";
	private static final String PASSWORD="970202";
	public int i;
	public String username;
	public String password;
	
	Register(int i,String username,String password){
		this.username=username;
		this.password=password;
		this.i=i;
	}
	
	public static Connection connect() throws SQLException, ClassNotFoundException{
		//Class.forName("org.postgresql.Driver");
		Connection c=DriverManager.getConnection(URL,DATABASENAME,PASSWORD);
		return c;
	}
	
	public static void createTable() throws SQLException, ClassNotFoundException{
		Statement stmt=Register.connect().createStatement();
		stmt.executeUpdate("CREATE TABLE userlist(username TEXT PRIMARY KEY,password TEXT)");
	}
	
	public void insert(Register r) throws SQLException, ClassNotFoundException{
		Statement stmt=Register.connect().createStatement();
		stmt.executeUpdate("INSERT INTO login(id,username,password) VALUES('"+r.i+"','"+r.username+"','"+r.password+"')");
	}
	
	public static void main(String[] args) throws SQLException, ClassNotFoundException {
//		Register r1=new Register(1,"tiangeng66","970202");
//		Register r2=new Register(2,"sunyifan","AK47sunyifan6");
		Register.createTable();
//		r1.insert(r1);
//		r2.insert(r2);
	}
	
}
