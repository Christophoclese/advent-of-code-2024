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

class Map {
    [char[,]]$Map
    [uint16]$Width
    [uint16]$Height

    Map($Data) {
        $this.Width = $Data[0].Length
        $this.Height = $Data.Length
        
        $this.Map = New-Object 'char[,]' $this.Width, $this.Height

        For ($y = 0; $y -lt $this.Height; $y++) {
            For ($x = 0; $x -lt $this.Width; $x++) {
                $Value = $Data[$y][$x]
                $this.Map[$x,$y] = $Value
            }
        }
    }

    [string]ToString() {
        $String = ""
        For ($y = 0; $y -lt $this.Height; $y++) {
            For ($x = 0; $x -lt $this.Width; $x++) {
                $String += $this.Map[$x,$y]
            }
            $String += "`n"
        }

        return $String
    }

    [hashtable]FreqHash() {
        $FreqHash = @{}
        For ($y = 0; $y -lt $this.Height; $y++) {
            For ($x = 0; $x -lt $this.Width; $x++) {
                [string]$Value = $this.Map[$x,$y]
                If ($Value -notin @('.','#')) {
                    $FreqHash[$Value] += @("$x,$y")
                }
            }
        }

        return $FreqHash
    }

    PlotAntinodes($Freqencies) {
        # For freqencies with count greater than 1
        ForEach ($Freqeuncy in $Freqencies.GetEnumerator()) {
            $Key = $Freqeuncy.Key
            $Values = $Freqeuncy.Value
            $Count = $Values.Count
            $Antinodes = @()

            If ($Count -lt 2) {
                continue
            }

            # Determine antinodes of each pair
            For ($i = 0; $i -lt $Count; $i++) {
                For ($j = $i + 1; $j -lt $Count; $j++) {
                    $A = @{}
                    $B = @{}
                    [int]$A.x, [int]$A.y = $Values[$i].split(",")
                    [int]$B.x, [int]$B.y = $Values[$j].split(",")

                    $Offsetx = $B.x - $A.x
                    $Offsety = $B.y - $A.y

                    $NewA = @{
                        x = $A.x - $Offsetx
                        y = $A.y - $Offsety
                    }
                    $NewB = @{
                        x = $B.x + $Offsetx
                        y = $B.y + $Offsety
                    }

                    $Antinodes += "$($NewA.x),$($NewA.y)"
                    $Antinodes += "$($NewB.x),$($NewB.y)"

#                    Write-Verbose "$Key $Offsetx $Offsety"
                }
            }

            # Put antinodes on map
            ForEach ($Node in $Antinodes) {
                [int]$x, [int]$y = $Node.split(",")
                If ($x -ge 0 -and $x -lt $this.Width -and $y -ge 0 -and $y -lt $this.Height) {
                    Write-Verbose "Plotting antinode at ($x,$y)"
                    $this.Map[$x,$y] = '#'
                }
            }
        }

    }
}

# New instance of base class
$Map = [Map]::new($PuzzleInput)

# Build a hashtable of frequencies present
$Freqencies = $Map.FreqHash()

$Map.PlotAntinodes($Freqencies)

($Map.Map | Where-Object { $_ -eq '#' }).Count
