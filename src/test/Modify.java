package test;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class Modify extends HttpServlet {

	/**
	 * Constructor of the object.
	 */
	public Modify() {
		super();
	}

	/**
	 * Destruction of the servlet. <br>
	 */
	public void destroy() {
		super.destroy(); // Just puts "destroy" string in log
		// Put your code here
	}

	/**
	 * The doGet method of the servlet. <br>
	 *
	 * This method is called when a form has its tag value method equals to get.
	 * 
	 * @param request the request send by the client to the server
	 * @param response the response send by the server to the client
	 * @throws ServletException if an error occurred
	 * @throws IOException if an error occurred
	 */
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		
	}

	/**
	 * The doPost method of the servlet. <br>
	 *
	 * This method is called when a form has its tag value method equals to post.
	 * 
	 * @param request the request send by the client to the server
	 * @param response the response send by the server to the client
	 * @throws ServletException if an error occurred
	 * @throws IOException if an error occurred
	 */
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		
		//解决中文乱码
		response.setContentType("text/html;charset=utf-8");
		//请求解决乱码
		request.setCharacterEncoding("utf-8");
		//响应解决乱码
		response.setCharacterEncoding("utf-8");
		String type_s=request.getParameter("type");
		Modify_JDBC m=new Modify_JDBC();
		if(type_s.equals("0"))
		{
			String x_s=request.getParameter("x");
			String y_s=request.getParameter("y");
			String category_s=request.getParameter("category");
			String note_s=request.getParameter("note");
			String imgData=request.getParameter("imgData");
			float x=Float.parseFloat(x_s);
			float y=Float.parseFloat(y_s);
			if(m.insert(x, y,category_s,note_s,imgData))
			{
				PrintWriter out = response.getWriter();
				out.println("success");
			}
		}

		if(type_s.equals("showPic"))
		{
			String POI_fid=request.getParameter("POI_fid");
			PrintWriter out = response.getWriter();
			out.println(m.picConvert(POI_fid));
		}
		
		if(type_s.equals("modify"))
		{
			String x_s=request.getParameter("x");
			String y_s=request.getParameter("y");
			String POI_fid=request.getParameter("id");
			float x=Float.parseFloat(x_s);
			float y=Float.parseFloat(y_s);
			if(m.modify(x, y, POI_fid))
			{
				PrintWriter out = response.getWriter();
				out.println("success");
			}else
			{
				PrintWriter out = response.getWriter();
				out.println("fail");
			}
		}
	}

	/**
	 * Initialization of the servlet. <br>
	 *
	 * @throws ServletException if an error occurs
	 */
	public void init() throws ServletException {
		// Put your code here
	}

}
