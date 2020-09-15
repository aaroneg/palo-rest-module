function Get-PADHCPServers {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,Position=0)][object]$paConnection
    )
    $ObjectAPIURI="$($paConnection.ApiBaseUrl)Network/DHCPServers?"
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

function Get-PADHCPRelays {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,Position=0)][object]$paConnection
    )
    $ObjectAPIURI="$($paConnection.ApiBaseUrl)Network/DHCPRelays?"
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
function Get-PADHCPServer {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,Position=0)][object]$paConnection,
        [Parameter(Mandatory=$True,Position=1)][string]$Name
    )
    $ObjectAPIURI="$($paConnection.ApiBaseUrl)Network/DHCPServers?"
    $Arguments= @(
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

function Get-PADHCPRelay {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,Position=0)][object]$paConnection,
        [Parameter(Mandatory=$True,Position=1)][string]$Name
    )
    $ObjectAPIURI="$($paConnection.ApiBaseUrl)Network/DHCPRelays?"
    $Arguments= @(
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

<#
function New-PADHCPServer {
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
                    '@name' = $AddressObject.'@name'
                }
            }
            'interface-management-profile' = 'pingable'
            'tag' = $vlanID
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
    $result=Invoke-RestMethod @restParams
    $result.result
}
#>


Export-ModuleMember -Function "*-*"