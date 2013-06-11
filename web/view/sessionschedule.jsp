<%-- 
    Document   : sessionschedule
    Created on : Jun 11, 2013, 8:40:30 AM
    Author     : 162107
--%>
<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="com.scripps.growler.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<!--[if lt IE 7]> <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
<!--[if IE 7]>    <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
<!--[if IE 8]>    <html class="no-js lt-ie9" lang="en"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->
    <head>
        <meta charset="utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
        <meta name="description" content="Growler Project Tentative Layout" /><!-- Description -->
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />

        <title>Session</title><!-- Title -->

        <link rel="stylesheet" href="http://code.jquery.com/ui/1.10.1/themes/base/jquery-ui.css" /> 
        <link rel="stylesheet" href="../css/bootstrap/bootstrap.1.2.0.css" /><!--Using bootstrap 1.2.0-->
        <link rel="stylesheet" href="../css/bootstrap/responsive.1.2.0.css" /><!--Basic responsive layout enabled-->
        <link rel="stylesheet" href="../css/demo.css" />  
        <link rel="stylesheet" href="../css/draganddrop.css" /><!--Drag and drop style-->
        <link rel="stylesheet" type="text/css" href="../css/general.css" /><!--General CSS-->
        <link rel="stylesheet" type="text/css" href="../css/theme.css" /><!--Theme CSS-->
        <link rel="stylesheet" href="/resources/demos/style.css" />

        <script src="../js/libs/modernizr.2.6.2.custom.min.js"></script><!--Modernizer-->
    </head>
    <body id="growler1">  
        <% String user = "";
            try {
                user = String.valueOf(session.getAttribute("id"));
                String name = String.valueOf(session.getAttribute("user"));
            } catch (Exception e) {
            }
            if (user == null) {
                response.sendRedirect("../index.jsp");
            }
        %>
        <%@ include file="../includes/header.jsp" %> 
        <div class="row">
            <%@ include file="../includes/usernav.jsp" %>
        </div>
        <div class="row"><!-- The Logo Row -->
            <div class="span3">
                <img class="logo" src="../images/Techtoberfest2013small.png" alt="Techtoberfest 2013 small"/><!-- Techtoberfest logo-->
            </div>
            <div class="span7 largeBottomMargin">
                <h1 class="bordered">Session Registration</h1>
                <%
                    //Displaying error or success messages -- clear it out when done
                    String message = String.valueOf(session.getAttribute("message"));
                    if (!message.equals("null") && message.startsWith("Successfully registered!")) {
                        out.print("<p class=feedbackMessage-success>" + message + "</p>");
                        session.removeAttribute("message");
                    } else if (!message.equals("null")) {
                        out.print("<p class=feedbackMessage-error>" + message + "</p>");
                        session.removeAttribute("message");
                    }
                    //Get the year
                    int year = 2013;
                    try {
                        year = Integer.parseInt(request.getParameter("year"));
                    } catch (Exception e) {
                    }
                    SessionPersistence sp = new SessionPersistence();
                    LocationPersistence lp = new LocationPersistence();
                    RegistrationPersistence rp = new RegistrationPersistence();
                    ArrayList<Session> sessions = sp.getThisYearSessions(year);
                %>
            </div>
        </div>
        <div class="container-fluid">
            <div class="content"><!-- Begin Content -->
                <div class="span6 offset3">
                    <form action="sessionschedule.jsp" method="post">
                        <select name="year">
                            <option value="2013">2013</option>
                            <option value="2012">2012</option>
                            <!--Provisioned for future years! -->
                        </select>
                        <input value="Change Year" type="submit" class="button button-primary"/>
                    </form>
                </div>
                <div class="span9 offset2">
                    <form method="post" action="../model/registerinterest.jsp">
                        <table class="table table-alternatingRow table-border table-columnBorder table-rowBorder">
                            <tr>
                                <th>Name</th>
                                <th>Description</th>
                                <th>Date</th>
                                <th>Time</th>
                                <th>Duration</th>
                                <th>Location</th>
                                <th>Register Interest</th>
                            </tr>
                            <%
                                for (int i = 0; i < sessions.size(); i++) {
                                    out.print("<tr>");
                                    out.print("<td>");
                                    out.print(sessions.get(i).getName());
                                    out.print("<input type=\"hidden\" value=\"" + sessions.get(i).getId() + "\" name=\"name\">");
                                    out.print("</td>");
                                    out.print("<td>");
                                    out.print(sessions.get(i).getDescription());
                                    out.print("</td>");
                                    out.print("<td>");
                                    out.print(sessions.get(i).getSessionDate());
                                    out.print("</td>");
                                    out.print("<td>");
                                    out.print(sessions.get(i).getStartTime());
                                    out.print("</td>");
                                    out.print("<td>");
                                    out.print(sessions.get(i).getDuration());
                                    out.print("</td>");
                                    out.print("<td>");
                                    out.print(lp.getLocationById(sessions.get(i).getLocation()).getDescription());
                                    out.print("</td>");
                                    out.print("<td>");
                                    out.print("<input type=\"checkbox\" value=\"" + sessions.get(i).getId() + "\" name=\"interest\"");
                                    if (rp.isUserRegistered(Integer.parseInt(user), sessions.get(i).getId())) {
                                        out.print(" checked ");
                                    }
                                    out.print(">");
                                    out.print("</td>");
                                    out.print("</tr>");
                                }
                            %>
                        </table>
                        <input value="Register" type="submit" class="button button-primary"/>
                    </form>
                </div>
            </div><!-- End Content -->	
        </div><!--/.container-fluid-->
        <div class="row">
            <div class="span8">
                <p></p>
            </div>
            <div class="span2">
            </div>
        </div>

        <%@ include file="../includes/footer.jsp" %>
        <%@ include file="../includes/scriptlist.jsp" %>
        <script src="http://code.jquery.com/jquery-1.9.1.js"></script>  
        <script src="http://code.jquery.com/ui/1.10.1/jquery-ui.js"></script>
    </body>
</html>

