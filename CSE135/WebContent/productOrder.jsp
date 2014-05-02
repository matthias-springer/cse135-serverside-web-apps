<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@page import="product.*"%>
<%@ page import="java.util.HashMap" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Product Order</title>
</head>
<jsp:include page="header.jsp"></jsp:include>
<body>
	<% if (request.getSession().getAttribute("username") == null) { %>
		<p>You must be logged in to see this page!</p>
	<% return;
	} %>
	
<form action="handle_productOrder" method="post">
<table>
<tr>
	<td>Item SKU</td>
	<td>Quantity</td>
</tr>
<% //Fetch the cart from the session. 
//Show its contents alongwith the product name that has been clicked on the productsBrowsing.jsp
//that has brought the user to this page.

        //@SupressWarnings("unchecked")
		Cart.setCart((HashMap<String,Integer>)session.getAttribute("cart"));
		for(String prodSKU : Cart.getCart().keySet())
		{
			%>
			<form action="handle_productOrder" method="post">
			<tr>
					<td><input type="text" readonly name="SKU" value="<%= prodSKU %>" /></td>
					<td><input type="text" name="Quantity" value="<%= Cart.getCart().get(prodSKU) %>" /></td>
					<td><input type="submit" name="type" value="Update" /><input type="submit" name="type" value="Delete" /></td>
			</tr>
			</form>
		<% } %>
	<form action="handle_productOrder" method="post">
<tr><td><input type="text" name="latestSKU" value="<%= request.getParameter("SKU")==null?"":request.getParameter("SKU") %>" /></td>
<td><input type="text" name="latestQuantity" /></td>
<td><input type="submit" name="type" value="Add" /></td>
</form>
</table>
<a href="productsBrowsing.jsp">Shop more!</a>
<a href="buyShoppingCart.jsp" style="float:right">Proceed to checkout</a>
</body>
</html>
