<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@page import="product.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>

	<table>
	<tr>
		<td>ItemSKU</td>
	</tr>
	<% 
	for(Product p : Product.getAllProduct())
	{%>
	<form action="productOrder.jsp" method="post">
	<tr>
		<td><input type="text" readonly name="SKU" value="<%=p.getSKU() %>" /></td>
		<td><input type="text" readonly name="Price" value="<%=p.getPrice().toString() %>" /></td>
		<td><input type="submit" name="type" value="Order" /></td>
	</tr>
	</form>
	<%} %>	
	</table>
</body>
</html>