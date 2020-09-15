function Get-PAAddresses {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,Position=0)][object]$paConnection
    )
    $ObjectAPIURI="$($paConnection.ApiBaseUrl)Objects/Addresses?"
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
    $result=Invoke-RestMethod @restParams
    ($result.result).entry
}
function Get-PAAddress {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,Position=0)][object]$paConnection,
        [Alias("AddressName")][Parameter(Mandatory=$True,Position=1)][string]$Name
    )
    $ObjectAPIURI="$($paConnection.ApiBaseUrl)Objects/Addresses?"
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

function New-PAAddress {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,Position=0)][object]$paConnection,
        [Parameter(Mandatory=$True,Position=1)][string]$Name,
        [Parameter(Mandatory=$True,Position=2)][string]$ipNetmask,
        [Parameter(Mandatory=$false,Position=3)][string]$description=''
    )
    $ObjectAPIURI="$($paConnection.ApiBaseUrl)Objects/Addresses?"
    $Arguments= @(
        "location=vsys"
        "vsys=$($paConnection.VSys)"
        "name=$Name"
    )
    
    [psobject]$newObject=@{
        entry = @{
            "@name" = $Name
            "@location" = "vsys"
            #"vsys" = $paConnection.VSys
            "ip-netmask" = $ipNetmask
            "description" = $description
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


function Set-PAAddress {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,Position=0)][object]$paConnection,
        [Parameter(Mandatory=$True,Position=1)][string]$Name,
        [Parameter(Mandatory=$True,Position=2)][string]$ipNetmask,
        [Parameter(Mandatory=$false,Position=3)][string]$description=''
    )
    $ObjectAPIURI="$($paConnection.ApiBaseUrl)Objects/Addresses?"
    $Arguments= @(
        "location=vsys"
        "vsys=$($paConnection.VSys)"
        "name=$Name"
    )
    
    [psobject]$newObject=@{
        entry = @{
            "@name" = $Name
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



Export-ModuleMember -Function "*-*"