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

$Width = $PuzzleInput[0].Length
$Height = $PuzzleInput.Length
$XMASCount = 0
$DoubleMASCount = 0
$ValidStrings = @("MSMS", "MMSS", "SMSM", "SSMM")

# Start scanning left right, top bottom
For ($y = 0; $y -lt $Height; $y++) {
    For ($x = 0; $x -lt $Width; $x++) {
        # Is this character an X?
        If ($PuzzleInput[$y][$x] -eq "X") {
            # Try to find XMAS in all directions...

            # To the right!
            If ($x + 3 -lt $Width) {
                $String = ""
                For ($off = 0; $off -lt 4; $off++) {
                    $String += $PuzzleInput[$y][$x + $off]
                }
                If ($String -eq "XMAS") { $XMASCount++ }
            }

            # Down and to the right!
            If ($x + 3 -lt $Width -and $y + 3 -lt $Height) {
                $String = ""
                For ($off = 0; $off -lt 4; $off++) {
                    $String += $PuzzleInput[$y + $off][$x + $off]
                }
                If ($String -eq "XMAS") { $XMASCount++ }
            }

            # Down!
            If ($y + 3 -lt $Height) {
                $String = ""
                For ($off = 0; $off -lt 4; $off++) {
                    $String += $PuzzleInput[$y + $off][$x]
                }
                If ($String -eq "XMAS") { $XMASCount++ }
            }

            # Down and Left!
            If ($x - 3 -ge 0 -and $y + 3 -lt $Height) {
                $String = ""
                For ($off = 0; $off -lt 4; $off++) {
                    $String += $PuzzleInput[$y + $off][$x - $off]
                }
                If ($String -eq "XMAS") { $XMASCount++ }
            }

            # Left!
            If ($x - 3 -ge 0) {
                $String = ""
                For ($off = 0; $off -lt 4; $off++) {
                    $String += $PuzzleInput[$y][$x - $off]
                }
                If ($String -eq "XMAS") { $XMASCount++ }
            }

            # Left and Up!
            If ($x - 3 -ge 0 -and $y - 3 -ge 0) {
                $String = ""
                For ($off = 0; $off -lt 4; $off++) {
                    $String += $PuzzleInput[$y - $off][$x - $off]
                }
                If ($String -eq "XMAS") { $XMASCount++ }
            }

            # Up, Up, and Away!
            If ($y - 3 -ge 0) {
                $String = ""
                For ($off = 0; $off -lt 4; $off++) {
                    $String += $PuzzleInput[$y - $off][$x]
                }
                If ($String -eq "XMAS") { $XMASCount++ }
            }

            # Up and Right!
            If ($x + 3 -lt $Width -and $y - 3 -ge 0) {
                $String = ""
                For ($off = 0; $off -lt 4; $off++) {
                    $String += $PuzzleInput[$y - $off][$x + $off]
                }
                If ($String -eq "XMAS") { $XMASCount++ }
            }

        }

        # Is the current character an A?
        If ($PuzzleInput[$y][$x] -eq "A") {
            # Not on an edge in any direction
            If ($x + 1 -lt $Width -and $x - 1 -ge 0 -and $y + 1 -lt $Height -and $y - 1 -ge 0) {
                # valid patterns
                # M . S
                # . A .
                # M . S
                # 
                # M . M
                # . A .
                # S . S
                # 
                # S . M
                # . A .
                # S . M
                # 
                # S . S
                # . A .
                # M . M
                # 
                # Assuming
                # 1 . 2
                # . A .
                # 3 . 4
                # 
                # Valid strings
                # MSMS
                # MMSS
                # SMSM
                # SSMM

                $String = ""
                $String += $PuzzleInput[$y - 1][$x - 1]
                $String += $PuzzleInput[$y - 1][$x + 1]
                $String += $PuzzleInput[$y + 1][$x - 1]
                $String += $PuzzleInput[$y + 1][$x + 1]

                If ($String -in $ValidStrings) {
                    $DoubleMASCount++
                }
            }
        }

    }
}

Write-Host "The total number of XMAS appearances is: $XMASCount"
Write-Host "The total number of X-MAS appearances is: $DoubleMASCount"
