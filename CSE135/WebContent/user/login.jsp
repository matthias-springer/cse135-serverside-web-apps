<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>User Login</title>
<script language="javascript">
function checkAllInputProvided(evt) {
	var textName = document.getElementById("name").value;
	
	document.getElementById("submit").disabled = textName == "";
}
</script>
</head>
<body>
	<h1>User Login</h1>
	
	<% if (request.getParameter("error") != null) { %>
		<p>The provided name <%= request.getParameter("name") %> is not known.</p>
	<% } %>
	
	<form action="handle_login" method="post">
		<table>
			<tr>
				<td>Name</td>
				<td><input type="text" value="<%= request.getParameter("name") == null ? "" : request.getParameter("name") %>" name="name" id="name" onmouseup="checkAllInputProvided(event);" onmouseout="checkAllInputProvided(event);" onclick="checkAllInputProvided(event);" onchange="checkAllInputProvided(event);" onkeyup="checkAllInputProvided(event);" /></td>
			</tr>
		</table>
		<p>
			<input type="submit" value="submit" id="submit" name="submit" disabled="disabled" />
		</p>
	</form>
</body>
</html>