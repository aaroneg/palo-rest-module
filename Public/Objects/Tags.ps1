function Get-PATags {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $False)][object]$paConnection = $Script:paConnection
    )
    Write-Verbose "[$($MyInvocation.MyCommand.Name)] This cmdlet will not show tags from the 'Predefined' location, only tags that exist in a vsys."
    $ObjectAPIURI = "$($paConnection.ApiBaseUrl)Objects/Tags?"
    $Arguments = @{
        location = 'vsys'
        vsys     = $($paConnection.VSys)
    }
    $Argumentstring = (New-PaArgumentString $Arguments)
    $restParams = @{
        Method               = 'Get'
        Uri                  = "$($ObjectAPIURI)$($ArgumentString)"
        SkipCertificateCheck = $True
    }
    $Result = Invoke-PaRequest $restParams
    ($Result.result).entry
}
function Get-PATag {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $False)][object]$paConnection = $Script:paConnection,
        [Alias("AddressName")][Parameter(Mandatory = $True, Position = 0)][string]$Name
    )
    $ObjectAPIURI = "$($paConnection.ApiBaseUrl)Objects/Tags?"
    $Arguments = @{
        location = 'vsys'
        vsys     = $($paConnection.VSys)
        name     = $Name
    }
    $Argumentstring = (New-PaArgumentString $Arguments)
    
    $restParams = @{
        Method               = 'Get'
        Uri                  = "$($ObjectAPIURI)$($ArgumentString)"
        SkipCertificateCheck = $True
    }
    $Result = Invoke-PaRequest $restParams
    ($Result.result).entry
}

function New-PATag {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $False)][object]$paConnection = $Script:paConnection,
        [Parameter(Mandatory = $True, Position = 0)][string]$Name,
        [Parameter(Mandatory = $false, Position = 1)][string]$Comments = ''
    )
    $ObjectAPIURI = "$($paConnection.ApiBaseUrl)Objects/Tags?"
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
            comments    = $Comments
        }
    }

    $restParams = @{
        Method               = 'post'
        Uri                  = "$($ObjectAPIURI)$($ArgumentString)"
        SkipCertificateCheck = $True
        body                 = $newObject | ConvertTo-Json -Depth 50
    }
    "[$($MyInvocation.MyCommand.Name)] Submitting '$Name' to API endpoint."
    Write-Debug "[$($MyInvocation.MyCommand.Name)] $($newObject|convertto-json -Depth 50)"
    $Result = Invoke-PaRequest $restParams
    $Result.result
}

function Set-PATag {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $False)][object]$paConnection = $Script:paConnection,
        [Parameter(Mandatory = $True, Position = 0)][string]$Name,
        [Parameter(Mandatory = $True, Position = 1)][string]$Comments = ''
    )
    #Write-Error "Not Implemented" 
    #<#
    $ObjectAPIURI = "$($paConnection.ApiBaseUrl)Objects/Tags?"
    $Arguments = @{
        location = 'vsys'
        vsys     = $($paConnection.VSys)
        name     = $Name
    }
    $Argumentstring = (New-PaArgumentString $Arguments)
    # Since this is such a simple object with no members, we're just going to update it the same way we would if we were creating a new one.
    # The only difference is the 'put' http method.
    # For a more complex example, see the Set-PAAddressGroupStatic cmdlet.
    [psobject]$newObject = @{
        entry = @{
            '@name'     = $Name
            '@location' = 'vsys'
            comments    = $Comments
        }
    }

    $restParams = @{
        Method               = 'put'
        Uri                  = "$($ObjectAPIURI)$($ArgumentString)"
        SkipCertificateCheck = $True
        body                 = $newObject | ConvertTo-Json -Depth 50
    }
    "[$($MyInvocation.MyCommand.Name)] Submitting '$Name' to API endpoint."
    Write-Debug "[$($MyInvocation.MyCommand.Name)] $($newObject|convertto-json -Depth 50)"
    $Result = Invoke-PaRequest $restParams
    $Result.result
    #>
}

Export-ModuleMember -Function "*-*"