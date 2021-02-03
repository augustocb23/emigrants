$htmlStatic = 'html-static'
$htmlOut = 'html-out'
$dataFile = 'museu.xml'

# validations
if (!(Test-Path  $htmlStatic )) {
    Write-Error -Category ObjectNotFound -ErrorAction Stop -Message "Folder $htmlStatic not found."
}
if (!(Test-Path  $dataFile )) {
    Write-Error -Category ObjectNotFound -ErrorAction Stop -Message "File $dataFile not found."
}

function CopyStaticFiles {
    Remove-Item $htmlOut -Recurse -Force
    New-Item $htmlOut -ItemType Directory
    $files = (Get-Item $htmlStatic).GetFiles()
    foreach ($file in $files) {
        $percent = $files.IndexOf($file) / $files.Length
        Write-Progress -Activity 'Copying static content...' -Status $file.Name -PercentComplete $percent

        Copy-Item $file.FullName $htmlOut/
    }
}
CopyStaticFiles

pause
Start-Process "$htmlOut/index.html"