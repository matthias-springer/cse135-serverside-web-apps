package category;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/CategoryHandler")
public class CategoryHandler extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public CategoryHandler() {
		super();
	}

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		if (request.getSession().getAttribute("username") == null) {
			response.sendRedirect("user/login.jsp");
			return;
		}
		String error = null;
		String confirmation = null;
		
		boolean isAdmin = user.User.findUserByName(
				(String) request.getSession().getAttribute("username"))
				.isOwner();
		
		try {
			Integer ID = Integer.parseInt(request.getParameter("ID"));
			String name = request.getParameter("name");
			String description = request.getParameter("description");

			if (request.getParameter("type").equals("Update")) {
				Category cat = Category.findCategoryByID(ID);
				cat.setName(name);
				cat.setDescription(description);

				if (!isAdmin || !cat.save()) {
					error = "Update of category " + ID + " (" + name
							+ ") failed!";
				}
				else {
					confirmation = "Updated category " + name + " with description '" + description + "' successfully!";
				}
			} else if (request.getParameter("type").equals("Delete")) {
				if (!isAdmin || !Category.findCategoryByID(ID).delete()) {
					error = "Deletion of category " + ID + " (" + name
							+ ") failed!";
				}
				else {
					confirmation = "Deleted category " + name + " with description '" + description + "' successfully!";
				}
			} else if (request.getParameter("type").equals("Insert")) {
				Category cat = new Category(name, description);

				if (!isAdmin || !cat.save()) {
					error = "Insertion of (" + name + ") failed!";
				}
				else {
					confirmation = "Inserted category " + name + " with description '" + description + "' successfully!";
				}
			}
		} catch (Exception e) {
			error = "Failed to insert/update/delete tuple!";
		} finally {
			if (error == null) {
				response.sendRedirect("category.jsp" + (confirmation == null ? "" : "?confirmation=" + confirmation));
			} else {
				response.sendRedirect("category.jsp?error=" + error);
			}
		}
	}
}
