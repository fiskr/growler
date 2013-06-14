<%-- 
    Document   : processSpeakerRanking
    Created on : Mar 5, 2013, 8:13:49 PM
    Author     : Justin Bauguess
    Purpose    : The purpose of processSpeakerRanking is to process the data 
                that users give us on what speakers they would like to hear.  It
                goes into the speaker_ranking table.
--%>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="com.scripps.growler.*" %>
<jsp:useBean id="dataConnection" class="com.scripps.growler.DataConnection" scope="page" />
<jsp:useBean id="queries" class="com.scripps.growler.GrowlerQueries" scope="page" />
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
        <%
                    int user = 0;
                    if (null == session.getAttribute("id")) {
                        response.sendRedirect("../index.jsp");
                    }
                    try {
                        user = Integer.parseInt(String.valueOf(session.getAttribute("id")));
                        String name = String.valueOf(session.getAttribute("user"));                  
                    }
                    catch (Exception e) {
                        
                    }
                %>
        <%@ include file="../includes/header.jsp" %> 
        <% String list[] = request.getParameterValues("list");
            int ids[] = new int[list.length];
            for (int i = 0; i < list.length; i++) {
                ids[i] = Integer.parseInt(list[i]);
            }
            SpeakerPersistence sp = new SpeakerPersistence();
            ArrayList<Speaker> speakers = sp.getUserRanks(user);
            if (speakers.size() > 0) {
                session.setAttribute("message", "Error: You have already voted!");
            }
            else {
                //If they haven't voted, take their votes and put them in the database
                ArrayList<Speaker> newSpeakers = new ArrayList<Speaker>();
                for (int i = 0; i < ids.length; i++) {
                    Speaker s = sp.getSpeakerByID(ids[i]);
                    newSpeakers.add(s);
                }
                sp.setUserRanks(newSpeakers, user);
                

                session.setAttribute("message", "Success: Your votes have been recorded");
            }
            response.sendRedirect("../view/speaker.jsp");
        %>

        <%@ include file="../includes/footer.jsp" %> 
        <%@ include file="../includes/scriptlist.jsp" %>
        <%@ include file="../includes/draganddrop.jsp" %>
    </body>
</html>


