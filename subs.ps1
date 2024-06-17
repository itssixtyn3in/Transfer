# Define the path to the domains.txt file
$domainsFile = "domains.txt"

# Check if the file exists
if (-Not (Test-Path -Path $domainsFile)) {
    Write-Host "The file domains.txt does not exist. Please create the file and add domains to it."
    exit
}

# Read all domains from the file
$domains = Get-Content -Path $domainsFile

# Iterate over each domain
foreach ($domain in $domains) {
    try {
        # Resolve the domain and get all DNS records
        $dnsRecords = Resolve-DnsName -Name $domain -ErrorAction Stop

        # Output all DNS records for the domain
        foreach ($record in $dnsRecords) {
	    $defaultDomain = $($record.Name)
	    if ($($record.Name = -like "*edgekey.net") { 
	    Write-Host "$domain has a CNAME record pointing to: $($record.Name)"
	    }
        }
    } catch {
        Write-Host "Domain: $($domain) could not be resolved or has no DNS records."
    }
}
