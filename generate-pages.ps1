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
    if (Test-Path  $htmlOut) {
        Get-Item $htmlOut | Remove-Item -Recurse -Force
    }

    $outFolder = New-Item $htmlOut -ItemType Directory
    $files = (Get-Item $htmlStatic).GetFiles()
    foreach ($file in $files) {
        $percent = $files.IndexOf($file) / $files.Length * 100
        Write-Progress -Id 1 -Activity 'Copying static content...' -Status $file.Name -PercentComplete $percent

        Copy-Item $file.FullName $outFolder
    }
}

function GenerateEmigrantsList {
    $emigrants = Select-Xml -Path $dataFile -XPath 'Museu/IdentificacaoEmigrante'

    $newXml = New-Object System.Xml.XmlDocument    
    $newXml.InsertBefore($newXml.CreateXmlDeclaration('1.0', 'UTF-8', $null), $newXml.DocumentElement)
    $newXml.AppendChild($newXml.CreateProcessingInstruction('xml-stylesheet', 'type="text/xsl" href="page.xsl"'))

    $pageNode = $newXml.CreateElement('page')
    $pageNode.SetAttribute('id', 'emigrants')
    $pageNode.SetAttribute('title', 'Emigrantes')

    foreach ($emigrant in $emigrants) {
        $node = $newXml.CreateElement('plaintext')
        $node.InnerText = Select-Xml -Xml $emigrant.Node -XPath 'nome/text()'

        $pageNode.AppendChild($node)
    }

    $newXml.AppendChild($pageNode)
    $newXml.Save("$htmlOut/emigrants.xml")
}

CopyStaticFiles
GenerateEmigrantsList

# TODO remover pausa
Pause
Start-Process "$htmlOut/index.html"