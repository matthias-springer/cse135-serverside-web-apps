<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Signup Handler</title>
</head>
<jsp:include page="../header.jsp"></jsp:include>
<body>
	<%
		if (new user.User(request.getParameter("name"),
				Integer.parseInt(request.getParameter("age")),
				request.getParameter("state"), request.getParameter("role"))
				.save()) {
	%>
		<h2>You have successfully signed up.</h2>
		<p><a href="login.jsp">Back to Login page</a></p>
	<% } else { %>
		<h2>Your signup failed.</h2>
		<p><a href="signup.jsp">Back to Signup page</a></p>
	<% } %>

</body>
</html>