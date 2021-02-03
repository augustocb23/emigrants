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
    foreach ($file in (Get-Item $htmlStatic).GetFiles()) {
        Copy-Item $file.FullName $outFolder
    }
}

function New-XmlPage([string] $Id, [string] $Title) {
    $doc = New-Object System.Xml.XmlDocument
    $doc.InsertBefore($doc.CreateXmlDeclaration('1.0', 'UTF-8', $null), $doc.DocumentElement) | Out-Null
    $doc.AppendChild($doc.CreateProcessingInstruction('xml-model', 'href="page.xsd"')) | Out-Null
    $doc.AppendChild($doc.CreateProcessingInstruction('xml-stylesheet', 'type="text/xsl" href="page.xsl"')) | Out-Null

    $pageNode = $doc.CreateElement('page')
    $pageNode.SetAttribute('id', $Id)
    $pageNode.SetAttribute('title', $Title)

    $doc.AppendChild($pageNode) | Out-Null
    return $doc
}

function GenerateEmigrantsList {
    $emigrants = Select-Xml -Path $dataFile -XPath 'Museu/IdentificacaoEmigrante'
    $doc = New-XmlPage -Id 'emigrants' -Title 'Emigrantes'

    $list = $doc.CreateElement('list')
    $doc.DocumentElement.AppendChild($list) | Out-Null

    foreach ($emigrant in $emigrants) {
        $node = $doc.CreateElement('link')
        $emigrantId = Select-Xml -Xml $emigrant.Node -XPath 'idEmigrante/text()'
        $node.setAttribute('href', "emigrante_$emigrantId.xml")
        $node.InnerText = Select-Xml -Xml $emigrant.Node -XPath 'nome/text()'

        $listItem = $doc.CreateElement('item')
        $listItem.AppendChild($node) | Out-Null
        $list.AppendChild($listItem) | Out-Null
    }

    $doc.Save("$htmlOut/emigrants.xml")
}

CopyStaticFiles
GenerateEmigrantsList

Start-Process "$htmlOut/index.html"