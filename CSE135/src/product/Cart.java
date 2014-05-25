package product;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import connection.ConnectToDB;

public class Cart {

	// product id, quantity
	private Map<Integer, Integer> cart = new HashMap<Integer, Integer>();

	public Map<Integer, Integer> getCart() {
		return cart;
	}
	
	public Float getTotal() {
		float total = 0;
		
		for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
			total += entry.getValue() * Product.findProductByID(entry.getKey()).getPrice();
		}
		
		return total;
	}
	
	public void addToCart(Integer ID,
			Integer quantity) {
		if (cart.containsKey(ID))
			cart.put(ID, cart.get(ID) + quantity);
		else
			cart.put(ID, quantity);
	}

	public void removeFromCart(Integer ID) {
		if (cart.containsKey(ID))
			cart.remove(ID);
	}

	public void updateCart(Integer ID, Integer quantity) {
		if (quantity == 0) {
			removeFromCart(ID);
			return;
		}
		
		if (cart.containsKey(ID))
			cart.put(ID, quantity);
	}

	public boolean save(Integer userid) {
		// Use sessionID as the orderID

		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String connectionString = ConnectToDB.getConnectionString();
		// Registering Postgresql JDBC driver with the DriverManager
		try {
			// Registering Postgresql JDBC driver with the DriverManager
			Class.forName("org.postgresql.Driver");

			// Open a connection to the database using DriverManager
			conn = DriverManager.getConnection(connectionString);
			conn.setAutoCommit(false);
			// Create the statement
			//PreparedStatement statement = conn
			//		.prepareStatement("INSERT INTO public.\"UserOrders\"(\"Username\",\"OrderID\",\"OrderDate\") VALUES(?,?,?);");
			//statement.setString(1, username);
			//statement.setString(2, sessionId);
			// ******************************************USED JODA TIME LIBRARY
			// FOR DATE/TIME FUNCTIONS*********************
			// DateTime d = new DateTime();
			// new Date().get
			//statement.setTimestamp(3, new java.sql.Timestamp(
			//		new java.util.Date().getTime()));
			// statement.setDate(3, new java.sql.Date(d.getMillis()));
			// *************************************************************************************************************
			//statement.execute();

			PreparedStatement statement1 = conn
					.prepareStatement("INSERT INTO public.\"sales\"(\"uid\",\"pid\",\"quantity\", price) VALUES(?,?,?,?);");
			statement1.setInt(1, userid);
			for (Integer key : cart.keySet()) {
				statement1.setInt(2, key);
				statement1.setInt(3, cart.get(key));
				
				float productsPrice = Product.findProductByID(key).getPrice() * cart.get(key);
				statement1.setFloat(4, productsPrice);
				statement1.execute();
			}

			conn.commit();

			// Close the ResultSet
			// rs.close();

			// Close the Statement
			// statement.close();

			// Close the Connection
			// conn.close();
			return true;

		} catch (SQLException e) {
			System.out.println(e);
			return false;
		} catch (ClassNotFoundException e) {
			System.out.println(e);
			return false;
		} finally {
			// Release resources in a finally block in reverse-order of
			// their creation

			if (rs != null) {
				try {
					rs.close();
				} catch (SQLException e) {
				} // Ignore
				rs = null;
			}
			if (pstmt != null) {
				try {
					pstmt.close();
				} catch (SQLException e) {
				} // Ignore
				pstmt = null;
			}
			if (conn != null) {
				try {
					conn.close();
				} catch (SQLException e) {
				} // Ignore
				conn = null;
			}
		}
	}

}
