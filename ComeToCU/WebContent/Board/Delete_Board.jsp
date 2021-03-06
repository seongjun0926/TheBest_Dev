<?xml version="1.0" encoding="utf-8" ?>
<%@ page contentType="text/xml; charset=utf-8"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.Statement"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="Util.Util"%>
<%@ page import="Util.DB"%>
<%
	String WB_Creator = request.getParameter("WB_Creator");
	String WB_ID = request.getParameter("WB_ID");
	String Get_ID = (String) session.getAttribute("Get_ID");
	String Get_Class = (String) session.getAttribute("Get_Class");
	String URI = (String)session.getAttribute("URI");//전에 있던 페이지로 돌아가기위한 변수
	
	if (Get_ID.equals(WB_Creator) || Get_Class.equals("1")) {

		Connection conn = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;

		try {
			conn = DB.getConnection();
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement("delete from C_write_board where WB_ID=? and WB_Creator=?");
			pstmt.setString(1, WB_ID);
			pstmt.setString(2, WB_Creator);
			pstmt.executeUpdate();

			pstmt1 = conn.prepareStatement("delete from C_reply where WB_ID not in (Select WB_ID from C_write_board)");
			pstmt1.executeUpdate();

			pstmt2 = conn.prepareStatement("delete from C_like_table where L_WB_ID not in (Select WB_ID from C_write_board)");
			pstmt2.executeUpdate();

			conn.commit();

			
			 response.sendRedirect("http://cometocu.com"); //내 글 보기는 어쩔 수 없이 내글 보이는 창으로 이동 해야함.
		} catch (Throwable e) {
			try {
				conn.rollback();
			} catch (SQLException ex) {
			}
		} finally {
			if (pstmt != null)
				try {
					pstmt.close();
				} catch (SQLException ex) {
				}
			if (pstmt1 != null)
				try {
					pstmt1.close();
				} catch (SQLException ex) {
				}
			if (pstmt2 != null)
				try {
					pstmt2.close();
				} catch (SQLException ex) {
				}
			if (conn != null)
				try {
					conn.setAutoCommit(true);
					conn.close();
				} catch (SQLException ex) {
				}
		}
	} else {
%>
<script>
	alert("잘못된 접근입니다.")
	location.href("http://cometocu.com");
</script>
<%
	}
%>
