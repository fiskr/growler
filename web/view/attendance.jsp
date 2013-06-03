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
        <link rel="stylesheet" href="../css/bootstrap/bootstrap.1.2.0.css" /><!--Using bootstrap 1.2.0-->
        <link rel="stylesheet" href="../css/bootstrap/responsive.1.2.0.css" /><!--Basic responsive layout enabled-->
        <link rel="stylesheet" href="draganddrop.css" /><!--Drag and drop style-->
        <link rel="stylesheet" href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css">
        <script src="../js/libs/modernizr.2.6.2.custom.min.js"></script><!--Modernizer-->
        <%@ include file="../includes/scriptlist.jsp" %>
        <script>
            $(function() {    $( "#modalDialog" ).dialog({
                    resizable: false,
                    height:140,
                    modal: true,
                    buttons: {
                        "Take a Survey": function() {
                            $( this ).dialog( "close" );
                            window.location = '../view/surveylist.jsp'
                        },        
                                "Don't take Survey": function() {          
                            $( this ).dialog( "close" );
                            alert('Thanks anyway.  You can always take a survey later!');
                        }      
                    }    
                    });  
                    });
        </script>
    </head>
    <body id="growler1">
        <%@ include file="../includes/header.jsp" %>
        <%@ include file="../includes/usernav.jsp" %>
        <div class="row">
            <div class="span3">
                <img class="logo" src="../images/Techtoberfest2013small.png" alt="Techtoberfest 2013 small"/><!-- Techtoberfest logo-->
            </div>
        </div>
        <div class="row">
            <div class="span7 offset3 largeBottomMargin">
                <h1 class="bordered">Acknowledge Session Attendance</h1>
                <%
                    String message = String.valueOf(session.getAttribute("message"));
                    if (!message.equals("null")) {
                        if (message.equals("You were successfully removed from the session!")){
                            out.print("<p id=\"topMessage\" class=feedbackMessage-success>" + message + "</p>");
                        }
                        else if (message.startsWith("Sucessfully registered!")){
                            out.print("<p id=\"topMessage\" class=feedbackMessage-success>" + message + "</p>");
                            out.print("<div id=\"modalDialog\" title=\"Survey Message\"><p>Please take a survey</p></div>");
                        }
                        else {
                            out.print("<p class=feedbackMessage-error>" + message + "</p>");
                        }
                        session.removeAttribute("message");
                    }
                %>
                <p>Enter a key, provided by the speaker, and click on the "Acknowledge" link to acknowledge your attendance.  If you changed your mind and switched sessions, click "UnRegister" to delete your attendance so you can attend another session.</p>
                <p>You will also receive a notification to complete a survey rating the session, or you can go to "Rate a Session" 
                link in the menu.</p>
                <p>Upon completing the survey, you will be registered to win a fantastic prize.</p>
            </div>
        </div>
        <div class="container-fluid">
            <div class="content">
                <!-- Begin Content -->
                <div class="row"><!--row-->
                    <div class="span6 offset3"><!--span-->

                                    <table class="table table-alternatingRow table-border table-columnBorder table-rowBorder">
                                        <tr>
                                            <th>Name</th>
                                            <th>Date</th>
                                            <th>Time</th>
                                            <th>Key</th>
                                            <th>Acknowledge</th>
                                            <th>UnRegister</th>
                                        </tr>
                                        <%
                                            Calendar today = Calendar.getInstance();
                                            String date = today.get(Calendar.YEAR) + "-" + (today.get(Calendar.MONTH) + 1) + "-" + today.get(Calendar.DATE);
                                            String time = today.get(Calendar.HOUR_OF_DAY) + ":" + today.get(Calendar.MINUTE) + ":" + today.get(Calendar.SECOND);
                                            
                                            Connection connection = dataConnection.sendConnection();
                                            Statement statement = connection.createStatement();
                                            //Select sessions that are today, before the current time
                                            ResultSet result = statement.executeQuery("select id, name, session_date, start_time, duration from session where session_date = '"
                                                    + date + "'");
                                            
                                            while (result.next()) {
                                                //Convert the duration into a usable format
                                               int duration = result.getInt("duration");
                                               int hours = duration / 60;
                                               int minutes = duration % 60;
                                               Time act = result.getTime("start_time");
                                               Calendar cal = Calendar.getInstance();
                                               //Set the Calendar's HOUR:MINUTE to that of the session
                                               cal.set(Calendar.HOUR_OF_DAY, act.getHours());
                                               cal.set(Calendar.MINUTE, act.getMinutes());
                                               //out.print(cal.get(Calendar.HOUR_OF_DAY) + ":" + cal.get(Calendar.MINUTE) + "<br/>");
                                               //Add the duration to the session's time
                                               cal.add(Calendar.HOUR_OF_DAY , hours);
                                               cal.add(Calendar.MINUTE, minutes + 15);
                                               //out.print(cal.get(Calendar.HOUR_OF_DAY) + ":" + cal.get(Calendar.MINUTE) + "<br/>");
                                               //If argument is later, negative number
                                               //If argument is sooner, positive number
                                               //out.print(today.get(Calendar.HOUR_OF_DAY) + ":" + today.get(Calendar.MINUTE) + "<br/>");
                                               //out.print(cal.compareTo(today) + "<br/>");
                                               if (today.compareTo(cal) < 0) {
                                                   out.print("<form action=\"../model/processattendance.jsp\" method=post>");
                                                   out.print("<tr>");
                                                   out.print("<td>" + result.getString("name") + "</td>" +
                                                           "<input type=hidden name=session value=\"" + result.getInt("id") + "\"/>");
                                                   out.print("<td>" + result.getDate("session_date") + "</td>");
                                                   out.print("<td>" + result.getTime("start_time") +  "</td>");
                                                   out.print("<td><input type=text name=\"skey\"/></td>");
                                                   out.print("<td><input type=submit name=submit value=Acknowledge></td>");
                                                   out.print("<td><a href=\"../model/leaveattendance.jsp?session=" + result.getInt("id") + "\"><i class=icon16-userRemove></i></a></td>");
                                                   out.print("</tr>");
                                                   out.print("</form>");
                                               }
                                            }
                                            result.close();
                                            statement.close();
                                            connection.close();
                                        %>
                                    </table>
                                    </form>
                                </div>
                                <br/>
                    </div><!--end span-->
            </div><!-- End Content -->
        </div><!--/.container-fluid-->
        <%@ include file="../includes/footer.jsp" %> 
        
        <%@ include file="../includes/draganddrop.jsp" %>
        
    </body>
</html>