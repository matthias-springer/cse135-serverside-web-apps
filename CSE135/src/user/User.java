package user;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import connection.ConnectToDB;

public class User {

	private int ID;
	
	private String name;

	private int age;

	private String state;

	private String role;

	public boolean isOwner() {
		return role.equals("owner");
	}
	
	public User(int ID, String name, int age, String state, String role) {
		this.ID = ID;
		this.name = name;
		this.age = age;
		this.state = state;
		this.role = role;
		
		if (this.role.toUpperCase().equals("O")) {
			this.role = "owner";
		}
		else if (this.role.toUpperCase().equals("U")) {
			this.role = "customer";
		}
	}

	public User(String name, int age, String state, String role) {
		this.ID = -1;
		this.name = name;
		this.age = age;
		this.state = state;
		this.role = role;
		
		if (this.role.toUpperCase().equals("O")) {
			this.role = "owner";
		}
		else if (this.role.toUpperCase().equals("U")) {
			this.role = "customer";
		}
	}
	
	public int getID() {
		return ID;
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
			PreparedStatement statement = conn
					.prepareStatement("INSERT INTO public.\"users\"(name,role,age,state) VALUES(?,?,?,?);");
			statement.setString(1, this.name);
			statement.setString(2, this.role);
			statement.setInt(3, this.age);
			statement.setString(4, this.state);
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

	public static List<String> getAllStates()
	{
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String connectionString = ConnectToDB.getConnectionString();
		List<String> result = new ArrayList<String>();
		
		// Registering Postgresql JDBC driver with the DriverManager
		try {
			// Registering Postgresql JDBC driver with the DriverManager
			Class.forName("org.postgresql.Driver");

			// Open a connection to the database using DriverManager
			conn = DriverManager.getConnection(connectionString);

			// Create the statement
			Statement stmt = conn.createStatement();
			rs = stmt
					.executeQuery("SELECT * from public.states");
			
			while (rs.next()) {
				result.add(rs.getString("name"));
			}
			
			return result;
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
	
	public static User findUserByName(String name) {
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
					.executeQuery("SELECT \"id\",name,role,age,state FROM public.\"users\" WHERE name = '"
							+ name + "'");
			
			while (rs.next()) {
				return new User(rs.getInt("id"), rs.getString("name"), rs.getInt("age"),
						rs.getString("state"), rs.getString("role"));
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

	public static boolean exists(String username) {
		return findUserByName(username) != null;
	}

}
