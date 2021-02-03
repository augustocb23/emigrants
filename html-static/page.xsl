<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:array="http://www.w3.org/2005/xpath-functions/array" xmlns:map="http://www.w3.org/2005/xpath-functions/map" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:err="http://www.w3.org/2005/xqt-errors" exclude-result-prefixes="array fn map math xhtml xs err" version="3.0">
	<xsl:output method="html" encoding="UTF-8" indent="yes"/>
	<!-- basic page structure -->
	<xsl:template match="page" name="xsl:initial-template">
		<head>
			<meta charset="utf-8"/>
			<title>Museu das Migrações e Comunidades</title>
			<link rel="stylesheet" href="styles.css"/>
		</head>
		<body>
			<header>
				<a href="index.html">Home</a>
				<span>Museu das Migrações e Comunidades</span>
			</header>
			<section>
				<div id="documentation-container" class="markdown-body">
					<h1>
						<xsl:value-of select="@title"/>
					</h1>
					<xsl:for-each select="*">
						<xsl:if test="name(.) = 'plaintext'">
							<p>
								<xsl:value-of select="text()"/>
							</p>
						</xsl:if>
						<xsl:if test="name(.) = 'caption'">
							<h2>
								<xsl:value-of select="text()"/>
							</h2>
						</xsl:if>
					</xsl:for-each>
					<xsl:if test="@id='home'">
						<h1>Menu</h1>
						<xsl:call-template name="links"/>
					</xsl:if>
				</div>
			</section>
			<footer>
				<xsl:call-template name="links"/>
			</footer>
		</body>
	</xsl:template>
	<xsl:template name="links">
		<ul>
			<li>
				<a href="emigrants.xml">Emigrantes</a>
			</li>
			<li>
				<a href="places.xml">Localidades</a>
			</li>
			<li>
				<a href="processes.xml">Processos</a>
			</li>
		</ul>
	</xsl:template>
</xsl:stylesheet>
