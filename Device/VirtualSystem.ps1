$Script:BaseURI="$deviceAddress/restapi/$APIVersion/Device/VirtualSystems"
function Get-VirtualSystem{
    [cmdletbinding()]
    begin { $URI = "$Script:apiURI/Device/VirtualSystems"}
    Process {Invoke-RestMethod -Uri $URI/ @Script:paInvokeParams -Method Get}
}
