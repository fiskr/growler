<%-- 
    Document   : processSessionEdit
    Created on : June 10, 2013, 9:40:24 AM
    Author     : 162107
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="com.scripps.growler.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Page</title>
        <%
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            
            DataConnection dc = new DataConnection();
            Connection connection = dc.sendConnection();
            PreparedStatement statement = connection.prepareStatement("update session set name = ?, description = ? where id = ?");
            statement.setString(1, name);
            statement.setString(2, description);
            statement.setInt(3, id);
            
            try {
                statement.execute();
            }
            catch (Exception e) {
                session.setAttribute("message", "Error processing update");
            }
            finally {
                statement.close();
                connection.close();
            }
            response.sendRedirect("../admin/session.jsp");
        %>
</html>