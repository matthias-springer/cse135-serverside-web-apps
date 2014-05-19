package category;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import product.Product;
import user.User;
import connection.ConnectToDB;

public class Category {

	private int ID = -1;

	private String name;

	private String description;

	public int getID() {
		return ID;
	}

	public String getName() {
		return name;
	}

	public String getDescription() {
		return description;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public Category(Integer ID, String name, String description) {
		this.ID = ID;
		this.name = name;
		this.description = description;
	}

	public Category(String name, String description) {
		this.name = name;
		this.description = description;
	}

	public boolean hasProducts() {
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
					.executeQuery("SELECT \"id\", name, sku, cid, price FROM public.\"products\" WHERE \"cid\" = "
							+ ID);

			while (rs.next()) {
				return true;
			}
			return false;

		} catch (SQLException e) {
			System.out.println(e);
			return true;
		} catch (ClassNotFoundException e) {
			System.out.println(e);
			return true;
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
	
	public static List<Category> getAllCategories() {
		List<Category> result = new ArrayList<Category>();

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
					.executeQuery("SELECT \"id\", name, description FROM public.\"categories\" ORDER BY \"id\"");

			while (rs.next()) {
				result.add(new Category(rs.getInt("id"), rs.getString("name"),
						rs.getString("description")));
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
						.prepareStatement("INSERT INTO public.\"categories\"(name,description) VALUES(?,?);");
				statement.setString(1, this.name);
				statement.setString(2, this.description);
				statement.execute();
			} else {
				PreparedStatement statement = conn
						.prepareStatement("UPDATE public.\"categories\" SET name='"
								+ this.name
								+ "', description='"
								+ this.description
								+ "' WHERE \"id\"="
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
					.prepareStatement("DELETE FROM public.\"categories\" WHERE \"id\"="
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

	public static Category findCategoryByID(Integer ID) {
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
					.executeQuery("SELECT \"id\", name, description FROM public.\"categories\" WHERE \"id\" = "
							+ ID);

			while (rs.next()) {
				return new Category(rs.getInt("id"), rs.getString("name"),
						rs.getString("description"));
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
