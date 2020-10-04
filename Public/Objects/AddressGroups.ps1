function Get-PAAddressGroups {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $False)][object]$paConnection = $Script:paConnection
    )
    $ObjectAPIURI = "$($paConnection.ApiBaseUrl)Objects/AddressGroups?"
    $Arguments = @{
        location = 'vsys'
        vsys     = $($paConnection.VSys)
    }
    $Argumentstring = (New-PaArgumentString $Arguments)
    $restParams = @{
        Method               = 'Get'
        Uri                  = "$($ObjectAPIURI)$($ArgumentString)"
        SkipCertificateCheck = $True
    }
    $Result = Invoke-PaRequest $restParams -Verbose:$False
    ($result.result).entry
}
function Get-PAAddressGroup {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $False)][object]$paConnection = $Script:paConnection,
        [Alias("AddressName")][Parameter(Mandatory = $True, Position = 0)][string]$Name
    )
    $ObjectAPIURI = "$($paConnection.ApiBaseUrl)Objects/AddressGroups?"
    $Arguments = @{
        location = 'vsys'
        vsys     = $($paConnection.VSys)
        name     = $Name
    }
    $Argumentstring = (New-PaArgumentString $Arguments)
    $restParams = @{
        Method               = 'Get'
        Uri                  = "$($ObjectAPIURI)$($ArgumentString)"
        SkipCertificateCheck = $True
    }
    $Result = Invoke-PaRequest $restParams -Verbose:$False
    ($result.result).entry
}

function New-PAAddressStaticGroup {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $False)][object]$paConnection = $Script:paConnection,
        [Parameter(Mandatory = $True, Position = 0)][string]$Name,
        [Parameter(Mandatory = $True, Position = 1)][string]$description,
        [Parameter(Mandatory = $false, Position = 2)][array]$Addresses,
        [Parameter(Mandatory=$false,Position=3)][array]$Tags
    )
    $ObjectAPIURI = "$($paConnection.ApiBaseUrl)Objects/AddressGroups?"
    $Arguments = @{
        location = 'vsys'
        vsys     = $($paConnection.VSys)
        name     = $Name
    }
    $Argumentstring = (New-PaArgumentString $Arguments)
    [psobject]$newObject = @{
        entry = @{
            '@name'      = $Name
            '@location'  = "vsys"
            description  = $description
        }
    }
    if ($Addresses) {
        $newObject.entry.static=@{member=@()}
        foreach ($Address in $Addresses) {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Adding address '$Address' => $Name"
            $newObject.entry.static.member+=[object]$Address
        }
    }
    if ($Tags) {
        $newObject.entry.tag=@{member=[array]@()}
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
    Write-Verbose "[$($MyInvocation.MyCommand.Name)] $($newObject|convertto-json -Depth 50)"
    $restParams = @{
        Method               = 'post'
        Uri                  = "$($ObjectAPIURI)$($ArgumentString)"
        SkipCertificateCheck = $True
        body                 = $newObject | ConvertTo-Json -Depth 50
    }

    $Result = Invoke-PaRequest $restParams -Verbose:$False
    $result.result
}


function Set-PAAddressGroup {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $False)][object]$paConnection = $Script:paConnection,
        [Parameter(Mandatory = $True, Position = 0)][string]$Name,
        [Parameter(Mandatory = $True, Position = 1)][string]$ipNetmask,
        [Parameter(Mandatory = $false, Position = 2)][string]$description = ''
    )
    $ObjectAPIURI = "$($paConnection.ApiBaseUrl)Objects/AddressGroups?"
    $Arguments = @{
        location = 'vsys'
        vsys     = $($paConnection.VSys)
        name     = $Name
    }
    $Argumentstring = (New-PaArgumentString $Arguments)
    [psobject]$newObject = @{
        entry = @{
            '@name'      = $Name
            '@location'  = 'vsys'
            'ip-netmask' = $ipNetmask
            description  = $description
        }
    }
    $restParams = @{
        Method               = 'put'
        Uri                  = "$($ObjectAPIURI)$($ArgumentString)"
        SkipCertificateCheck = $True
        body                 = $newObject | ConvertTo-Json
    }

    $Result = Invoke-PaRequest $restParams
    $result.result
}

Export-ModuleMember -Function "*-*"