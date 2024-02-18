<#
.SYNOPSIS
Find the Geo location of 

.DESCRIPTION
Long description

.PARAMETER hostAddress
Parameter description

.EXAMPLE
An example

.NOTES
Geo Lookup of IP address - Uses mywan function defined above
https://practical365.com/using-powershell-and-rest-api-requests-to-look-up-ip-address-geolocation-data/
#>

param (
    [string]$hostAddress
)

function geo([string]$hostAddress) {
    if ($hostAddress) {
        #$hostAddress has value
        #Write-Host "Checking Geo Location of $hostAddress"
    } else {
        #$hostAddress has no value
        $hostAddress = (Invoke-WebRequest http://ifconfig.me/ip ).Content
        Write-Host "No host targeted, using your current WAN IP: $hostAddress" -ForegroundColor Green
        Write-Host "To check Geo Location of a host, type geo then host IP or FQDN`n> geo example.com`nor`n> geo 1.1.1.1"
    }
    Write-Host ">>> Running nslookup against host with your current DNS server"
    nslookup $hostAddress
    Write-Host ">>> Getting Host Address Details from http://ip-api.com"
    $targetHostInfo = Invoke-RestMethod -Method Get -Uri "http://ip-api.com/json/$hostAddress"
    $targetHostInfo
    ## Find and remove all whitespace: https://stackoverflow.com/questions/24355760/removing-spaces-from-a-variable-input-using-powershell-4-0
    $targetHostIP = ($targetHostInfo).query -replace '\s',''
    $targetHostLat = ($targetHostInfo).lat -replace '\s',''
    $targetHostLon = ($targetHostInfo).lon -replace '\s',''

    # Create a menu: https://www.elevenforum.com/t/powershell-create-a-menu.4800/
    Write-Host "Some helpful links using the target host: $hostAddress" -ForegroundColor Green
    $mainMenu = {
        Write-Host
        Write-Host " 1.) Info about IP address: https://ipinfo.io/$targetHostIP"
        Write-Host " 2.) Talos Intelligence: https://talosintelligence.com/reputation_center/lookup?search=$hostAddress"
        Write-Host " 3.) VirusTotal: https://www.virustotal.com/gui/ip-address/$targetHostIP"
        Write-Host " 4.) Open Google Map: https://www.google.com/maps/@$targetHostLat,$targetHostLon,15z?entry=ttu"
        Write-Host " 5.) Quit"
        Write-Host
        Write-Host "Select an option and press Enter: "  -nonewline -ForegroundColor Green
        }
    Do {
        Invoke-Command $mainMenu
        $select = Read-Host
        Switch ($select)
            {
                1 {Start-Process "https://ipinfo.io/$targetHostIP"}
                2 {Start-Process "https://talosintelligence.com/reputation_center/lookup?search=$hostAddress"}
                3 {Start-Process "https://www.virustotal.com/gui/ip-address/$targetHostIP"}
                4 {Start-Process "https://www.google.com/maps/@$targetHostLat,$targetHostLon,15z?entry=ttu"}
            }
    }
    while ($select -ne 5)
}
Export-ModuleMember -Function geo