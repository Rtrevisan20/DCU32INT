param([int]$Tag = 0x9C, [string]$Dcu = (Join-Path $PSScriptRoot '..\Packages\Delphi\System.dcu'))
$data = [System.IO.File]::ReadAllBytes($Dcu)
for ($i = 0; $i -lt $data.Length; $i++) {
    if ($data[$i] -eq $Tag) {
        write-host ("Found 0x{0:X2} at offset 0x{1:X8}" -f $Tag, $i)
        $ctxStart = [Math]::Max(0, $i - 16)
        $ctxEnd = [Math]::Min($data.Length, $i + 64)
        $chunk = $data[$ctxStart..$ctxEnd]
        $hex = ($chunk | ForEach-Object { '{0:X2}' -f $_ }) -join ' '
        $ascii = ($chunk | ForEach-Object { if ($_ -ge 32 -and $_ -lt 127) { [char]$_ } else { '.' } }) -join ''
        write-host ('  Context 0x{0:X8}: {1}' -f $ctxStart, $hex)
        write-host ('  ASCII:    {0}' -f $ascii)
        write-host ""
    }
}