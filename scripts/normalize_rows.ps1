$path = 'D:\first-contributions\docs\translations\Translations.md'
$lines = Get-Content -Path $path -ErrorAction Stop

$first = -1
for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match '^\|') { $first = $i; break }
}
if ($first -lt 0) { Write-Error 'No table found'; exit 1 }

$headerLines = $lines[0..($first+1)]
$bodyLines = @()
if ($first+2 -le $lines.Count-1) { $bodyLines = $lines[($first+2)..($lines.Count-1)] }

$newRows = @()
foreach ($l in $bodyLines) {
    if ($l -match '^\|') {
        $m = [regex]::Match($l, '^\|\s*(?<left>.*?)\s*\|\s*(?<right>.*?)\s*\|?\s*$')
        if ($m.Success) {
            $left = $m.Groups['left'].Value.Trim()
            $right = $m.Groups['right'].Value.Trim().TrimEnd('|').Trim()
            $newRows += "| $left | $right |"
        }
    }
}

$newContent = $headerLines + $newRows
Set-Content -Path $path -Value $newContent -Encoding UTF8
Write-Output "Normalized rows: $($newRows.Count) rows."