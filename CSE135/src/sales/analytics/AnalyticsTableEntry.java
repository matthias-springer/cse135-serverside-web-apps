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

	public AnalyticsTableEntry(String row, String product, int sales) {
		this.row = row;
		this.product = product;
		this.sales = sales;
	}

	public static List<AnalyticsTableEntry> getCustomerSalesAnalyticsDataFromDatabase(
			String state, int categoryID) {

		List<AnalyticsTableEntry> result = new ArrayList<AnalyticsTableEntry>();
		List<AnalyticsTableEntry> customerData = new ArrayList<AnalyticsTableEntry>();
		List<AnalyticsTableEntry> productData = new ArrayList<AnalyticsTableEntry>();
		List<AnalyticsTableEntry> customerProductData = new ArrayList<AnalyticsTableEntry>();
		String queryForCustomerAggregatedData = getQueryForCustomerAggregatedData(
				state, categoryID);
		String queryForProductAggregatedData = getQueryForProductAggregatedData(
				state, categoryID);
		String queryForCustomerProductData = getQueryForCustomerProductData(
				state, categoryID);

		Connection conn = null;
		PreparedStatement pstmt = null;
		Statement stmt = null;
		ResultSet rs = null;
		String connectionString = ConnectToDB.getConnectionString();
		try {
			Class.forName("org.postgresql.Driver");
			conn = DriverManager.getConnection(connectionString);
			conn.setAutoCommit(false);
			stmt = conn.createStatement();
			stmt.execute("CREATE TEMP TABLE user_temp (uid int, sales int ) 	ON COMMIT DELETE ROWS;");
			stmt.execute(queryForCustomerAggregatedData);
			rs = stmt
					.executeQuery("select u.name as user_name, ut.sales from user_temp ut join users u on (u.id = ut.uid) order by sales desc");

			while (rs.next()) {
				AnalyticsTableEntry entry = new AnalyticsTableEntry(
						rs.getString("user_name"),
						"all", rs.getInt("sales"));
				customerData.add(entry);
			}
			stmt.execute("CREATE TEMP TABLE product_temp (pid int, sales int) ON COMMIT DELETE ROWS;");
			stmt.execute(queryForProductAggregatedData);
			rs = stmt.executeQuery("select p.name as product_name, pt.sales   from product_temp pt join products p on (p.id = pt.pid) order by pt.sales desc ");

			while (rs.next()) {
				AnalyticsTableEntry entry = new AnalyticsTableEntry("all", rs.getString("product_name") ,rs.getInt("sales"));
				productData.add(entry);
			}

			rs = stmt.executeQuery(queryForCustomerProductData);
			while (rs.next()) {
				AnalyticsTableEntry entry = new AnalyticsTableEntry(rs.getString("user_name"), rs.getString("product_name") ,rs.getInt("sales"));
				customerProductData.add(entry);
			}
			
			result.addAll(productData);
			int numOfProducts = productData.size();
			int count =0;
			for(AnalyticsTableEntry customerEntry : customerData){
				result.add(customerEntry);
				for(int i=0; i < numOfProducts; i++){
					result.add(customerProductData.get(count));
					count++;
				}
			}
			
			conn.commit();
			conn.setAutoCommit(true);
			conn.close();

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


	public static List<AnalyticsTableEntry> getStatesSalesAnalyticsDataFromDatabase(
String state, int categoryID) {

		List<AnalyticsTableEntry> result = new ArrayList<AnalyticsTableEntry>();
		List<AnalyticsTableEntry> stateData = new ArrayList<AnalyticsTableEntry>();
		List<AnalyticsTableEntry> productData = new ArrayList<AnalyticsTableEntry>();
		List<AnalyticsTableEntry> stateProductData = new ArrayList<AnalyticsTableEntry>();
		String queryForStateAggregatedData = getQueryForStateAggregatedData(
				state, categoryID);
		String queryForProductAggregatedData = getQueryForProductAggregatedData(
				state, categoryID);
		String queryForStateProductData = getQueryForStateProductData(
				state, categoryID);

		Connection conn = null;
		PreparedStatement pstmt = null;
		Statement stmt = null;
		ResultSet rs = null;
		String connectionString = ConnectToDB.getConnectionString();
		try {
			Class.forName("org.postgresql.Driver");
			conn = DriverManager.getConnection(connectionString);
			conn.setAutoCommit(false);
			stmt = conn.createStatement();
			stmt.execute("CREATE TEMP TABLE state_temp (state text, sales int ) ON COMMIT DELETE ROWS;");
			stmt.execute(queryForStateAggregatedData);
			rs = stmt
					.executeQuery("select st.state, st.sales from state_temp st order by st.sales desc");

			while (rs.next()) {
				AnalyticsTableEntry entry = new AnalyticsTableEntry(
						rs.getString("state"),
						"all", rs.getInt("sales"));
				stateData.add(entry);
			}
			stmt.execute("CREATE TEMP TABLE product_temp (pid int, sales int) ON COMMIT DELETE ROWS;");
			stmt.execute(queryForProductAggregatedData);
			rs = stmt.executeQuery("select p.name as product_name, pt.sales   from product_temp pt join products p on (p.id = pt.pid) order by pt.sales desc ");

			while (rs.next()) {
				AnalyticsTableEntry entry = new AnalyticsTableEntry("all", rs.getString("product_name") ,rs.getInt("sales"));
				productData.add(entry);
			}

			rs = stmt.executeQuery(queryForStateProductData);
			while (rs.next()) {
				AnalyticsTableEntry entry = new AnalyticsTableEntry(rs.getString("state"), rs.getString("product_name") ,rs.getInt("sales"));
				stateProductData.add(entry);
			}
			
			result.addAll(productData);
			int numOfProducts = productData.size();
			int count =0;
			for(AnalyticsTableEntry customerEntry : stateData){
				result.add(customerEntry);
				for(int i=0; i < numOfProducts; i++){
					result.add(stateProductData.get(count));
					count++;
				}
			}
			
			conn.commit();
			conn.setAutoCommit(true);
			conn.close();

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

	
	private static String getQueryForCustomerAggregatedData(String state,
			int categoryID) {
		String queryString = null ;
		
		if("all".equals(state) && categoryID == -1){
			 queryString = "insert into user_temp select uid, sales as sales_sum from pre_customers order by sales desc limit 20";
		}else if("all".equals(state) && categoryID != -1){
			 queryString = "insert into user_temp select uid, sales from pre_customers_cat where cid= "+  categoryID + "  order by sales desc limit 20";
		}else if(! "all".equals(state) && categoryID == -1){
			queryString = "insert into user_temp select uid, sales from pre_customers where  state='"+state+"' order by sales desc limit 20";
		}else{
			queryString = "insert into user_temp select uid, sales from pre_customers_cat where cid= "+ categoryID+"  and state='"+state+"' order by sales desc limit 20";
		}	
		return queryString;
	}

	private static String getQueryForCustomerProductData(String state,
			int categoryID) {
	String queryString = "select utpt.user_name, utpt.product_name, coalesce(pcp.sales,0) as sales " +
			" from (select ut.uid, u.name as user_name, pt.pid , p.name as product_name , ut.sales as user_sales, pt.sales as product_sales " + 
			" from user_temp ut cross join product_temp pt "+
			" join users u on (u.id = ut.uid) " +
			" join products p on (p.id=pt.pid) " +
			" ) as utpt " +
			" left join pre_customers_products pcp  on (pcp.uid=utpt.uid and pcp.pid= utpt.pid) " +
			" order by utpt.user_sales desc , utpt.product_sales desc;" ;
	return queryString;
	}

	private static String getQueryForProductAggregatedData(String state,
			int categoryID) {
		String queryString = null ;
		if("all".equals(state) && categoryID == -1){
			queryString = "insert into product_temp select pid, sum(sales) as sales_sum from pre_products group by pid order by sales_sum desc limit 10";
		}else if("all".equals(state) && categoryID != -1){
			 queryString = "insert into product_temp select pid, sum(sales) as sales_sum from pre_products where  cid= "+categoryID+" group by pid order by sales_sum desc limit 10";
		}else if(! "all".equals(state) && categoryID == -1){
			queryString = "insert into product_temp select pid, sales as sales_sum from pre_products where   state='"+state+"' order by sales desc limit 10";
		}else{
			queryString = "insert into product_temp select pid, sales from pre_products where  cid= "+categoryID +" and state='"+state+"' order by sales desc limit 10";
		}	
		return queryString;
	}
	
	private static String getQueryForStateProductData(String state,
			int categoryID) {
		String queryString = " select stpt.state, stpt.product_name, coalesce(pp.sales,0) as sales " + 
				" from " +
				"(select st.state, pt.pid , p.name as product_name , st.sales as state_sales, pt.sales " + " as product_sales " 
				+ " from state_temp st cross join product_temp pt " 
				+ " join products p on (p.id=pt.pid) " 
				+ " ) as stpt " 
				+ " left join pre_products pp  on (pp.state=stpt.state and pp.pid= stpt.pid) " 
				+ " order by stpt.state_sales desc , stpt.product_sales desc";
		
		return queryString;
	}

	private static String getQueryForStateAggregatedData(String state,
			int categoryID) {
		String queryString = null ;
		if("all".equals(state) && categoryID == -1){
			queryString = "insert into state_temp select state, sum(sales) as sales_sum from pre_states group by state"
					+" order by sales_sum desc limit 20";
		}else if("all".equals(state) && categoryID != -1){
			 queryString = "insert into state_temp select state, sales from pre_states where cid= "+categoryID + "  order by sales desc limit 20";
		}else if(! "all".equals(state) && categoryID == -1){
			queryString = "insert into state_temp select state, sum(sales) as sales_sum from pre_states where state='"+state+"'  group by state order by sales_sum desc limit 20";
		}else{
			queryString = "insert into state_temp select state, sales from pre_states where cid= "+ categoryID+" and state='"+state+"' order by sales desc limit 20";
		}	
		return queryString;
	}

}
