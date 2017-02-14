#!/bin/bash

# Simple bash script to check total, used and available data for vianet users. Because logging in to customer portal is too much time consuming.
# Distributed under WTFPL.
# Feel free to do whatever you want with this script.
# Do not contact me for help or assistance with this script, as I did it in my spare time for my own need and it is fulfilled now.
# However, I might improve it for my own requirements if needed.
# Enjoy.

username="" #Enter your username inside the quotes
password="" #Enter your password inside the quotes

if [ -f /tmp/vianetcookies ]
then
	rm -rf /tmp/vianetcookies
fi

curl -c /tmp/vianetcookies -s --request POST 'https://customers.vianet.com.np/customerportal/customers/login' -d "username=$username" -d "password=$password" -d "btnLogin=login"
curl -b /tmp/vianetcookies -s https://customers.vianet.com.np/customerportal/services/internet  -o /tmp/vianet
spent=`grep -o -P '(?<=>).*(?=GB \()' /tmp/vianet | head -1`
limit=`grep -o -P '(?<=<span>).*(?=GB</span>)' /tmp/vianet | head -1`
exp_date=`grep -o -P '(?<=col-md-8 cldata\"><span>).*(?=</span>)' /tmp/vianet | sed -n '2p'`

plan=`grep -o -P '(?<=FiberNet).*(?=</h3>)' /tmp/vianet | head -1`


left=`scale=2; echo "$limit-$spent" | bc`
echo -e "
Plan Type\t: FiberNet$plan
Data spent\t: $spent
Data Left\t: $left
Expiration Date\t: $exp_date
"

