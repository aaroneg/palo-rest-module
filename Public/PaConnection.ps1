<#
.SYNOPSIS
    Creates a connection object for a palo device.
.PARAMETER DeviceAddress
    The address of your API. This is a DNS or IP address. All of the rest of the URL is generated for you.
.PARAMETER ApiKey
    Your API key.
.PARAMETER VSys
    Set this if it's equal to anything other than 'vsys1', which is the most common setting.
.PARAMETER ApiVersion
    The address of your API. You should leave this at its default value unless you're using a newer version of the firmware. You *can* use this with version 9.x but some cmdlets will not function.
.PARAMETER Passthru
    Set this to true to get a copy of the paConnection Object.
.EXAMPLE
    PS> New-PaConnection -DeviceAddress 192.168.1.2 -ApiKey abcd
.INPUTS
    None. This cmdlet does not support pipelines.
.OUTPUTS
    System.Object
#>
function New-PaConnection {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True,Position=0)][string]$DeviceAddress,
        [Parameter(Mandatory=$True,Position=1)][string]$ApiKey,
        [Parameter(Mandatory=$false)][string]$VSys='vsys1',
        [Parameter(Mandatory=$false)][string]$ApiVersion='v10.0',
        [Parameter(Mandatory=$false)][switch]$Passthru

    )
    $paConnectionProperties = @{
        Address    = "$DeviceAddress"
        ApiKey     = $ApiKey
        VSys       = $VSys
        ApiVersion = $ApiVersion
        ApiBaseURL = "https://$DeviceAddress/restapi/$ApiVersion/"
    }
    $paConnection = New-Object psobject -Property $paConnectionProperties
    Write-Verbose "[$($MyInvocation.MyCommand.Name)] Host '$($paConnection.Address)' is now the default connection."
    $Script:paConnection=$paConnection
    if ($true -eq $Passthru){
        $paConnection
    }
    
}

<#
.SYNOPSIS
    Tests a PaConnection object by getting a list of virtual systems.
.PARAMETER paConnection
    A connection object from New-PaConnection
.EXAMPLE
    PS> Test-PaConnection $paConnection
.INPUTS
    System.Object
.OUTPUTS
    System.String

#>
function Test-PaConnection {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline=$True,Mandatory=$True,Position=0)][object]$paConnection
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

function Get-PaCurrentConnection {
    "Here is the current default connection:"
    $Script:paConnection
}

Export-ModuleMember -Function "*-*"