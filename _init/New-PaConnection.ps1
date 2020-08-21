<#
.SYNOPSIS
    Creates a connection to the palo device.

.EXAMPLE
    PS> New-PaConnection -DeviceAddress 192.168.1.2 -ApiKey abcd

#>
function New-PaConnection {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True,Position=0)][string]$DeviceAddress,
        [Parameter(Mandatory=$True,Position=1)][string]$ApiKey,
        [Parameter(Mandatory=$false)][string]$VSys='vsys1',
        [Parameter(Mandatory=$false)][string]$ApiVersion='v9.1'
    )
    $paConnectionProperties = @{
        Address    = $DeviceAddress
        ApiKey     = $ApiKey
        VSys       = $VSys
        ApiVersion = $ApiVersion
        ApiBaseURL = "$DeviceAddress/restapi/$ApiVersion/"
    }
    $paConnection = New-Object psobject -Property $paConnectionProperties
    $paConnection

}

Export-ModuleMember -Function "*-*"