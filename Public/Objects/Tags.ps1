function Get-PATags {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$False)][object]$paConnection=$Script:paConnection
    )
    Write-Verbose "[$($MyInvocation.MyCommand.Name)] This cmdlet will not show tags from the 'Predefined' location, only tags that exist in a vsys."
    $ObjectAPIURI="$($paConnection.ApiBaseUrl)Objects/Tags?"
    $Arguments= @(
        "location=vsys"
        "vsys=$($paConnection.VSys)"
    )

    $restParams=@{
        Method = 'Get'
        Uri = "$($ObjectAPIURI)$($Arguments -join('&'))"
        SkipCertificateCheck = $True
        Headers = @{
            "X-PAN-KEY" = $paConnection.ApiKey
            ContentType = 'application/json'
        }
    }
    write-warning $restParams.Uri
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
    $Arguments= @(
        "location=vsys"
        "vsys=$($paConnection.VSys)"
        "name=$([System.Web.HttpUtility]::UrlEncode($Name))"
    )
    
    $restParams=@{
        Method = 'Get'
        Uri = "$($ObjectAPIURI)$($Arguments -join('&'))"
        SkipCertificateCheck = $True
        Headers = @{
            "X-PAN-KEY" = $paConnection.ApiKey
            ContentType = 'application/json'    
        }
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
    $Arguments= @(
        "location=vsys"
        "vsys=$($paConnection.VSys)"
        "name=$Name"
    )
    
    [psobject]$newObject=@{
        entry = @{
            "@name" = $Name
            "@location" = "vsys"
            "comments" = $Comments
        }
    }

    $restParams=@{
        Method = 'post'
        Uri = "$($ObjectAPIURI)$($Arguments -join('&'))"
        SkipCertificateCheck = $True
        Headers = @{
            "X-PAN-KEY" = $paConnection.ApiKey
            ContentType = 'application/json'
        }
        body = $newObject|ConvertTo-Json
    }
    "[$($MyInvocation.MyCommand.Name)] Submitting '$Name' to API endpoint."
    $Result = Invoke-PaRequest $restParams
}

Export-ModuleMember -Function "*-*"