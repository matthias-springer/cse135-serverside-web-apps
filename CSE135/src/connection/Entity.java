package connection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public abstract class Entity<T1, T2, T3, T4> {

	private PreparedStatement insertStatement;
	
	public abstract String getTableName();
	
	public abstract String[] getColumnNames();
	
	private Connection getConnection() throws SQLException, ClassNotFoundException {
		return ConnectionManager.getInstance().getConnection();
	}
	
	private String getInsertStatement() {
		String result = "INSERT INTO public.\"" + getTableName() + "\" (";
		String qmarks = "";
		
		for (int i = 0; i < getColumnNames().length - 1; i++) {
			result += getColumnNames()[i] + ", ";
			qmarks += "?, ";
		}
		
		result += getColumnNames()[getColumnNames().length - 1] + ") VALUES (" + qmarks + "?);";
		
		return result;
	}
	
	private PreparedStatement getInsertPreparedStatement() throws SQLException, ClassNotFoundException {
		if  (insertStatement == null) {
			insertStatement = getConnection().prepareStatement(getInsertStatement());
		}
		
		return insertStatement;
	}
	
	private void setStatementParameters(PreparedStatement statement, int num, Object parameter) throws SQLException {
		if (parameter instanceof Integer) {
			statement.setInt(num, (Integer) parameter);
		}
		else if (parameter instanceof String) {
			statement.setString(num, (String) parameter);
		}
		else if (parameter instanceof Double) {
			statement.setDouble(num, (Double) parameter);
		}
		else {
			throw new SQLException("Unknown parameter type when setting statement parameter.");
		}
	}
	
	public void insertTuple(T1 t1, T2 t2, T3 t3, T4 t4) throws SQLException, ClassNotFoundException {
		PreparedStatement ps = getInsertPreparedStatement();
		
		if (t1 != null) setStatementParameters(ps, 1, t1);
		if (t2 != null) setStatementParameters(ps, 2, t2);
		if (t3 != null) setStatementParameters(ps, 3, t3);
		if (t4 != null) setStatementParameters(ps, 4, t4);
		
		ps.execute();
		//getConnection().commit();
	}
	
	public void insertTuple(T1 t1, T2 t2, T3 t3) throws ClassNotFoundException, SQLException {
		insertTuple(t1, t2, t3, null);
	}
	
	public void insertTuple(T1 t1, T2 t2) throws ClassNotFoundException, SQLException {
		insertTuple(t1, t2, null, null);
	}
	
	public void insertTuple(T1 t1) throws ClassNotFoundException, SQLException {
		insertTuple(t1, null, null, null);
	}
	
	public List<QueryResult> findTupleBy(String attribute, String value) throws SQLException, ClassNotFoundException {
		String queryString = "SELECT ";
		
		for (int i = 0; i < getColumnNames().length - 1; i++) {
			queryString += getColumnNames()[i] + ", ";
		}
		
		queryString += getColumnNames()[getColumnNames().length - 1] + " FROM public.\"" + getTableName() + "\" WHERE ";
		queryString += attribute + " = '" + value + "'"; 
				
		Statement stmt = getConnection().createStatement();
		ResultSet rs = stmt.executeQuery(queryString);
		
		List<QueryResult> result = new ArrayList<QueryResult>();
		
		while (rs.next()) {
			QueryResult qr = new QueryResult();
			
			for (int i = 1; i <= getColumnNames().length; i++) {
				if (i == 1) qr.t1 = (T1) rs.getObject(i);
				if (i == 2) qr.t2 = (T2) rs.getObject(i);
				if (i == 3) qr.t3 = (T3) rs.getObject(i);
				if (i == 4) qr.t4 = (T4) rs.getObject(i);
			}
			
			result.add(qr);
		}
		
		rs.close();
		return result;
	}
	
	public class QueryResult {
		public T1 t1;
		public T2 t2;
		public T3 t3;
		public T4 t4;
		
		public QueryResult() {
			
		}
		
		public QueryResult(T1 t1, T2 t2, T3 t3, T4 t4) {
			this.t1 = t1;
			this.t2 = t2;
			this.t3 = t3;
			this.t4 = t4;
		}
	}
}
