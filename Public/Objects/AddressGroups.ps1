function Get-PAAddressGroup {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$False)][object]$paConnection=$Script:paConnection
    )
    $ObjectAPIURI="$($paConnection.ApiBaseUrl)Objects/AddressGroups?"
    $Arguments= @(
        "location=vsys"
        "vsys=$($paConnection.VSys)"
    )
    
    $restParams=@{
        Method = 'Get'
        Uri = "$($ObjectAPIURI)$($Arguments -join('&'))"
        SkipCertificateCheck = $True
    }
    $Result = Invoke-PaRequest $restParams -Verbose:$False
    ($result.result).entry
}
function Get-PAAddressGroup {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$False)][object]$paConnection=$Script:paConnection,
        [Alias("AddressName")][Parameter(Mandatory=$True,Position=0)][string]$Name
    )
    $ObjectAPIURI="$($paConnection.ApiBaseUrl)Objects/AddressGroups?"
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
    $Result = Invoke-PaRequest $restParams -Verbose:$False
    ($result.result).entry
}

function New-PAAddressGroup {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$False)][object]$paConnection=$Script:paConnection,
        [Parameter(Mandatory=$True,Position=0)][string]$Name,
        [Parameter(Mandatory=$True,Position=1)][string]$ipNetmask,
        [Parameter(Mandatory=$false,Position=2)][string]$description=''
    )
    $ObjectAPIURI="$($paConnection.ApiBaseUrl)Objects/AddressGroups?"
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
        body = $newObject|ConvertTo-Json
    }

    $Result = Invoke-PaRequest $restParams -Verbose:$False
    $result.result
}


function Set-PAAddressGroup {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$False)][object]$paConnection=$Script:paConnection,
        [Parameter(Mandatory=$True,Position=0)][string]$Name,
        [Parameter(Mandatory=$True,Position=1)][string]$ipNetmask,
        [Parameter(Mandatory=$false,Position=2)][string]$description=''
    )
    $ObjectAPIURI="$($paConnection.ApiBaseUrl)Objects/AddressGroups?"
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
        body = $newObject|ConvertTo-Json
    }

    $Result = Invoke-PaRequest $restParams
    $result.result
    #$restParams
}



Export-ModuleMember -Function "*-*"