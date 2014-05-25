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
	
	public final String customer;
	public final String product;
	public final int sales;
	
	public AnalyticsTableEntry(String customer, String product, int sales){
		this.customer=customer;
		this.product=product;
		this.sales=sales;
	}

	public static  List<AnalyticsTableEntry> getCustomerSalesAnalyticsDataFromDatabase(
			String state, int  categoryID, int ageRangeID, int customerOffset, int productOffset) {

		List<AnalyticsTableEntry> result = new ArrayList<AnalyticsTableEntry>();

		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String connectionString = ConnectToDB.getConnectionString();
		try {
			Class.forName("org.postgresql.Driver");
			conn = DriverManager.getConnection(connectionString);
			Statement stmt = conn.createStatement();

				rs = stmt
						.executeQuery("SELECT \"id\", name, sku, cid, price FROM public.\"products\" WHERE cid=");

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

		//return result;
		return createDummyTableData();

	}
	
	public static List<AnalyticsTableEntry> createDummyTableData(){
		List<AnalyticsTableEntry> result = new ArrayList<AnalyticsTableEntry>();
		result.add(new AnalyticsTableEntry("20", "10", 0));
		for(int i=1;i <=5; i++){
			result.add(new AnalyticsTableEntry("all", "Product"+i, 90*i));
		}
		for(int i=1;i <=12; i++){
			result.add(new AnalyticsTableEntry("Customer"+i, "all", 70*i));
			for(int j=1;j <=5; j++){
				result.add(new AnalyticsTableEntry("Customer"+i, "Product"+j, 11*j));
			}
		}
		return result;
	}

}
