<%-- 
    Document   : processThemeSuggestion
    Created on : Feb 26, 2013, 11:51:27 PM
    Author     : Justin Bauguess
    Purpose    : The purpose of processThemeSuggestion is to add themes to the 
                database.  It will add the name, description, reason from user data,
                and creator, visibility and id from other sources.  Both admins and
                users will use this for the processing of data.
--%>

<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="com.scripps.growler.*" %>
<jsp:useBean id="persist" class="com.scripps.growler.ThemePersistence" scope="page" />
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
                    }
                    catch (Exception e) {
                        
                    }
                %>
        <% String name = request.getParameter("name");
            String type = request.getParameter("type");
            String reason = "";
            try {
                reason = request.getParameter("reason");
            } catch (Exception e) {
                reason = "";
            }
            Theme t = new Theme();
            t.setName(name);
            t.setType(type);
            t.setCreatorId(user);
            t.setReason(reason);
            t.setVisible(false);
            persist.addTheme(t);
            if (user == 808300) {
                session.setAttribute("message", "Success: Theme Successfully added!");
                response.sendRedirect("../private/employee/admin/theme.jsp");
            } else {
                session.setAttribute("message", "Success: Your suggestion has been submitted successfully!");
                response.sendRedirect("../private/employee/themeentry-confirm.jsp");
            }
        %>