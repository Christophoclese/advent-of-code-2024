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

function ValidateReport($Report) {
    $Diffs = @()

    $Parts = $Report.split(" ")
    For ($i=0; $i -lt $Parts.Count - 1; $i++) {
        $Diffs += $Parts[$i+1] - $Parts[$i]
    }

    # Ensure all values increasing or decreasing
    If ($Diffs -gt 0 -and $Diffs -lt 0) {
        return $Diffs, $false
        
    }

    # Ensure all differences are between 1 and 3
    # While you can use comparison operators to check if values in a list match
    # You cannot use that expresion in a logic statement if the value returned is zero
    # or you'll get a false, despite a value matched.
    # PS /home/cbarton/github/advent-of-code-2024> $Range
    # 1
    # 2
    # 1
    # 0
    # PS /home/cbarton/github/advent-of-code-2024> $Range -lt 1
    # 0
    # PS /home/cbarton/github/advent-of-code-2024> [bool]$Range -lt 1
    # False

    $Range = $Diffs | ForEach-Object { [Math]::Abs($_) }
    If ($Range -lt 1 -or $Range -gt 3 -or $Range -contains 0) {
        return $Diffs, $false
    }

    return $Diffs, $true
}

$Reports = @()

$Input | ForEach-Object {
    $Diffs, $Safe = ValidateReport -Report $_
    $Reports += [PSCustomObject]@{
        "Report" = $_
        "Diffs" = $Diffs
        "Safe" = $Safe
    }
}

$SafeReportsCount = @($Reports | Where-Object { $_.Safe }).Count
Write-Host "The number of safe reports is: $SafeReportsCount"
