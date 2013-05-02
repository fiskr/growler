<%-- 
    Document   : speakerentry
    Created on : Feb 27, 2013, 12:17:43 AM
    Author     : Justin Bauguess and Jonathan C. McCowan
    Purpose    : The purpose of speakerentry(user) is for users to suggest speakers
                to the Techtoberfest Admins.  It uses model/processSpeakerSuggestion.
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<!--[if lt IE 7]> <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
<!--[if IE 7]>    <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
<!--[if IE 8]>    <html class="no-js lt-ie9" lang="en"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->
<head>
    <meta charset="utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
	<meta name="description" content="" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	
	<title>Speaker Entry</title>
  
	<link rel="stylesheet" href="../css/jquery-ui/jquery-ui-1.9.2.custom.min.css" />
	<link rel="stylesheet" href="../css/bootstrap/bootstrap.1.2.0.css" /><!--Using bootstrap 1.2.0-->
	<link rel="stylesheet" href="../css/bootstrap/responsive.1.2.0.css" /><!--Basic responsive layout enabled-->
	<link rel="stylesheet" href="../css/prettify/prettify.css" /> 
	<link rel="stylesheet" type="text/css" href="../css/general.css" /><!--General CSS-->
  
    <script src="../js/libs/modernizr.2.6.2.custom.min.js"></script><!--Modernizer-->	
</head>
<body id="growler1">
    <%@ include file="../includes/header.jsp" %> 
    <%@ include file="../includes/usernav.jsp" %>
   <div class="row">
		<div class="span3">
			<img class="logo" src="../images/Techtoberfest2013small.png" alt="Techtoberfest 2013 small"/>
		</div>
		<div class="span5">
			<h1 class = "bordered largeBottomMargin">Suggest a Speaker</h1>
		</div>
	</div>
	<div class="container-fluid">
		<div class="content" role="main">
		<!-- Begin Content -->
			<form method="POST" id="action" action="../model/processSpeakerSuggestion.jsp">
				<div class="span5 offset3">
					<fieldset>
						<div class="form-group">
							<label class="required">Speaker First Name</label>
							<input name="name" class="input-xlarge" type="text" id="tip" data-content="30 characters or less please" maxlength="30"/>
						</div>
						<div class="form-group">
							<label class="required">Speaker Last Name</label>
							<input name="description" class="input-xlarge" type="text" id="tip2" data-content="30 characters or less please" maxlength="30"/>
						</div>
						<div class="form-actions">
							<input class="button button-primary" value="Send" id="send"/>
							<a class="button" id="cancel" href="../view/speaker.jsp">Cancel</a>
						</div>
					</fieldset>
				</div>   
			</form>		
		</div><!-- /.content -->
	</div><!-- /.container-fluid -->
 
	<%@ include file="../includes/footer.jsp" %> 
	<%@ include file="../includes/scriptlist.jsp" %>
	
	<!--additional script-->
	<script>
	$(function () {
		$("input").autoinline();
    });
	$("#send").click(function(){
		var emptyString = "";
		if($("#tip").val() === emptyString || $("#tip2").val() === emptyString) {
			$("#action").attr("action","");
			alert("Please enter both a first and last name for the speaker before submitting.");
		}
		else{
			$("#action").attr("action","../model/processSpeakerSuggestion.jsp");
		}
	});
	</script>
</body>
</html>
