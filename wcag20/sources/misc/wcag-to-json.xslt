<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs"
	version="2.0">
	
	<!--<xsl:import href="../xmlspec-wcag.xsl"/>-->
	<xsl:param name="understanding.file">../guide-to-wcag2-src.xml</xsl:param>
	<xsl:param name="techniques.file">../wcag20-merged-techs.xml</xsl:param>
	
	<xsl:param name="understanding.doc" select="document($understanding.file)"/>
	<xsl:param name="techniques.doc" select="document($techniques.file)"/>
	
	<xsl:output method="text"/>
	
	<xsl:template match="/">
		<xsl:text>{</xsl:text>
		<xsl:text>"principles": [</xsl:text>
		<xsl:apply-templates select="//div2[@role='principle']"></xsl:apply-templates>
		<xsl:text>]</xsl:text>
		<xsl:text>}</xsl:text>
	</xsl:template>
	
	<xsl:template match="div2[@role='principle']">
		<xsl:text>{</xsl:text>
		<xsl:text>"id": "WCAG2:</xsl:text><xsl:value-of select="@id"/><xsl:text>",</xsl:text>
		<xsl:text>"num": "</xsl:text><xsl:number/><xsl:text>",</xsl:text>
		<xsl:text>"handle": "@@",</xsl:text><!-- not separately selected in the XML--><!-- requested format was title -->
		<xsl:text>"title": "</xsl:text><xsl:value-of select="normalize-space(head)"/><xsl:text>",</xsl:text><!-- full text of the principle, not in the requested format -->

		<xsl:text>"guidelines": [</xsl:text>
		<xsl:apply-templates select="div3[@role='group1']"></xsl:apply-templates>
		<xsl:text>]</xsl:text>

		<xsl:text>}</xsl:text>
		<xsl:if test="position() != last()">,</xsl:if>
	</xsl:template>
	
	<xsl:template match="div3[@role='group1']">
		<xsl:text>{</xsl:text>
		<xsl:text>"id": "WCAG2:</xsl:text><xsl:value-of select="@id"/><xsl:text>",</xsl:text>
		<xsl:text>"num": "</xsl:text><xsl:number level="multiple" count="div2[@role='principle'] | div3" format="1.1"/><xsl:text>",</xsl:text>
		<xsl:text>"handle": "@@",</xsl:text><!-- not in the XML --><!-- requested format was title -->
		<xsl:text>"title": "</xsl:text><xsl:value-of select="normalize-space(head)"/><xsl:text>",</xsl:text><!-- requested format was intro -->

		<xsl:text>"techniques": {</xsl:text>
		<xsl:apply-templates select="$understanding.doc//*[@id = current()/@id]//*[@role = 'gladvisory']"></xsl:apply-templates>
		<xsl:text>},</xsl:text>

		<xsl:text>"successcriteria": [</xsl:text>
		<xsl:apply-templates select="div4/div5[@role = 'sc']"></xsl:apply-templates>
		<xsl:text>]</xsl:text>

		<xsl:text>}</xsl:text><xsl:if test="position() != last()">,</xsl:if>
	</xsl:template>
	
	<xsl:template match="div5[@role = 'sc']">
		<xsl:text>{</xsl:text>
		<xsl:text>"id": "WCAG2:</xsl:text><xsl:value-of select="@id"/><xsl:text>",</xsl:text>
		<xsl:text>"num": "</xsl:text><xsl:number level="multiple" count="div2[@role='principle'] | div3 | div5" format="1.1.1"/><xsl:text>",</xsl:text>
		<xsl:text>"handle": "</xsl:text><xsl:value-of select="normalize-space(head)"/><xsl:text>",</xsl:text><!-- requested format was title -->
		<xsl:text>"text": "</xsl:text><xsl:value-of select="normalize-space(p)"/><xsl:text>"</xsl:text>
		<xsl:if test="p/following-sibling::*">
			<xsl:text>, "details": [</xsl:text>
			<xsl:apply-templates select="p/following-sibling::*" mode="sc-details"/>
			<xsl:text>]</xsl:text>
		</xsl:if>
		<xsl:text>}&#10;</xsl:text>
		<xsl:if test="position() != last()">,</xsl:if>
	</xsl:template>
	
	<xsl:template match="ulist" mode="sc-details">
		<xsl:text>{</xsl:text>
		<xsl:text>"type": "ulist",</xsl:text>
		<xsl:text>"items": [</xsl:text>
		<xsl:apply-templates select="item" mode="sc-details"/>
		<xsl:text>]</xsl:text>
		<xsl:text>}</xsl:text>
		<xsl:if test="position() != last()">,</xsl:if>
	</xsl:template>
	
	<xsl:template match="item" mode="sc-details">
		<xsl:variable name="text"><xsl:apply-templates select="p" mode="sc-text"/></xsl:variable>
		<xsl:text>{</xsl:text>
		<xsl:text>"handle": "</xsl:text><xsl:value-of select="normalize-space(p/emph[@role = 'sc-handle'])"/><xsl:text>",</xsl:text><!-- requested format was title -->
		<xsl:text>"text": "</xsl:text><xsl:value-of select="normalize-space($text)"/><xsl:text>"</xsl:text>
		<xsl:text>}</xsl:text>
		<xsl:if test="position() != last()">,</xsl:if>
	</xsl:template>
	
	<xsl:template match="p" mode="sc-details">
		<xsl:text>{</xsl:text>
		<xsl:text>"type": "p",</xsl:text>
		<xsl:text>"text": "</xsl:text><xsl:value-of select="normalize-space(.)"/><xsl:text>"</xsl:text>
		<xsl:text>}</xsl:text>
		<xsl:if test="position() != last()">,</xsl:if>
	</xsl:template>
	
	<xsl:template match="note" mode="sc-details">
		<xsl:text>{</xsl:text>
		<xsl:text>"type": "note",</xsl:text>
		<xsl:text>"text": "</xsl:text><xsl:value-of select="normalize-space(.)"/><xsl:text>"</xsl:text>
		<xsl:text>}</xsl:text>
		<xsl:if test="position() != last()">,</xsl:if>
	</xsl:template>
	
	<xsl:template match="p" mode="sc-text">
		<xsl:apply-templates mode="sc-text"/>
	</xsl:template>
	
	<xsl:template match="emph[@role = 'sc-handle']" mode="sc-text"/>
	
	<xsl:template match="div2[@role = 'gladvisory'] | div4[@role = 'sufficient'] | div4[@role = 'advisory']">
		<xsl:if test="olist or ulist or div5">
			<xsl:text>"</xsl:text>
			<xsl:choose>
				<xsl:when test="@role = 'sufficient'">sufficient</xsl:when>
				<xsl:otherwise>advisory</xsl:otherwise>
			</xsl:choose>
			<xsl:text>": [</xsl:text>
			<xsl:apply-templates select="ulist/item" mode="technique"/>
			<xsl:apply-templates select="div5[@role = 'situation']" mode="situation"/>
			<xsl:text>]</xsl:text>
			<xsl:if test="position() != last()">,</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="div5[@role = 'situation']" mode="situation">
		
	</xsl:template>
	
	<xsl:template match="div2/ulist | div4/ulist | div5/ulist"></xsl:template>
	
	<xsl:template match="item[p/loc]" mode="technique">
		<xsl:text>"id": "TECH:</xsl:text>
		<xsl:value-of select="loc/@id"/>
		<xsl:text>"</xsl:text>
		<xsl:if test="position() != last()">,</xsl:if>
	</xsl:template>
	
	<xsl:template match="item[not(p/loc)]" mode="technique">
		<xsl:text>{</xsl:text>
		<xsl:text>"id": "TECH:future</xsl:text><xsl:number/><xsl:text>",</xsl:text>
		<xsl:text>"text": "</xsl:text><xsl:value-of select="normalize-space(.)"/><xsl:text>"</xsl:text><!-- maybe this should be title to match the others -->
		<xsl:text>}</xsl:text>
		<xsl:if test="position() != last()">,</xsl:if>
	</xsl:template>
	
	<xsl:template match="*[use-id]" mode="#all">
		<xsl:apply-templates select="id(@use-id)" mode="#current"/>
	</xsl:template>
</xsl:stylesheet>