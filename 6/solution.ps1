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

$DirMap = [ordered]@{
    '^' = @{
        'xdir' = 0
        'ydir' = -1
    }
    '>' = @{
        'xdir' = 1
        'ydir' = 0
    }
    'v' = @{
        'xdir' = 0
        'ydir' = 1
    }
    '<' = @{
        'xdir' = -1
        'ydir' = 0
    }
}

# Setup a 2D char array and read initial state into it while locating starting position and direction
$Map = New-Object 'char[,]' $Width, $Height
For ($y = 0; $y -lt $Height; $y++) {
    For ($x = 0; $x -lt $Width; $x++) {
        $Value = $PuzzleInput[$y][$x]
        $Map[$x,$y] = $Value

        # Locate initial guard position and direction
        If ($Value -in @('^','>','v','<')) {
            Write-Verbose "Found starting position ($x,$y) and direction ($Value)"
            $StartingPosition = @{
                'x' = $x
                'y' = $y
            }

            $Direction = $Value
        }
    }
}

$x = $StartingPosition.x
$y = $StartingPosition.y

$VisitedLocations = $Map.Clone()
$VisitedLocations[$x,$y] = 'X'

$Position = $StartingPosition.Clone()
$LeftTheBuilding = $false
$Log = @()

# Start moving around until we exit the boundaries
Do {
    # Is there something (#) in the direction we are looking?
    $Nextx = $x + $DirMap["$Direction"].xdir
    $Nexty = $y + $DirMap["$Direction"].ydir
    If ($Map[$Nextx, $Nexty] -eq '#' -and $Nextx -gt 0 -and $Nexty -gt 0) {
        Write-Verbose "There is a # at ($Nextx,$Nexty)"
        # Turn right
        $NewDirectionIndex = @($DirMap.Keys).IndexOf($Direction) + 1
        If ($NewDirectionIndex -gt @($DirMap.Keys).Count - 1) { $NewDirectionIndex = 0 }
        $Direction = @($DirMap.Keys)[$NewDirectionIndex]
        Write-Verbose "Turning right ($Direction)"
    }
    Else {
        # Increment x y with direction
        $x += $DirMap["$Direction"].xdir
        $y += $DirMap["$Direction"].ydir
        Write-Verbose "Moved to ($x,$y)"

        # Have we left the board?
        If ($x -lt 0 -or $x -ge $Width -or $y -lt 0 -or $y -ge $Height) {
            # Prep loop exit
            $LeftTheBuilding = $true
            Write-Verbose "We have left the boundaries ($x,$y) ($Width,$Height)"
        }
        Else {
            # Record position
            $VisitedLocations[$x,$y] = 'X'
            $Log += @($x,$y)
            # Check log to see if we're looping???
        }
    }

} Until ($LeftTheBuilding)

$VisitedCount = ($VisitedLocations | Where-Object { $_ -eq 'X' }).Count

Write-Host "The total number of distinct positions the guard will visit is: $VisitedCount"
