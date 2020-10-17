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

  <xsl:template match="/">
    <add>
      <xsl:for-each-group select="//tei:name[@nymRef][ancestor::tei:persName]" group-by="concat(@nymRef,'-',@type)">
        <doc>
          <field name="document_type">
            <xsl:value-of select="$subdirectory" />
            <xsl:text>_</xsl:text>
            <xsl:value-of select="$index_type" />
            <xsl:text>_index</xsl:text>
          </field>
          <xsl:call-template name="field_file_path" />
          <field name="index_item_name">
            <xsl:value-of select="@nymRef" />
          </field>
          <field name="index_patronymic">
            <xsl:choose>
              <xsl:when test="@type='patronymic'"><xsl:text>Patronimico</xsl:text></xsl:when>
              <xsl:when test="@type='matronymic'"><xsl:text>Matronimico</xsl:text></xsl:when>
              <xsl:when test="@type='andronym'"><xsl:text>Andronimo</xsl:text></xsl:when>
              <xsl:otherwise><xsl:text>Nome</xsl:text></xsl:otherwise>
            </xsl:choose>
          </field>
          <xsl:apply-templates select="current-group()" />
        </doc>
      </xsl:for-each-group>
    </add>
  </xsl:template>

  <xsl:template match="tei:name">
    <xsl:call-template name="field_index_instance_location" />
  </xsl:template>

</xsl:stylesheet>
