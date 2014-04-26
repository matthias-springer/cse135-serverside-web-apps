package connection;

public class ConnectToDB {

	public static String getConnectionString()
	{
		String s = "jdbc:postgresql://localhost/CSE135DB?user=cse135user&password=password";
		return s;
	}

}