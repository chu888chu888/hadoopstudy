$ORIGIN .
$TTL 604800	; 1 week
hbase-admin-cookbook.com IN SOA	ns1.hbase-admin-cookbook.com. root.hbase-admin-cookbook.com. (
				147        ; serial
				604800     ; refresh (1 week)
				86400      ; retry (1 day)
				2419200    ; expire (4 weeks)
				604800     ; minimum (1 week)
				)
			NS	ns1.hbase-admin-cookbook.com.
$ORIGIN hbase-admin-cookbook.com.
$TTL 60	; 1 minute
client1			A	10.168.42.97
master1			A	10.168.107.177
master2			A	10.174.15.19
$TTL 604800	; 1 week
ns1			A	10.160.49.250
$TTL 60	; 1 minute
slave1			A	10.168.39.188
slave2			A	10.168.39.165
slave3			A	10.176.203.63
