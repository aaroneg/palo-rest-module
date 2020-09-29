function Get-PAAddresses {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$False)][object]$paConnection=$Script:paConnection
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
    $Result = Invoke-PaRequest $restParams
    ($result.result).entry
}
function Get-PAAddress {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$False)][object]$paConnection=$Script:paConnection,
        [Alias("AddressName")][Parameter(Mandatory=$True,Position=0)][string]$Name
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
    $Result = Invoke-PaRequest $restParams
    ($result.result).entry
}

function New-PAAddress {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$False)][object]$paConnection=$Script:paConnection,
        [Parameter(Mandatory=$True,Position=0)][string]$Name,
        [Parameter(Mandatory=$True,Position=1)][string]$ipNetmask,
        [Parameter(Mandatory=$false,Position=2)][string]$description='',
        [Parameter(Mandatory=$false,Position=3)][array]$Tags
    )
    #Write-Verbose "[$($MyInvocation.MyCommand.Name)] Checking for existing entry: '$Name'"
    if ($foo=Get-PAAddress -Name $Name -ErrorAction SilentlyContinue ) {throw "This object already exists"}
    else { 
        #Write-Verbose "[$($MyInvocation.MyCommand.Name)] Address does not already exist, proceeding." 
    }
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
            "ip-netmask" = $ipNetmask
            "description" = $description
        }
    }

    if ($Tags) {
        $newObject.entry.tag=@{member=@()}
        foreach ($Tag in $Tags) {
            try {$foo=Get-PATag -Name $Tag -ErrorAction Stop}
            catch {
                Write-Warning "[$($MyInvocation.MyCommand.Name)] Tag '$Tag' was not found. Adding."
                try {New-PATag -Name $Tag}
                catch {throw "[$($MyInvocation.MyCommand.Name)] Unable to process $Name"}
            }
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Adding tag '$tag' => $Name"
            $newObject.entry.tag.member+= $Tag
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
    
    "[$($MyInvocation.MyCommand.Name)] Submitting '$Name' to API endpoint."
    $Result = Invoke-PaRequest $restParams
    #$result.result
    #$restParams
}


function Set-PAAddress {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$False)][object]$paConnection=$Script:paConnection,
        [Parameter(Mandatory=$True,Position=0)][string]$Name,
        [Parameter(Mandatory=$True,Position=1)][string]$ipNetmask,
        [Parameter(Mandatory=$false,Position=2)][string]$description=''
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

    $Result = Invoke-PaRequest $restParams
    $result.result
    #$restParams
}



Export-ModuleMember -Function "*-*"