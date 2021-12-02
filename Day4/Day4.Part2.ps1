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
    $fields = $passport -split '\s+'

    $validatedFields = @{
        byr = $false
        iyr = $false
        eyr = $false
        hgt = $false
        hcl = $false
        ecl = $false
        pid = $false
    }

    switch -Regex ($fields) {
        '^byr:(\d{4})$' { $i = $Matches[1] -as [int]; if($i -ge 1920 -and $i -le 2002) { $validatedFields.byr = $true } }
        '^iyr:(\d{4})$' { $i = $Matches[1] -as [int]; if($i -ge 2010 -and $i -le 2020) { $validatedFields.iyr = $true } }
        '^eyr:(\d{4})$' { $i = $Matches[1] -as [int]; if($i -ge 2020 -and $i -le 2030) { $validatedFields.eyr = $true } }
        '^hgt:(\d+)(cm|in)$' { 
            $d = $Matches[1] -as [int];
            $u = $matches[2]
            if($u -eq 'cm') { 
                $validatedFields.hgt = ($d -ge 150 -and $d -le 193)
            } else {
                $validatedFields.hgt = ($d -ge 59 -and $d -le 76)
            }
        }      
        '^hcl:(#[0-9a-f]{6})$' { $validatedFields.hcl = $true }
        '^ecl:(amb|blu|brn|gry|grn|hzl|oth)$' { $validatedFields.ecl = $true }
        '^pid:(\d{9})$' { $validatedFields.pid = $true }
        '^cid:(.*)$' { }
        default { Write-Warning "invalid field '$_'" }
    }

    if($validatedFields.Values -notcontains $false) {
        $validCount += 1
    }
}

"Found $validCount valid passports"