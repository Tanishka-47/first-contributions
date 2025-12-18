$md = 'D:\first-contributions\docs\translations\Translations.md'
$dir = 'D:\first-contributions\docs\translations'

$content = Get-Content -Path $md -Raw -ErrorAction Stop
$matches = [regex]::Matches($content, 'README\.[\w\-_]+\.md') | ForEach-Object { $_.Value } | Sort-Object -Unique
$files = Get-ChildItem -Path $dir -File -Name | Sort-Object
$missing = $matches | Where-Object { -not ($files -contains $_) }

Write-Output '---LINKS---'
$matches | ForEach-Object { Write-Output $_ }
Write-Output '---FILES---'
$files | ForEach-Object { Write-Output $_ }
Write-Output '---MISSING---'
if ($missing -and $missing.Count -gt 0) { $missing | ForEach-Object { Write-Output $_ } } else { Write-Output '(none)' }
