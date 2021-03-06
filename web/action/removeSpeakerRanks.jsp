<%-- 
    Document   : removeSpeakerRanks
    Created on : May 31, 2013, 7:50:07 AM
    Author     : 162107
        Purpose	   : Allows a user to reset their ranks of speakers.
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="com.scripps.growler.*" %>
<jsp:useBean id="dataConnection" class="com.scripps.growler.DataConnection" scope="page" />
<jsp:useBean id="queries" class="com.scripps.growler.GrowlerQueries" scope="page" />
<%
    int user = 0;
    if (null == session.getAttribute("id")) {
        response.sendRedirect("../index.jsp");
    }
    try {
        user = Integer.parseInt(String.valueOf(session.getAttribute("id")));
        String name = String.valueOf(session.getAttribute("user"));
    } catch (Exception e) {
    }
    Connection connection = dataConnection.sendConnection();
    Statement statement = connection.createStatement();
    String sql = "delete from speaker_ranking where user_id = " + user;
    int success = statement.executeUpdate(sql);
    connection.close();
    statement.close();
    if (request.getParameter("return").equals("non")) {
        response.sendRedirect("../private/employee/nondragspeaker.jsp");
    } else {
        response.sendRedirect("../private/employee/speaker.jsp");
    }
%>