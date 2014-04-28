<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>User Signup</title>
<script language="javascript">
function isNumber(evt) {
    evt = (evt) ? evt : window.event;
    var charCode = (evt.which) ? evt.which : evt.keyCode;
    if (charCode > 31 && (charCode < 48 || charCode > 57)) {
        return false;
    }
    return true;
}

function checkAllInputProvided(evt) {
	var textName = document.getElementById("name").value;
	var textAge = document.getElementById("age").value;
	
	document.getElementById("submit").disabled = textName == "" || textAge == "";
}
</script>
</head>
<body>
	<h1>User Signup</h1>
	<form action="handle_signup.jsp" method="post">
		<table>
			<tr>
				<td>Name</td>
				<td><input type="text" name="name" id="name" onmouseup="checkAllInputProvided(event);" onmouseout="checkAllInputProvided(event);" onclick="checkAllInputProvided(event);" onchange="checkAllInputProvided(event);" onkeyup="checkAllInputProvided(event);" /></td>
			</tr>
			<tr>
				<td>Age</td>
				<td><input type="text" name="age" id="age" onmouseup="checkAllInputProvided(event);" onmouseout="checkAllInputProvided(event);" onclick="checkAllInputProvided(event);" onchange="checkAllInputProvided(event);" onkeyup="checkAllInputProvided(event);" onkeypress="return isNumber(event);" /></td>
			</tr>
			<tr>
				<td>Role</td>
				<td><select name="role">
						<option value="U">User</option>
						<option value="O">Owner</option>
				</select></td>
			</tr>
			<tr>
				<td>State</td>
				<td><select name="state">
						<option value="AL">AL</option>
						<option value="AK">AK</option>
						<option value="AZ">AZ</option>
						<option value="AR">AR</option>
						<option value="CA">CA</option>
						<option value="CO">CO</option>
						<option value="CT">CT</option>
						<option value="DE">DE</option>
						<option value="DC">DC</option>
						<option value="FL">FL</option>
						<option value="GA">GA</option>
						<option value="HI">HI</option>
						<option value="ID">ID</option>
						<option value="IL">IL</option>
						<option value="IN">IN</option>
						<option value="IA">IA</option>
						<option value="KS">KS</option>
						<option value="KY">KY</option>
						<option value="LA">LA</option>
						<option value="ME">ME</option>
						<option value="MD">MD</option>
						<option value="MA">MA</option>
						<option value="MI">MI</option>
						<option value="MN">MN</option>
						<option value="MS">MS</option>
						<option value="MO">MO</option>
						<option value="MT">MT</option>
						<option value="NE">NE</option>
						<option value="NV">NV</option>
						<option value="NH">NH</option>
						<option value="NJ">NJ</option>
						<option value="NM">NM</option>
						<option value="NY">NY</option>
						<option value="NC">NC</option>
						<option value="ND">ND</option>
						<option value="OH">OJ</option>
						<option value="OK">OK</option>
						<option value="OR">OR</option>
						<option value="PA">PA</option>
						<option value="RI">RI</option>
						<option value="SC">SC</option>
						<option value="SD">SD</option>
						<option value="TN">TN</option>
						<option value="TX">TX</option>
						<option value="UT">UT</option>
						<option value="VT">VT</option>
						<option value="VA">VA</option>
						<option value="WA">WA</option>
						<option value="WV">WV</option>
						<option value="WI">WI</option>
						<option value="WY">WY</option>
				</select></td>
			</tr>
		</table>
		<p>
			<input type="submit" value="submit" id="submit" name="submit" disabled="disabled" />
		</p>
	</form>
</body>
</html>