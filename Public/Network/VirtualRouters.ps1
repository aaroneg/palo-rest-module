function Get-PAVirtualRouters {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,Position=0)][object]$paConnection
    )
    $ObjectAPIURI="$($paConnection.ApiBaseUrl)Network/VirtualRouters?"
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

    $result=Invoke-RestMethod @restParams
    ($result.result).entry
}

function Get-PAVirtualRouter {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,Position=0)][object]$paConnection,
        [Parameter(Mandatory=$True,Position=1)][string]$Name
    )
    $ObjectAPIURI="$($paConnection.ApiBaseUrl)Network/VirtualRouters?"
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


function Set-PAVirtualRouterInterfaces {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,Position=0)][object]$paConnection,
        [Parameter(Mandatory=$True,Position=1)][string]$Name,
        [Parameter(Mandatory=$True,Position=2)][array]$Interfaces
    )
    $ObjectAPIURI="$($paConnection.ApiBaseUrl)Network/VirtualRouters?"
    $Arguments= @(
        "name=$([System.Web.HttpUtility]::UrlEncode($Name))"
    )
    
    $CurrentRouter=Get-PAVirtualRouter -paConnection $paConnection -Name $Name
    
    # The virtual router already has some interfaces
    if ($CurrentRouter.interface) { 
        Write-Verbose "Interfaces property already exists, Proceeding with adding the interfaces."
    }
    # The virtual router does not have interfaces
    else {
        Write-Verbose "Adding interfaces property"
        Add-Member -NotePropertyName interface -NotePropertyValue @{member=@()} -InputObject $CurrentRouter
        #$CurrentRouter|ConvertTo-Json -Depth 50
        $CurrentRouter.interface = @{
            member = @()
        }
    }
    foreach ($Interface in $Interfaces) {
        if ($Interface.'@name' -in $CurrentRouter.interface.member) {
            Write-Verbose "$($Interface.'@name') already in list, skipping"
            continue
        }
        else {
            Write-Verbose "Adding interface :  $($Interface.'@name')"
            $CurrentRouter.interface.member += $Interface.'@name'
        }
    }

    [psobject]$newObject=@{
        entry = @(
            $CurrentRouter
        )
    }

    $restParams=@{
        Method = 'put'
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
    ($result.result).entry
}


Export-ModuleMember -Function "*-*"