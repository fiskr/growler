<%-- 
    Document   : attendance
    Created on : Apr 17, 2013, 10:48:45 PM
    Author     : Justin Bauguess
    Purpose    : This will display a list of active sessions a user can attend.
                (Initially, it will display a list of all previous sessions.)
--%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="java.security.*"%>
<%@page import="com.scripps.growler.*" %>
<jsp:useBean id="dataConnection" class="com.scripps.growler.DataConnection" scope="page" />
<!doctype html>
<!--[if lt IE 7]> <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
<!--[if IE 7]>    <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
<!--[if IE 8]>    <html class="no-js lt-ie9" lang="en"> <![endif]-->
<!--[if gt IE 8]><!--> 
<html class="no-js" lang="en"> <!--<![endif]-->
    <head>
        <meta charset="utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
        <title>Acknowledge Session Attendance</title><!-- Title -->
        <meta name="description" content="Growler Project Tentative Layout" /><!-- Description -->
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <link rel="stylesheet" href="../../css/bootstrap/bootstrap.1.2.0.css" /><!--Using bootstrap 1.2.0-->
        <link rel="stylesheet" href="../../css/bootstrap/responsive.1.2.0.css" /><!--Basic responsive layout enabled-->
        <link rel="stylesheet" href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css">
        <script src="../../js/libs/modernizr.2.6.2.custom.min.js"></script><!--Modernizer-->
        <script src="http://code.jquery.com/jquery-1.9.1.js"></script>  
        <script src="http://code.jquery.com/ui/1.10.1/jquery-ui.js"></script>     
        <script src="../../attendance.js"></script>
        <style>
            .message_container {
                display: none;
                color: red;
                font-weight: bold;
            }
        </style>
    </head>
    <body id="growler1">
        <%
                    String user = "";
                    if (null == session.getAttribute("id")) {
                        response.sendRedirect("../../index.jsp");
                    }
                    try {
                        user = String.valueOf(session.getAttribute("id"));
                        String name = String.valueOf(session.getAttribute("user"));                  
                    }
                    catch (Exception e) {
                        
                    }
                %>
        <%@ include file="../../includes/header.jsp" %>
        <%@ include file="../../includes/testnav.jsp" %>
        <div class="container-fixed">
            <br/><br/><br/>
            <div class="row">
                
                    <h2 class="bordered"><img style="padding-bottom:0;padding-left:0;width:165px;" src='../../images/Techtoberfest2013small.png'/><span class="titlespan">Acknowledge Session Attendance</span></h2>
                
            </div>
            <br/>
            <div class="row">
                
                    <%
                    String message = String.valueOf(session.getAttribute("message"));
                    if (!message.equals("null")) {
                        if (message.startsWith("Success:")) {
                            out.print("<p id=\"topMessage\" class=feedbackMessage-success>" + message + "</p>");
                            String sessionName = (String) session.getAttribute("sessionName");
                            out.print("<div id=\"modalDialog\" title=\"Successfully Acknowledged Attendance for " + sessionName + "\"><p>Please take a survey.</p><p>This will enter you in a drawing for a fantastic prize.</p></div>");
                            out.print("<div id=\"thanksDialog\" title=\"Thanks Anyway\"><p>Thanks anyway. You can always take a survey later.</p></div>");
                        } else {
                            out.print("<p class=feedbackMessage-error>" + message + "</p>");
                        }
                        session.removeAttribute("message");
                    }
                %>

<%
                            SessionPersistence sp = new SessionPersistence();
                            ArrayList<Session> sessions = sp.getSessionsToAcknowledge();
                            
                            if (sessions.size() > 0) {
                                out.print("<p>Enter a key, provided by the speaker, and click on the \"Acknowledge\" link to acknowledge your attendance.  If you changed your mind and switched sessions, click \"UnRegister\" to delete your attendance so you can attend another session.</p>");
                                out.print("<p>You will also receive a notification to complete a survey rating the session, or you can go to \"Rate a Session\" link in the menu.</p>");
                                out.print("<p>Upon completing the survey, you will be registered to win a fantastic prize.</p>");
                                out.print("<form action=\"../../action/processattendance.jsp\" method=\"post\">");
                                out.print("<label class=\"required\">Session: </label>");
                                out.print("<select name=\"session\">");
                                for (int i = 0; i < sessions.size(); i++) {
                                        out.print("<option value=\"" + sessions.get(i).getId() + "\">");
                                        out.print(sessions.get(i).getName());
                                        out.print("</option>");
                                    }
                                out.print("</select><br/>");
                                out.print("<label class=\"required\">Session Key:</label>");
                                out.print("<input class=\"input-large\" id=\"tip\" type=\"text\" maxlength=\"4\" required=\"required\" name=\"skey\" data-content=\"Please enter the 4 character session key the instructor provided\"/>");
                                out.print("<br/><span id=\"error_key\" class=\"message_container\"><span>Please Enter a Session Key</span></span>");
                                out.print("<input id=\"send\" type=\"submit\" value=\"Submit\" />");
                                out.print("</form>");
                            }
                            else {
                                out.print("<p>There are currently no sessions available</p>");
                            }
                        %>   
                
            </div>
        </div>
        <br/>
        <br/>
        <%@ include file="../../includes/footer.jsp" %> 
        <%@ include file="../../includes/scriptlist.jsp" %>
        
    </body>
</html>