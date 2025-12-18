$md = 'D:\first-contributions\docs\translations\Translations.md'
$dir = 'D:\first-contributions\docs\translations'
$content = Get-Content -Path $md -Raw -ErrorAction Stop
$links = [regex]::Matches($content, 'README\.[\w\-]+\.md') | ForEach-Object { $_.Value } | Sort-Object -Unique

$problems = @()
foreach ($link in $links) {
    $path = Join-Path $dir $link
    if (-not (Test-Path $path)) {
        $problems += [pscustomobject]@{ File=$link; Issue='Missing' }
        continue
    }
    $info = Get-Item $path
    if ($info.Length -lt 20) {
        $problems += [pscustomobject]@{ File=$link; Issue='Too small (<20 bytes)' }
        continue
    }
    $txt = Get-Content -Path $path -Raw -ErrorAction SilentlyContinue
    if (-not ($txt -match '(?m)^\s*#')) {
        $problems += [pscustomobject]@{ File=$link; Issue='No Markdown header found' }
    }
}

Write-Output '---VERIFY-RESULTS---'
if ($problems.Count -eq 0) { Write-Output 'All referenced README files exist, are non-empty, and contain a markdown header.' } else { $problems | Format-Table -AutoSize }
