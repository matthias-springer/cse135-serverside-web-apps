package sales.analytics;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import connection.ConnectToDB;

public class AnalyticsTableEntry {
	
	public final String row;
	public final String product;
	public final int sales;
	
	public AnalyticsTableEntry(String row, String product, int sales){
		this.row=row;
		this.product=product;
		this.sales=sales;
	}

	public static  List<AnalyticsTableEntry> getCustomerSalesAnalyticsDataFromDatabase(int productOffset, int customerOffset,
			String state,int  categoryID, int ageRangeID) {

		List<AnalyticsTableEntry> result = new ArrayList<AnalyticsTableEntry>();

		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String connectionString = ConnectToDB.getConnectionString();
		try {
			Class.forName("org.postgresql.Driver");
			conn = DriverManager.getConnection(connectionString);
			PreparedStatement stmt = conn.prepareStatement("select * from generate_report_customers(?,?,?,?,?)");
			stmt.setInt(1, productOffset);
			stmt.setInt(2, customerOffset);
			stmt.setString(3, state);
			stmt.setInt(4, categoryID);
			stmt.setInt(5, ageRangeID);
			rs = stmt.executeQuery();
			
			while (rs.next()) {
				AnalyticsTableEntry entry = new AnalyticsTableEntry(rs.getString("user_name"), rs.getString("product_name"), rs.getInt("sales"));
				result.add(entry);
			}

		} catch (SQLException e) {
			System.out.println(e);
			return null;
		} catch (ClassNotFoundException e) {
			System.out.println(e);
			return null;
		} finally {
			if (rs != null) {
				try {
					rs.close();
				} catch (SQLException e) {
				}
				rs = null;
			}
			if (pstmt != null) {
				try {
					pstmt.close();
				} catch (SQLException e) {
				} 
				pstmt = null;
			}
			if (conn != null) {
				try {
					conn.close();
				} catch (SQLException e) {
				} 
				conn = null;
			}
		}

		return result;
	}
	

	public static  List<AnalyticsTableEntry> getStatesSalesAnalyticsDataFromDatabase(int productOffset, int customerOffset, String state,
			int  categoryID, int ageRangeID) {

		List<AnalyticsTableEntry> result = new ArrayList<AnalyticsTableEntry>();

		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String connectionString = ConnectToDB.getConnectionString();
		try {
			Class.forName("org.postgresql.Driver");
			conn = DriverManager.getConnection(connectionString);
			PreparedStatement stmt = conn.prepareStatement("select * from generate_report_states(?,?,?,?,?)");
			stmt.setInt(1, productOffset);
			stmt.setInt(2, customerOffset);
			stmt.setString(3, state);
			stmt.setInt(4, categoryID);
			stmt.setInt(5, ageRangeID);
			rs = stmt.executeQuery();
			
			while (rs.next()) {
				AnalyticsTableEntry entry = new AnalyticsTableEntry(rs.getString("state"), rs.getString("product_name"), rs.getInt("sales"));
				result.add(entry);
			}

		} catch (SQLException e) {
			System.out.println(e);
			return null;
		} catch (ClassNotFoundException e) {
			System.out.println(e);
			return null;
		} finally {
			if (rs != null) {
				try {
					rs.close();
				} catch (SQLException e) {
				}
				rs = null;
			}
			if (pstmt != null) {
				try {
					pstmt.close();
				} catch (SQLException e) {
				} 
				pstmt = null;
			}
			if (conn != null) {
				try {
					conn.close();
				} catch (SQLException e) {
				} 
				conn = null;
			}
		}

		return result;
	}

}
