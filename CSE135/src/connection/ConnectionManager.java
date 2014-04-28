package connection;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectionManager {
	
	private static ConnectionManager instance;
	
	private static final String CONNECTION_STRING = "jdbc:postgresql://localhost/CSE135DB?user=cse135user&password=password";

	/**
	 * Get the singleton instance of the ConnectionManager.
	 * @return A ConnectionManager instance.
	 */
	public static ConnectionManager getInstance() {
		if (instance == null) {
			instance = new ConnectionManager();
		}
		
		return instance;
	}
	
	public Connection getConnection() throws SQLException, ClassNotFoundException {
		Class.forName("org.postgresql.Driver");
		Connection connection = DriverManager.getConnection(CONNECTION_STRING);
		
		connection.setAutoCommit(true);
		return connection;
	}

	
}