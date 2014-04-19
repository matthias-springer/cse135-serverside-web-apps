<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>User Signup</title>
</head>
<body>
	<h1>User Signup</h1>
	<form action="handle_signup.jsp" method="post">
		<table>
			<tr>
				<td>Name</td>
				<td><input type="text" name="name" id="name" /></td>
			</tr>
			<tr>
				<td>Age</td>
				<td><input type="text" name="age" id="age" /></td>
			</tr>
			<tr>
				<td>Role</td>
				<td><select>
						<option value="user">User</option>
						<option value="owner">Owner</option>
				</select></td>
			</tr>
			<tr>
				<td>State</td>
				<td><select>
						<option value="ca">California</option>
				</select></td>
			</tr>
		</table>
		<p><input type="submit" value="submit" /></p>
	</form>
</body>
</html>