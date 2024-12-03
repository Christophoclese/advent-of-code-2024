[CmdletBinding()]
Param(
    $InputFile = "./input"
)

If (Test-Path -Path $InputFile -PathType Leaf) {
    $Input = Get-Content -Path $InputFile
}
Else {
    Throw "Invalid input file: $InputFile"
}

$Left, $Right = @()
$TotalApart = 0
$RightOccurrenceMap = @{}
$SimilarityScore = 0

# Generate two lists (left & right) and sort them
$Input | ForEach-Object {
    [int]$l, [int]$r = $_.split('   ')
    $Left += @($l)
    $Right += @($r)
}

$Left = $Left | Sort-Object
$Right = $Right | Sort-Object

# Now calculate total distance apart and build occurrence map for right side
For ($i = 0; $i -lt $Input.Count; $i++) {
    $Apart = [Math]::Abs($Left[$i] - $Right[$i])
    $TotalApart += $Apart

    $RightOccurrenceMap[$Right[$i]] += 1
}

Write-Host "The total distance between both lists is: $TotalApart"

For ($i = 0; $i -lt $Input.Count; $i++) {
    $NewScore = $Left[$i] * $RightOccurrenceMap[$Left[$i]]
    Write-Host $Left[$i] "*" $RightOccurrenceMap[$Left[$i]] "=" $NewScore
    $SimilarityScore += $NewScore
}

Write-Host "The similarity score for these two lists is: $SimilarityScore"
