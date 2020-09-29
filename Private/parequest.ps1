function Invoke-PaRequest {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True,Position=0)][Object]$restParams
    )
    Write-Verbose $($MyInvocation.MyCommand.Name)
    $result = try {
        Invoke-RestMethod @restParams
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
