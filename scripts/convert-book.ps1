param(
    [string]$InputPath = "manuscript/book.md",
    [string]$OutputDir = "output",
    [string[]]$Formats = @("html", "epub", "docx"),
    [string]$BaseName = "gsoc2026-organizations-guide",
    [string]$CssPath = "assets/book.css",
    [string]$Author,
    [string]$DocumentLang = "ja",
    [string]$PublishedDate = (Get-Date -Format "yyyy-MM-dd"),
    [switch]$Clean
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$resolvedInput = Join-Path $repoRoot $InputPath
$resolvedOutputDir = Join-Path $repoRoot $OutputDir
$resolvedCss = Join-Path $repoRoot $CssPath

if (-not (Test-Path -LiteralPath $resolvedInput)) {
    throw "Input file was not found: $resolvedInput"
}

$pandocCommand = Get-Command pandoc -ErrorAction SilentlyContinue
if (-not $pandocCommand) {
    $fallbackPaths = @(
        "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\JohnMacFarlane.Pandoc_Microsoft.Winget.Source_8wekyb3d8bbwe\pandoc-3.9.0.2\pandoc.exe"
    )
    $found = $fallbackPaths | Where-Object { Test-Path $_ } | Select-Object -First 1
    if ($found) {
        $pandocCommand = [PSCustomObject]@{ Source = $found }
    } else {
        throw "pandoc is required. Install: winget install --id JohnMacFarlane.Pandoc -e"
    }
}

$chromeExe = $null
$chromeCandidates = @(
    "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
    "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe"
)
$x86 = ${env:ProgramFiles(x86)}
if ($x86) { $chromeCandidates += "$x86\Google\Chrome\Application\chrome.exe" }
foreach ($c in $chromeCandidates) {
    if (Test-Path $c) { $chromeExe = $c; break }
}

New-Item -ItemType Directory -Path $resolvedOutputDir -Force | Out-Null

if ($Clean) {
    Get-ChildItem -Path $resolvedOutputDir -Filter "$BaseName.*" -File -ErrorAction SilentlyContinue |
        Remove-Item -Force
}

$resourcePath = @(
    $repoRoot,
    (Join-Path $repoRoot "manuscript"),
    (Join-Path $repoRoot "assets")
) -join [IO.Path]::PathSeparator

$commonArgs = @(
    "--standalone",
    "--from", "markdown+yaml_metadata_block+link_attributes",
    "--toc",
    "--toc-depth=2",
    "--resource-path", $resourcePath,
    "--metadata", "lang=$DocumentLang",
    "--metadata", "date=$PublishedDate"
)

if ($Author) {
    $commonArgs += @("--metadata", "author=$Author")
}

$cssArgs = @()
if (Test-Path -LiteralPath $resolvedCss) {
    $cssArgs = @("--css", $resolvedCss)
}

foreach ($format in $Formats) {
    $normalizedFormat = $format.ToLowerInvariant()

    switch ($normalizedFormat) {
        "html" {
            $outputPath = Join-Path $resolvedOutputDir ($BaseName + ".html")
            $formatArgs = @("--to", "html5", "--embed-resources") + $cssArgs
            Write-Host "Converting to html -> $outputPath"
            & $pandocCommand.Source $resolvedInput "-o" $outputPath @commonArgs @formatArgs
        }
        "epub" {
            $outputPath = Join-Path $resolvedOutputDir ($BaseName + ".epub")
            $formatArgs = @("--to", "epub3") + $cssArgs
            Write-Host "Converting to epub -> $outputPath"
            & $pandocCommand.Source $resolvedInput "-o" $outputPath @commonArgs @formatArgs
        }
        "docx" {
            $mdForDocx = Join-Path $resolvedOutputDir ($BaseName + "-for-docx.md")
            $outputPath = Join-Path $resolvedOutputDir ($BaseName + ".docx")
            Write-Host "Adding page breaks (2 orgs per page) -> $mdForDocx"
            $pyScript = Join-Path $repoRoot "scripts/add-docx-pagebreaks.py"
            & python3 $pyScript $resolvedInput $mdForDocx
            Write-Host "Converting to docx -> $outputPath"
            & $pandocCommand.Source $mdForDocx "-o" $outputPath @commonArgs "--to" "docx"
        }
        "pdf" {
            if (-not $chromeExe) {
                throw "Chrome not found. Please install Google Chrome."
            }
            $htmlForPdf = Join-Path $resolvedOutputDir ($BaseName + "-for-pdf.html")
            $outputPath  = Join-Path $resolvedOutputDir ($BaseName + ".pdf")

            Write-Host "Converting to html (for pdf) -> $htmlForPdf"
            & $pandocCommand.Source $resolvedInput "-o" $htmlForPdf @commonArgs "--to" "html5" "--embed-resources" @cssArgs

            Write-Host "Adding page breaks (2 orgs per page)"
            $pyScript = Join-Path $repoRoot "scripts/add-pdf-pagebreaks.py"
            & python3 $pyScript $htmlForPdf

            Write-Host "Converting to pdf (via Chrome) -> $outputPath"
            $htmlUri = "file:///" + $htmlForPdf.Replace("\", "/")
            $chromeArgs = "--headless=new --disable-gpu --no-sandbox --run-all-compositor-stages-before-draw --print-to-pdf=`"$outputPath`" --print-to-pdf-no-header `"$htmlUri`""
            Start-Process -FilePath $chromeExe -ArgumentList $chromeArgs -Wait -NoNewWindow
        }
        default {
            throw "Unsupported format: $format. Supported: html, epub, docx, pdf."
        }
    }
}

Write-Host "Completed. Outputs are in $resolvedOutputDir"
