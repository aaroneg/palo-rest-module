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
        [Parameter(Mandatory=$True,Position=1)][string]$AddressName
    )
    $ObjectAPIURI="$($paConnection.ApiBaseUrl)Network/Zones?"
    $Arguments= @(
        "location=vsys"
        "vsys=$($paConnection.VSys)"
        "name=$([System.Web.HttpUtility]::UrlEncode($AddressName))"
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
        body = $newObject|ConvertTo-Json
    }

    $result=Invoke-RestMethod @restParams
    $result.result
    #$restParams
}

<#
function Set-PAZone {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,Position=0)][object]$paConnection,
        [Parameter(Mandatory=$True,Position=1)][string]$AddressName,
        [Parameter(Mandatory=$True,Position=2)][string]$ipNetmask,
        [Parameter(Mandatory=$false,Position=3)][string]$description=''
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
            "ip-netmask" = $ipNetmask
            "description" = $description
        }
    }

    $restParams=@{
        Method = 'put'
        Uri = "$($ObjectAPIURI)$($Arguments -join('&'))"
        SkipCertificateCheck = $True
        Headers = @{
            "X-PAN-KEY" = $paConnection.ApiKey
            ContentType = 'application/json'
        }
        body = $newObject|ConvertTo-Json
    }

    $result=Invoke-RestMethod @restParams
    $result.result
    #$restParams
}
#>




Export-ModuleMember -Function "*-*"