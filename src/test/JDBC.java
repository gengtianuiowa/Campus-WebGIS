package test;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

//import javax.servlet.jsp.jstl.sql.Result;

public class JDBC {

	private static final String URL="jdbc:postgresql://localhost:5432/Register";
	private static final String DATABASENAME="postgres";
	private static final String PASSWORD="970202";
	
	public static String[] namejudge=new String[100];
	public static String[] passwordjudge=new String[100];

	public static Connection connect() throws SQLException, ClassNotFoundException{
		Class.forName("org.postgresql.Driver");
		Connection c=DriverManager.getConnection(URL,DATABASENAME,PASSWORD);
		return c;
	}

	public static void search() throws SQLException, ClassNotFoundException{
		Statement stmt=JDBC.connect().createStatement();
		ResultSet r=stmt.executeQuery("select username,password from accountlist");
		int p=0;
		while(r.next()){
			namejudge[p]=r.getString("username");
			passwordjudge[p]=r.getString("password");
			p++;
		}
	}
}
