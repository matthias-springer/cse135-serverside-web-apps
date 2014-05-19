package connection;

public class ConnectToDB {

	public static String getConnectionString()
	{
		String s = "jdbc:postgresql://localhost/postgres?user=cse135user&password=password";
		return s;
	}

}