function Get-PAAddressGroup {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $False)][object]$paConnection = $Script:paConnection
    )
    $ObjectAPIURI = "$($paConnection.ApiBaseUrl)Objects/AddressGroups?"
    $Arguments = @(
        "location=vsys"
        "vsys=$($paConnection.VSys)"
    )
    $Argumentstring = (New-PaArgumentString $Arguments)
    $restParams = @{
        Method               = 'Get'
        Uri                  = "$($ObjectAPIURI)$($ArgumentString)"
        SkipCertificateCheck = $True
    }
    $Result = Invoke-PaRequest $restParams -Verbose:$False
    ($result.result).entry
}
function Get-PAAddressGroup {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $False)][object]$paConnection = $Script:paConnection,
        [Alias("AddressName")][Parameter(Mandatory = $True, Position = 0)][string]$Name
    )
    $ObjectAPIURI = "$($paConnection.ApiBaseUrl)Objects/AddressGroups?"
    $Arguments = @{
        location = vsys
        vsys     = $($paConnection.VSys)
        name     = $Name
    }
    $Argumentstring = (New-PaArgumentString $Arguments)
    $restParams = @{
        Method               = 'Get'
        Uri                  = "$($ObjectAPIURI)$($ArgumentString)"
        SkipCertificateCheck = $True
    }
    $Result = Invoke-PaRequest $restParams -Verbose:$False
    ($result.result).entry
}

function New-PAAddressGroup {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $False)][object]$paConnection = $Script:paConnection,
        [Parameter(Mandatory = $True, Position = 0)][string]$Name,
        [Parameter(Mandatory = $True, Position = 1)][string]$ipNetmask,
        [Parameter(Mandatory = $false, Position = 2)][string]$description = ''
    )
    $ObjectAPIURI = "$($paConnection.ApiBaseUrl)Objects/AddressGroups?"
    $Arguments = @{
        location = 'vsys'
        vsys     = $($paConnection.VSys)
        name     = $Name
    }
    $Argumentstring = (New-PaArgumentString $Arguments)
    [psobject]$newObject = @{
        entry = @{
            '@name'      = $Name
            '@location'  = "vsys"
            'ip-netmask' = $ipNetmask
            description  = $description
        }
    }

    $restParams = @{
        Method               = 'post'
        Uri                  = "$($ObjectAPIURI)$($ArgumentString)"
        SkipCertificateCheck = $True
        body                 = $newObject | ConvertTo-Json
    }

    $Result = Invoke-PaRequest $restParams -Verbose:$False
    $result.result
}


function Set-PAAddressGroup {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $False)][object]$paConnection = $Script:paConnection,
        [Parameter(Mandatory = $True, Position = 0)][string]$Name,
        [Parameter(Mandatory = $True, Position = 1)][string]$ipNetmask,
        [Parameter(Mandatory = $false, Position = 2)][string]$description = ''
    )
    $ObjectAPIURI = "$($paConnection.ApiBaseUrl)Objects/AddressGroups?"
    $Arguments = @{
        location = 'vsys'
        vsys     = $($paConnection.VSys)
        name     = $Name
    }
    $Argumentstring = (New-PaArgumentString $Arguments)
    [psobject]$newObject = @{
        entry = @{
            '@name'      = $Name
            '@location'  = 'vsys'
            'ip-netmask' = $ipNetmask
            description  = $description
        }
    }
    $restParams = @{
        Method               = 'put'
        Uri                  = "$($ObjectAPIURI)$($ArgumentString)"
        SkipCertificateCheck = $True
        body                 = $newObject | ConvertTo-Json
    }

    $Result = Invoke-PaRequest $restParams
    $result.result
}

Export-ModuleMember -Function "*-*"