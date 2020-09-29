function Get-PAVirtualRouters {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$False)][object]$paConnection=$Script:paConnection
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
        [Parameter(Mandatory=$False)][object]$paConnection=$Script:paConnection,
        [Parameter(Mandatory=$True,Position=0)][string]$Name
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
        [Parameter(Mandatory=$False)][object]$paConnection=$Script:paConnection,
        [Parameter(Mandatory=$True,Position=1)][string]$Name,
        [Parameter(Mandatory=$True,Position=2)][array]$Interfaces
    )
    $ObjectAPIURI="$($paConnection.ApiBaseUrl)Network/VirtualRouters?"
    $Arguments= @(
        "name=$([System.Web.HttpUtility]::UrlEncode($Name))"
    )
    
    $CurrentRouter=Get-PAVirtualRouter -paConnection $paConnection -Name $Name
    
    # The virtual router already has some interfaces
    if ($CurrentRouter.interface.member) { 
        Write-Verbose "$($MyInvocation.MyCommand.Name): Interfaces property already exists, Proceeding with adding the interfaces."
    }
    # The virtual router does not have interfaces
    else {
        Write-Verbose "$($MyInvocation.MyCommand.Name): Adding interfaces property"
        Add-Member -NotePropertyName interface -NotePropertyValue @{member=@()} -InputObject $CurrentRouter
        #$CurrentRouter|ConvertTo-Json -Depth 50
        $CurrentRouter.interface = @{
            member = @()
        }
    }
    #$Interfaces
    foreach ($Interface in $Interfaces) {
        # Detect incorrect interface types and reject them.
        if (!($Interface.tag) -and !($Interface.layer3)) { 
            Write-Error "$($Interface.'@name') is not a layer3 interface, skipping"
            continue
        }
        if ($Interface.'@name' -in $CurrentRouter.interface.member) {
            Write-Warning "$($Interface.'@name') already in list, skipping"
            continue
        }
        else {
            Write-Verbose "$($MyInvocation.MyCommand.Name): Adding interface :  $($Interface.'@name')"
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