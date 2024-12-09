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

$Operators = @('+','*','||')
$Total = 0

$threadSafeDictionary = [System.Collections.Concurrent.ConcurrentDictionary[string,object]]::new()

$null = $PuzzleInput | ForEach-Object -ThrottleLimit 10 -Parallel {
    function BuildExpressions($Operand1, $Operand2, $Operators) {
        $Expressions = ForEach ($Operator in $Operators) {
            If ($Operator -eq "||") {
                $Expression = "$Operand1$Operand2"
            }
            Else {
                $Expression = "$Operand1 $Operator $Operand2"
            }
            Write-Verbose "Adding expression: $Expression"
            $Expression
        }

        Return $Expressions
    }

    function FixCalibration() {
        [CmdletBinding()]
        Param(
            [decimal]$TestValue,

            [int[]]$Numbers,

            [string[]]$Operators
        )

        # Preload initial loop
        $Values = @($Numbers[0])

        For ($i = 0; $i -lt $Numbers.Count - 1; $i++) {
            $Expressions = @()

            $Expressions = ForEach ($Value in $Values) {
                BuildExpressions -Operand1 $Value -Operand2 $Numbers[$i+1] -Operators $Operators
            }

            $Values = $Expressions | ForEach-Object { $_ | Invoke-Expression } | Where-Object { $_ -le $TestValue } | Select-Object -Unique
            Write-Verbose "Current values are: $($Values -Join ',')"
        }

        If ($TestValue -in $Values) {
            Return $TestValue
        }

        Return 0
    }

    Write-Verbose "Starting work on '$_'"
    [decimal]$Answer, [int[]]$Numbers = $_.Split(":").Trim().Split(" ")
    $Result = FixCalibration -TestValue $Answer -Numbers $Numbers -Operators $using:Operators
    Write-Verbose "Finished work on '$_' with result = $Result"

    $dict = $using:threadSafeDictionary
    $dict.TryAdd($_, $Result)
}

$Total = $threadSafeDictionary.Values | Measure-Object -Sum | Select-Object -ExpandProperty Sum
Write-Host "The total calibration result is: $Total"
