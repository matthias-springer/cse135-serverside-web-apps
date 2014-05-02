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
				if(request.getParameter("type").equals("Add"))
					Cart.addToCart(request.getParameter("latestSKU"), Integer.parseInt(request.getParameter("latestQuantity")));
				if(request.getParameter("type").equals("Delete"))
					Cart.removeFromCart(request.getParameter("SKU"));
				if(request.getParameter("type").equals("Update"))
					Cart.updateCart(request.getParameter("SKU"), Integer.parseInt(request.getParameter("Quantity")));
				
				session.setAttribute("cart", Cart.getCart());
				response.sendRedirect("productOrder.jsp");
			}
			catch(Exception e)
			{ 
				response.sendRedirect("productsBrowsing.jsp?error=1&name=" + request.getParameter("latestSKU"));
			}
	
	}
}
