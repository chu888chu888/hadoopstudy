# Script that get region starting keys from a HBase table
#
include Java
import org.apache.hadoop.hbase.util.Bytes
import org.apache.hadoop.hbase.client.HTable

# Name of this script
NAME = "region-starting-keys"

# Print usage for this script
def usage
    puts 'Usage: region-starting-keys.rb <table_name> <output_fle>'
    exit!
end

# Check arguments
if ARGV.size != 2
    usage
end

# arguments
table_name = ARGV[0]
output_file = ARGV[1]

table = HTable.new(table_name)
starting_keys = table.getStartKeys()
f = File.open(output_file, 'w')
for starting_key in starting_keys
    str_starting_key = Bytes.toString(starting_key)
    puts str_starting_key
    f.puts str_starting_key
end

f.close()
table.close()
