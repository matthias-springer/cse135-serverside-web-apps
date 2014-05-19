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
			session.setAttribute("user", User.findUserByName(request.getParameter("name")));
			
			if (session.getAttribute("user") == null) System.out.println("(debug) ERROR!");
			
			if (user.User.findUserByName((String) request.getSession().getAttribute("username")).isOwner())
				response.sendRedirect("../product.jsp?pagetype=admin");
			else 
				response.sendRedirect("../product.jsp?pagetype=browsing");
		}
		else {
			response.sendRedirect("login.jsp?error=The provided name " + request.getParameter("name") + " is not known.&name=" + request.getParameter("name"));
		}
	}
}
