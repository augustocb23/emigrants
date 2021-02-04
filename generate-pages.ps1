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

$xmlData = (Select-Xml -Path $dataFile -XPath "Museu").Node

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
    $emigrants = Select-Xml -Xml $xmlData -XPath 'IdentificacaoEmigrante'
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
function GeneratPlacesList {
    $places = Select-Xml -Xml $xmlData -XPath 'Localidade'
    $doc = New-XmlPage -Id 'places' -Title 'Localidades'

    $list = $doc.CreateElement('list')
    $doc.DocumentElement.AppendChild($list) | Out-Null

    foreach ($emigrant in $places) {
        $node = $doc.CreateElement('plaintext')
        $freguesia = Select-Xml -Xml $emigrant.Node -XPath 'freguesia/text()'
        $concelho = Select-Xml -Xml $emigrant.Node -XPath 'concelho/text()'
        $distrito = Select-Xml -Xml $emigrant.Node -XPath 'distrito/text()'
        $node.InnerText = "$freguesia - $concelho (Distrito de $distrito)"

        $listItem = $doc.CreateElement('item')
        $listItem.AppendChild($node) | Out-Null
        $list.AppendChild($listItem) | Out-Null
    }

    $doc.Save("$htmlOut/places.xml")
}

function New-ProcessPage ([string] $ProcessId, [string] $EmigrantName) {
    $process = Select-Xml -Xml $xmlData -XPath "Processo[numCM/text()='$ProcessId']"
    if (!$process) {
        Write-Warning -Category ObjectNotFound -ErrorAction Continue -Message "Process $ProcessId not found"
    }

    $pageId = "process_$ProcessId"
    $doc = New-XmlPage -Id $pageId -Title "Processo $ProcessId"
    
    $emigrantInfo = $doc.CreateElement('plaintext')
    $emigrantInfo.InnerText = $EmigrantName
    $doc.DocumentElement.AppendChild($emigrantInfo) | Out-Null
    
    $companionsTitle = $doc.CreateElement('caption')
    $companionsTitle.InnerText = "Acompanhantes"
    $doc.DocumentElement.AppendChild($companionsTitle) | Out-Null
    $companionsList = $doc.CreateElement('list')
    $doc.DocumentElement.AppendChild($companionsList) | Out-Null
    $companionIds = Select-Xml -Xml $xmlData -XPath "ProcessoAcomp[numCM/text()='$ProcessId']/idAcomp/text()"
    foreach ($companionId in $companionIds) {
        $companion = (Select-Xml -Xml $xmlData -XPath "Acompanhante[idAcomp=$companionId]").Node
        $companionName = Select-Xml -Xml $companion -XPath 'nome/text()'
        $companionRelationship = Select-Xml -Xml $companion -XPath 'parentesco/text()'

        $node = $doc.CreateElement('plaintext')
        $node.InnerText = "$companionName ($companionRelationship)"

        $listItem = $doc.CreateElement('item')
        $listItem.AppendChild($node) | Out-Null
        $companionsList.AppendChild($listItem) | Out-Null
    }

    $relativesTitle = $doc.CreateElement('caption')
    $relativesTitle.InnerText = "Familiares que ficaram"
    $doc.DocumentElement.AppendChild($relativesTitle) | Out-Null
    $relativesList = $doc.CreateElement('list')
    $doc.DocumentElement.AppendChild($relativesList) | Out-Null
    $relativeIds = Select-Xml -Xml $xmlData -XPath "ProcessoPessoasFam[numCM/text()='$ProcessId']/idPessoasFamFicamPais/text()"
    foreach ($relativeId in $relativeIds) {
        $relative = (Select-Xml -Xml $xmlData -XPath "PessoasFamFicamPais[idPessoasFamFicamPais=$relativeId]").Node
        $relativeName = Select-Xml -Xml $relative -XPath 'nome/text()'
        $relativeRelationship = Select-Xml -Xml $relative -XPath 'parentesco/text()'

        $node = $doc.CreateElement('plaintext')
        $node.InnerText = "$relativeName ($relativeRelationship)"

        $listItem = $doc.CreateElement('item')
        $listItem.AppendChild($node) | Out-Null
        $relativesList.AppendChild($listItem) | Out-Null
    }

    $attachmentsTitle = $doc.CreateElement('caption')
    $attachmentsTitle.InnerText = "Anexos"
    $doc.DocumentElement.AppendChild($attachmentsTitle) | Out-Null
    $attachmentsList = $doc.CreateElement('list')
    $doc.DocumentElement.AppendChild($attachmentsList) | Out-Null
    $attachmentIds = Select-Xml -Xml $xmlData -XPath "ProcessoAnexo[numCM/text()='$ProcessId']/idAnexo/text()"
    foreach ($attachmentId in $attachmentIds) {
        $attachment = (Select-Xml -Xml $xmlData -XPath "anexo[idAnexo=$attachmentId]").Node

        $node = $doc.CreateElement('plaintext')
        $node.InnerText = Select-Xml -Xml $attachment -XPath 'descricao/text()'

        $listItem = $doc.CreateElement('item')
        $listItem.AppendChild($node) | Out-Null
        $attachmentsList.AppendChild($listItem) | Out-Null
    }

    $doc.Save("$htmlOut/$pageId.xml")
}

CopyStaticFiles
GeneratPlacesList
GenerateEmigrantsList

#Start-Process "$htmlOut/index.html"