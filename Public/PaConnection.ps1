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
        [Parameter(Mandatory=$false)][string]$ApiVersion='v10.0'
    )
    $paConnectionProperties = @{
        Address    = "$DeviceAddress"
        ApiKey     = $ApiKey
        VSys       = $VSys
        ApiVersion = $ApiVersion
        ApiBaseURL = "https://$DeviceAddress/restapi/$ApiVersion/"
    }
    $paConnection = New-Object psobject -Property $paConnectionProperties
    Write-Verbose "$($MyInvocation.MyCommand.Name): $($paConnection.Address) is now the default. "
    $Script:paConnection=$paConnection
    $paConnection
}

function Test-PaConnection {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True,Position=0)][object]$paConnection
    )

    $restParams=@{
        Method = 'Get'
        Uri = "$($paConnection.ApiBaseUrl)/Device/VirtualSystems"
        SkipCertificateCheck = $True
        Headers = @{
            "X-PAN-KEY" = $paConnection.ApiKey
            ContentType = 'application/json'    
        }
    }

    $result=Invoke-RestMethod @restParams
    "$($result.result.'@count') virtual system[s]"
    "$($result.result[0].entry.'@name')"
    "$($result.result[0].entry.import.network.interface.member.Count) network interfaces defined."

}

Export-ModuleMember -Function "*-*"