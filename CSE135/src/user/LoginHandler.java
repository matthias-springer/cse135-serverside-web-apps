package user;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import sun.reflect.ReflectionFactory.GetReflectionFactoryAction;

@WebServlet("/LoginHandler")
public class LoginHandler extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public LoginHandler() {
        super();
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		if (User.exists(request.getParameter("name"))) {
			HttpSession session = request.getSession();
			session.setAttribute("username", request.getParameter("name"));
			
			response.sendRedirect("../category.jsp");
		}
		else {
			response.sendRedirect("login.jsp?error=The provided name " + request.getParameter("name") + " is not known.&name=" + request.getParameter("name"));
		}
	}
}
