<%-- 
    Document   : processSpeakerRanking
    Created on : Mar 5, 2013, 8:13:49 PM
    Author     : Robert Brown
--%>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="com.scripps.growler.DataConnection" %>
<jsp:useBean id="dataConnection" class="com.scripps.growler.DataConnection" scope="application" />
<jsp:setProperty name="dataConnection" property = "*" />
<jsp:useBean id="queries" class="com.scripps.growler.GrowlerQueries" scope="application" />
<jsp:setProperty name="queries" property = "*" />
<!doctype html>
<!--[if lt IE 7]> <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
<!--[if IE 7]>    <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
<!--[if IE 8]>    <html class="no-js lt-ie9" lang="en"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->
<head>
  <meta charset="utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
  <title>Growler Project</title><!-- Title -->
  <meta name="description" content="Growler Project Tentative Layout" /><!-- Description -->
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <link rel="stylesheet" href="../css/bootstrap/bootstrap.1.2.0.css" /><!--Using bootstrap 1.2.0-->
  <link rel="stylesheet" href="../css/bootstrap/responsive.1.2.0.css" /><!--Basic responsive layout enabled-->
	<link rel="stylesheet" href="../js/draganddrop.css" /><!--Drag and drop style-->
  <script src="../js/libs/modernizr.2.6.2.custom.min.js"></script><!--Modernizer-->
</head>
<body id="growler1">
 <%@ include file="../includes/header.jsp" %> 
 <% String list[] = request.getParameterValues("list");
 int ids[] = new int[list.length];
 for (int i = 0; i < list.length; i++) {
     ids[i] = Integer.parseInt(list[i]);
 }
 Connection connection = dataConnection.sendConnection();
 Statement statement = connection.createStatement();
 PreparedStatement insert = connection.prepareStatement(queries.insertSpeakerRanking());
 //two fields to put: ID (int), ranking (int)
 for (int j = 0; j < 9; j++) {
     insert.setInt(1, ids[j]);
     insert.setInt(2, 10-j);
     insert.execute();
 }
 Statement showRanks = connection.createStatement();
 ResultSet ranks = showRanks.executeQuery(queries.returnSpeakerRanking() + " order by sum(ranking) desc");
 while(ranks.next()) {
 %><p><% out.print(ranks.getString("first_name") + " " + ranks.getString("last_name") + " : " + ranks.getInt(1)); %></p><%
 }
 %>
 
<%@ include file="../includes/footer.jsp" %> 
<%@ include file="../includes/scriptlist.jsp" %>
<%@ include file="../includes/draganddrop.jsp" %>
    </body>
</html>

