<%-- 
    Document   : assignspeaker
    Created on : Jun 10, 2013, 10:52:05 AM
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
        <title>Assign a Speaker to a Session</title><!-- Title -->
        <meta name="description" content="Growler Project Tentative Layout" /><!-- Description -->
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <link rel="stylesheet" href="http://growler-dev.elasticbeanstalk.com/css/bootstrap/bootstrap.1.2.0.css" /><!--Using bootstrap 1.2.0-->
        <link rel="stylesheet" href="http://growler-dev.elasticbeanstalk.com/css/bootstrap/responsive.1.2.0.css" /><!--Basic responsive layout enabled-->
        <link rel="shortcut icon" type="image/png" href="http://growler-dev.elasticbeanstalk.com/images/scripps_favicon-32.ico">
        <script src="http://growler-dev.elasticbeanstalk.com/js/libs/modernizr.2.6.2.custom.min.js"></script><!--Modernizer-->
        <style>
            h1, h3 {
                font-weight: normal;
            }
            .no-close .ui-dialog-titlebar-close {
                display: none;
            }
            .keywordFilter-clear {
                cursor: pointer;
            }
            .pullRight {
                float: right;
                top:10px;
                position:relative;
            }
            #sessions {
                list-style-type: none;
                height: 345px;
                overflow-y: auto;
                border: 1px solid #ccc;
                margin:0;
                margin-bottom: 24px;
            }
            input[type="radio"] {
                position:relative;
                bottom: 5px;
                margin-right: 6px;
            }
        </style>
    </head>
    <body id="growler1">
        <%
            int user = 0;
            int speakerPassed = 0;
            if (null == session.getAttribute("id")) {
                response.sendRedirect("../../../index.jsp");
            } else if (!session.getAttribute("role").equals("admin")) {
                response.sendRedirect("../../../index.jsp");
            }
            try {
                user = Integer.parseInt(String.valueOf(session.getAttribute("id")));
                String name = String.valueOf(session.getAttribute("user"));
                speakerPassed = Integer.parseInt(request.getParameter("speakerId"));
            } catch (Exception e) {
            }
        %>

        <%@ include file="../../../includes/adminheader.jsp" %> 
        <%@ include file="../../../includes/adminnav.jsp" %>
        <div class="container-fixed">
            <div class="row mediumBottomMargin"></div>
            <div class="row">
                <ul class="breadcrumb">
                    <li><a href="../../../private/employee/admin/home.jsp">Home</a></li>
                    <li class='ieFix'>Assign A Speaker</li>
                </ul>
            </div>
            <div class="row mediumBottomMargin">
                <h1 style="margin-top:0px;font-weight: normal;">Assign A Speaker</h1>
            </div>
            <div class="row mediumBottomMargin" style="border:1px dotted #ddd"></div>
            <div class="row largeBottomMargin">
                <h3>To assign a speaker to a session, choose an available session from the list and press the <strong>Assign</strong> button.</h3>
            </div>
            <div class="row largeBottomMargin"></div>
            <div class="row mediumBottomMargin">
                <h2 class="bordered"><img style="padding-bottom:0;padding-left:0;" src='http://growler-dev.elasticbeanstalk.com/images/Techtoberfest2013small.png'/><span class="titlespan">Assign Details</span></h2>
            </div>
            <div class="row largeBottomMargin">
                <%
                    SessionPersistence sessionPersist = new SessionPersistence();
                    SpeakerPersistence speakerPersist = new SpeakerPersistence();
                    Speaker speaker = speakerPersist.getSpeakerByID(speakerPassed);
                    ArrayList<Session> sessions = sessionPersist.getThisYearSessions(2013, " order by session_date");
                %>
                <form id="action" action="../../../action/processSessionAssign.jsp" method="post">
                    <div class="form-group"><% out.print(speaker.getLastName() + ", " + speaker.getFirstName() + "<strong> | Current ranking: </strong>" + speaker.getRank());%>
                    <input type="hidden" name="speaker" value="<%= speaker.getId() %>"/>
                    </div>
                    <div class="form-group">
                        <span class="keywordFilter">
                            <i class="icon16-magnifySmall"></i>
                            <span class="keywordFilter-wrapper">
                                <input type="search" id="filter" value="Filter..." />
                            </span>
                            <a class="keywordFilter-clear" onclick="clearFilter();"><i class="icon16-close"></i></a>
                        </span><span class="pullRight"><a>Refresh List</a></span></div>
                    <div class="form-group">
                        <ol id="sessions">
                            <%
                                //Get a list of all sessions
                                for (int i = 0; i < sessions.size(); i++) {
                                    out.print("<li>");
                                    if (speakerPersist.getSpeakersBySession(sessions.get(i).getId()).size() == 0) {
                                        out.print("<input type='radio' name='session' value=\"" + sessions.get(i).getId() + "\">");
                                    } else {
                                        out.print("<i class='icon16-success'></i>");
                                    }
                                    out.print(sessions.get(i).getSessionDate() + ", " + sessions.get(i).getStartTime() + ", " + sessions.get(i).getName());
                                    out.print("</li>");
                                }
                            %>
                        </ol>
                    </div>
                    <div class="form-actions">
                        <input id="send" type="submit" class="button button-primary" value="Assign Speaker"/>
                        <a id="cancel" href="../../../private/employee/admin/speaker.jsp">Cancel</a>
                    </div>
                </form>
            </div>
        </div>

        <%@ include file="../../../includes/footer.jsp" %> 
        <script src="http://code.jquery.com/jquery-1.9.1.js"></script>  
        <script src="http://code.jquery.com/ui/1.10.1/jquery-ui.js"></script>
        <script src="../../../js/libs/bootstrap-popover.2.1.1.min.js" type="text/javascript"></script>
        <script src="../../../js/libs/sniui.user-inline-help.1.2.0.min.js" type="text/javascript"></script>
        <script>
                                $().ready(function() {
                                    jQuery.expr[":"].icontains = jQuery.expr.createPseudo(function(arg) {
                                        return function(elem) {
                                            return jQuery(elem).text().toUpperCase().indexOf(arg.toUpperCase()) >= 0;
                                        };
                                    });
                                    $("#filter").on("keyup", function() {
                                        var text = $("#filter").val();
                                        if (text !== "") {
                                            $("ol li").filter(":icontains('" + text + "')").show();
                                            $("ol li").filter(":not(:icontains('" + text + "'))").hide();
                                        }
                                        else if (text === "") {
                                            $("ol li").show();
                                        }
                                    });
                                });
                                function clearFilter() {
                                    $("#filter").val("");
                                    $("#speakers li").show();
                                }
        </script>
    </body>
</html>
