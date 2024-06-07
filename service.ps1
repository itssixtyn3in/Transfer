function Check-ModifiableAccess {
    param (
        [string]$path
    )

    $acl = Get-Acl -Path $path
    $user = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

    foreach ($access in $acl.Access) {
        if ($access.IdentityReference -eq $user -and `
            $access.FileSystemRights -match "Write" -and `
            $access.AccessControlType -eq "Allow") {
            return $true
        }
    }
    return $false
}

function Get-ModifiableServiceBinaries {
    $services = Get-WmiObject -Class win32_service -Namespace "root\cimv2"
    $vulnerableServices = @()

    foreach ($service in $services) {
        if ($service.PathName) {
            $path = [regex]::Match($service.PathName, '^\W*([a-z]:\\.+?(\.exe|\.dll|\.sys))\W*', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase).Groups[1].Value
            
            if ($path -and (Test-Path -Path $path)) {
                if (Check-ModifiableAccess -path $path) {
                    $vulnerableServices += [pscustomobject]@{
                        Name      = $service.Name
                        State     = $service.State
                        StartMode = $service.StartMode
                        PathName  = $service.PathName
                    }
                }
            }
        }
    }

    return $vulnerableServices
}

try {
    $modifiableServiceBinaries = Get-ModifiableServiceBinaries

    if ($modifiableServiceBinaries) {
        Write-Output "Modifiable Service Binaries found:"
        foreach ($service in $modifiableServiceBinaries) {
            Write-Output "Service '$($service.Name)' (State: $($service.State), StartMode: $($service.StartMode)) : $($service.PathName)"
        }
    } else {
        Write-Output "No modifiable service binaries found."
    }
} catch {
    Write-Output "[X] Exception: $_"
}