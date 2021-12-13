$in = Get-Content "$PSScriptRoot\input.txt"

# Copying arrays over and over... Not for production :) 
$O2Rating, $CO2Rating = $in.Clone(), $in.Clone()
for ($i = 0; $i -lt $in[0].Length; $i++) {
    if($O2Rating.Count -gt 1) { 
        $O2CommonBit = $O2Rating | Group-Object { $_[$i] } -NoElement | Sort-Object -Descending -Property Count, Name | Select-Object -ExpandProperty Name -First 1
        $O2Rating = $O2Rating.Where({ $_[$i] -eq $O2CommonBit })
    }

    if($CO2Rating.Count -gt 1) { 
        $CO2CommonBit = $CO2Rating | Group-Object { $_[$i] } -NoElement | Sort-Object -Descending -Property Count, Name | Select-Object -ExpandProperty Name -Last 1
        $CO2Rating = $CO2Rating.Where({ $_[$i] -eq $CO2CommonBit })
    }

    if ($O2Rating.Count -eq 1 -and $CO2Rating.Count -eq 1) { Write-Host "Done!"; break }
}

if($O2Rating.Count -gt 1 -or $CO2Rating.Count -gt 1) {
    Write-Host "ERROR - Too many values!"
    Write-Host "O2 Rating: $O2Rating"
    Write-Host "CO2 Rating: $CO2Rating"
    break
}

$O2 = [Convert]::ToInt32($O2Rating, 2)
$CO2 = [Convert]::ToInt32($CO2Rating, 2)

"Result: $O2 (O2 Rating) * $CO2 (CO2 Rating) = $($O2*$CO2)"