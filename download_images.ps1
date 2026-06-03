$sourceUrl = "https://northwestgroup.in"
$outputDir = "d:\Northwestgroup.in\images"

if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

Write-Host "Downloading images from $sourceUrl..."

try {
    $page = Invoke-WebRequest -Uri $sourceUrl -UseBasicParsing
    $images = $page.Images | Select-Object -ExpandProperty src

    $downloaded = 0
    foreach ($img in $images) {
        if ($img) {
            if ($img -match '^/') {
                $fullUrl = "$sourceUrl$img"
            } elseif ($img -match '^http') {
                $fullUrl = $img
            } else {
                $fullUrl = "$sourceUrl/$img"
            }

            $fileName = Split-Path $fullUrl -Leaf
            $fileName = $fileName.Split('?')[0]

            if ($fileName) {
                $outputPath = Join-Path $outputDir $fileName

                try {
                    Invoke-WebRequest -Uri $fullUrl -OutFile $outputPath -UseBasicParsing
                    Write-Host "Downloaded: $fileName"
                    $downloaded++
                } catch {
                    Write-Host "Failed: $fileName"
                }
            }
        }
    }

    Write-Host "Complete. Downloaded $downloaded images to $outputDir"
} catch {
    Write-Host "Error: $_"
}
