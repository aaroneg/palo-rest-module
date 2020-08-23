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
        [Parameter(Mandatory=$True,Position=2)][string]$vlanID,
        [Parameter(Mandatory=$True,Position=3)][string]$AddressName

    )
    $ObjectAPIURI="$($paConnection.ApiBaseUrl)Network/EthernetInterfaces?"
    $Arguments= @(
        "name=$ParentConnectionName.$vlanID"
    )
    try {$AddressObject=Get-PAAddress -paConnection $paConnection -Name $AddressName} catch {throw "Address object does not exist or cannot be retrieved"}
    [psobject]$newObject=@{
        entry = @{
            "@name" = "$ParentConnectionName.$vlanID"
            "ipv6" = @{"neighbor-discovery"=''}
            "ndp-proxy" = @{'enabled'='no'}
            'adjust-tcp-mss'= @{'enable'='no'}
            'ip'= @{
                'entry' = @{
                    #name = $AddressObject.'@name'
                    '@name' = $AddressObject.'@name'
                }
            }
            'interface-management-profile' = 'pingable'
            'tag' = $vlanID
        }
    }
    #$newObject
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
    $newObject|ConvertTo-Json -Depth 50
    $result=Invoke-RestMethod @restParams
    #$result.result
    #$restParams
}

Export-ModuleMember -Function "*-*"