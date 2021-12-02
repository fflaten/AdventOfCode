$pwdlist = Get-Content $PSScriptRoot\input.txt
$validPass = @()

foreach($entry in $pwdlist) {
    $firstPos,$lastPos,$char,$pass = $entry.Split('-|:| ',[System.StringSplitOptions]::RemoveEmptyEntries)

    $match = @($pass[($firstPos-1),($lastPos-1)] -match $char)

    if($match.Count -eq 1) { $validPass += $pass }
}

"$($validPass.Count) password valid"