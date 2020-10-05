function Get-PaItem {
    [CmdletBinding()]
    Param(
        [parameter(Mandatory = $false)][object]$paConnection = $Script:paConnection,
        [parameter(Mandatory = $true)][string]$RelativePath,
        [parameter(Mandatory = $true)][string]$Name,
        [parameter(Mandatory = $false)][string]$Location='vsys'
    )
    $ObjectAPIURI = "$($paConnection.ApiBaseUrl)$($RelativePath)?"
    $vsysName = $paConnection.Vsys
    $Arguments = @{
        location = $Location
        name = $Name
    }
    if ('vsys' -eq $Location) { $Arguments.Add('vsys', $paConnection.Vsys) }
    $Argumentstring = (New-PaArgumentString $Arguments)
    $restParams = @{
        Method               = 'get'
        Uri                  = "$($ObjectAPIURI)$($ArgumentString)"
        SkipCertificateCheck = $paConnection.SkipCertificateCheck
    }
    (Invoke-PaRequest $restParams).result.entry
}

function Get-PaItems {
    [CmdletBinding()]
    Param(
        [parameter(Mandatory = $false)][object]$paConnection = $Script:paConnection,
        [parameter(Mandatory = $true)][string]$RelativePath,
        [parameter(Mandatory = $false)][string]$Location='vsys'
    )
    $ObjectAPIURI = "$($paConnection.ApiBaseUrl)$($RelativePath)?"
    $vsysName = $paConnection.Vsys
    $Arguments = @{
        location = $Location
        name = $Name
    }
    if ('vsys' -eq $Location) { $Arguments.Add('vsys', $paConnection.Vsys) }
    $Argumentstring = (New-PaArgumentString $Arguments)
    $restParams = @{
        Method               = 'get'
        Uri                  = "$($ObjectAPIURI)$($ArgumentString)"
        SkipCertificateCheck = $paConnection.SkipCertificateCheck
    }
    (Invoke-PaRequest $restParams).result.entry
}

Export-ModuleMember -Function "*-*"