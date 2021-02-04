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

function Copy-StaticFiles {
    if (Test-Path  $htmlOut) {
        Get-Item $htmlOut | Remove-Item -Recurse -Force
    }

    $outFolder = New-Item $htmlOut -ItemType Directory
    foreach ($file in (Get-Item $htmlStatic).GetFiles()) {
        Copy-Item $file.FullName $outFolder
    }
}

function New-XmlPage([string] $Id, [string] $Title, [string] $BackTo) {
    $doc = New-Object System.Xml.XmlDocument
    $doc.InsertBefore($doc.CreateXmlDeclaration('1.0', 'UTF-8', $null), $doc.DocumentElement) | Out-Null
    $doc.AppendChild($doc.CreateProcessingInstruction('xml-model', 'href="page.xsd"')) | Out-Null
    $doc.AppendChild($doc.CreateProcessingInstruction('xml-stylesheet', 'type="text/xsl" href="page.xsl"')) | Out-Null

    $pageNode = $doc.CreateElement('page')
    $pageNode.SetAttribute('id', $Id)
    $pageNode.SetAttribute('title', $Title)
    if ($BackTo) { $pageNode.SetAttribute('backTo', $BackTo) }

    $doc.AppendChild($pageNode) | Out-Null
    return $doc
}

function Build-PlacesListPage {
    $places = Select-Xml -Xml $xmlData -XPath 'Localidade'
    $doc = New-XmlPage -Id 'places' -Title 'Localidades' -BackTo 'home.xml'

    $list = $doc.CreateElement('list')
    $list.SetAttribute('size', $places.Length)
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

function Build-EmigrantsListPage {
    $emigrants = Select-Xml -Xml $xmlData -XPath 'IdentificacaoEmigrante'
    $doc = New-XmlPage -Id 'emigrants' -Title 'Emigrantes' -BackTo 'home.xml'

    $list = $doc.CreateElement('list')
    $list.SetAttribute('size', $emigrants.Length)
    $doc.DocumentElement.AppendChild($list) | Out-Null

    $i = 0
    $length = $emigrants.Length
    foreach ($emigrant in $emigrants) {
        $node = $doc.CreateElement('link')
        $emigrantId = Select-Xml -Xml $emigrant.Node -XPath 'idEmigrante/text()'
        $node.setAttribute('href', "emigrant_$emigrantId.xml")
        $emigrantName = Select-Xml -Xml $emigrant.Node -XPath 'nome/text()'
        $node.InnerText = $emigrantName

        $listItem = $doc.CreateElement('item')
        $listItem.AppendChild($node) | Out-Null
        $list.AppendChild($listItem) | Out-Null

        Write-Progress -Activity 'Generating emigrant pages' -Status $emigrantName -PercentComplete ($i / $length * 100)
        Build-EmigrantPage -EmigrantId $emigrantId -Emigrant $emigrant.Node

        $i++
    }

    $doc.Save("$htmlOut/emigrants.xml")
}

function Build-EmigrantPage ([System.Xml.XmlNode] $Emigrant) {
    $emigrantId = Select-Xml -Xml $Emigrant -XPath 'idEmigrante/text()'
    $emigrantName = Select-Xml -Xml $Emigrant -XPath 'nome/text()'
    $doc = New-XmlPage -Id "emigrant_$emigrantId" -Title $emigrantName -BackTo 'emigrants.xml'
    $pageElement = $doc.DocumentElement

    $birthdate = Select-Xml -Xml $Emigrant -XPath 'dtNasc/text()'
    $formattedBirthdate = (Get-Date $birthdate.ToString()).ToString('dd \de MMMMM \de yyyy')
    $birthdateNode = $doc.CreateElement('longtext')
    $birthdateNode.InnerText = "Data de Nascimento: $formattedBirthdate"
    $pageElement.AppendChild($birthdateNode) | Out-Null

    $consort = Select-Xml -Xml $Emigrant -XPath 'nomeConj/text()'
    if ($consort.ToString() -Ne 'NULL') {
        $consortNode = $doc.CreateElement('longtext')
        $consortNode.InnerText = "Cônjuge: $consort"
        $pageElement.AppendChild($consortNode) | Out-Null 
    }

    # affiliation
    $affiliationTitle = $doc.CreateElement('caption')
    $affiliationTitle.InnerText = 'Filiação'
    $pageElement.AppendChild($affiliationTitle) | Out-Null

    $affiliationId = Select-Xml -Xml $Emigrant -XPath 'idFiliacao/text()'
    $affiliation = Select-Xml -Xml $xmlData -XPath "Filiacao[idFiliacao/text() = '$affiliationId']"
    if ($affiliation) {
        $fatherNode = $doc.CreateElement('longtext')
        $fatherName = Select-Xml -Xml $affiliation.Node -XPath "nomePai/text()"
        $fatherNode.InnerText = "Pai: $fatherName"
        $pageElement.AppendChild($fatherNode) | Out-Null

        $motherNode = $doc.CreateElement('longtext')
        $motherName = Select-Xml -Xml $affiliation.Node -XPath "nomeMae/text()"
        $motherNode.InnerText = "Mãe: $motherName"
        $pageElement.AppendChild($motherNode) | Out-Null
    } else {
        Write-Warning "Emigrant '$emigrantName' (ID $emigrantId) has no affiliation data"
    }

    # place
    $placeTitle = $doc.CreateElement('caption')
    $placeTitle.InnerText = 'Naturalidade'
    $pageElement.AppendChild($placeTitle) | Out-Null

    $placeId = Select-Xml -Xml $Emigrant -XPath 'idNaturalidade/text()'
    $place = Select-Xml -Xml $xmlData -XPath "Localidade[idLocalidade/text() = '$placeId']"

    if ($place) {
        $placeDescription = $doc.CreateElement('longtext')    
        $freguesia = Select-Xml -Xml $place.Node -XPath 'freguesia/text()'
        $concelho = Select-Xml -Xml $place.Node -XPath 'concelho/text()'
        $distrito = Select-Xml -Xml $place.Node -XPath 'distrito/text()'
        $placeDescription.InnerText = "$freguesia - $concelho (Distrito de $distrito)"
        $pageElement.AppendChild($placeDescription) | Out-Null
    } else {
        Write-Warning "Emigrant '$emigrantName' (ID $emigrantId) has no location data"
    }

    # processes
    $processesTitle = $doc.CreateElement('caption')
    $processesTitle.InnerText = 'Processos'
    $pageElement.AppendChild($processesTitle) | Out-Null

    $processIds = Select-Xml -Xml $xmlData -XPath "Processo[idEmigrante/text() = '$emigrantId']/numCM/text()"
    if ($processIds) {
        $processList = $doc.CreateElement('list')
        $pageElement.AppendChild($processList) | Out-Null

        foreach ($processId in $processIds) {
            Build-ProcessPage -ProcessId $processId -EmigrantId $emigrantId -EmigrantName $emigrantName

            $processLink = $doc.CreateElement('link')
            $processLink.SetAttribute('href', "process_$processId.xml")
            $processLink.InnerText = "Processo $processId"

            $listItem = $doc.CreateElement('item')
            $listItem.AppendChild($processLink) | Out-Null
            $processList.AppendChild($listItem) | Out-Null
        }
    } else {
        Write-Warning "Emigrant '$emigrantName' (ID $emigrantId) don't has any process data"
    }

    $doc.Save("$htmlOut/emigrant_$EmigrantId.xml")
}

function Build-ProcessPage ([string] $ProcessId, [string] $EmigrantId, [string] $EmigrantName) {
    $process = Select-Xml -Xml $xmlData -XPath "Processo[numCM/text()='$ProcessId']"
    if (!$process) {
        Write-Warning -Category ObjectNotFound -ErrorAction Continue -Message "Process $ProcessId not found"
    }

    $pageId = "process_$ProcessId"
    $doc = New-XmlPage -Id $pageId -Title "Processo $ProcessId" -BackTo "emigrant_$EmigrantId.xml"
    $pageElement = $doc.DocumentElement

    $emigrantInfo = $doc.CreateElement('longtext')
    $emigrantInfo.InnerText = "Emigrante: $EmigrantName"
    $pageElement.AppendChild($emigrantInfo) | Out-Null

    $destinationCountry = Select-Xml -Xml $process.Node -XPath 'paisDestino/text()'
    $destinationInfo = $doc.CreateElement('longtext')
    $destinationInfo.InnerText = "Destino: $destinationCountry"
    $pageElement.AppendChild($destinationInfo) | Out-Null

    $reason = Select-Xml -Xml $process.Node -XPath 'motivoEmigCondEco/text()'
    $reasonInfo = $doc.CreateElement('longtext')
    $reasonInfo.InnerText = "Motivação: $reason"
    $pageElement.AppendChild($reasonInfo) | Out-Null
    
    $companionsTitle = $doc.CreateElement('caption')
    $companionsTitle.InnerText = "Acompanhantes"
    $pageElement.AppendChild($companionsTitle) | Out-Null
    $companionsList = $doc.CreateElement('list')
    $pageElement.AppendChild($companionsList) | Out-Null
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
    $pageElement.AppendChild($relativesTitle) | Out-Null
    $relativesList = $doc.CreateElement('list')
    $pageElement.AppendChild($relativesList) | Out-Null
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
    $pageElement.AppendChild($attachmentsTitle) | Out-Null
    $attachmentsList = $doc.CreateElement('list')
    $pageElement.AppendChild($attachmentsList) | Out-Null
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

Copy-StaticFiles
Build-PlacesListPage
Build-EmigrantsListPage

#Start-Process "$htmlOut/index.html"