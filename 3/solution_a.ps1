[CmdletBinding()]
Param(
    $InputFile = "./input"
)

If (Test-Path -Path $InputFile -PathType Leaf) {
    $PuzzleInput = Get-Content -Path $InputFile
}
Else {
    Throw "Invalid input file: $InputFile"
}

$regex = [regex]'mul\((\d{1,3}),(\d{1,3})\)'
$AllMatches = $regex.Matches($PuzzleInput)
$Total = 0

ForEach ($Item in $AllMatches) {
    $Total += [int]$Item.Groups[1].Value * [int]$Item.Groups[2].Value
}

Write-Host "The total of all mul(x,y) entries is: $Total"
