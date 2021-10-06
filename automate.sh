#!/usr/bin/expect -f
set timeout -1

spawn ./mysql.sh
expect "Before we begin installing, please enter a ROOT PASSWORD for MYSQL:"
send "tufropes\r"
expect "Please enter the password once more to confirm:"
send "tufropes\r"
expect eof

spawn ./lemp.sh
expect "Enter Document Root path"
send "tuf\r"
expect "Enter server name"
send "_\r"
expect "Enter PHP Version"
send "7.1\r"
expect eof
