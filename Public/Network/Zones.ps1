function Get-PAZones {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $False)][object]$paConnection = $Script:paConnection
    )
    $relativePath = 'Network/Zones'
    Get-PaItems -paConnection $paConnection -RelativePath $relativePath
}
function Get-PAZone {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $False)][object]$paConnection = $Script:paConnection,
        [Parameter(Mandatory = $True, Position = 0)][string]$Name
    )
    $relativePath = 'Network/Zones'
    Get-PaItem -paConnection $paConnection -RelativePath $relativePath -Name $Name
}

function New-PAZone {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $False)][object]$paConnection = $Script:paConnection,
        [Parameter(Mandatory = $True, Position = 0)][object]$Name,
        [Parameter(Mandatory = $True, Position = 1)][ValidateSet('Tap', 'Virtual Wire', 'Layer2', 'Layer3', 'Tunnel')][string]$Type,
        [Parameter(Mandatory = $false, Position = 2)][string]$Interface

    )
    $ObjectAPIURI = "$($paConnection.ApiBaseUrl)Network/Zones?"
    $Arguments = @{
        location = 'vsys'
        vsys     = $($paConnection.VSys)
        name     = $Name
    }
    $Argumentstring = (New-PaArgumentString $Arguments)
    [psobject]$newObject = @{
        entry = @{
            '@name'     = $Name
            '@location' = 'vsys'
            '@vsys'     = $paConnection.VSys
            network     = @{'layer3' = @(@{member = $Interface }) }
        }
    }

    $restParams = @{
        Method               = 'post'
        Uri                  = "$($ObjectAPIURI)$($ArgumentString)"
        SkipCertificateCheck = $paConnection.SkipCertificateCheck
        body                 = $newObject | ConvertTo-Json -Depth 50
    }
    $Result = Invoke-PaRequest $restParams
    $result.result
}

Export-ModuleMember -Function "*-*"