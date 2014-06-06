package product;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import user.User;

@WebServlet("/ProductOrderHandler")
public class ProductOrderHandler extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public ProductOrderHandler() {
        super();
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
			HttpSession session = request.getSession();
			
			try{
				Cart cart = request.getSession().getAttribute("cart") == null ?
						new Cart() : (Cart) request.getSession().getAttribute("cart");
				if(request.getParameter("type").equals("Add"))
					cart.addToCart(Integer.parseInt(request.getParameter("ID")), Integer.parseInt(request.getParameter("quantity")));
				else if(request.getParameter("type").equals("Delete"))
					cart.removeFromCart(Integer.parseInt(request.getParameter("ID")));
				else if(request.getParameter("type").equals("Update"))
					cart.updateCart(Integer.parseInt(request.getParameter("ID")), Integer.parseInt(request.getParameter("quantity")));
				else if (request.getParameter("type").equals("Purchase")) {
					cart.save(((User) session.getAttribute("user")).getID(), ((User) session.getAttribute("user")).getState());
					response.sendRedirect("productOrder.jsp?pageType=2");
					return;
				}
				
				session.setAttribute("cart", cart);
				response.sendRedirect("product.jsp?pagetype=browsing");
			}
			catch(Exception e)
			{ 
				e.printStackTrace();
				//response.sendRedirect("productsBrowsing.jsp?error=1&name=" + request.getParameter("ID"));
			}
	
	}
}
