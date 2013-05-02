<%-- 
    Document   : theme
    Created on : Feb 28, 2013, 7:15:03 PM
    Author     : Justin Bauguess & Jonathan C. McCowan
    Purpose    : The theme (admin) page is for admins to edit theme information. 
                The editable fields are simply if the theme is visible to a user 
                or not.  It will display the theme name, how many rating points 
                it has earned, and how many times someone has rated it.  It will 
                also display the creator of the theme.
--%>
<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="com.scripps.growler.DataConnection" %>
<jsp:useBean id="dataConnection" class="com.scripps.growler.DataConnection" scope="page" />
<jsp:useBean id="queries" class="com.scripps.growler.GrowlerQueries" scope="page" />
<jsp:useBean id="giveStars" class="com.scripps.growler.GiveStars" scope="page" />
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
  
	<title>Admin Themes</title><!-- Title -->
  
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
    <%@include file="../includes/isadmin.jsp" %>
	<%@ include file="../includes/header.jsp" %> 
	<%@ include file="../includes/adminnav.jsp" %>
	
	<div class="row">
		<div class="span3">
			<img class="logo" src="../images/Techtoberfest2013admin.png" alt="Techtoberfest 2013 admin"/><!-- Techtoberfest logo-->
		</div>
		<div class="span6 largeBottomMargin">
			<h1 class = "bordered">Default Themes - Admin View</h1>
		</div>
    </div>
	<div class="container-fluid">
		<div class="content">
			<!-- Begin Content -->
			<div class="row"><!--row-->
				<div class="span6 offset3"><!--span-->
                    <div id="tabs-1">
						<div class="row">
							<div class="span1">
							<br/>                   
								<% 
								Connection newConnect = dataConnection.sendConnection();
                                Statement newStatement = newConnect.createStatement();
                                ResultSet themeResult = newStatement.executeQuery("select t.id, t.name, sum(r.theme_rank) as rating, count(theme_id) as count, t.visible from theme t, theme_ranking r where t.id = r.theme_id group by theme_id order by rating desc, name");
                                %>
							</div>
							<div class="span2">
								 <section>
									<form action="../model/admintheme.jsp" >
										<table>
											<tr>
												<td>Name</td>
												<td>Rating</td>
												<td>Times Rated</td>
												<td>Visible?</td>
												<td>Created By</td>
											</tr>
												<% 
												while (themeResult.next()) {
												%>
											<tr>
											<td><% out.print(themeResult.getString("name")); %>
											<input type="hidden" name="list" value="<% out.print(themeResult.getInt("id")); %>" /></td>
											<td><% out.print(themeResult.getInt("rating")); %></td>
											<td><% out.print(themeResult.getInt("count")); %></td>
											<td><input type="checkbox" name="visible" value="<% out.print(themeResult.getInt("id")); %>"
													   <% if (themeResult.getInt("visible") == 0) {
															  out.print(" checked");} %>/>
											<td><% out.print(themeResult.getString("creator")); %>
											</tr>
											<% } 
											newConnect.close();
											themeResult.close();
											newStatement.close(); %>
										</table>
									</form>
								</section>
							</div>
							<div class="span7">
							<p></p>
							</div>
						</div>
					</div>
				</div><!--end span-->
			</div><!--end row-->
			<div class="span2 offset3"><!--button div-->
				<input type="submit" value="Submit" class="button-primary" />
			</div>
		</div><!-- End Content -->	
	</div><!--/.container-fluid-->


	<%@ include file="../includes/footer.jsp" %>
	<%@ include file="../includes/scriptlist.jsp" %>
	<%@ include file="../includes/draganddrop.jsp" %>
	
	<script src="http://code.jquery.com/jquery-1.9.1.js"></script>  
	<script src="http://code.jquery.com/ui/1.10.1/jquery-ui.js"></script>
	<script src="../js/grabRanks.js"></script>
	
	<!--Additional Script-->
	<script>  
	$(function() {    
		$( "#sortable" ).sortable({revert: true});    
		$( "#draggable" ).draggable({connectToSortable: "#sortable",helper: "clone",revert: "invalid"});    
		$( "ul, li" ).disableSelection();  
	});  
	</script>
</body>
</html>

