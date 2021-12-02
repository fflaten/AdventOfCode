$fields = @{
    byr = 'Birth Year'
    iyr = 'Issue Year'
    eyr = 'Expiration Year'
    hgt = 'Height'
    hcl = 'Hair Color'
    ecl = 'Eye Color'
    pid = 'Passport ID'
    cid = 'Country ID'
}

$fieldKeys = $fields.GetEnumerator() | % { $_.key}
$List = (Get-Content $PSScriptRoot\input.txt -Raw) -split '[\r\n]{4}'

$validCount = 0

foreach ($passport in $List) {
    $missingFields = @($fieldKeys | ? { -not ($passport -match $_) })

    if($missingFields.Count -eq 0 -or @("cid") -eq $missingFields ) {
        $validCount += 1
    }
}

"Found $validCount valid passports"