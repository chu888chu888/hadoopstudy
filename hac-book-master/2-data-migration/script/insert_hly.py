#!/usr/bin/python

import MySQLdb
from optparse import OptionParser

parser = OptionParser()
parser.add_option("-f", "--file", dest="filename",
                          help="FILE contains data to be inserted", metavar="FILE")
parser.add_option("-t", "--table", dest="tablename",
                          help="TABLE to be inserted", metavar="TABLE")
(options, args) = parser.parse_args()

if not options.filename:   # if filename is not given
    parser.error('Filename not given')

if not options.tablename:   # if table is not given
    parser.error('Tablename not given')

filename = options.filename
table = options.tablename

conn = MySQLdb.connect (host = "db_host",
                       user = "db_user",
                       passwd = "db_password",
                       db = "db_database")

sql = "insert into " + table + " values ( NULL, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s )"

cursor = conn.cursor ()

f = open(filename, "r")
for line in f:
    stationid = line[0:11].strip()
    month = int(line[12:14].strip())
    day = int(line[15:17].strip())
    value1 = line[18:24].strip()
    value2 = line[25:31].strip()
    value3 = line[32:38].strip()
    value4 = line[39:45].strip()
    value5 = line[46:52].strip()
    value6 = line[53:59].strip()
    value7 = line[60:66].strip()
    value8 = line[67:73].strip()
    value9 = line[74:80].strip()
    value10 = line[81:87].strip()
    value11 = line[88:94].strip()
    value12 = line[95:101].strip()
    value13 = line[102:108].strip()
    value14 = line[109:115].strip()
    value15 = line[116:122].strip()
    value16 = line[123:129].strip()
    value17 = line[130:136].strip()
    value18 = line[137:143].strip()
    value19 = line[144:150].strip()
    value20 = line[151:157].strip()
    value21 = line[158:164].strip()
    value22 = line[165:171].strip()
    value23 = line[172:178].strip()
    value24 = line[179:185].strip()

#    print sql % ( stationid, month, day, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10, value11, value12, value13, value14, value15, value16, value17, value18, value19, value20, value21, value22, value23, value24)
    cursor.execute (sql, (stationid, month, day, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10, value11, value12, value13, value14, value15, value16, value17, value18, value19, value20, value21, value22, value23, value24))
    conn.commit()

f.close()
cursor.close ()
conn.close ()
