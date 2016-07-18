#!/usr/bin/python

from optparse import OptionParser
import string

parser = OptionParser()
parser.add_option("-f", "--file", dest="filename",
                          help="FILE contains data to be converted from", metavar="FILE")
parser.add_option("-t", "--tsv", dest="tsvname",
                          help="TSV file to be converted to", metavar="TSV")
(options, args) = parser.parse_args()

if not options.filename:   # if filename is not given
    parser.error('Filename not given')

if not options.tsvname:   # if tsv filename is not given
    parser.error('TSV filename not given')

filename = options.filename
tsv = options.tsvname

inputFile = open(filename, "r")
outputFile = open(tsv, "w")

for line in inputFile:
    stationid = line[0:11].strip()
    month = line[12:14].strip()
    day = line[15:17].strip()
    v1 = line[18:24].strip()
    v2 = line[25:31].strip()
    v3 = line[32:38].strip()
    v4 = line[39:45].strip()
    v5 = line[46:52].strip()
    v6 = line[53:59].strip()
    v7 = line[60:66].strip()
    v8 = line[67:73].strip()
    v9 = line[74:80].strip()
    v10 = line[81:87].strip()
    v11 = line[88:94].strip()
    v12 = line[95:101].strip()
    v13 = line[102:108].strip()
    v14 = line[109:115].strip()
    v15 = line[116:122].strip()
    v16 = line[123:129].strip()
    v17 = line[130:136].strip()
    v18 = line[137:143].strip()
    v19 = line[144:150].strip()
    v20 = line[151:157].strip()
    v21 = line[158:164].strip()
    v22 = line[165:171].strip()
    v23 = line[172:178].strip()
    v24 = line[179:185].strip()

    hbaseRowID = stationid + month + day
    datas = (hbaseRowID, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21, v22, v23, v24)
    outputFile.write(string.join(datas, "\t") + "\n")

inputFile.close()
outputFile.close()
