<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../../kiln/stylesheets/solr/tei-to-solr.xsl" />

  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Oct 18, 2010</xd:p>
      <xd:p><xd:b>Author:</xd:b> jvieira</xd:p>
      <xd:p>This stylesheet converts a TEI document into a Solr index document. It expects the parameter file-path,
      which is the path of the file being indexed.</xd:p>
    </xd:desc>
  </xd:doc>
  
  <xsl:variable name="language" select="'it'"/><!-- it should select the current language -->

  <xsl:template match="/">
    <add>
      <xsl:apply-imports />
    </add>
  </xsl:template>
  
  <xsl:template match="tei:summary/@corresp" mode="facet_inscription_type">
    <xsl:variable name="doc-id" select="tokenize(replace(.,'#',''),' ')"/>
    <xsl:variable name="doc1-id" select="document('../../content/xml/authority/doc.xml')//tei:item[@xml:id=$doc-id[1]]/tei:term[@xml:lang=$language]"/>
    <xsl:variable name="doc2-id" select="document('../../content/xml/authority/doc.xml')//tei:item[@xml:id=$doc-id[2]]/tei:term[@xml:lang=$language]"/>
    <xsl:if test="$doc1-id"><field name="inscription_type"><xsl:value-of select="$doc1-id" /></field></xsl:if>
    <xsl:if test="$doc2-id"><field name="inscription_type"><xsl:value-of select="$doc2-id" /></field></xsl:if>
  </xsl:template>

  <xsl:template match="tei:rs[@type='institution'][@key]" mode="facet_mentioned_institutions">
    <field name="mentioned_institutions">
      <xsl:variable name="key-id" select="@key"/>
      <xsl:value-of select="document('../../content/xml/authority/ins.xml')//tei:item[@xml:id=$key-id]/tei:term[@xml:lang=$language]"/>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:rs[@type='institution'][@key]" mode="facet_type_of_mentioned_institutions">
    <field name="type_of_mentioned_institutions">
      <xsl:variable name="subtype-id" select="@subtype"/>
      <xsl:value-of select="document('../../content/xml/authority/ins.xml')//tei:item[@xml:id=$subtype-id]/tei:term[@xml:lang=$language]"/>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:rs[@type='institution'][@key]" mode="facet_sphere_or_role_of_mentioned_institutions">
    <field name="sphere_or_role_of_mentioned_institutions">
      <xsl:variable name="role-id" select="@role"/>
      <xsl:value-of select="document('../../content/xml/authority/ins.xml')//tei:item[@xml:id=$role-id]/tei:term[@xml:lang=$language]"/>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:origDate[@period]" mode="facet_period">
    <field name="period">
      <xsl:variable name="per-id" select="substring-after(@period,'#')"/>
      <xsl:value-of select="document('../../content/xml/authority/per.xml')//tei:item[@xml:id=$per-id]/tei:term[@xml:lang=$language]"/>
    </field>
  </xsl:template>
  
  <!-- to show only bibl with type="main_edition" or type="indexed_edition" among facet items-->
  <xsl:template match="tei:bibl[@type]/tei:ref[@target]" mode="facet_bibliographic_reference">
    <field name="bibliographic_reference">
      <xsl:value-of select="."/>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:persName[@type='divine']" mode="facet_mentioned_divinities">
    <field name="mentioned_divinities">
      <xsl:value-of select="@key"/>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:persName/tei:name[@nymRef]" mode="facet_person_name">
    <field name="person_name">
      <xsl:value-of select="@nymRef"/>
    </field>
  </xsl:template>
  
  <xsl:template match="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='filename']" mode="facet_file_name">
    <field name="file_name">
      <xsl:value-of select="."/>
    </field>
  </xsl:template>
  
  <xsl:template match="//tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:history/tei:origin/tei:origPlace[@ref]" mode="facet_area">
    <field name="area">
      <xsl:variable name="pl-id" select="substring-after(@ref,'#')"/>
      <xsl:value-of select="document('../../content/xml/authority/pl.xml')//tei:place[@xml:id=$pl-id]/tei:place/tei:region"/>
    </field>
  </xsl:template>
  
  <!-- This template is called by the Kiln tei-to-solr.xsl as part of
       the main doc for the indexed file. Put any code to generate
       additional Solr field data (such as new facets) here. -->
  
  <xsl:template name="extra_fields">
    <xsl:call-template name="field_inscription_type"/>
    <xsl:call-template name="field_mentioned_institutions"/>
    <xsl:call-template name="field_type_of_mentioned_institutions"/>
    <xsl:call-template name="field_sphere_or_role_of_mentioned_institutions"/>
    <xsl:call-template name="field_period"/>
    <xsl:call-template name="field_bibliographic_reference"/>
    <xsl:call-template name="field_mentioned_divinities"/>
    <xsl:call-template name="field_person_name"/>
    <xsl:call-template name="field_file_name"/>
    <xsl:call-template name="field_area"/>
  </xsl:template>
  
  <xsl:template name="field_inscription_type">
    <xsl:apply-templates mode="facet_inscription_type" select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:msContents/tei:summary/@corresp"/>
  </xsl:template>
  
  <xsl:template name="field_mentioned_institutions">
    <xsl:apply-templates mode="facet_mentioned_institutions" select="//tei:text/tei:body/tei:div[@type='edition']"/>
  </xsl:template>
  
  <xsl:template name="field_type_of_mentioned_institutions">
    <xsl:apply-templates mode="facet_type_of_mentioned_institutions" select="//tei:text/tei:body/tei:div[@type='edition']"/>
  </xsl:template>
  
  <xsl:template name="field_sphere_or_role_of_mentioned_institutions">
    <xsl:apply-templates mode="facet_sphere_or_role_of_mentioned_institutions" select="//tei:text/tei:body/tei:div[@type='edition']"/>
  </xsl:template>
  
  <xsl:template name="field_period">
    <xsl:apply-templates mode="facet_period" select="//tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:history/tei:origin"/>
  </xsl:template>
  
  <xsl:template name="field_bibliographic_reference">
    <xsl:apply-templates mode="facet_bibliographic_reference" select="//tei:text/tei:body/tei:div[@type='bibliography']/tei:p/tei:bibl"/>
  </xsl:template>

  <xsl:template name="field_mentioned_divinities">
    <xsl:apply-templates mode="facet_mentioned_divinities" select="//tei:text/tei:body/tei:div[@type='edition']" />
  </xsl:template>
  
  <xsl:template name="field_person_name">
    <xsl:apply-templates mode="facet_person_name" select="//tei:text/tei:body/tei:div[@type='edition']" />
  </xsl:template>
  
  <xsl:template name="field_file_name">
    <xsl:apply-templates mode="facet_file_name" select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='filename']"/>
  </xsl:template>
  
  <xsl:template name="field_area">
    <xsl:apply-templates mode="facet_area" select="//tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:history/tei:origin/tei:origPlace[@ref]" />
  </xsl:template>
</xsl:stylesheet>