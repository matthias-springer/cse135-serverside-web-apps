<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<%
		if (new user.User(request.getParameter("name"),
				Integer.parseInt(request.getParameter("age")),
				request.getParameter("state"), request.getParameter("role"))
				.save()) {
	%>
		<p>User Signup successful!</p>
	<% } else { %>
		<p>User Signup failed! The user does already exist!</p>
	<% } %>
</body>
</html>