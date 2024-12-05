[CmdletBinding()]
Param(
    $InputFile = "./input"
)

If (Test-Path -Path $InputFile -PathType Leaf) {
    $PuzzleInput = Get-Content -Path $InputFile -Delimiter "`r`n`r`n"
}
Else {
    Throw "Invalid input file: $InputFile"
}

$Ruleset = $PuzzleInput[0].split("`r`n") | Where-Object { $_ }
$Updates = $PuzzleInput[1].split("`r`n") | Where-Object { $_ }
$MiddlePageSum = 0

ForEach ($Update in $Updates) {
    $ValidUpdate = $true
    $Parts = $Update.split(",") 
    # See if each rule applies to the numbers in this update?
    ForEach ($Rule in $Ruleset) {
        Write-Verbose "Evaluating $Rule on $Update"
        $Before, $After = $Rule.split("|")
        If ($Before -in $Parts -and $After -in $Parts) {
            # Enforce the rule
            $BeforeIndex = $Parts.IndexOf($Before)
            $AfterIndex = $Parts.IndexOf($After)
            If ($BeforeIndex -gt $AfterIndex) {
                Write-Verbose "Rule $Rule is not valid because $Before ($BeforeIndex) appears after $After ($AfterIndex)"
                $ValidUpdate = $false
            }
            Else {
                Write-Verbose "Rule $Rule is valid for $Update"
            }
        }
        Else {
            Write-Verbose "Rule $Rule does not apply for $Update"
        }
    }

    If ($ValidUpdate) {
        Write-Verbose "$Update - Appears Valid"
        # All the rules passed
        # Find middle value and add to sum
        $Mid = [int][Math]::Truncate($Parts.Count / 2)
        $MiddlePageSum += [int]$Parts[$Mid]
    }
}

Write-Host "The sum of the middle page of correctly ordered updates is: $MiddlePageSum"
