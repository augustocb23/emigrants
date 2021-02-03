<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:array="http://www.w3.org/2005/xpath-functions/array" xmlns:map="http://www.w3.org/2005/xpath-functions/map" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:err="http://www.w3.org/2005/xqt-errors" exclude-result-prefixes="array fn map math xhtml xs err" version="3.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- Museu -->
	<xsl:template match="/" name="xsl:initial-template">
		<Museu xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="Museu.xsd">
			<xsl:apply-templates select="//table[@name='Acompanhante']"/>
			<xsl:apply-templates select="//table[@name='anexo']"/>
			<xsl:apply-templates select="//table[@name='Chamante']"/>
			<xsl:apply-templates select="//table[@name='Contratante']"/>
			<xsl:apply-templates select="//table[@name='DeslAnterior']"/>
			<xsl:apply-templates select="//table[@name='Filiacao']"/>
			<xsl:apply-templates select="//table[@name='IdentificacaoEmigrante']"/>
			<xsl:apply-templates select="//table[@name='Intermediario']"/>
			<xsl:apply-templates select="//table[@name='Localidade']"/>
			<xsl:apply-templates select="//table[@name='Lugar']"/>
			<xsl:apply-templates select="//table[@name='Nota']"/>
			<xsl:apply-templates select="//table[@name='PessoasFamFicamPais']"/>
			<xsl:apply-templates select="//table[@name='Processo']"/>
			<xsl:apply-templates select="//table[@name='ProcessoAcomp']"/>
			<xsl:apply-templates select="//table[@name='ProcessoAnexo']"/>
			<xsl:apply-templates select="//table[@name='ProcessoPessoasFam']"/>
		</Museu>
	</xsl:template>
	<!-- Acompanhante -->
	<xsl:template match="table[@name='Acompanhante']">
		<Acompanhante>
			<idAcomp>
				<xsl:value-of select="column[@name='idAcomp']/text()"/>
			</idAcomp>
			<nome>
				<xsl:value-of select="column[@name='nome']/text()"/>
			</nome>
			<idAcompAux>
				<xsl:value-of select="column[@name='idAcompAux']/text()"/>
			</idAcompAux>
			<dtNasc>
				<xsl:value-of select="column[@name='dtNasc']/text()"/>
			</dtNasc>
			<parentesco>
				<xsl:value-of select="column[@name='parentesco']/text()"/>
			</parentesco>
			<habilitacoes>
				<xsl:value-of select="column[@name='habilitacoes']/text()"/>
			</habilitacoes>
		</Acompanhante>
	</xsl:template>
	<!-- anexo -->
	<xsl:template match="table[@name='anexo']">
		<anexo>
			<idAnexo>
				<xsl:value-of select="column[@name='idAnexo']/text()"/>
			</idAnexo>
			<descricao>
				<xsl:value-of select="column[@name='descricao']/text()"/>
			</descricao>
		</anexo>
	</xsl:template>
	<!-- Chamante -->
	<xsl:template match="table[@name='Chamante']">
		<Chamante>
			<idChamante>
				<xsl:value-of select="column[@name='idAnexo']/text()"/>
			</idChamante>
			<nome>
				<xsl:value-of select="column[@name='nome']/text()"/>
			</nome>
			<residencia>
				<xsl:value-of select="column[@name='residencia']/text()"/>
			</residencia>
			<tempoEstrang>
				<xsl:value-of select="column[@name='tempoEstrang']/text()"/>
			</tempoEstrang>
			<passap>
				<xsl:value-of select="column[@name='passap']/text()"/>
			</passap>
		</Chamante>
	</xsl:template>
	<!-- Contratante -->
	<xsl:template match="table[@name='Contratante']">
		<Contratante>
			<idContratante>
				<xsl:value-of select="column[@name='idContratante']/text()"/>
			</idContratante>
			<nome>
				<xsl:value-of select="column[@name='nome']/text()"/>
			</nome>
			<residencia>
				<xsl:value-of select="column[@name='residencia']/text()"/>
			</residencia>
			<conhecimento>
				<xsl:value-of select="column[@name='conhecimento']/text()"/>
			</conhecimento>
		</Contratante>
	</xsl:template>
	<!-- DeslAnterior -->
	<xsl:template match="table[@name='DeslAnterior']">
		<DeslAnterior>
			<idDeslAnterior>
				<xsl:value-of select="column[@name='idDeslAnterior']/text()"/>
			</idDeslAnterior>
			<viajaPrimVez>
				<xsl:value-of select="column[@name='viajaPrimVez']/text()"/>
			</viajaPrimVez>
			<dtRegresso>
				<xsl:value-of select="column[@name='dtRegresso']/text()"/>
			</dtRegresso>
			<passapAnt>
				<xsl:value-of select="column[@name='passapAnt']/text()"/>
			</passapAnt>
			<entEmissora>
				<xsl:value-of select="column[@name='entEmissora']/text()"/>
			</entEmissora>
			<repatriado>
				<xsl:value-of select="column[@name='repatriado']/text()"/>
			</repatriado>
			<motivo>
				<xsl:value-of select="column[@name='motivo']/text()"/>
			</motivo>
			<pedidoAnt>
				<xsl:value-of select="column[@name='pedidoAnt']/text()"/>
			</pedidoAnt>
			<numCM>
				<xsl:value-of select="column[@name='numCM']/text()"/>
			</numCM>
		</DeslAnterior>
	</xsl:template>
	<!-- Filiacao -->
	<xsl:template match="table[@name='Filiacao']">
		<Filiacao>
			<idFiliacao>
				<xsl:value-of select="column[@name='idFiliacao']/text()"/>
			</idFiliacao>
			<idPai>
				<xsl:value-of select="column[@name='idPai']/text()"/>
			</idPai>
			<idMae>
				<xsl:value-of select="column[@name='idMae']/text()"/>
			</idMae>
			<nomePai>
				<xsl:value-of select="column[@name='nomePai']/text()"/>
			</nomePai>
			<nomeMae>
				<xsl:value-of select="column[@name='nomeMae']/text()"/>
			</nomeMae>
		</Filiacao>
	</xsl:template>
	<!-- IdentificacaoEmigrante -->
	<xsl:template match="table[@name='IdentificacaoEmigrante']">
		<IdentificacaoEmigrante>
			<idEmigrante>
				<xsl:value-of select="column[@name='idEmigrante']/text()"/>
			</idEmigrante>
			<nome>
				<xsl:value-of select="column[@name='nome']/text()"/>
			</nome>
			<dtNasc>
				<xsl:value-of select="column[@name='dtNasc']/text()"/>
			</dtNasc>
			<idConj>
				<xsl:value-of select="column[@name='idConj']/text()"/>
			</idConj>
			<nomeConj>
				<xsl:value-of select="column[@name='nomeConj']/text()"/>
			</nomeConj>
			<idFiliacao>
				<xsl:value-of select="column[@name='idFiliacao']/text()"/>
			</idFiliacao>
			<idNaturalidade>
				<xsl:value-of select="column[@name='idNaturalidade']/text()"/>
			</idNaturalidade>
		</IdentificacaoEmigrante>
	</xsl:template>
	<!-- Intermediario -->
	<xsl:template match="table[@name='Intermediario']">
		<Intermediario>
			<idIntermediario>
				<xsl:value-of select="column[@name='idIntermediario']/text()"/>
			</idIntermediario>
			<nome>
				<xsl:value-of select="column[@name='nome']/text()"/>
			</nome>
			<residencia>
				<xsl:value-of select="column[@name='residencia']/text()"/>
			</residencia>
			<atividade>
				<xsl:value-of select="column[@name='atividade']/text()"/>
			</atividade>
			<nomePai>
				<xsl:value-of select="column[@name='nomePai']/text()"/>
			</nomePai>
			<nomeMae>
				<xsl:value-of select="column[@name='nomeMae']/text()"/>
			</nomeMae>
			<parentesco>
				<xsl:value-of select="column[@name='parentesco']/text()"/>
			</parentesco>
			<passap>
				<xsl:value-of select="column[@name='passap']/text()"/>
			</passap>
			<pagamento>
				<xsl:value-of select="column[@name='pagamento']/text()"/>
			</pagamento>
		</Intermediario>
	</xsl:template>
	<!-- Localidade -->
	<xsl:template match="table[@name='Localidade']">
		<Localidade>
			<idLocalidade>
				<xsl:value-of select="column[@name='idLocalidade']/text()"/>
			</idLocalidade>
			<freguesia>
				<xsl:value-of select="column[@name='freguesia']/text()"/>
			</freguesia>
			<concelho>
				<xsl:value-of select="column[@name='concelho']/text()"/>
			</concelho>
			<distrito>
				<xsl:value-of select="column[@name='distrito']/text()"/>
			</distrito>
		</Localidade>
	</xsl:template>
	<!-- Lugar -->
	<xsl:template match="table[@name='Lugar']">
		<Lugar>
			<idLugar>
				<xsl:value-of select="column[@name='idLugar']/text()"/>
			</idLugar>
			<lugar>
				<xsl:value-of select="column[@name='lugar']/text()"/>
			</lugar>
			<idLocalidade>
				<xsl:value-of select="column[@name='idLocalidade']/text()"/>
			</idLocalidade>
		</Lugar>
	</xsl:template>
	<!-- Nota -->
	<xsl:template match="table[@name='Nota']">
		<Nota>
			<idNota>
				<xsl:value-of select="column[@name='idNota']/text()"/>
			</idNota>
			<descricao>
				<xsl:value-of select="column[@name='descricao']/text()"/>
			</descricao>
			<numCM>
				<xsl:value-of select="column[@name='numCM']/text()"/>
			</numCM>
		</Nota>
	</xsl:template>
	<!-- PessoasFamFicamPais -->
	<xsl:template match="table[@name='PessoasFamFicamPais']">
		<PessoasFamFicamPais>
			<idPessoasFamFicamPais>
				<xsl:value-of select="column[@name='idPessoasFamFicamPais']/text()"/>
			</idPessoasFamFicamPais>
			<nome>
				<xsl:value-of select="column[@name='nome']/text()"/>
			</nome>
			<idDependente>
				<xsl:value-of select="column[@name='idDependente']/text()"/>
			</idDependente>
			<idade>
				<xsl:value-of select="column[@name='idade']/text()"/>
			</idade>
			<parentesco>
				<xsl:value-of select="column[@name='parentesco']/text()"/>
			</parentesco>
			<aCargoEmigrante>
				<xsl:value-of select="column[@name='aCargoEmigrante']/text()"/>
			</aCargoEmigrante>
			<idResidencia>
				<xsl:value-of select="column[@name='idResidencia']/text()"/>
			</idResidencia>
		</PessoasFamFicamPais>
	</xsl:template>	
	<!-- Processo -->
	<xsl:template match="table[@name='Processo']">
		<Processo>
			<numCM>
				<xsl:value-of select="column[@name='numCM']/text()"/>
			</numCM>
			<numCMu>
				<xsl:value-of select="column[@name='numCMu']/text()"/>
			</numCMu>
			<numJE>
				<xsl:value-of select="column[@name='numJE']/text()"/>
			</numJE>
			<ano>
				<xsl:value-of select="column[@name='ano']/text()"/>
			</ano>
			<idade>
				<xsl:value-of select="column[@name='idade']/text()"/>
			</idade>
			<estCivil>
				<xsl:value-of select="column[@name='estCivil']/text()"/>
			</estCivil>
			<paisDestino>
				<xsl:value-of select="column[@name='paisDestino']/text()"/>
			</paisDestino>
			<localidadeDestino>
				<xsl:value-of select="column[@name='localidadeDestino']/text()"/>
			</localidadeDestino>
			<dtExp>
				<xsl:value-of select="column[@name='dtExp']/text()"/>
			</dtExp>
			<oficioExp>
				<xsl:value-of select="column[@name='oficioExp']/text()"/>
			</oficioExp>
			<passapExp>
				<xsl:value-of select="column[@name='passapExp']/text()"/>
			</passapExp>
			<tipoTranspEmb>
				<xsl:value-of select="column[@name='tipoTranspEmb']/text()"/>
			</tipoTranspEmb>
			<desigTranspEmb>
				<xsl:value-of select="column[@name='desigTranspEmb']/text()"/>
			</desigTranspEmb>
			<ciaEmb>
				<xsl:value-of select="column[@name='ciaEmb']/text()"/>
			</ciaEmb>
			<dtEmb>
				<xsl:value-of select="column[@name='dtEmb']/text()"/>
			</dtEmb>
			<passPagaEmb>
				<xsl:value-of select="column[@name='passPagaEmb']/text()"/>
			</passPagaEmb>
			<localEmb>
				<xsl:value-of select="column[@name='localEmb']/text()"/>
			</localEmb>
			<portoDesemb>
				<xsl:value-of select="column[@name='portoDesemb']/text()"/>
			</portoDesemb>
			<irComEmb>
				<xsl:value-of select="column[@name='irComEmb']/text()"/>
			</irComEmb>
			<profissaoHab>
				<xsl:value-of select="column[@name='profissaoHab']/text()"/>
			</profissaoHab>
			<habLiterariasHab>
				<xsl:value-of select="column[@name='habLiterariasHab']/text()"/>
			</habLiterariasHab>
			<localTrabHab>
				<xsl:value-of select="column[@name='localTrabHab']/text()"/>
			</localTrabHab>
			<remCondEco>
				<xsl:value-of select="column[@name='remCondEco']/text()"/>
			</remCondEco>
			<numDiasTrabCondEco>
				<xsl:value-of select="column[@name='numDiasTrabCondEco']/text()"/>
			</numDiasTrabCondEco>
			<motivoEmigCondEco>
				<xsl:value-of select="column[@name='motivoEmigCondEco']/text()"/>
			</motivoEmigCondEco>
			<despDeslCondEco>
				<xsl:value-of select="column[@name='despDeslCondEco']/text()"/>
			</despDeslCondEco>
			<julgadoAntPen>
				<xsl:value-of select="column[@name='julgadoAntPen']/text()"/>
			</julgadoAntPen>
			<procPendAntPen>
				<xsl:value-of select="column[@name='procPendAntPen']/text()"/>
			</procPendAntPen>
			<procPendFamAntPen>
				<xsl:value-of select="column[@name='procPendFamAntPen']/text()"/>
			</procPendFamAntPen>
			<nomeAuxPaisDestino>
				<xsl:value-of select="column[@name='nomeAuxPaisDestino']/text()"/>
			</nomeAuxPaisDestino>
			<parentescoAuxPaisDestino>
				<xsl:value-of select="column[@name='parentescoAuxPaisDestino']/text()"/>
			</parentescoAuxPaisDestino>
			<residenciaAuxPaisDestino>
				<xsl:value-of select="column[@name='residenciaAuxPaisDestino']/text()"/>
			</residenciaAuxPaisDestino>
			<profissaoAuxPaisDestino>
				<xsl:value-of select="column[@name='profissaoAuxPaisDestino']/text()"/>
			</profissaoAuxPaisDestino>
			<auxPrestadosAuxPaisDestino>
				<xsl:value-of select="column[@name='auxPrestadosAuxPaisDestino']/text()"/>
			</auxPrestadosAuxPaisDestino>
			<obtenContratoTrab>
				<xsl:value-of select="column[@name='obtenContratoTrab']/text()"/>
			</obtenContratoTrab>
			<profissaoContratoTrab>
				<xsl:value-of select="column[@name='profissaoContratoTrab']/text()"/>
			</profissaoContratoTrab>
			<salarioContratoTrab>
				<xsl:value-of select="column[@name='salarioContratoTrab']/text()"/>
			</salarioContratoTrab>
			<jaTrabalhouMulherMenor>
				<xsl:value-of select="column[@name='jaTrabalhouMulherMenor']/text()"/>
			</jaTrabalhouMulherMenor>
			<familiaresMulherMenor>
				<xsl:value-of select="column[@name='familiaresMulherMenor']/text()"/>
			</familiaresMulherMenor>
			<qtTempoMulherMenor>
				<xsl:value-of select="column[@name='qtTempoMulherMenor']/text()"/>
			</qtTempoMulherMenor>
			<ocupacaoMulherMenor>
				<xsl:value-of select="column[@name='ocupacaoMulherMenor']/text()"/>
			</ocupacaoMulherMenor>
			<temConhecimentoDeclMulher>
				<xsl:value-of select="column[@name='temConhecimentoDeclMulher']/text()"/>
			</temConhecimentoDeclMulher>
			<consideraDeclMulher>
				<xsl:value-of select="column[@name='consideraDeclMulher']/text()"/>
			</consideraDeclMulher>
			<parentescoComChamante>
				<xsl:value-of select="column[@name='parentescoComChamante']/text()"/>
			</parentescoComChamante>
			<idEmigrante>
				<xsl:value-of select="column[@name='idEmigrante']/text()"/>
			</idEmigrante>
			<idChamante>
				<xsl:value-of select="column[@name='idChamante']/text()"/>
			</idChamante>
			<idResidencia>
				<xsl:value-of select="column[@name='idResidencia']/text()"/>
			</idResidencia>
			<idLugar>
				<xsl:value-of select="column[@name='idLugar']/text()"/>
			</idLugar>
			<idIntermediario>
				<xsl:value-of select="column[@name='idIntermediario']/text()"/>
			</idIntermediario>
			<idContratante>
				<xsl:value-of select="column[@name='idContratante']/text()"/>
			</idContratante>
		</Processo>
	</xsl:template>
	<!-- ProcessoAcomp-->
	<xsl:template match="table[@name='ProcessoAcomp']">
		<ProcessoAcomp>
			<numCM>
				<xsl:value-of select="column[@name='numCM']/text()"/>
			</numCM>
			<idAcomp>
				<xsl:value-of select="column[@name='idAcomp']/text()"/>
			</idAcomp>
			<idProcessoAcomp>
				<xsl:value-of select="column[@name='idProcessoAcomp']/text()"/>
			</idProcessoAcomp>
		</ProcessoAcomp>
	</xsl:template>
	<!-- ProcessoAnexo -->
	<xsl:template match="table[@name='ProcessoAnexo']">
		<ProcessoAnexo>
			<idAnexo>
				<xsl:value-of select="column[@name='idAnexo']/text()"/>
			</idAnexo>
			<numCM>
				<xsl:value-of select="column[@name='numCM']/text()"/>
			</numCM>
			<idProcessoAnexo>
				<xsl:value-of select="column[@name='idProcessoAnexo']/text()"/>
			</idProcessoAnexo>
		</ProcessoAnexo>
	</xsl:template>
	<!-- ProcessoPessoasFam -->
	<xsl:template match="table[@name='ProcessoPessoasFam']">
		<ProcessoPessoasFam>
			<idPessoasFamFicamPais>
				<xsl:value-of select="column[@name='idPessoasFamFicamPais']/text()"/>
			</idPessoasFamFicamPais>
			<numCM>
				<xsl:value-of select="column[@name='numCM']/text()"/>
			</numCM>
			<idProcessoPessoasFam>
				<xsl:value-of select="column[@name='idProcessoPessoasFam']/text()"/>
			</idProcessoPessoasFam>
		</ProcessoPessoasFam>
	</xsl:template>	
</xsl:stylesheet>
