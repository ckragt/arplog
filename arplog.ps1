# DESCRIPTION  : This tool pings customized IP range (1-254) and outputs an ARP File.
# AUTOR        : Christopher Kragt | email ck@kragt.pro
# LICENSE      : MIT License
# VERSION      : 1.0.0 RC [19. December 2013]
# PARAMETER    : .\arplog -range <string> -first <int>
# USAGE        : .\arplog -range 10.1.10 OR .\arp -range 10.1.10 -first 10
#                .\arplog -range 10.1.10 will ping all hosts from 10.1.10.1 to 10.1.10.254
#                .\arplog -range 10.1.10 -first 10 will ping all hosts from 10.1.10.1 to 10.1.10.10 (first 10 hosts)
#                The -first parameter is optional.

Param([string]$range, [int]$first)
$host.ui.RawUI.WindowTitle = "ArpLog - Windows PowerShell"
$workdir = Split-Path -Parent $MyInvocation.MyCommand.Path;
$date = Get-Date
$i = 1

New-Item $workdir\_log -type directory

Function F_CLEARARP {

	Write-Host "Before we start, do you want to clear the ARP cache? (You need administrative rights to do this task)"
	Write-Host "[Y]" -ForegroundColor Yellow -NoNewline; Write-Host " Yes or [N] No: " -NoNewline
	$cleararp = Read-Host
	Write-Host #Spacer

	if ($cleararp -eq 'Y' -or !$cleararp) {

		Write-Host "Clearing ARP cache ..." -NoNewline

		arp -d *

		Write-Host "        [" -NoNewline; Write-Host " done " -ForegroundColor Green -NoNewline; Write-Host "]"
		Write-Host #Spacer

		F_PING

	}

	else {

		Write-Host "Skipping clearing the ARP cache. No task to do ..." -ForegroundColor Blue -BackgroundColor White
		Write-Host #Spacer

		F_PING

	}

}

Function F_PING {

	Write-Host "Log started: $date" -ForegroundColor White -BackgroundColor Blue
	Write-Host "Saving log output to $workdir" -ForegroundColor White -BackgroundColor Blue
	Write-host #Spacer
	Write-Host "To stopp this script, press CTRL+C or STRG+C. It might take some seconds for the script to stopp." -ForegroundColor Red -BackgroundColor Black
	Write-Host #Spacer

	Start-Sleep 2

	while ($i -le $max) {

		Write-Host "Pinging $range.$i ...... " -NoNewline
		$ping = Get-WmiObject Win32_PingStatus -filter "Address='$range.$i'"

		if ($ping.statuscode -eq 0) {
			Write-Host "[ " -NoNewline; Write-Host "STATUS: HOST FOUND   " -ForegroundColor Green -NoNewline; Write-Host " ]"
		}

		else {

			Write-Host "[ " -NoNewline; Write-Host "STATUS: NOTHING FOUND" -ForegroundColor Red -NoNewline; Write-Host " ]"

		}

		$i++

	}

	F_ARP

}

Function F_ARP {

	Write-Host #Spacer
	Write-Host "Writing arp file to $workdir\_log ..." -NoNewline

	arp -a | Out-File $workdir\_log\arp.txt

	Write-Host "        [" -NoNewline; Write-Host " done " -ForegroundColor Green -NoNewline; Write-Host "]"
	Write-Host #Spacer

	Notepad $workdir\_log\arp.txt

	$host.ui.RawUI.WindowTitle = "Windows PowerShell"

	Exit

}

Clear-Host

if (!$first) {

	$max = 254

}

elseif ($first -ge 255) {
	Write-Host "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" -ForegroundColor Red -BackgroundColor Black
	Write-Host "+ Error: " -ForegroundColor Red -BackgroundColor Black -NoNewline; Write-Host "The '-first' parameter is too high. Max value allowed is 254 (default). Start pinging from host 1 to 254. " -BackgroundColor Black -ForegroundColor Red -NoNewline; Write-Host " +" -ForegroundColor Red -BackgroundColor Black
	Write-Host "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" -ForegroundColor Red -BackgroundColor Black
	Write-Host #Spacer

	$max = 254

}

else {

	$max = $first

}

F_CLEARARP
