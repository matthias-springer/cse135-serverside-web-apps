package product;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import sun.reflect.ReflectionFactory.GetReflectionFactoryAction;

@WebServlet("/ProductOrderHandler")
public class ProductOrderHandler extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public ProductOrderHandler() {
        super();
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
			HttpSession session = request.getSession();
			
			try{
				
				Cart.addToCart(request.getParameter("latestSKU"), Integer.parseInt(request.getParameter("latestQuantity")));
				session.setAttribute("cart", Cart.getCart());
				response.sendRedirect("productsBrowsing.jsp");
			}
			catch(Exception e)
			{ 
				response.sendRedirect("productsBrowsing.jsp?error=1&name=" + request.getParameter("latestSKU"));
			}
	
	}
}
