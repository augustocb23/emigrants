<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:array="http://www.w3.org/2005/xpath-functions/array" xmlns:map="http://www.w3.org/2005/xpath-functions/map" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:err="http://www.w3.org/2005/xqt-errors" exclude-result-prefixes="array fn map math xhtml xs err" version="3.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="Museu" name="xsl:initial-template">
		<questoes>
			<q1>
				<xsl:for-each select="Processo/numCM[text()=/Museu/ProcessoAcomp/numCM/text()]">
					<xsl:variable name="processWithCompanions" select="."/>
					<xsl:if test="count(/Museu/ProcessoAcomp[numCM/text()=$processWithCompanions]) &gt;3">
						<processo>
							<xsl:value-of select="$processWithCompanions"/>
						</processo>
					</xsl:if>
				</xsl:for-each>
			</q1>
			<q2>
				<xsl:for-each select="IdentificacaoEmigrante[substring(dtNasc/text(),1,4)='1937' and number(substring(dtNasc/text(), 6,2))&lt;7]">
					<xsl:copy-of select="."/>
				</xsl:for-each>
			</q2>
			<q3>
				<!--TODO-->
			</q3>
			<q4>
				<xsl:for-each-group select="Localidade" group-by="distrito">
					<xsl:variable name="districtName" select="distrito/text()"/>
					<distrito nome="{$districtName}">
						<xsl:for-each-group select="/Museu/Localidade[distrito=$districtName]" group-by="concelho">
							<xsl:variable name="stateName" select="concelho/text()"/>
							<concelho nome="{$stateName}">
								<xsl:for-each select="/Museu/Localidade[distrito=$districtName and concelho=$stateName]">
									<freguesia nome="{freguesia/text()}"/>
								</xsl:for-each>
							</concelho>
						</xsl:for-each-group>
					</distrito>
				</xsl:for-each-group>
			</q4>
		</questoes>
	</xsl:template>
</xsl:stylesheet>
