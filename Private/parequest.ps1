function Invoke-PaRequest {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True,Position=0)][Object]$restParams
    )
    $Headers = @{
        "X-PAN-KEY" = $paConnection.ApiKey
        ContentType = 'application/json'
    }
    try {
        $result = Invoke-RestMethod @restParams -Headers $headers
    }
    catch {
        if ($_.ErrorDetails.Message) {
            Write-Error "Response from $($paConnection.Address): $(($_.ErrorDetails.Message|convertfrom-json).message)."
        }
        else {
            $_.ErrorDetails
        }
    }
    $result
    $restParams
}
