#!/bin/bash

# This shell script downloads the bandwidth information from ntopng 0.8.5 into a json file and then does everything needed to convert that file to a csv file 
# that is able to be imported into a mysql table for backup. 

# Change directory to home directory that has the json file.
cd /home/testubuntu

# Download json of the bandwidth information from ntop.
curl --cookie "user=admin; password=admkn2008" "http://192.168.10.2:3000/lua/export.lua?ifname=em1" -o /home/testubuntu/ntop_redroom.json

# Clean up the json file to create a csv file that will easily integrate into a mysql table. You have to get rid of unwanted characters like "{}", multiples 
# of the same word like "bytes", and extra commas and words that are not needed like "country".
sed -i -e 's/{/,/g' ntop_redroom.json
sed -i -e 's/"ip": ,/"ip0": ,/1' ntop_redroom.json
sed -i -e 's/ },/,/g' ntop_redroom.json
sed -i -e 's/"bytes"/"tcp_bytes_sent"/1' ntop_redroom.json
sed -i -e 's/"bytes"/"tcp_bytes_rcvd"/1' ntop_redroom.json
sed -i -e 's/"bytes"/"udp_bytes_sent"/1' ntop_redroom.json
sed -i -e 's/"bytes"/"udp_bytes_rcvd"/1' ntop_redroom.json
sed -i -e 's/"bytes"/"icmp_bytes_sent"/1' ntop_redroom.json
sed -i -e 's/"bytes"/"icmp_bytes_rcvd"/1' ntop_redroom.json
sed -i -e 's/"bytes"/"otherip_bytes_sent"/1' ntop_redroom.json
sed -i -e 's/"bytes"/"otherip_bytes_rcvd"/1' ntop_redroom.json

sed -i -e '/"country"/d' ntop_redroom.json
sed -i -e 's/,/{/1' ntop_redroom.json
sed -i -e 's/, "pktStats.sent".*/ },/' ntop_redroom.json
sed -i -e '1h;1!H;$!d;g;s/\(.*\),/\1/' ntop_redroom.json
sed -i -e 's/"tcp_sent": , //g' ntop_redroom.json
sed -i -e 's/"tcp_rcvd": , //g' ntop_redroom.json
sed -i -e 's/"udp_sent": , //g' ntop_redroom.json
sed -i -e 's/"udp_rcvd": , //g' ntop_redroom.json
sed -i -e 's/"icmp_sent": , //g' ntop_redroom.json
sed -i -e 's/"icmp_rcvd": , //g' ntop_redroom.json
sed -i -e 's/"other_ip_sent": , //g' ntop_redroom.json
sed -i -e 's/"other_ip_rcvd": , //g' ntop_redroom.json
sed -i -e 's/"ip0": , //g' ntop_redroom.json

# Use json2csv to convert the json file to a csv file.
php /home/testubuntu/JSON2CSV-master/json2csv.php --file=/home/testubuntu/ntop_redroom.json --dest=/home/testubuntu/ntop_redroom.csv

# Connect to a mysql database called bandwidth and run commands in ntop_redroom.txt.
# These commands import the csv file into a mysql table named ntop_redroom.
username=""
password=""
database=""

mysql -u $username -p$password $database < '/home/testubuntu/ntop_redroom.txt'
