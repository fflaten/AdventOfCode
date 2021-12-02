# $in = @"
# FBFBBFFRLR
# BFFFBBFRRR
# FFFBBBFRRR
# BBFFBBFRLL
# "@ -split "`n" | % trim

$in = Get-Content $PSScriptRoot\input.txt
$rowFieldIndexes = 0..6
$seatFieldIndexes = 7..9
$totalRows = 0..127
$totalSeats = 0..7

$highestSeatID = $null;

foreach($seat in $in) {
    $remainingRows = $totalRows
    foreach($i in $rowFieldIndexes) {
        if($seat[$i] -eq 'F') {
            $remainingRows = $remainingRows[0..($remainingRows.Count/2-1)]
        } else {
            $remainingRows = $remainingRows[($remainingRows.Count/2)..($remainingRows.Count-1)]
        }
    }

    #"Row found: $remainingRows. Calculating seat..."

    $remainingSeats = $totalSeats
    foreach($i in $seatFieldIndexes) {
        if($seat[$i] -eq 'L') {
            $remainingSeats = $remainingSeats[0..($remainingSeats.Count/2-1)]
        } else {
            $remainingSeats = $remainingSeats[($remainingSeats.Count/2)..($remainingSeats.Count-1)]
        }
    }

    $seatId = $remainingRows[0] * 8 + $remainingSeats[0]
    #"Seat found - Row: $remainingRows Seat: $remainingSeats Seat ID: $remainingRows * 8 + $remainingSeats = $seatId"
    if($seatId -gt $highestSeatID) { $highestSeatID = $seatId}
}

"Highest seat id: $highestSeatID"