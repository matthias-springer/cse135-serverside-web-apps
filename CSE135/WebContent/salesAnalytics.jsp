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
		String row = "customers";
		String state = "all";
		int categoryID = -1;
		int numberOfProduct = 0;
		List<AnalyticsTableEntry> tableCellEntry;
		if (request.getParameter("state") != null) {
			row = request.getParameter("row");
			state = request.getParameter("state");
			categoryID = Integer.parseInt(request
					.getParameter("categoryID"));
		}
		if ("customers".equals(row)) {
			tableCellEntry = AnalyticsTableEntry
					.getCustomerSalesAnalyticsDataFromDatabase( state, categoryID);
		} else {
			tableCellEntry = AnalyticsTableEntry.getStatesSalesAnalyticsDataFromDatabase(state, categoryID);
		}
		for (AnalyticsTableEntry entry : tableCellEntry) {
			if ("all".equals(entry.row)) {
				numberOfProduct++;
			}
		}
	%>

	<h1>Select your filters and submit</h1>

	<div id="filters" style="width: 100%; float: left;" >

		<table class="table table-striped">
			<form action="handle_sales_analytics" method="post">
				<tr>
					<td>Row selection</td>
					<td>State</td>
					<td>Product Category</td>
					<td>Submit Button</td>
				</tr>
				<tr>
					<td><select name="row">
							<%
								if ("customers".equals(row)) {
							%>
							<option selected="selected" value="customers">customers</option>
							<option value="state">states</option>
							<%
								} else {
							%>
							<option value="customers">customers</option>
							<option selected="selected" value="state">states</option>

							<%
								}
							%>
					</select></td>
					<td><select name="state">
							<option selected="selected" value="all">All states</option>
							<%
								List<String> states = user.User.getAllStates();
								for (String st : states) {
							%>
							<option value="<%=st%>" <%= st.equals(request.getParameter("state")) ? "selected=\"selected\"" : "" %>><%=st%></option>
							<%
							
								}
							%>
					</select></td>
					<td><select name="categoryID">
							<%
								for (Category cat : Category.getAllCategories()) {
							%>
							<%
								if (categoryID == cat.getID()) {
							%>
							<option selected="selected" value="<%=cat.getID()%>"><%=cat.getName()%></option>
							<%
								} else {
							%>
							<option value="<%=cat.getID()%>"><%=cat.getName()%></option>
							<%
								}
							%>

							<%
								}
							%>
							<%
								if (categoryID == -1) {
							%>
							<option selected="selected" value="-1">All Categories</option>
							<%
								} else {
							%>
							<option value="-1">All Categories</option>
							<%
								}
							%>
					</select></td>
					<td> <input
						type="submit" name="submit" value="Run Query" /></td>
				</tr>
			</form>

		</table>

	</div>
	<h1>Sales Analytics Data</h1>
	<div id="filters" style="width: 100%; float: left;">

		<table class="table table-striped">
			<tr>
				<%
					if ("customers".equals(row)) {
				%>
				<td><b>customer/product</b></td>
				<%
					} else {
				%>
				<td><b>State/product</b></td>
				<%
					}
				%>
				<%
					for (int i = 0; i < numberOfProduct; i++) {
				%>
				<td><b><%=tableCellEntry.get(i).product + " ("
						+ (tableCellEntry.get(i).sales) + ")"%></b></td>
				<%
					}
				%>
			</tr>
			<%
				for (int j = numberOfProduct; j < tableCellEntry.size();) {
			%>
			<tr>
				<td><b><%=tableCellEntry.get(j).row + " ("
						+ (tableCellEntry.get(j).sales) + ")"%></b></td> <%
 				j++;
			 				int k = j;
			 		for (int i = j; i < k + numberOfProduct
 							&& i < tableCellEntry.size(); i++, j++) {
				 %>
				<td><b><%=tableCellEntry.get(i).sales%></b></td>
				<%
					}
				%>

			</tr>
			<% 
				}
			%>
		</table>

	</div>

</body>
</html>