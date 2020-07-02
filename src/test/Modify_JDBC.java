package test;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import com.sun.org.apache.xerces.internal.impl.dv.util.Base64;

import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;

public class Modify_JDBC {
	private static final String URL="jdbc:postgresql://localhost:5432/tgmap";
	private static final String DATABASENAME="postgres";
	private static final String PASSWORD="970202";

	public static Connection connect() throws SQLException, ClassNotFoundException{
		Class.forName("org.postgresql.Driver");
		Connection c=DriverManager.getConnection(URL,DATABASENAME,PASSWORD);
		return c;
	}

	public boolean insert(float x, float y,String category,String note,String imagedata)  {
		Statement stmt;
		int updateCount=0;
		try {
			int commaPlace=imagedata.indexOf(",");
			String imgBase64 = imagedata.substring(commaPlace+1);
			String pictype=imagedata.substring(0,commaPlace+1);
			System.out.println(imgBase64);
			stmt = Modify_JDBC.connect().createStatement();
			updateCount=stmt.executeUpdate("insert into poi_p(note,category,geom,id,pic,picType) values('"+note+"','"+category+"',ST_GeomFromText('Point("+x+" "+y+")'),9999,decode('" +imgBase64 +"','base64'),'"+pictype+"')");
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-gen	erated catch block
			e.printStackTrace();
		}
		if(updateCount>0)
			return true;
		else
			return false;
	}
	
	public String picConvert(String fid)
	{

		Statement stmt;
		try {
			stmt = Modify_JDBC.connect().createStatement();
			int commaPlace=fid.indexOf(".");
			String id_s=fid.substring(commaPlace+1);
			int id= Integer.parseInt(id_s);
			ResultSet r=stmt.executeQuery("select * from poi_p where gid="+id);
			InputStream in;
			String pictype ;
			String encodedText;
			while(r.next()){
				in = r.getBinaryStream("pic");
				pictype = r.getString("pictype");
				byte[] pic;
				try {
					pic = new byte[in.available()];
					in.read(pic);
					in.close();
					BASE64Encoder encoder = new BASE64Encoder();
					encodedText = encoder.encode(pic);
 					String rst = pictype+ encodedText;
					return rst;
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "";
	}
		
	
	public boolean modify(float x, float y,String fid)  {
		int updateCount=0;
		try {
			Statement stmt;
			try {
				stmt = Modify_JDBC.connect().createStatement();
				int commaPlace=fid.indexOf(".");
				String id_s=fid.substring(commaPlace+1);
				int id= Integer.parseInt(id_s);
				updateCount=stmt.executeUpdate("UPDATE poi_p SET geom = ST_GeomFromText('Point("+x+" "+y+")') WHERE gid = "+id);
			} catch (ClassNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		if(updateCount>0)
			return true;
		else
			return false;
	}
}

