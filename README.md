# Description
Simple PowerShell Script for network maintenance.
The Script will ping a given network range and shows IP addresse that are currently in use an reachable.

> ⚠ This script was made for internal use in a mid-sized company's remote branch to quickly find network hardware that has gone rogue.

# Usage

.\arplog -range 10.1.10

.\arplog -range 10.1.10 -first 10

.\arplog -range 10.1.10 will ping all hosts from 10.1.10.1 to 10.1.10.254

.\arplog -range 10.1.10 -first 10 will ping all hosts from 10.1.10.1 to 10.1.10.10 (first 10 hosts)

The -first parameter is optional.
