$pwdlist = Get-Content $PSScriptRoot\input.txt
$validPass = @()

foreach($entry in $pwdlist) {
    $charMin,$charMax,$char,$pass = $entry.Split('-|:| ',[System.StringSplitOptions]::RemoveEmptyEntries)

    $count = @($pass.ToCharArray() -match $char).Count
    if($count -ge $charMin -and $count -le $charMax) { $validPass += $pass }
}

"$($validPass.Count) password valid"