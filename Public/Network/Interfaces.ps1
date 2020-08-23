function Get-PAEthernetInterfaces {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,Position=0)][object]$paConnection
    )
    $ObjectAPIURI="$($paConnection.ApiBaseUrl)Network/EthernetInterfaces?"
    $Arguments= @(
        #"location=vsys"
        #"vsys=$($paConnection.VSys)"
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
function Get-PAEthernetInterface {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,Position=0)][object]$paConnection,
        [Parameter(Mandatory=$True,Position=1)][string]$InterfaceName
    )
    $ObjectAPIURI="$($paConnection.ApiBaseUrl)Network/EthernetInterfaces?"
    $Arguments= @(
        "name=$([System.Web.HttpUtility]::UrlEncode($InterfaceName))"
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

function New-PAEthernetL3SubInterface {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,Position=0)][object]$paConnection,
        [Parameter(Mandatory=$True,Position=1)][string]$ParentConnectionName,
        [Parameter(Mandatory=$True,Position=2)][string]$vlanID

    )
    $ObjectAPIURI="$($paConnection.ApiBaseUrl)Network/EthernetInterfaces?"
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

Export-ModuleMember -Function "*-*"