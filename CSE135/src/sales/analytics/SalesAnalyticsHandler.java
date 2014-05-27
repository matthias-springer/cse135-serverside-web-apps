package sales.analytics;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/SalesAnalyticsHandler")
public class SalesAnalyticsHandler extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public SalesAnalyticsHandler() {
		super();
	}

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		if (request.getSession().getAttribute("username") == null) {
			response.sendRedirect("user/login.jsp");
			return;
		}

		String row = "customers";
		String state = "all";
		int categoryID = -1;
		int ageRangeID = -1;
		int rowOffset = 0;
		int productOffset = 0;
		if (request.getParameter("state") != null) {
			row = request.getParameter("row");
			state = request.getParameter("state");
			categoryID = Integer.parseInt(request.getParameter("categoryID"));
			ageRangeID = Integer.parseInt(request.getParameter("ageRangeID"));
			rowOffset = Integer.parseInt(request.getParameter("rowOffset"));
			productOffset = Integer.parseInt(request
					.getParameter("productOffset"));
		}
		response.sendRedirect("salesAnalytics.jsp?row=" + row + "&state="
				+ state + "&categoryID=" + categoryID + "&ageRangeID="
				+ ageRangeID + "&rowOffset=" + rowOffset + "&productOffset="
				+ productOffset);
	}

}
