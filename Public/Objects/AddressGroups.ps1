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
        [Parameter(Mandatory = $True, Position = 2)][array]$Addresses,
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

    # We have to supply addresses for static groups. 
    $newObject.entry.static=@{member=@()}
    foreach ($Address in $Addresses) {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Adding address '$Address' => $Name"
        $newObject.entry.static.member += $Address
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
    Write-Debug "[$($MyInvocation.MyCommand.Name)] $($newObject|convertto-json -Depth 50)"
    $restParams = @{
        Method               = 'post'
        Uri                  = "$($ObjectAPIURI)$($ArgumentString)"
        SkipCertificateCheck = $True
        body                 = $newObject | ConvertTo-Json -Depth 50
    }

    $Result = Invoke-PaRequest $restParams -Verbose:$False
    $result.result
}


function Set-PAAddressGroupStatic {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $False)][object]$paConnection = $Script:paConnection,
        [Parameter(Mandatory = $True, Position = 0)][string]$Name,
        [Parameter(Mandatory = $True, Position = 1)][string]$description,
        [Parameter(Mandatory = $False, Position = 2)][array]$Addresses,
        [Parameter(Mandatory=$false,Position=3)][array]$Tags
    )
    Write-Verbose "[$($MyInvocation.MyCommand.Name)] Getting existing group $Name."
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
    $CurrentObject = Get-PAAddressGroup -paConnection $paConnection -Name $Name
    If ($CurrentObject.static.member) {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] AddressGroup $Name already has static members. Proceeding with adding the addresses."
    }
    elseif ($CurrentObject.dynamic) {
        throw "$($MyInvocation.MyCommand.Name): Cannot work with dynamic groups."
    }
    # Blank out the current list and set it to the addresses we were given.
    $CurrentObject.static.member=@()
    foreach ($Address in $Addresses) {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Adding address '$Address' => $Name"
        $CurrentObject.static.member+=$Address
    }

    if ($Tags) {
        $CurrentObject.tag=@{member=[array]@()}
        foreach ($Tag in $Tags) {
            try {$foo=Get-PATag -Name $Tag -ErrorAction Stop}
            catch {
                Write-Warning "[$($MyInvocation.MyCommand.Name)] Tag '$Tag' was not found. Adding."
                try {New-PATag -Name $Tag}
                catch {throw "[$($MyInvocation.MyCommand.Name)] Unable to process $Name"}
            }
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Adding tag '$tag' => $Name"
            $CurrentObject.tag.member+= $Tag
        }
    }

    [psobject]$newObject=@{
        entry = @(
            $CurrentObject
        )
    }
    Write-Debug "$($newObject | ConvertTo-Json -Depth 50)"
    $restParams = @{
        Method               = 'put'
        Uri                  = "$($ObjectAPIURI)$($ArgumentString)"
        SkipCertificateCheck = $True
        body                 = $newObject | ConvertTo-Json -Depth 50
    }
    Write-Debug "[$($MyInvocation.MyCommand.Name)] $($newObject|convertto-json -Depth 50)"
    $Result = Invoke-PaRequest $restParams
    $result.result
}

Export-ModuleMember -Function "*-*"