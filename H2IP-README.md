Usage:
    linux: pwsh ./host2ip.ps1 -filename hostnames.txt
    Windows: ./host2ip.ps1 -filename hostnames.txt

host2ip takes a filename with one hostname per line. It parses nslookup output
and returns the first address found for each hostname.
