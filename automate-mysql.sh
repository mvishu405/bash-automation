#!/usr/bin/expect -f

set timeout -1
spawn mysql_secure_installation
match_max 100000
expect -exact "\r
Securing the MySQL server deployment.\r
\r
Connecting to MySQL using a blank password.\r
\r
VALIDATE PASSWORD COMPONENT can be used to test passwords\r
and improve security. It checks the strength of password\r
and allows the users to set only those passwords which are\r
secure enough. Would you like to setup VALIDATE PASSWORD component?\r
\r
Press y|Y for Yes, any other key for No: "
send -- "n\r"
expect -exact "n\r
Please set the password for root here.\r
\r
New password: "
send -- "JH;,XAy-\$_m5m%TQ\r"
expect -exact "\r
\r
Re-enter new password: "
send -- "JH;,XAy-\$_m5m%TQ\r"
expect -exact "\r
By default, a MySQL installation has an anonymous user,\r
allowing anyone to log into MySQL without having to have\r
a user account created for them. This is intended only for\r
testing, and to make the installation go a bit smoother.\r
You should remove them before moving into a production\r
environment.\r
\r
Remove anonymous users? (Press y|Y for Yes, any other key for No) : "
send -- "y\r"
expect -exact "y\r
Success.\r
\r
\r
Normally, root should only be allowed to connect from\r
'localhost'. This ensures that someone cannot guess at\r
the root password from the network.\r
\r
Disallow root login remotely? (Press y|Y for Yes, any other key for No) : "
send -- "y\r"
expect -exact "y\r
Success.\r
\r
By default, MySQL comes with a database named 'test' that\r
anyone can access. This is also intended only for testing,\r
and should be removed before moving into a production\r
environment.\r
\r
\r
Remove test database and access to it? (Press y|Y for Yes, any other key for No) : "
send -- "y\r"
expect -exact "y\r
 - Dropping test database...\r
Success.\r
\r
 - Removing privileges on test database...\r
Success.\r
\r
Reloading the privilege tables will ensure that all changes\r
made so far will take effect immediately.\r
\r
Reload privilege tables now? (Press y|Y for Yes, any other key for No) : "
send -- "y\r"
expect eof