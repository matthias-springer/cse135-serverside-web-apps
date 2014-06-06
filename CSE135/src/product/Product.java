package product;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import connection.ConnectToDB;
import category.Category;

public class Product {

	private int ID;
	
	private String name;
	
	private String SKU;
	
	private Integer category;
	
	private int price;
	
	public Product(Integer ID, String name, String SKU, Integer category, int price) {
		this.ID = ID;
		this.setName(name);
		this.setSKU(SKU);
		this.setCategory(category);
		this.setPrice(price);
	}
	
	public Product(String name, String SKU, Integer category, int price) {
		this.ID = -1;
		this.setName(name);
		this.setSKU(SKU);
		this.setCategory(category);
		this.setPrice(price);
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getSKU() {
		return SKU;
	}

	public void setSKU(String sKU) {
		SKU = sKU;
	}

	public Integer getCategory() {
		return category;
	}

	public void setCategory(Integer category) {
		this.category = category;
	}

	public int getPrice() {
		return price;
	}

	public void setPrice(int price) {
		this.price = price;
	}
	
	public int getID() {
		return ID;
	}
	
	public void setID(int ID) {
		this.ID = ID;
	}
	
	public static List<Product> getAllProducts(Integer category, String keyword) {
		List<Product> result = new ArrayList<Product>();

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

			// Create the statement
			Statement stmt = conn.createStatement();

			if (category != -1) {
				rs = stmt
						.executeQuery("SELECT \"id\", name, sku, cid, price FROM public.\"products\" WHERE cid=" + category + " AND UPPER(name) LIKE '%" + keyword.toUpperCase() + "%' ORDER BY \"id\"");
			}
			else {
				rs = stmt
						.executeQuery("SELECT \"id\", name, sku, cid, price FROM public.\"products\" WHERE UPPER(name) LIKE '%" + keyword.toUpperCase() + "%' ORDER BY \"id\"");			
			}
			
			while (rs.next()) {
				result.add(new Product(rs.getInt("ID"), rs.getString("name"),
						rs.getString("SKU"), rs.getInt("cid"), rs.getInt("price")));
			}

		} catch (SQLException e) {
			System.out.println(e);
			return null;
		} catch (ClassNotFoundException e) {
			System.out.println(e);
			return null;
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

		return result;
	}
	
	public boolean save() {
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
			
			if (ID == -1) {
				PreparedStatement statement = conn
						.prepareStatement("INSERT INTO public.\"products\"(name,sku,cid,price) VALUES(?,?,?,?);");
				statement.setString(1, this.name);
				statement.setString(2, this.SKU);
				statement.setInt(3, this.category);
				statement.setInt(4, this.price);
				statement.execute();
			} else {
				PreparedStatement statement = conn
						.prepareStatement("UPDATE public.\"products\" SET name='"
								+ this.name
								+ "', sku='"
								+ this.SKU
								+ "', cid="
								+ new Integer(this.category).toString()
								+ ", price="
								+ new Integer(this.price).toString()
								+ " WHERE \"id\"="
								+ new Integer(this.ID).toString());
				statement.execute();
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

	public boolean delete() {
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

			PreparedStatement statement = conn
					.prepareStatement("DELETE FROM public.\"products\" WHERE \"id\"="
							+ new Integer(this.ID).toString());
			statement.execute();

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

	public static Product findProductByID(Integer ID) {
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

			// Create the statement
			Statement stmt = conn.createStatement();
			rs = stmt
					.executeQuery("SELECT \"id\", name, sku, cid, price FROM public.\"products\" WHERE \"id\" = "
							+ ID);

			while (rs.next()) {
				return new Product(rs.getInt("id"), rs.getString("name"),
						rs.getString("sku"), rs.getInt("cid"), rs.getInt("price"));
			}
			return null;

		} catch (SQLException e) {
			System.out.println(e);
			return null;
		} catch (ClassNotFoundException e) {
			System.out.println(e);
			return null;
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
