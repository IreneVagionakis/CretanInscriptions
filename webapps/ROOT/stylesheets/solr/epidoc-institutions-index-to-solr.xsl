<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- This XSLT transforms a set of EpiDoc documents into a Solr
       index document representing an index of institutions in those
       documents. -->

  <xsl:import href="epidoc-index-utils.xsl" />

  <xsl:param name="index_type" />
  <xsl:param name="subdirectory" />
  <xsl:variable name="language" select="'it'"/><!-- it should select the current language -->

  <xsl:template match="/">
    <add>
      <xsl:for-each-group select="//tei:rs[@type='institution']" group-by="concat(@key,'-',./tei:persName[@type='attested']/@key,'-',@subtype,'-',@role,'-',@ref,'-',ancestor::tei:TEI//tei:origDate)"> <!--.//tei:w[@lemma]/@lemma,'-',-->
        <doc>
          <field name="document_type">
            <xsl:value-of select="$subdirectory" />
            <xsl:text>_</xsl:text>
            <xsl:value-of select="$index_type" />
            <xsl:text>_index</xsl:text>
          </field>
          <xsl:call-template name="field_file_path" />
          <field name="index_item_name">
            <xsl:variable name="key-id" select="@key"/>
            <xsl:value-of select="document('../../content/xml/authority/ins.xml')//tei:item[@xml:id=$key-id]/tei:term[@xml:lang=$language]" />
          </field>
          <field name="index_attested_form">
            <xsl:value-of select=".//tei:w[1]/@lemma" />
          </field>
          <field name="index_greek_pers_name">
            <xsl:value-of select="./tei:persName[@type='attested']/@key" />
          </field>
          <!--<field name="index_real_attested_form">
            <xsl:value-of select="." />
          </field>-->
          <field name="index_institution_subtype">
            <xsl:variable name="subtype-id" select="@subtype"/>
            <xsl:value-of select="document('../../content/xml/authority/ins.xml')//tei:item[@xml:id=$subtype-id]/tei:term[@xml:lang=$language]" />
          </field>
          <field name="index_institution_role">
            <xsl:variable name="role-id" select="@role"/>
            <xsl:value-of select="document('../../content/xml/authority/ins.xml')//tei:item[@xml:id=$role-id]/tei:term[@xml:lang=$language]" />
          </field>
          <!--<field name="index_epigraphic_context">
            <xsl:value-of select="ancestor::tei:TEI//tei:summary" />
          </field>-->
          <field name="index_related_place">
            <xsl:variable name="pl-id" select="substring-after(@ref,'#')"/>
            <xsl:value-of select="document('../../content/xml/authority/pl.xml')//tei:place[@xml:id=$pl-id]/tei:placeName[@xml:lang=$language]" />
          </field>
          <field name="index_related_period">
            <xsl:variable name="per-id" select="substring-after(ancestor::tei:TEI//tei:origDate/@period,'#')"/>
            <xsl:value-of select="document('../../content/xml/authority/per.xml')//tei:item[@xml:id=$per-id]/tei:abbr" />
          </field>
          <xsl:apply-templates select="current-group()" />
        </doc>
      </xsl:for-each-group>
    </add>
  </xsl:template>

  <xsl:template match="tei:rs">
    <xsl:call-template name="field_index_instance_location" />
  </xsl:template>

</xsl:stylesheet>