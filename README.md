# AbuseIPDB-CLI for Bash
A small script for looking up IPs in AbuseIPDB from your command line.

## Installation
* Clone the project or download the raw .sh file
* Make it executable
```
$ chmod +x AbuseIPDB-CLI.sh
```
* Install 'jq' and 'curl' unless you already have those installed. (*example below for Ubuntu/apt users*)
```
$ sudo apt install jq curl
```
* Now head over to abuseipdb.com, login into your account and go to Account section
* Click on the APIv2 tab, hit Create Key and name it whatever you wish (*name is not important*)
* Copy the entire 80-character key from the window that pops up
* Now edit your AbuseIPDB-CLI.sh file and replace <<YOUR_API_KEY_HERE>> with your actual key.

## Syntax
It's very simple:
```
./AbuseIPDB-CLI.sh <IP>
```

## Example usage:
```
$ ./AbuseIPDB-CLI.sh 23.129.64.111

IP Lookup Details:
----------------
IP: 23.129.64.111
Domain: emeraldonion.org
Country: United States of America
ISP: Emerald Onion

This IP appears benign.
----------------
```
