<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@page import="product.*"%>
<%@ page import="java.util.HashMap"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Product Order</title>
</head>
<jsp:include page="header.jsp"></jsp:include>
<body>
	<%
		int pageType = request.getParameter("pageType") == null ? 0
				: Integer.parseInt((String) request
						.getParameter("pageType"));

		if (request.getSession().getAttribute("username") == null) {
	%>
	<p>You must be logged in to see this page!</p>
	<%
		return;
		}
	%>

	<%
		if (request.getSession().getAttribute("cart") != null
				&& ((Cart) request.getSession().getAttribute("cart"))
						.getCart().size() > 0) {
	%>
	
	<% if (pageType == 2) { %>
		<h2>You just bought the following items!</h2>
	<% } else { %>
		<h2>Current shopping cart</h2>
	<% } %>
	
	<table class="table table-striped">
		<tr>
			<td><b>Name</b></td>
			<td><b>Price</b></td>
			<td><b>Quantity</b></td>
			<td><b>Total Price</b></td>
			<td></td>
		</tr>
		<%
				for (Map.Entry<Integer, Integer> entry : ((Cart) request
						.getSession().getAttribute("cart")).getCart()
						.entrySet()) {
		%>

		<tr>
			<form action="handle_productOrder" method="post">
			<td><input type="hidden" name="ID" value="<%=entry.getKey()%>" />
				<%=Product.findProductByID(entry.getKey()).getName()%></td>
			<td><%=Product.findProductByID(entry.getKey())
							.getPrice()%></td>
			<td><input <%=pageType > 0 ? "readonly=\"readonly\"" : ""%>
				type="text" name="quantity" value="<%=entry.getValue()%>" /></td>
			<td><%=Product.findProductByID(entry.getKey())
							.getPrice() * entry.getValue()%>
			<td>
				<%
						if (pageType == 0) {
					%> <input type="submit" name="type" value="Update" /><input
				type="submit" name="type" value="Delete" /> <%
 	}
 %>
			</td>
			</form>
		</tr>

		<% } %>
	</table>
	<% } %>

	<%
		if (request.getParameter("ID") != null) {
	%>
	<h2>Add a new product to the cart</h2>
	<form action="handle_productOrder" method="post">
		<input type="hidden" name="ID" value="<%=request.getParameter("ID")%>" />
		<table class="table table-striped">
			<tr>
				<td><b>Name</b></td>
				<td><%=Product.findProductByID(
						Integer.parseInt(request.getParameter("ID"))).getName()%></td>
			</tr>
			<tr>
				<td><b>Price</b></td>
				<td><%=Product.findProductByID(
						Integer.parseInt(request.getParameter("ID")))
						.getPrice()%></td>
			</tr>
			<tr>
				<td><b>Quantity</b></td>
				<td><input type="text" name="quantity" value="1" /></td>
			</tr>

		</table>

		<p>
			<input type="submit" name="type" value="Add" />
		</p>
	</form>
	<%
		}
	%>

	<%
		if (request.getSession().getAttribute("cart") != null
				&& ((Cart) request.getSession().getAttribute("cart"))
						.getCart().size() > 0) {
	%>
	<p>
		<b>Total price: </b>
		<%=((Cart) request.getSession().getAttribute("cart"))
						.getTotal()%>
	</p>
	<%
		if (pageType == 0) {
				// product order page
	%>
	<p>
		<a href="productOrder.jsp?pageType=1" style="float: right"><b>Proceed
				to checkout</b></a>
	</p>
	<%
		} else if (pageType == 1) {
				// shopping cart page
	%>

	<script>
		function ccn_changed() {
			document.getElementById("purchase").disabled = document.getElementById("ccn").value == "";
		}
	</script>
	<form action="handle_productOrder" method="post">
		<p>
			<b>Credit Card Number</b> <input name="creditcard" type="text" id="ccn" onmouseleave="ccn_changed();" onkeypress="ccn_changed();" onkeydown="ccn_changed();" onkeyup="ccn_changed();" onchange="ccn_changed();" />
		<p>
		<p>
			<input type="submit" name="type" value="Purchase" id="purchase" />
		</p>
	</form>
	<%
		} else if (pageType == 2) {
				request.getSession().removeAttribute("cart");
	%>
	<p>
		<a href="product.jsp?pagetype=browsing">Back to Products Browsing</a>
	</p>
	<%
		}
	%>
	<%
		} else {
	%>
	<h2>Your shopping cart is empty!</h2>
	<%
		}
	%>
</body>
</html>
