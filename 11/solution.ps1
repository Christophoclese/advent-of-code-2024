using namespace System.Collections.Generic

[CmdletBinding()]
Param(
    $InputFile = "./input",

    [switch]$Test
)

If ($Test) { $InputFile = "./test_input" }

If (Test-Path -Path $InputFile -PathType Leaf) {
    $PuzzleInput = Get-Content -Path $InputFile
}
Else {
    Throw "Invalid input file: $InputFile"
}

function StareAtStones($Blinks, $Setup) {
    $LastState = $Setup
    For ($Count = 1; $Count -le $Blinks; $Count++) {
        Write-Host "Current blink: $Count/$Blinks"
        $NewState = [List[decimal]]@()

        ForEach ($Value in $LastState) {
            If ($Value -eq 0) {
                $NewState.Add(1)
            }
            ElseIf ($Value.ToString().Length % 2 -eq 0) {
                $String = [string]$Value
                $Mid = $String.Length / 2
                $End = $String.Length
                [decimal]$Left = $String.Substring(0, $Mid)
                [decimal]$Right = $String.Substring($Mid, $Mid)
                $NewState.Add($Left)
                $NewState.Add($Right)
            }
            Else {
                $NewState.Add($Value * 2024)
            }    
        }

        Write-Verbose "Current Stone Count: $($NewState.Count)"
        If ($Count -lt $Blinks) {
            $LastState = $NewState.ToArray()
        }
    }

    Return "The total number of stones after $Blinks blinks is: $($NewState.Count)"
}

[decimal[]]$InitialState = $PuzzleInput.split(" ")

StareAtStones -Blinks 25 -Setup $InitialState
StareAtStones -Blinks 75 -Setup $InitialState
