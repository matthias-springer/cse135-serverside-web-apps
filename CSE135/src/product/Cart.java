package product;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.text.SimpleDateFormat;
import java.sql.Date;

import javax.servlet.http.HttpSession;

import org.apache.catalina.util.SessionIdGenerator;
import org.joda.time.DateTime;

import connection.ConnectToDB;

public class Cart {
	
	private static HashMap<String,Integer> cart;
	
	public static HashMap<String,Integer> addToCart(String SKU, int quantity)
	{
		if(cart.containsKey(SKU))
			cart.put(SKU,cart.get(SKU)+quantity);
		else
			cart.put(SKU,quantity);
		return cart;
	}
	
	public static HashMap<String,Integer> removeFromCart(String SKU)
	{
		if(cart.containsKey(SKU))
		cart.remove(SKU);
		return cart;
	}
	
	public static HashMap<String,Integer> updateCart(String SKU, int quantity)
	{
		if(cart.containsKey(SKU))
		cart.put(SKU,quantity);
		return cart;
	}
	
	public static HashMap<String,Integer> getCart() {
		if(cart==null)
			cart = new HashMap<String,Integer>();
		return cart;
	}
	
	public static void setCart(HashMap<String,Integer> cartFromSession) {
		if(cartFromSession!=null)
		cart = cartFromSession;
	}
	
	public static boolean save(HttpSession session) {
		//Use sessionID as the orderID
		
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
			PreparedStatement statement = conn.prepareStatement("INSERT INTO public.\"UserOrders\"(\"Username\",\"OrderID\",\"OrderDate\") VALUES(?,?,?);");
			statement.setString(1, (String)session.getAttribute("username"));
			statement.setString(2, (String)session.getId());
			//******************************************USED JODA TIME LIBRARY FOR DATE/TIME FUNCTIONS*********************
			//DateTime d = new DateTime();
			//new Date().get
			statement.setTimestamp(3, new java.sql.Timestamp(new java.util.Date().getTime()));
			//statement.setDate(3, new java.sql.Date(d.getMillis()));
			//*************************************************************************************************************
			statement.execute();
			
			PreparedStatement statement1 = conn.prepareStatement("INSERT INTO public.\"OrderDetails\"(\"OrderID\",\"SKU\",\"Quantity\") VALUES(?,?,?);");
			statement1.setString(1, (String)session.getId());
			for(String key : cart.keySet())
			{
				statement1.setString(2,key);
				statement1.setInt(3,cart.get(key));
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
