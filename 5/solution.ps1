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

function CheckRules($Values, $LastChance, $Depth = 0) {
    $ValidUpdate = ""
    $Depth++

    # See if each rule applies to the numbers in this update?
    ForEach ($Rule in $Ruleset) {
        Write-Verbose "Evaluating $Rule on $($Values -join(','))"
        $Before, $After = $Rule.split("|")
        If ($Before -in $Values -and $After -in $Values) {
            # Enforce the rule
            $BeforeIndex = $Values.IndexOf($Before)
            $AfterIndex = $Values.IndexOf($After)
            If ($BeforeIndex -gt $AfterIndex) {
                Write-Verbose "FAILED: Rule $Rule is not valid because $Before ($BeforeIndex) appears after $After ($AfterIndex)"

                If ($Depth -lt $Values.Count * 100 -and -not $LastChance) {
                    # We'll attempt to swap the positions of Before and After, then validate again?
                    $SwappedParts = $Values.Clone()
                    $SwappedParts[$BeforeIndex] = $After
                    $SwappedParts[$AfterIndex] = $Before
                    Write-Verbose "REPAIRING: Rule $Rule"
                    return CheckRules -Values $SwappedParts -Depth $Depth
                }

                return $false
            }
            Else {
                Write-Verbose "SUCCESS: Rule $Rule is valid for $($Values -join(','))"
                $ValidUpdate = $Values
            }
        }
        Else {
            Write-Verbose "IGNORED: Rule $Rule does not apply for $($Values -join(','))"
            $ValidUpdate = $Values
        }
    }

    Return $ValidUpdate
}

$Ruleset = $PuzzleInput[0].split("`r`n") | Where-Object { $_ }
$Updates = $PuzzleInput[1].split("`r`n") | Where-Object { $_ }
$CorrectMiddlePageSum = 0
$FixedMiddlePageSum = 0

ForEach ($Update in $Updates) {
    Write-Verbose "START: $Update"
    $Parts = $Update.split(",") 

    $ValidUpdate = CheckRules -Values $Parts -LastChance $true

    If ($ValidUpdate) {
        Write-Verbose "$Update - Appears Valid"
        # All the rules passed
        # Find middle value and add to sum
        $Mid = [int][Math]::Truncate($Parts.Count / 2)
        $CorrectMiddlePageSum += [int]$Parts[$Mid]
    }
    Else {
        Write-Verbose "$Update - Is Invalid...can we fix it?"
        If ($FixedOrder = CheckRules -Values $Parts -LastChance $false) {
            Write-Verbose "FIXED!?!?! $Update -> $($FixedOrder -join ',')"
            $Mid = [int][Math]::Truncate($FixedOrder.Count / 2)
            $FixedMiddlePageSum += [int]$FixedOrder[$Mid]
        }

    }
}

Write-Host "The sum of the middle page of correctly ordered updates is: $CorrectMiddlePageSum"
Write-Host "The sum of the middle page of fixed updates is: $FixedMiddlePageSum"

# TODO: Consider returning the matching parts/swapped parts and using that to test for true/false, then can extract middle value from used parts
