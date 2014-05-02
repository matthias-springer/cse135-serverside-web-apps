package product;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import category.Category;

@WebServlet("/ProductHandler")
public class ProductHandler extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public ProductHandler() {
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
			String SKU = request.getParameter("SKU");
			Integer category = Integer.parseInt(request
					.getParameter("category"));
			Integer price = Integer.parseInt(request.getParameter("price"));

			if (request.getParameter("type").equals("Update")) {
				Product pr = Product.findProductByID(ID);
				pr.setName(name);
				pr.setSKU(SKU);
				pr.setCategory(category);
				pr.setPrice(price);

				if (!isAdmin || !pr.save()) {
					error = "Update of product " + ID + " (" + name
							+ ") failed!";
				} else {
					confirmation = "Updated an existing proudct " + name
							+ " with SKU " + SKU + " and price " + price
							+ " and cateogory "
							+ Category.findCategoryByID(category).getName()
							+ "!";
				}
			} else if (request.getParameter("type").equals("Delete")) {
				if (!isAdmin || !Product.findProductByID(ID).delete()) {
					error = "Deletion of product " + ID + " (" + name
							+ ") failed!";
				} else {
					confirmation = "Deletion of product " + ID + " (" + name
							+ ") was successful!";
				}
			} else if (request.getParameter("type").equals("Insert")) {
				Product pr = new Product(name, SKU, category, price);

				if (!isAdmin || !pr.save()) {
					error = "Insertion of product (" + name + ") failed!";
				} else {
					confirmation = "Inserted a new product " + name
							+ " with SKU " + SKU + " and price " + price
							+ " and cateogory "
							+ Category.findCategoryByID(category).getName()
							+ "!";
				}
			} else if (request.getParameter("type").equals("Order")) {
				response.sendRedirect("productOrder.jsp?ID=" + ID);
				return;
			}
		} catch (Exception e) {
			error = "Failed to insert/update/delete tuple!";
		}

		response.sendRedirect("product.jsp?cat="
				+ (request.getParameter("cat") == null ? "-1" : request
						.getParameter("cat"))
				+ "&keyword="
				+ (request.getParameter("keyword") == null ? "" : request
						.getParameter("keyword"))
				+ (error == null ? "" : "&error=" + error) + "&pagetype="
				+ request.getParameter("pagetype")
				+ (confirmation == null ? "" : "&confirmation=" + confirmation));

	}

}
