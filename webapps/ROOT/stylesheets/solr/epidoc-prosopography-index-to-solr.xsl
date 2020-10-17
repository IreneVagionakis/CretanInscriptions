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
      <xsl:for-each-group select="//tei:persName[@type!='divine'][ancestor::tei:div/@type='edition']" group-by="concat(@key,'-',@type,'-',descendant::tei:placeName[1]/@ref, ancestor::tei:rs[1]/@ref or @ref)">
        <doc>
          <field name="document_type">
            <xsl:value-of select="$subdirectory" />
            <xsl:text>_</xsl:text>
            <xsl:value-of select="$index_type" />
            <xsl:text>_index</xsl:text>
          </field>
          <xsl:call-template name="field_file_path" />
          <field name="index_item_name">
            <xsl:value-of select="@key" />
          </field>
          <field name="index_related_place">
            <xsl:choose>
              <xsl:when test="descendant::tei:placeName">
                <xsl:variable name="pl-id" select="substring-after(descendant::tei:placeName[1]/@ref,'#')"/>
                <xsl:value-of select="document('../../content/xml/authority/pl.xml')//tei:place[@xml:id=$pl-id]/tei:placeName[@xml:lang='it']" />
              </xsl:when>
              <xsl:when test="ancestor::tei:rs and not(descendant::tei:placeName)">
                <xsl:variable name="pl-id" select="substring-after(ancestor::tei:rs[1]/@ref,'#')"/>
                 <xsl:value-of select="document('../../content/xml/authority/pl.xml')//tei:place[@xml:id=$pl-id]/tei:placeName[@xml:lang='it']" />
              </xsl:when>
              <xsl:when test="@ref, not(ancestor::tei:rs) and not(descendant::tei:placeName)">
                <xsl:variable name="pl-id" select="substring-after(@ref,'#')"/>
                <xsl:value-of select="document('../../content/xml/authority/pl.xml')//tei:place[@xml:id=$pl-id]/tei:placeName[@xml:lang='it']" />
              </xsl:when>
              <xsl:otherwise><xsl:text>-</xsl:text></xsl:otherwise>
            </xsl:choose>
          </field>
          <field name="index_person_type">
            <xsl:choose>
              <xsl:when test="@type='attested'"><xsl:text>Magistrato o funzionario</xsl:text></xsl:when>
              <xsl:when test="@type='ruler'"><xsl:text>Regnante</xsl:text></xsl:when>
              <xsl:when test="@type='honoured'"><xsl:text>Individuo onorato</xsl:text></xsl:when>
              <xsl:otherwise><xsl:text>Altro</xsl:text></xsl:otherwise>
            </xsl:choose>
          </field>
          <xsl:apply-templates select="current-group()" />
        </doc>
      </xsl:for-each-group>
    </add>
  </xsl:template>

  <xsl:template match="tei:persName">
    <xsl:call-template name="field_index_instance_location" />
  </xsl:template>

</xsl:stylesheet>
