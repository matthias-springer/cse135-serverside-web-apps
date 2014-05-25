<%@page import="sales.analytics.AnalyticsTableEntry"%>
<%@page import="category.Category"%>
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
</head>
<jsp:include page="header.jsp"></jsp:include>
<body>
	<%
		if (request.getSession().getAttribute("username") == null) {
	%>
	<p>You must be logged in to see this page!</p>
	<%
		return;
		}
	%>

	<%
		if (!user.User.findUserByName(
				(String) request.getSession().getAttribute("username"))
				.isOwner()) {
	%>
	<p>You do not have access to this page!</p>
	<%
		return;
		}
	%>

	<%
		String state = "all";
		int categoryID = -1;
		int ageRangeID = -1;
		int customerOffset = 0;
		int productOffset = 0;
		if (request.getParameter(state) != null) {
			state = request.getParameter("state");
			categoryID = Integer.parseInt(request
					.getParameter("categoryID"));
			ageRangeID = Integer.parseInt(request
					.getParameter("ageRangeID"));
			customerOffset = Integer.parseInt(request
					.getParameter("customerOffset"));
			productOffset = Integer.parseInt(request
					.getParameter("productOffset"));
		}
		//List<AnalyticsTableEntry> tableCellEntry = AnalyticsTableEntry.getCustomerSalesAnalyticsDataFromDatabase(state, categoryID, ageRangeID, customerOffset, productOffset);
		List<AnalyticsTableEntry> tableCellEntry = AnalyticsTableEntry
				.createDummyTableData();
		int nextCustomerOffset = Integer
				.parseInt(tableCellEntry.get(0).customer);
		int nextProdcutOffset = Integer
				.parseInt(tableCellEntry.get(0).product);
		int numberOfProduct = 0;
		for (AnalyticsTableEntry entry : tableCellEntry) {
			if ("all".equals(entry.customer)) {
				numberOfProduct++;
			}
		}
	%>

	<h1>Select your filters and submit</h1>

	<div id="filters" style="width: 100%; float: left;">

		<table class="table table-striped">
			<form action="handle_product" method="post">
				<tr>
					<td>Row selection</td>
					<td>State</td>
					<td>Product Category</td>
					<td>Age</td>
					<td>Submit Button</td>
				</tr>
				<tr>
					<td><select name="row">
							<option selected="selected" value="customers">customers</option>
							<option value="states">states</option>
					</select></td>
					<td><select name="state">
							<option selected="selected" value="all">All states</option>
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
					<td><select name="category">
							<%
								for (Category cat : Category.getAllCategories()) {
							%>
							<option value="<%=cat.getID()%>"><%=cat.getName()%></option>
							<%
								}
							%>
							<option selected="selected" value="all">All Categories</option>
					</select></td>
					<td><select name="age">
							<option selected="selected" value="all">All Ages</option>
							<option value="1">12-18</option>
							<option value="2">18-45</option>
							<option value="3">45-65</option>
							<option value="4">65-</option>
					</select></td>
					<td><input type="submit" name="type" value="Run Query" /></td>
				</tr>
			</form>

		</table>

	</div>
	<h1>Sales Analytics Data</h1>
	<div id="filters" style="width: 100%; float: left;">

		<table class="table table-striped">
			<tr>
				<td>customer/product</td>
				<%
					for (int i = 1; i <= numberOfProduct; i++) {
				%>
				<td><%=tableCellEntry.get(i).product + "("
						+ (tableCellEntry.get(i).sales) + ")"%></td>
				<% 	}
			%>
			</tr>
			<% for(int j=numberOfProduct+1;j< tableCellEntry.size();){ %>
			<tr>
				<td><%=tableCellEntry.get(j).customer + "("
						+ (tableCellEntry.get(j).sales) + ")"%> <%
					j++;
					int k=j;
					for (int i = j; i < k + numberOfProduct && i < tableCellEntry.size(); i++,j++) {
				%>
				<td><%=tableCellEntry.get(i).product + "("
						+ (tableCellEntry.get(i).sales) + ")"%></td>
				<% 	}
			%>

			</tr>
			<% 	}
			%>

		</table>

	</div>

</body>
</html>