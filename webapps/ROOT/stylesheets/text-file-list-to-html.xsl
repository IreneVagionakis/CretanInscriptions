<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="response" mode="text-index">
    <table class="tablesorter">
      <thead>
        <tr>
          <th style="width:4em;">ID</th>
          <xsl:if test="result/doc/str[@name='file_name']">
            <th>Iscrizione</th>
          </xsl:if>
          <th>Titolo</th>
        </tr>
      </thead>
      <tbody>
        <xsl:apply-templates mode="text-index" select="result/doc" >
          <xsl:sort select="str[@name='project_no']"/>
        </xsl:apply-templates>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="result/doc" mode="text-index">
    <tr>
      <xsl:apply-templates mode="text-index" select="str[@name='file_path']" />
      <xsl:apply-templates mode="text-index" select="str[@name='file_name']" />
      <xsl:apply-templates mode="text-index" select="arr[@name='document_title']" />
    </tr>
  </xsl:template>

  <xsl:template match="str[@name='file_path']" mode="text-index">
    <xsl:variable name="filename" select="substring-after(., '/')" />
    <xsl:variable name="project_no" select="../str[@name='project_no']" />
    <td>
      <a href="{kiln:url-for-match($match_id, ($language, $filename), 0)}">
        <xsl:value-of select="number($project_no)" />
      </a>
    </td>
  </xsl:template>

  <xsl:template match="str[@name='file_name']" mode="text-index">
    <td><xsl:value-of select="." /></td>
  </xsl:template>
  
  <xsl:template match="arr[@name='document_title']" mode="text-index">
    <td><xsl:value-of select="string-join(str, '; ')" /></td>
  </xsl:template>

</xsl:stylesheet>
