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
		int ageRangeID = -1;
		int rowOffset = 0;
		int productOffset = 0;
		List<AnalyticsTableEntry> tableCellEntry;
		if (request.getParameter("state") != null) {
			row = request.getParameter("row");
			state = request.getParameter("state");
			categoryID = Integer.parseInt(request
					.getParameter("categoryID"));
			ageRangeID = Integer.parseInt(request
					.getParameter("ageRangeID"));
			rowOffset = Integer.parseInt(request.getParameter("rowOffset"));
			productOffset = Integer.parseInt(request
					.getParameter("productOffset"));
		}
		if ("customers".equals(row)) {
			tableCellEntry = AnalyticsTableEntry
					.getCustomerSalesAnalyticsDataFromDatabase(
							productOffset, rowOffset, state, categoryID,
							ageRangeID);
		} else {
			tableCellEntry = AnalyticsTableEntry
					.getStatesSalesAnalyticsDataFromDatabase(productOffset,
							rowOffset, categoryID, ageRangeID);
		}

		int nextRowOffset = Integer.parseInt(tableCellEntry.get(0).row);
		int nextProdcutOffset = Integer
				.parseInt(tableCellEntry.get(0).product);
		int numberOfProduct = 0;
		for (AnalyticsTableEntry entry : tableCellEntry) {
			if ("all".equals(entry.row)) {
				numberOfProduct++;
			}
		}
	%>

	<h1>Select your filters and submit</h1>

	<div id="filters" style="width: 100%; float: left;">

		<table class="table table-striped">
			<form action="handle_sales_analytics" method="post">
				<tr>
					<td>Row selection</td>
					<td>State</td>
					<td>Product Category</td>
					<td>Age</td>
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
							<option value="<%=st%>"><%=st%></option>
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
					<td><select name="ageRangeID">
							<%
								if (ageRangeID == -1) {
							%>
							<option selected="selected" value="-1">All Ages</option>
							<%
								} else {
							%>
							<option value="-1">All Ages</option>
							<%
								}
							%>
							<%
								if (ageRangeID == 1) {
							%>
							<option selected="selected" value="1">12-18</option>
							<%
								} else {
							%>
							<option value="1">12-18</option>
							<%
								}
							%>
							<%
								if (ageRangeID == 2) {
							%>
							<option selected="selected" value="2">18-45</option>
							<%
								} else {
							%>
							<option value="2">18-45</option>
							<%
								}
							%>
							<%
								if (ageRangeID == 3) {
							%>
							<option selected="selected" value="3">45-65</option>
							<%
								} else {
							%>
							<option value="3">45-65</option>
							<%
								}
							%>
							<%
								if (ageRangeID == 4) {
							%>
							<option selected="selected" value="4">65-</option>
							<%
								} else {
							%>
							<option value="4">65-</option>
							<%
								}
							%>
					</select></td>
					<td><input type="hidden" name="rowOffset" value="0" /> <input
						type="hidden" name="productOffset" value="0" /> <input
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
				<td>customer/product</td>
				<%
					} else {
				%>
				<td>State/product</td>
				<%
					}
				%>
				<%
					for (int i = 1; i <= numberOfProduct; i++) {
				%>
				<td><%=tableCellEntry.get(i).product + "("
						+ (tableCellEntry.get(i).sales) + ")"%></td>
				<%
					}
				%>
				<td>
					<form action="handle_sales_analytics" method="post">
						<input type="hidden" name="row" value="<%=row%>" /> <input
							type="hidden" name="state" value="<%=state%>" /> <input
							type="hidden" name="categoryID" value="<%=categoryID%>" /> <input
							type="hidden" name="ageRangeID" value="<%=ageRangeID%>" /> <input
							type="hidden" name="rowOffset" value="<%=rowOffset%>" /> <input
							type="hidden" name="productOffset" value="<%=productOffset + 10%>" />
						<input type="submit" name="submit1"
							value="Get next 10 products >>" />
					</form>
				</td>
			</tr>
			<%
				for (int j = numberOfProduct + 1; j < tableCellEntry.size();) {
			%>
			<tr>
				<td><%=tableCellEntry.get(j).row + "("
						+ (tableCellEntry.get(j).sales) + ")"%> <%
 	j++;
 		int k = j;
 		for (int i = j; i < k + numberOfProduct
 				&& i < tableCellEntry.size(); i++, j++) {
 %>
				<td><%=tableCellEntry.get(i).sales%></td>
				<%
					}
				%>

			</tr>
			<%
				}
			%>
			<%
				if (nextRowOffset != 0) {
			%>
			<tr>
				<td><form action="handle_sales_analytics" method="post">
						<input type="hidden" name="row" value="<%=row%>" /> <input
							type="hidden" name="state" value="<%=state%>" /> <input
							type="hidden" name="categoryID" value="<%=categoryID%>" /> <input
							type="hidden" name="ageRangeID" value="<%=ageRangeID%>" /> <input
							type="hidden" name="rowOffset" value="<%=nextRowOffset%>" /> <input
							type="hidden" name="productOffset" value="<%=productOffset%>" />
						<input type="submit" name="submit2"
							value="Get next 20 <%=" " + row + " >>"%> " />
					</form></td>
			</tr>
			<%
				}
			%>
		</table>

	</div>

</body>
</html>