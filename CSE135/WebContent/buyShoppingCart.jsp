<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@page import="product.*"%>
<%@ page import="java.util.HashMap" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Buy shopping Cart</title>
</head>
<body>
<form action="handle_finalOrder" method="post">
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
			<tr>
					<td><input type="text" readonly name="SKU" value="<%= prodSKU %>" /></td>
					<td><input type="text" readonly name="Quantity" value="<%= Cart.getCart().get(prodSKU) %>" /></td>
				</tr>
		<% } %>
</table>
<input type="submit" name="type" value="Buy!"/>
</form>
</body>
</html>