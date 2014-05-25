<script
	src="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js">
	
</script>
<link rel="stylesheet" type="text/css"
	href="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">

<div id="header">
	<%
		if (request.getSession().getAttribute("username") != null) {
	%>
	<h2>
		Hello
		<%=request.getSession().getAttribute("username")%></h2>
	<% if (user.User.findUserByName((String) request.getSession().getAttribute("username")).isOwner()) { %>
		<p><i>You're logged in as an owner!</i><p>
	<% } else { %>
		<p><i>You're logged in as a user!</i></p>
	<% } %>
	
	<% if (user.User.findUserByName((String) request.getSession().getAttribute("username")).isOwner()) { %>
	<p>
		<a style="float: right;" href="product.jsp?pagetype=admin">Products</a>
	</p>
	<p>
		<a style="float: right; margin-right: 10px;" href="category.jsp">Categories</a>
	</p>
	<p>
		<a style="float: right; margin-right: 10px;" href="salesAnalytics.jsp">Sales Analytics</a>
	</p>
	<% } else {%>
	<p>
		<a style="float: right; margin-right: 10px;"
			href="product.jsp?pagetype=browsing">Products Browsing</a>
	</p>
	<p>
		<a style="float: right; margin-right: 10px;" href="productOrder.jsp">Shopping Cart</a>
	</p>
	<% } %>
	
	<p>
		<a style="float: right; margin-right: 10px;" href="user/logout.jsp">Logout</a>
	</p>
	<%
		} else {
	%>
	<p>
		<% if (!request.getRequestURI().contains("/user/")) { %>
			<META http-equiv="refresh" content="1;user/login.jsp">
			<a style="float: right; margin-right: 10px;" href="user/login.jsp">Login</a>
		<% } else { %>
			<a style="float: right; margin-right: 10px;" href="login.jsp">Login</a>
		<% } %>
	</p>
	<%
		}
	%>
	<%
		if (request.getParameter("error") != null) {
	%>
	<div class="alert alert-error">
		<b>Error: </b>
		<%=request.getParameter("error")%>
	</div>
	<%
		}
	%>
	
	<% if (request.getParameter("confirmation") != null) { %>
	<div class="alert alert-info">
		<b>Confirmation: </b>
		<%= request.getParameter("confirmation") %>
	</div>
	<% } %>
</div>
