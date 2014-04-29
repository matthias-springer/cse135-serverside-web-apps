<script src="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js">
</script>
<link rel="stylesheet" type="text/css" href="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">

<div id="header">
	<h2>Hello <%= request.getSession().getAttribute("username") %></h2>
	<p><a style="float:right;" href="product.jsp">Products</a></p>
	<p><a style="float:right; margin-right:10px;" href="category.jsp">Categories</a></p>
	
	<% if (request.getParameter("error") != null) { %>
		<div class="alert alert-error">
			<b>Error: </b> <%= request.getParameter("error") %>
		</div>
	<% } %>
</div>
