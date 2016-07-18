package hac.chapter2;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.hbase.client.HTable;
import org.apache.hadoop.hbase.client.Put;
import org.apache.hadoop.hbase.util.Bytes;

/**
 * An example to read data from MySQL and put into HBase.
 *
 */
public class Recipe1 {
	public static void main(String[] args) {
		Connection dbConn = null;
		HTable htable = null;
		Statement stmt = null;
		String query = "select * from hly_temp_normal";
		try {

			dbConn = connectDB();
			htable = connectHBase("hly_temp");
			byte[] family = Bytes.toBytes("n");

			stmt = dbConn.createStatement();
			ResultSet rs = stmt.executeQuery(query);
			// time stamp for all inserted rows
			long ts = System.currentTimeMillis();
			
			while (rs.next()) {
				String stationid = rs.getString("stnid");
				int month = rs.getInt("month");
				int day = rs.getInt("day");
				
				String rowkey = stationid + Common.lpad(String.valueOf(month), 2, '0') + Common.lpad(String.valueOf(day), 2, '0');
				Put p = new Put(Bytes.toBytes(rowkey));
				
				// get hourly data from MySQL and put into hbase
				for (int i = 5; i < 29; i++) {
					String columnI = "v" + Common.lpad(String.valueOf(i - 4), 2, '0');
					String valueI = rs.getString(i);
					p.add(family, Bytes.toBytes(columnI), ts, Bytes.toBytes(valueI));
				}
				htable.put(p);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (stmt != null) {
					stmt.close();
				}
				if (dbConn != null) {
					dbConn.close();
				}
				if (htable != null) {
					htable.close();
				}

			} catch (Exception e) {
				// ignore
			}
		}
	}

	private static HTable connectHBase(String tablename) throws IOException {
		HTable table = null;
		Configuration conf = HBaseConfiguration.create();
		table = new HTable(conf, tablename);
		return table;
	}

	private static Connection connectDB() throws Exception {
		String userName = "db_user";
		String password = "db_password";
		String url = "jdbc:mysql://db_host/database";
		Class.forName("com.mysql.jdbc.Driver").newInstance();
		Connection conn = DriverManager.getConnection(url, userName, password);

		return conn;
	}
}
