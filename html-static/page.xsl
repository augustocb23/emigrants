<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:array="http://www.w3.org/2005/xpath-functions/array" xmlns:map="http://www.w3.org/2005/xpath-functions/map" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:err="http://www.w3.org/2005/xqt-errors" exclude-result-prefixes="array fn map math xhtml xs err" version="3.0">
	<xsl:output method="html" encoding="UTF-8" indent="yes"/>
	<xsl:template match="page" name="xsl:initial-template">
		<head>
			<meta charset="utf-8"/>
			<title>Museu das Migrações e Comunidades</title>
			<link rel="stylesheet" href="styles.css"/>
		</head>
		<body>
			<header>
				<a href="home.xml">Home</a>
				<span>Museu das Migrações e Comunidades</span>
			</header>
			<section>
				<div id="container" class="markdown-body">
					<h1>
						<xsl:value-of select="@title"/>
					</h1>
					<xsl:apply-templates />
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
		</ul>
	</xsl:template>
	<!-- matches -->
	<xsl:template match="longtext">
		<p>
			<xsl:value-of select="text()"/>
		</p>
	</xsl:template>
	<xsl:template match="plaintext">
		<xsl:value-of select="text()"/>
	</xsl:template>
	<xsl:template match="link">
		<a href="{@href}">
			<xsl:value-of select="text()"/>
		</a>
	</xsl:template>
	<xsl:template match="caption">
		<h2>
			<xsl:value-of select="text()"/>
		</h2>
	</xsl:template>
	<xsl:template match="list">
		<ul>
			<xsl:for-each select="item">
				<xsl:sort select="*/text()"/>
				<li>
					<xsl:apply-templates/>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
</xsl:stylesheet>
