package product;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import sun.reflect.ReflectionFactory.GetReflectionFactoryAction;

@WebServlet("/FinalOrderHandler")
public class FinalOrderHandler extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public FinalOrderHandler() {
        super();
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
			HttpSession session = request.getSession();
			
			try{
				Cart.setCart((HashMap<String,Integer>)session.getAttribute("cart"));
				if(Cart.save(session))
				response.sendRedirect("confirmation.jsp");
				else 
				response.sendRedirect("buyShoppingCart.jsp?error=1");
					
			}
			catch(Exception e)
			{ 
				response.sendRedirect("buyShoppingCart.jsp?error=1");
			}
	
	}
}
