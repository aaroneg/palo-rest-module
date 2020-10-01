function Get-PATags {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$False)][object]$paConnection=$Script:paConnection
    )
    Write-Verbose "[$($MyInvocation.MyCommand.Name)] This cmdlet will not show tags from the 'Predefined' location, only tags that exist in a vsys."
    $ObjectAPIURI="$($paConnection.ApiBaseUrl)Objects/Tags?"
    $Arguments= @{
        location = 'vsys'
        vsys     = $($paConnection.VSys)
    }
    $Argumentstring=(New-PaArgumentString $Arguments)
    $restParams=@{
        Method               = 'Get'
        Uri                  = "$($ObjectAPIURI)$($ArgumentString)"
        SkipCertificateCheck = $True
    }
    $Result = Invoke-PaRequest $restParams
    ($result.result).entry
}
function Get-PATag {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$False)][object]$paConnection=$Script:paConnection,
        [Alias("AddressName")][Parameter(Mandatory=$True,Position=0)][string]$Name
    )
    $ObjectAPIURI="$($paConnection.ApiBaseUrl)Objects/Tags?"
    $Arguments=@{
        location = 'vsys'
        vsys     = $($paConnection.VSys)
        name     = $Name
    }
    $Argumentstring=(New-PaArgumentString $Arguments)
    
    $restParams=@{
        Method               = 'Get'
        Uri                  = "$($ObjectAPIURI)$($ArgumentString)"
        SkipCertificateCheck = $True
    }
    $Result = Invoke-PaRequest $restParams
    ($result.result).entry
}

function New-PATag {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$False)][object]$paConnection=$Script:paConnection,
        [Parameter(Mandatory=$True,Position=0)][string]$Name,
        [Parameter(Mandatory=$false,Position=1)][string]$Comments=''
    )
    $ObjectAPIURI="$($paConnection.ApiBaseUrl)Objects/Tags?"
    $Arguments= @{
        location = 'vsys'
        vsys     = $($paConnection.VSys)
        name     = $Name
    }
    $Argumentstring=(New-PaArgumentString $Arguments)
    [psobject]$newObject=@{
        entry = @{
            "@name"     = $Name
            "@location" = "vsys"
            "comments"  = $Comments
        }
    }

    $restParams=@{
        Method               = 'post'
        Uri                  = "$($ObjectAPIURI)$($ArgumentString)"
        SkipCertificateCheck = $True
        body                 = $newObject|ConvertTo-Json
    }
    "[$($MyInvocation.MyCommand.Name)] Submitting '$Name' to API endpoint."
    $Result = Invoke-PaRequest $restParams
    $Result.result
}

Export-ModuleMember -Function "*-*"