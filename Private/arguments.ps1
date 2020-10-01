function New-PaArgumentString {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True,Position=0)][hashtable]$QueryArguments
    )
    $OutputString=[System.Web.HttpUtility]::ParseQueryString('')
#    Foreach ($Argument in $QueryArguments) {
#        $OutputString.Add($Argument.Name, $Argument.Value)
#    }
    $QueryArguments.GetEnumerator() | ForEach-Object {$OutputString.Add($_.Key, $_.Value)}
    Write-Verbose "[$($MyInvocation.MyCommand.Name)] $($OutputString.ToString())"
    $OutputString.ToString()
}
