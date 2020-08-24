function Get-PAZones {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,Position=0)][object]$paConnection
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
        Headers = @{
            "X-PAN-KEY" = $paConnection.ApiKey
            ContentType = 'application/json'    
        }
    }
    $restParams
    $result=Invoke-RestMethod @restParams
    ($result.result).entry
}
function Get-PAZone {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,Position=0)][object]$paConnection,
        [Parameter(Mandatory=$True,Position=1)][string]$Name
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
        Headers = @{
            "X-PAN-KEY" = $paConnection.ApiKey
            ContentType = 'application/json'    
        }
    }
    $result=Invoke-RestMethod @restParams
    ($result.result).entry
}

function New-PAZone {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,Position=0)][object]$paConnection,
        [Parameter(Mandatory=$True,Position=1)][string]$ZoneName,
        [Parameter(Mandatory=$True,Position=2)][ValidateSet('Tap','Virtual Wire','Layer2','Layer3','Tunnel')][string]$Type
    )
    $ObjectAPIURI="$($paConnection.ApiBaseUrl)Network/Zones?"
    $Arguments= @(
        "location=vsys"
        "vsys=$($paConnection.VSys)"
        "name=$AddressName"
    )
    
    [psobject]$newObject=@{
        entry = @{
            "@name" = $AddressName
            "@location" = "vsys"
            #"vsys" = $paConnection.VSys
            "network" = @{'layer3'=''}
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
        body = $newObject|ConvertTo-Json -Depth 50
    }
    #$restParams.Uri
    #$restParams.body
    $result=Invoke-RestMethod @restParams
    $result.result
}



Export-ModuleMember -Function "*-*"