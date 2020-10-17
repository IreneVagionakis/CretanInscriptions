<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- This XSLT transforms a set of EpiDoc documents into a Solr
       index document representing an index of symbols in those
       documents. -->

  <xsl:import href="epidoc-index-utils.xsl" />

  <xsl:param name="index_type" />
  <xsl:param name="subdirectory" />
  <xsl:variable name="language" select="'it'"/><!-- it should select the current language -->

  <xsl:template match="/">
    <add>
      <xsl:for-each-group select="//tei:placeName[@ref][ancestor::tei:div/@type='edition']" group-by="concat(@ref,'-',@type)">
        <doc>
          <field name="document_type">
            <xsl:value-of select="$subdirectory" />
            <xsl:text>_</xsl:text>
            <xsl:value-of select="$index_type" />
            <xsl:text>_index</xsl:text>
          </field>
          <xsl:call-template name="field_file_path" />
          <field name="index_item_name">
            <xsl:variable name="pl-id" select="substring-after(@ref,'#')"/><xsl:value-of select="document('../../content/xml/authority/pl.xml')//tei:place[@xml:id=$pl-id]/tei:placeName[@xml:lang=$language]" />
          </field>
          <field name="index_ethnic">
            <xsl:choose>
              <xsl:when test="@type='ethnic'"><xsl:text>Etnico</xsl:text></xsl:when>
              <xsl:otherwise><xsl:text>Toponimo</xsl:text></xsl:otherwise>
            </xsl:choose>
          </field>
          <xsl:apply-templates select="current-group()" />
        </doc>
      </xsl:for-each-group>
    </add>
  </xsl:template>

  <xsl:template match="tei:placeName">
    <xsl:call-template name="field_index_instance_location" />
  </xsl:template>

</xsl:stylesheet>
