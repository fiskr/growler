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
    } catch (Exception e) {
    }
    Theme t = new Theme();
    String name = request.getParameter("name");
    String description = request.getParameter("description");
    String type = request.getParameter("type");
    int creator;
    try {
        creator = Integer.parseInt(request.getParameter("creator"));
    } catch (Exception e) {
        creator = (user);
    }
    if (request.getParameter("visible") != null){
        t.setVisible(true);
    }
    else  {
        t.setVisible(false);
    }
    t.setName(name);
    t.setDescription(description);
    t.setType(type);
    t.setCreatorId(creator);
    persist.addAdminTheme(t);
    session.setAttribute("message", "Success: The following theme has been added successfully!");
    session.setAttribute("theme", name);
    response.sendRedirect("../private/employee/admin/themeentry-confirm.jsp");

%>