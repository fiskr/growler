<%-- 
    Document   : nondragspeaker
    Created on : Jun 14, 2013, 11:31:26 AM
    Author     : 162107
--%>
<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="com.scripps.growler.Speaker" %>
<%@page import="com.scripps.growler.SpeakerPersistence" %>
<jsp:useBean id="persist" class="com.scripps.growler.SpeakerPersistence" scope="page" />
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

        <title>Speakers</title><!-- Title -->

        <link rel="stylesheet" href="http://code.jquery.com/ui/1.10.1/themes/base/jquery-ui.css" /> 
        <link rel="stylesheet" href="../css/bootstrap/bootstrap.1.2.0.css" /><!--Using bootstrap 1.2.0-->
        <link rel="stylesheet" href="../css/bootstrap/responsive.1.2.0.css" /><!--Basic responsive layout enabled-->
        <link rel="stylesheet" href="../css/demo.css" />  
        <link rel="stylesheet" href="../css/draganddrop.css" /><!--Drag and drop style-->
        <link rel="stylesheet" type="text/css" href="../css/general.css" /><!--General CSS-->
        <link rel="stylesheet" type="text/css" href="../css/theme.css" /><!--Theme CSS-->
        <link rel="stylesheet" href="/resources/demos/style.css" />

        <script src="../js/libs/modernizr.2.6.2.custom.min.js"></script><!--Modernizer-->

        <script src="http://code.jquery.com/jquery-1.9.1.js"></script>  
        <script src="http://code.jquery.com/ui/1.10.1/jquery-ui.js"></script>
        <!--Additional Script-->
        <script>
            $().ready(function() {
                $('#add').click(function() {
                    return !$('#visible option:selected').appendTo('#list');
                });
                $('#remove').click(function() {
                    return !$('#list option:selected').appendTo('#visible');
                });
                $('#send').click(function(event) {
                    if ($('#list').has('option').length == 0) {
                        alert('Please select some Speakers to rank');
                        event.preventDefault();
                    }
                    else {
                        $('#action').attr("action", "../model/processSpeakerRanking.jsp");
                    }
                });
            });
        </script>
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
            } catch (Exception e) {
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
                <%
                    //Get a list of Speakers by calling getUserRanks
                    ArrayList<Speaker> speakers = persist.getUserRanks(user);
                    //If we didn't get any ranks, we tell the user to rank the Speakers
                    if (speakers == null || speakers.size() == 0) {
                        out.print("<h1 class=bordered>Speakers - Click To Order Speakers</h1>");
                    } else { //If we got speakers, we let the user see them
                        response.sendRedirect("../view/speaker.jsp");
                        out.print("<h1 class=bordered>Your Speaker Ranks</h1>");
                    }
                %>
            </div>
        </div>
        <div class="container-fluid">
            <div class="content">
                <!-- Begin Content -->

                <div class="row"><!--row-->
                    <div class="span6 offset3"><!--span-->
                        <div id="tabs-1">
                            <div class="row">
                                <div class="span6 offset1">
                                    <%@include file="../includes/messagehandler.jsp" %>
                                    <section>
                                        <%
                                            //If There are Ranked Speakers already, here is where they will be displayed
                                            if (speakers.size() > 0) {
                                                out.print("<table class=\"propertyGrid\">");
                                                for (int i = 0; i < speakers.size(); i++) {
                                                    out.print("<tr><th>Rank " + (i + 1) + "</th><td>" + speakers.get(i).getLastName() + ", " + speakers.get(i).getFirstName() + "</td></tr>");
                                                }

                                                out.print("</table><br/>");
                                                out.print("<a href=\"../model/removeSpeakerRanks.jsp?id=" + user + "\">Reset Ranks</a>");

                                            } else {
                                            }


                                        %>

                                        <form id="action" name="Speakers">
                                            <table>
                                                <tr>
                                                    <td>

                                                        <%
                                                            if (speakers == null || speakers.size() == 0) {
                                                                out.print("<select id=\"visible\" name=\"visible\" size=\"10\" MULTIPLE>");
                                                                ArrayList<Speaker> vspeakers = persist.getSpeakersByVisibility(true, persist.SORT_BY_LAST_NAME_ASC);
                                                                for (int i = 0; i < vspeakers.size(); i++) {
                                                                    out.print("<option value=\"" + vspeakers.get(i).getId() + "\">");
                                                                    out.print(vspeakers.get(i).getLastName() + ", " + vspeakers.get(i).getFirstName());
                                                                    out.print("</option>");
                                                                }
                                                                out.print("</select>");


                                                        %>

                                                    </td>
                                                    <td align="center" valign="middle">

                                                        <br>

                                                        <br/>

                                                    </td>
                                                    <td>
                                                        <%
                                                            out.print("<select id=\"list\" name=\"list\" size=\"10\" MULTIPLE>");
                                                            out.print("</select>");%>
                                                    </td>
                                                </tr>
                                            </table>    
                                            <%
                                                    out.print("<input id=\"add\" type=\"Button\" value=\"Add >>\" style=\"width:100px\"><br/><br/>");
                                                    out.print("<input id=\"remove\" type=\"Button\" value=\"<< Remove\" style=\"width:100px\"><br/><br/>");
                                                    out.print("<input type=\"Submit\" value=\"Send Ranks\" id=\"send\" class=\"button button-primary\"/>");
                                                }
                                            %>

                                        </form>
                                    </section>
                                </div>
                                <div class="span3">
                                    <p></p>
                                </div>
                            </div>
                        </div>
                    </div><!--end span-->
                </div><!--end row-->
                <div class="span2 offset3"><!--button div-->

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



    </body>
</html>
