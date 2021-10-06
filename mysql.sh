#!/bin/bash
echo "Before we begin installing, please enter a ROOT PASSWORD for MYSQL:"
read mp
echo "Please enter the password once more to confirm:"
read pq
while [ $mp != $pq ]; do
	echo "Password does not match, please try again:"
	read pq
done
echo "MYSQL ROOT password saved!"

sudo mysql_secure_installation
