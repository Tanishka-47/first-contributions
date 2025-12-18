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

$seen = @{}
$newRows = @()
foreach ($l in $bodyLines) {
    if ($l -match '^\|') {
        $match = [regex]::Match($l, 'README\.[\w\-_]+\.md').Value
        if ($match) {
            if (-not $seen.ContainsKey($match)) {
                $seen[$match] = $true
                $newRows += $l.TrimEnd()
            }
        }
    }
}

$newContent = $headerLines + $newRows
Set-Content -Path $path -Value $newContent -Encoding UTF8
Write-Output "Deduplicated by target: $($newRows.Count) unique README targets written."