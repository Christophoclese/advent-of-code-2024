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

$regex = [regex]"mul\((\d{1,3}),(\d{1,3})\)|do(?>n't)?\(\)"
$AllMatches = $regex.Matches($PuzzleInput)
$Total = 0
$EnabledTotal = 0
$MulEnabled = $true

ForEach ($Item in $AllMatches) {
    If ($Item.Value -eq "do()") {
        $MulEnabled = $true
    }
    ElseIf ($Item.Value -eq "don't()") {
        $MulEnabled = $false
    }
    Else {
        $Total += [int]$Item.Groups[1].Value * [int]$Item.Groups[2].Value
        If ($MulEnabled) {
            $EnabledTotal += [int]$Item.Groups[1].Value * [int]$Item.Groups[2].Value
        }
    }
}

Write-Host "The total of all mul(x,y) entries is: $Total"
Write-Host "The total of all mul(x,y) entries with do/don't is: $EnabledTotal"
