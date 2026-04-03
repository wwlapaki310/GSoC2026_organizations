param(
    [string]$InputPath = "manuscript/book.md",
    [string]$OutputDir = "output",
    [string[]]$Formats = @("html", "epub", "docx"),
    [string]$BaseName = "gsoc2026-organizations-guide",
    [string]$CssPath = "assets/book.css",
    [string]$Author,
    [string]$DocumentLang = "ja",
    [string]$PublishedDate = (Get-Date -Format "yyyy-MM-dd"),
    [string]$PdfEngine,
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
    throw "pandoc is required. Install it first, for example with: winget install --id JohnMacFarlane.Pandoc -e"
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
    $outputPath = $null
    $formatArgs = @()

    switch ($normalizedFormat) {
        "html" {
            $outputPath = Join-Path $resolvedOutputDir "$BaseName.html"
            $formatArgs = @("--to", "html5", "--embed-resources") + $cssArgs
        }
        "epub" {
            $outputPath = Join-Path $resolvedOutputDir "$BaseName.epub"
            $formatArgs = @("--to", "epub3") + $cssArgs
        }
        "docx" {
            $outputPath = Join-Path $resolvedOutputDir "$BaseName.docx"
            $formatArgs = @("--to", "docx")
        }
        "pdf" {
            $outputPath = Join-Path $resolvedOutputDir "$BaseName.pdf"
            $formatArgs = @("--to", "pdf")
            if ($PdfEngine) {
                $formatArgs += @("--pdf-engine", $PdfEngine)
            }
        }
        default {
            throw "Unsupported format: $format. Supported formats are html, epub, docx, pdf."
        }
    }

    Write-Host "Converting to $normalizedFormat -> $outputPath"
    & $pandocCommand.Source $resolvedInput "-o" $outputPath @commonArgs @formatArgs
}

Write-Host "Completed. Outputs are in $resolvedOutputDir"