include Java
import org.apache.hadoop.util.StringUtils

path = ARGV[0]
dus = %x[$HADOOP_HOME/bin/hadoop fs -dus #{path}]
splited = dus.split
byteDesc = StringUtils.byteDesc(splited[1].to_i)
puts splited[0] + "\t" + byteDesc
