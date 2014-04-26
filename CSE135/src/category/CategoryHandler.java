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

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Integer ID = Integer.parseInt(request.getParameter("ID"));
		String name = request.getParameter("name");
		String description = request.getParameter("description");
		
		if (request.getParameter("type").equals("Update")) {
			// update row
		}
		else if (request.getParameter("type").equals("Delete")) {
			// delete row
		}
		else if (request.getParameter("type").equals("Insert")) {
			// insert row
		}
		
		response.sendRedirect("category.jsp");
	}
}
