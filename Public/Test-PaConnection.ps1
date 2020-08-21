function Test-PaConnection {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True,Position=0)][object]$paConnection
    )

    $restParams=@{
        Method = 'Get'
        Uri = "$($paConnection.ApiBaseUrl)/Device/VirtualSystems"
        SkipCertificateCheck = $True
        Headers = @{
            "X-PAN-KEY" = $paConnection.ApiKey
            ContentType = 'application/json'    
        }
    }

    $result=Invoke-RestMethod @restParams
    "$($result.result.'@count') virtual system[s]"
    "$($result.result[0].entry.'@name')"
    "$($result.result[0].entry.import.network.interface.member.Count) network interfaces defined."

}
Export-ModuleMember -Function "*-*"