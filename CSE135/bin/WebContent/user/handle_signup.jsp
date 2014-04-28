<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Signup Handler</title>
</head>
<body>
	<%
		if (new user.User(request.getParameter("name"),
				Integer.parseInt(request.getParameter("age")),
				request.getParameter("state"), request.getParameter("role"))
				.save()) {
	%>
		<p>You have successfully signed up.</p>
	<% } else { %>
		<p>Your signup failed.</p>
	<% } %>
</body>
</html>