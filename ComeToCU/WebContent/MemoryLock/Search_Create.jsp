<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.*"%>
<%@ page import="java.sql.*"%>
<%
	String E_Mail = request.getParameter("E_Mail");
//	String PW = request.getParameter("PW");

	JSONObject jsonMain = new JSONObject();
	JSONArray jArray = new JSONArray();

	//json을 만드는 부분인데,, 설명을 못쓰겠습니다. 고수님들 도와주세요.~
	Connection conn = null;

	try {
		Class.forName("com.mysql.jdbc.Driver");
		conn = DriverManager.getConnection(
				"jdbc:mysql://localhost:3306/seongjun0926",
				"seongjun0926", "tjdwns3721");

		Statement stmt = conn.createStatement();
		//스테이트먼트 객체를 생성합니다.
		String query = "select * from M_Create where M_C_Creator='"+E_Mail+"'";
		//db에 날릴 쿼리문을 생성합니다. 

		ResultSet rs = stmt.executeQuery(query);
		//쿼리를 실행합니다. 
		int total = 0;
		while (rs.next()) {
			//널 이면 넘어가게 만들어야함
			total=1;
			JSONObject jObject = new JSONObject();

			jObject.put("Check", "succed");
			jObject.put("M_C_Num", rs.getString("M_C_Num"));
			jObject.put("M_C_Creator", rs.getString("M_C_Creator"));
			jObject.put("M_C_Text", rs.getString("M_C_Text"));
			jObject.put("M_C_Contents","http://seongjun0926.cafe24.com/MemoryLock/Upload/img/"+rs.getString("M_C_Contents"));
			jObject.put("M_C_Type", rs.getString("M_C_Type"));
			jObject.put("M_C_lat", rs.getString("M_C_lat"));
			jObject.put("M_C_lng", rs.getString("M_C_lng"));
			jObject.put("M_C_Time", rs.getString("M_C_Time"));
			if(jObject!=null){
			
				jArray.add(jObject);
			}
		}

		//없는 경우에는 succed 담습니다.
		if (total == 0) {
			JSONObject jObject = new JSONObject();

			jObject.put("Check", "failed");
			jArray.add(jObject);

		}

		stmt.close();
		conn.close();
		//stmt와 conn객체를 닫습니다.
		
		//담은 데이터를 배열로 만듭니다.
		jsonMain.put("results", jArray);
		//안드로이드로 데이터를 날립니다.
		out.println(jsonMain.toJSONString());
	} catch (Exception e) {
	}
%>