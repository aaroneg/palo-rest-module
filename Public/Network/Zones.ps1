function Get-PAZones {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$False)][object]$paConnection=$Script:paConnection
    )
    $ObjectAPIURI="$($paConnection.ApiBaseUrl)Network/Zones?"
    $Arguments= @(
        "location=vsys"
        "vsys=$($paConnection.VSys)"
    )
    
    $restParams=@{
        Method = 'Get'
        Uri = "$($ObjectAPIURI)$($Arguments -join('&'))"
        SkipCertificateCheck = $True
    }
    $restParams
    $Result = Invoke-PaRequest $restParams
    ($result.result).entry
}
function Get-PAZone {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$False)][object]$paConnection=$Script:paConnection,
        [Parameter(Mandatory=$True,Position=0)][string]$Name
    )
    $ObjectAPIURI="$($paConnection.ApiBaseUrl)Network/Zones?"
    $Arguments= @(
        "location=vsys"
        "vsys=$($paConnection.VSys)"
        "name=$([System.Web.HttpUtility]::UrlEncode($Name))"
    )
    
    $restParams=@{
        Method = 'Get'
        Uri = "$($ObjectAPIURI)$($Arguments -join('&'))"
        SkipCertificateCheck = $True
    }
    $Result = Invoke-PaRequest $restParams
    ($result.result).entry
}

function New-PAZone {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$False)][object]$paConnection=$Script:paConnection,
        [Parameter(Mandatory=$True,Position=0)][object]$Name,
        [Parameter(Mandatory=$True,Position=1)][ValidateSet('Tap','Virtual Wire','Layer2','Layer3','Tunnel')][string]$Type,
        [Parameter(Mandatory=$false,Position=2)][string]$Interface

    )
    $ObjectAPIURI="$($paConnection.ApiBaseUrl)Network/Zones?"
    $Arguments= @(
        "location=vsys"
        "vsys=$($paConnection.VSys)"
        "name=$Name"
    )
    
    [psobject]$newObject=@{
        entry = @{
            "@name" = $Name
            "@location" = "vsys"
            "@vsys" = $paConnection.VSys
            "network" = @{'layer3'=@(@{member = $Interface})}
        }
    }

    $restParams=@{
        Method = 'post'
        Uri = "$($ObjectAPIURI)$($Arguments -join('&'))"
        SkipCertificateCheck = $True
        body = $newObject|ConvertTo-Json -Depth 50
    }
    #$restParams.Uri
    #$restParams.body
    $Result = Invoke-PaRequest $restParams
    $result.result
}



Export-ModuleMember -Function "*-*"