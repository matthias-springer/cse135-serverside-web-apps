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
	<h1>List of Products</h1>

	<div id="categories"
		style="width: 30%; float: left;">

		<table class="table table-striped">
			<tr>
				<td>Categories</td>
			</tr>

			<%
				for (category.Category cat : category.Category.getAllCategories()) {
			%>
			<tr>
				<td><a
					href="product.jsp?cat=<%=cat.getID()%>&keyword=<%=request.getParameter("keyword") == null ? ""
						: request.getParameter("keyword")%>"><%=cat.getName()%></a>
				</td>
			</tr>
			<% } %>
			<tr>
				<td><a
					href="product.jsp?cat=-1&keyword=<%=request.getParameter("keyword") == null ? "" : request
					.getParameter("keyword")%>">(all
						categories)</a></td>
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
			<form action="handle_product" method="post">
				<tr>
					<td><input type="hidden" name="ID" value="-1" />(auto)</td>
					<td><input type="text" name="name" /></td>
					<td><input type="text" name="SKU" /></td>
					<td><select name="category">
							<% for (Category cat : Category.getAllCategories()) { %>
							<option value="<%= cat.getID() %>"><%= cat.getName() %></option>
							<% } %>
					</select></td>
					<td><input type="text" name="price" /></td>
					<td><input type="submit" name="type" value="Insert" /></td>
				</tr>
			</form>
			<%
				for (product.Product pr : product.Product.getAllProducts(request.getParameter("cat") == null ? -1 : Integer.parseInt(request.getParameter("cat")), request.getParameter("keyword") == null ? "" : request.getParameter("keyword"))) {
			%>
			<form action="handle_product" method="post">
				<tr>
					<td><input type="hidden" name="ID" value="<%=pr.getID()%>" /><%=pr.getID()%></td>
					<td><input type="text" name="name" value="<%=pr.getName()%>" /></td>
					<td><input type="text" name="SKU" value="<%=pr.getSKU()%>" /></td>
					<td><select name="category">
							<% for (Category cat : Category.getAllCategories()) { %>
							<% if (pr.getCategory() == cat.getID()) { %>
							<option selected="selected" value="<%= cat.getID() %>"><%= cat.getName() %></option>
							<% } else { %>
							<option value="<%= cat.getID() %>"><%= cat.getName() %></option>
							<% } %>
							<% } %>
					</select></td>
					<td><input type="text" name="price" value="<%=pr.getPrice()%>" /></td>
					<td><input type="submit" name="type" value="Update" /><input
						type="submit" name="type" value="Delete" /></td>
				</tr>
			</form>
			<% } %>
		</table>
	</div>
</body>
</html>