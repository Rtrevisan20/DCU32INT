param([string]$Path, [int]$Start = 0x0, [int]$End = 0x100)
$data = [System.IO.File]::ReadAllBytes($Path)
for ($i = $Start; $i -lt $End; $i += 16) {
    $chunk = $data[$i..($i+15)]
    $hex = ($chunk | ForEach-Object { '{0:X2}' -f $_ }) -join ' '
    $ascii = ($chunk | ForEach-Object { if ($_ -ge 32 -and $_ -lt 127) { [char]$_ } else { '.' } }) -join ''
    write-host ('{0:X8}: {1,-48} {2}' -f $i, $hex, $ascii)
}