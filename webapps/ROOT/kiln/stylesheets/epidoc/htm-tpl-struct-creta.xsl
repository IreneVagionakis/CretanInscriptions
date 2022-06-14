<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:t="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="t" 
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  version="2.0">
  <!-- Contains named templates for creta file structure (aka "metadata" aka "supporting data") -->  
  <!-- Called from htm-tpl-structure.xsl -->
  
  <xsl:template name="creta-title">
    <xsl:value-of select="//t:idno[@type='filename']"/>
  </xsl:template>
  
  <xsl:template name="creta-structure">
    <xsl:variable name="title">
      <xsl:call-template name="creta-title" />
    </xsl:variable>
    <html>
      <head>
        <title>
          <xsl:value-of select="$title"/>
        </title>
        <meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
        <xsl:call-template name="css-script"/> <!-- Found in htm-tpl-cssandscripts.xsl -->
      </head>
      <body>
        <h1><xsl:call-template name="creta-title" /></h1>
          <xsl:call-template name="creta-body-structure" />
      </body>
    </html>
  </xsl:template>
    
    <xsl:template name="creta-body-structure">
      <xsl:call-template name="creta-navigation"/>
      <div id="creta-inscription-body" class="creta">
        <div id="title" class="creta">
          <h1><xsl:if test="//t:idno[@type='projectNo']/text()"><xsl:value-of select="number(//t:idno[@type='projectNo'])"/>. </xsl:if><xsl:apply-templates select="//t:titleStmt/t:title"/></h1>
        </div>
        
        
        <div id="descriptive_lemma" class="creta">
            <p><b>Tipologia documentaria: </b> 
              <xsl:choose>
                  <xsl:when test="//t:msContents/t:summary">
                    <xsl:apply-templates select="//t:msContents/t:summary"/>
                  </xsl:when>
                  <xsl:otherwise>?</xsl:otherwise>
                </xsl:choose>
            </p>
          
          <p><b>Supporto: </b> 
            <xsl:choose>
              <xsl:when test="//t:support">
                <xsl:apply-templates select="//t:support"/>
              </xsl:when>
              <xsl:otherwise>?</xsl:otherwise>
            </xsl:choose>
          </p>
          
          <xsl:if test="//t:layoutDesc/t:layout//text()">
                <p><b>Disposizione del testo: </b> 
                  <xsl:value-of select="//t:layoutDesc/t:layout"/>
                </p>
              </xsl:if>
          
              <xsl:if test="//t:handDesc/t:handNote//text()">
                <p><b>Scrittura: </b>
                  <xsl:choose>
                    <xsl:when test="//t:handDesc/t:handNote/t:p/text()">
                      <xsl:value-of select="//t:handDesc/t:handNote/t:p"/><xsl:if test="//t:handDesc/t:handNote/t:height/text()">; h. <xsl:value-of select="//t:handDesc/t:handNote/t:height"/></xsl:if></xsl:when>
                    <xsl:otherwise>
                      <xsl:if test="//t:handDesc/t:handNote/t:height">h. <xsl:value-of select="//t:handDesc/t:handNote/t:height"/></xsl:if></xsl:otherwise>
                  </xsl:choose>
                </p>
              </xsl:if>
          
              <p><b>Datazione: </b> 
                <xsl:choose>
                  <xsl:when test="//t:origin/t:origDate/text()">
                    <xsl:value-of select="//t:origin/t:origDate"/>
                  </xsl:when>
                  <xsl:otherwise>?</xsl:otherwise>
                </xsl:choose>
              </p>
          
              <p><b>Provenienza: </b> 
                <xsl:choose>
                  <xsl:when test="//t:origin/t:origPlace"><xsl:apply-templates select="//t:origin/t:origPlace"/></xsl:when>
                  <xsl:otherwise>?</xsl:otherwise>
                </xsl:choose>
              </p>
          
              <xsl:if test="//t:provenance[@type='found']">
                <p><b>Luogo di ritrovamento: </b> 
                  <xsl:apply-templates select="//t:provenance[@type='found']"/>
                </p>
              </xsl:if>
          
              <p><b>Collocazione attuale: </b> 
                <xsl:choose>
                  <xsl:when test="//t:msIdentifier//t:repository">
                    <xsl:apply-templates select="//t:msIdentifier//t:repository"/>
                    <xsl:if test="//t:idno[@type='invNo'][string(translate(normalize-space(.),' ',''))]">
                      <xsl:text> (n. inv. </xsl:text>
                      <xsl:for-each select="//t:idno[@type='invNo'][string(translate(normalize-space(.),' ',''))]">
                        <xsl:value-of select="."/>
                        <xsl:if test="position()!=last()">
                          <xsl:text>, </xsl:text>
                        </xsl:if>
                      </xsl:for-each>
                      <xsl:text>)</xsl:text>
                    </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>?</xsl:otherwise>
                </xsl:choose>
              </p>
        </div>
        
        
            <div id="bibliography" class="creta">
              <xsl:apply-templates mode="creta" select="//t:div[@type='bibliography']/t:p"/>
            </div>
        
        
            <div id="edition" class="creta">
              <xsl:variable name="edtxt">
                <xsl:apply-templates select="//t:div[@type='edition']">
                  <xsl:with-param name="parm-edition-type" tunnel="yes"><xsl:text>interpretive</xsl:text></xsl:with-param>
                  <xsl:with-param name="parm-verse-lines" tunnel="yes"><xsl:text>off</xsl:text></xsl:with-param>
                  <xsl:with-param name="parm-line-inc" tunnel="yes"><xsl:text>5</xsl:text></xsl:with-param>
                </xsl:apply-templates>
              </xsl:variable>
              <!-- Moded templates found in htm-tpl-sqbrackets.xsl -->
              <xsl:apply-templates select="$edtxt" mode="sqbrackets"/>
            </div>
        
        
        <xsl:if test="//t:div[@type='apparatus']">
              <div id="apparatus" class="creta">
              <xsl:variable name="apptxt">
                <xsl:apply-templates select="//t:div[@type='apparatus']//t:p"/>
              </xsl:variable>
              <xsl:apply-templates select="$apptxt" mode="sqbrackets"/>
            </div>
            </xsl:if>
        
        
        <xsl:if test="//t:div[@type='translation']">
          <div id="translation" class="creta">
            <xsl:variable name="transtxt">
              <xsl:apply-templates select="//t:div[@type='translation']//t:p"/>
            </xsl:variable>
            <xsl:apply-templates select="$transtxt" mode="sqbrackets"/>
          </div>
        </xsl:if>
        
        
            <div id="commentary" class="creta">
              <xsl:variable name="commtxt">
                <xsl:apply-templates mode="creta" select="//t:div[@type='commentary']//t:p"/>
              </xsl:variable>
              <!-- Moded templates found in htm-tpl-sqbrackets.xsl -->
              <xsl:apply-templates select="$commtxt" mode="sqbrackets"/>
          </div>
      </div>
    </xsl:template> 
  
  
  
  <!-- MODED TEMPLATES, APPLIED IN BIBLIOGRAPHY AND COMMENTARY -->
  <!-- external links  -->
  <xsl:template mode="creta" match="t:bibl/t:ptr[@target][@type]">➚
    <xsl:choose>
      <xsl:when test="@type='phi'"><a target="_blank" href="http://epigraphy.packhum.org/text/{@target}">PHI</a></xsl:when>
      <xsl:when test="@type='aio'"><a target="_blank" href="https://www.atticinscriptions.com/inscription/{@target}">AIO</a></xsl:when>
      <xsl:when test="@type='seg'"><a target="_blank" href="http://dx.doi.org/10.1163/1874-6772_seg_{@target}">SEG</a></xsl:when>
      <xsl:when test="@type='cgrn'"><a target="_blank" href="http://cgrn.ulg.ac.be/file/{@target}">CGRN</a></xsl:when>
      <xsl:when test="@type='thetima'"><a target="_blank" href="http://ancdialects.greek-language.gr/inscriptions/{@target}">ΘΕΤΙΜΑ</a></xsl:when>
      <xsl:when test="@type='axon'"><a target="_blank" href="https://mizar.unive.it/axon/public/axon/anteprima/anteprima/idSchede/{@target}">Axon</a></xsl:when>
      <xsl:when test="@type='poinikastas'"><a target="_blank" href="http://poinikastas.csad.ox.ac.uk/search-browse.shtml{@target}">Poinikastas</a></xsl:when>
      <xsl:when test="@type='ela'"><a target="_blank" href="http://www.epigraphiclandscape.unito.it/index.php/browse/{@target}">ELA</a></xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <!-- internal links -->
  <xsl:template mode="creta" match="t:ref[@target]">
    <xsl:choose>
      <xsl:when test="@type='ins'"><a target="_blank" href="./{substring-after(@target,'#')}.html"><xsl:apply-templates mode="creta"/></a></xsl:when>
      <xsl:when test="@type='lit'"><a target="_blank" href="../texts/fonti_letterarie.html{@target}"><xsl:apply-templates mode="creta"/></a></xsl:when>
      <xsl:when test="@type='inst'"><a target="_blank" href="../texts/istituzioni.html{@target}"><xsl:apply-templates mode="creta"/></a></xsl:when>
      <xsl:when test="ancestor::t:bibl"><a target="_blank" href="../texts/bibliografia.html{@target}" class="link"><xsl:apply-templates mode="creta"/></a></xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- bold chosen edition, emph, apices, p  -->
  <xsl:template mode="creta" match="t:bibl[@type='main_edition']|t:emph"><strong><xsl:apply-templates mode="creta"/></strong></xsl:template>
  <xsl:template mode="creta" match="t:hi[@rend='superscript']"><sup><xsl:apply-templates/></sup></xsl:template>
  <xsl:template mode="creta" match="t:p"><p><xsl:apply-templates mode="creta"/></p></xsl:template>
  
  
  
  
  <!-- ARROWS POINTING TO PREVIOUS/NEXT INSCRIPTION -->
  <xsl:template name="creta-navigation">
    <xsl:if test="doc-available(concat('file:',system-property('user.dir'),'/all_inscriptions.xml')) = fn:true()">
    <xsl:variable name="filename"><xsl:value-of select="//t:idno[@type='projectNo']"/></xsl:variable>
    <xsl:variable name="list" select="document(concat('file:',system-property('user.dir'),'/all_inscriptions.xml'))//t:list"/>
    <xsl:variable name="prev" select="$list/t:item[@sortKey=$filename]/preceding-sibling::t:item[1]/@n"/>
    <xsl:variable name="next" select="$list/t:item[@sortKey=$filename]/following-sibling::t:item[1]/@n"/>
    
    <div class="row">
      <div class="large-12 columns">
        <ul class="pagination left">
          <xsl:if test="$prev">
            <li class="arrow">
              <a href="./{$prev}.html"><xsl:text>&#171;</xsl:text></a>
            </li>
          </xsl:if>
          
          <xsl:if test="$next">
            <li class="arrow">
              <a href="./{$next}.html"><xsl:text>&#187;</xsl:text></a>
            </li>
          </xsl:if>
        </ul>
      </div>
    </div>
    </xsl:if>
  </xsl:template>
  
</xsl:stylesheet>