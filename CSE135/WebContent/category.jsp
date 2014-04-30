<%@page import="category.Category"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
</head>
<jsp:include page="header.jsp"></jsp:include>
<body>
	<% if (request.getSession().getAttribute("username") == null) { %>
		<p>You must be logged in to see this page!</p>
	<% return;
	} %>
	
	<h1>List of Categories</h1>
	
	<table class="table table-striped">
		<tr>
			<td><b>ID</b></td><td><b>Name</b></td><td><b>Description</b></td><td></td>
		</tr>
		<form action="handle_category" method="post">
			<tr>
				<td><input type="hidden" name="ID" value="-1" />(auto)</td>
				<td><input type="text" name="name" /></td>
				<td><input type="text" name="description" /></td>
				<td><input type="submit" name="type" value="Insert" /></td>
			</tr>
		</form>
		<% for (Category cat : Category.getAllCategories()) { %>
			<form action="handle_category" method="post">
				<tr>
					<td><input type="hidden" name="ID" value="<%= cat.getID() %>" /><%= cat.getID() %></td>
					<td><input type="text" name="name" value="<%= cat.getName() %>" /></td>
					<td><input type="text" name="description" value="<%= cat.getDescription() %>" /></td>
					<td><input type="submit" name="type" value="Update" />
					<% if (!cat.hasProducts()) { %>
						<input type="submit" name="type" value="Delete" />
					<% } else { %>
						<input disabled="disabled" type="submit" name="type" value="Delete" />
					<% } %>
					</td>
				</tr>
			</form>
		<% } %>
	</table>
</body>
</html>