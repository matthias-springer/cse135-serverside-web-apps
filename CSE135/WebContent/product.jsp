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
	
	<h1>List of Products</h1>

	<div id="categories"
		style="width: 30%; float: left;">

		<table class="table table-striped">
			<tr>
				<td><b>Categories</b></td>
			</tr>

			<%
				for (category.Category cat : category.Category.getAllCategories()) {
			%>
			<tr>
				<td><a
					href="product.jsp?cat=<%=cat.getID()%>&keyword=<%=request.getParameter("keyword") == null ? ""
						: request.getParameter("keyword")%>&pagetype=<%= request.getParameter("pagetype") %>"><%=cat.getName()%></a>
				</td>
			</tr>
			<% } %>
			<tr>
				<td><a
					href="product.jsp?cat=-1&keyword=<%=request.getParameter("keyword") == null ? "" : request
					.getParameter("keyword")%>&pagetype=<%= request.getParameter("pagetype") %>"><i>All
						Products</i></a></td>
			</tr>
		</table>

	</div>

	<div id="content"
		style="background-color: #EEEEEE; width: 70%; float: left;">
		<h2>Products</h2>

		<form class="form-inline">
			<p>
				Search: <input type="text" name="keyword"
					value="<%=request.getParameter("keyword") == null ? "" : request
					.getParameter("keyword")%>" />
				<input type="hidden" name="category"
					value="<%=request.getParameter("cat") == null ? "-1" : request
					.getParameter("cat")%>" />
				<input type="hidden" name="pagetype" value="<%= request.getParameter("pagetype") %>" />
				<input type="submit" name="submit_filter" />
			</p>
		</form>

		<table class="table table-striped">
			<tr>
				<td><b>ID</b></td>
				<td><b>Name</b></td>
				<td><b>SKU</b></td>
				<td><b>Category</b></td>
				<td><b>Price</b></td>
				<td></td>
			</tr>
			<%
				boolean isAdmin = request.getParameter("pagetype").equals("admin") && user.User.findUserByName((String) request.getSession().getAttribute("username")).isOwner();
				if (isAdmin) {
			%>
			<form action="handle_product" method="post">
				<tr>
					<td><input type="hidden" name="ID" value="-1" /> <input
						type="hidden" name="pagetype"
						value="<%=request.getParameter("pagetype")%>" />(auto)</td>
					<td><input type="text" name="name" /></td>
					<td><input type="text" name="SKU" /></td>
					<td><select name="category">
							<%
								for (Category cat : Category.getAllCategories()) {
							%>
							<option value="<%=cat.getID()%>"><%=cat.getName()%></option>
							<%
								}
							%>
					</select></td>
					<td><input type="text" name="price" /></td>
					<td><input type="submit" name="type" value="Insert" /></td>
				</tr>
			</form>
			<% } %>
			<%
				for (product.Product pr : product.Product.getAllProducts(request.getParameter("cat") == null ? -1 : Integer.parseInt(request.getParameter("cat")), request.getParameter("keyword") == null ? "" : request.getParameter("keyword"))) {
			%>
			<form action="handle_product" method="post">
				<tr>
					<td><input type="hidden" name="ID" value="<%=pr.getID()%>" /><%=pr.getID()%>
						<input type="hidden" name="pagetype" value="<%= request.getParameter("pagetype") %>" /></td>
					<td><input <%= !isAdmin ? "readonly=\"readonly\"" : "" %> type="text" name="name" value="<%=pr.getName()%>" /></td>
					<td><input <%= !isAdmin ? "readonly=\"readonly\"" : "" %> type="text" name="SKU" value="<%=pr.getSKU()%>" /></td>
					<td><select <%= !isAdmin ? "readonly=\"readonly\"" : "" %> name="category">
							<% for (Category cat : Category.getAllCategories()) { %>
							<% if (pr.getCategory() == cat.getID()) { %>
							<option selected="selected" value="<%= cat.getID() %>"><%= cat.getName() %></option>
							<% } else { %>
							<option value="<%= cat.getID() %>"><%= cat.getName() %></option>
							<% } %>
							<% } %>
					</select></td>
					<td><input <%= !isAdmin ? "readonly=\"readonly\"" : "" %> type="text" name="price" value="<%=new Float(pr.getPrice()).toString()%>" /></td>
					<td>
						<% if (isAdmin) { %>
							<input type="submit" name="type" value="Update" />
							<input type="submit" name="type" value="Delete" />
						<% } else if (request.getParameter("pagetype").equals("browsing")) { %>
							<input type="submit" name="type" value="Order" />
						<% } %>
					</td>
				</tr>
			</form>
			<% } %>
		</table>
	</div>
</body>
</html>