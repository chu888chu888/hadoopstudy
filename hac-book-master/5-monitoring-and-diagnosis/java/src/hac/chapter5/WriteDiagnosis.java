package hac.chapter5;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FileStatus;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.hbase.regionserver.wal.HLog;
import org.apache.hadoop.hbase.regionserver.wal.SequenceFileLogReader;
import org.apache.hadoop.hbase.util.Bytes;

public class WriteDiagnosis {

	public static void main(String[] args) {

		try {
			if (args.length < 1) {
				usage();
				System.exit(-1);
			}
			String logPath = args[0];
			printWriteDiagnosis(logPath);

		} catch (Exception e) {
			e.printStackTrace();
			System.exit(-1);
		}
	}

	private static void usage() {
		System.err.println("Usage: WriteDiagnosis <HLOG_PATH>");
		System.err.println("HLOG_PATH:");
		System.err
				.println("  Path on HDFS where HLogs are stored. For example: /hbase/.logs");
	}

	private static void printWriteDiagnosis(String logPath) throws IOException {
		Configuration conf = HBaseConfiguration.create();
		FileSystem fs = FileSystem.get(conf);
		FileStatus[] regionServers = fs.listStatus(new Path(logPath));
		HLog.Reader reader = new SequenceFileLogReader();
		Map<String, Long> result = new HashMap<String, Long>();

		for (FileStatus regionServer : regionServers) {
			Path regionServerPath = regionServer.getPath();
			FileStatus[] logs = fs.listStatus(regionServerPath);
			Map<String, Long> parsed = new HashMap<String, Long>();

			for (FileStatus log : logs) {
				System.out.println("Processing: " + log.getPath().toString());

				reader.init(fs, log.getPath(), conf);
				try {
					HLog.Entry entry;
					while ((entry = reader.next()) != null) {
                        String tableName = Bytes.toString(entry.getKey().getTablename());
						String encodedRegionName = Bytes.toString(entry.getKey()
								.getEncodedRegionName());
                        String mapkey = tableName + "/" + encodedRegionName;
						Long editNum = parsed.get(mapkey);
						if (editNum == null) {
							editNum = 0L;
						}
                        editNum += entry.getEdit().size();
						parsed.put(mapkey, editNum);
					}
				} finally {
					reader.close();
				}
			}
			
			for (String key : parsed.keySet()) {
				result.put(key, parsed.get(key));
			}
		}

        System.out.println();
		System.out.println("==== HBase Write Diagnosis ====");
		for (String region : result.keySet()) {
			long editNum = result.get(region);
			System.out.println(String.format("Region: %s    Edits #: %d",
					region, editNum));
		}
	}
}
