# ntopngbandwidthnotifier

Greetings Earthlings,

This project has been successfully used with pfsense 2.3.2 and ntopng 0.8.5.
These scripts take the ntopng bandwidth data, exports it to a mysql table, and then sends an email with the user's name, 
mac address, and the date/time, when a user's bandwidth is greater than 1GB for 15 minutes.

-Julian
