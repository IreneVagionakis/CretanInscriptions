<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Project-specific XSLT for transforming TEI to
       HTML. Customisations here override those in the core
       to-html.xsl (which should not be changed). -->

  <xsl:import href="../../kiln/stylesheets/tei/to-html.xsl" />
  
  <!-- general settings -->
  <xsl:template match="tei:body">
    <div id="creta-chapters" class="creta"><xsl:apply-templates/></div>
  </xsl:template>
  
  <xsl:template match="tei:div">
    <div><xsl:apply-templates /></div>
  </xsl:template>
  
  <xsl:template match="tei:p">
    <p><xsl:apply-templates /></p>
  </xsl:template>
  
  <xsl:template match="tei:div[@xml:id]">
    <div><xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute><xsl:apply-templates /></div>
  </xsl:template>
  
  <xsl:template match="tei:p[@xml:id]">
    <p><xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute><xsl:apply-templates /></p>
  </xsl:template>
  
  <xsl:template match="tei:foreign">
    <i><xsl:apply-templates/></i>
  </xsl:template>
  
  <xsl:template match="tei:hi[@rend='superscript']">
    <sup><xsl:apply-templates/></sup>
  </xsl:template>
  
  <xsl:template match="tei:head[@type='heading']">
    <h4><xsl:apply-templates /></h4>
  </xsl:template>
  
  <xsl:template match="tei:head[@type='subheading']">
    <h5><xsl:apply-templates /></h5>
  </xsl:template>
  
  <xsl:template match="tei:head[@type='subheading2']">
    <xsl:variable name="pleiades-id" select="child::tei:placeName[@n]/@n"/>
    <xsl:choose>
      <xsl:when test="$pleiades-id">
        <h6><a><xsl:attribute name="href"><xsl:value-of select="concat('https://pleiades.stoa.org/places/',$pleiades-id)"/></xsl:attribute><xsl:attribute name="target"><xsl:value-of select="'_blank'"/></xsl:attribute><xsl:apply-templates /></a></h6>
      </xsl:when>
      <xsl:otherwise><h6><xsl:apply-templates /></h6></xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="tei:p//tei:title">
    <xsl:choose>
      <xsl:when test="@xml:lang='grc'">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <i><xsl:apply-templates/></i>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- ref for mentions of bibliography, inscriptions, papyri, literary sources and links to Pleiades -->
  <xsl:template match="tei:div//tei:ref[@type='bibl']">
    <xsl:variable name="bib-id" select="substring-after(@target,'#')"/>
    <a><xsl:attribute name="href"><xsl:value-of select="concat('bibliografia.html#',$bib-id)"/></xsl:attribute><xsl:attribute name="target"><xsl:value-of select="'_blank'"/></xsl:attribute><xsl:apply-templates/></a>
  </xsl:template>

  <xsl:template match="tei:div//tei:ref[@type='pleiades']">
    <a><xsl:attribute name="href"><xsl:value-of select="concat('https://pleiades.stoa.org/places/',@target)"/></xsl:attribute><xsl:attribute name="target"><xsl:value-of select="'_blank'"/></xsl:attribute><xsl:apply-templates/></a>
  </xsl:template>
  
  <xsl:template match="tei:div//tei:ref[@type='ins'][@target]">
    <xsl:variable name="ins-id" select="substring-after(@target,'#')"/>
    <a><xsl:attribute name="href"><xsl:value-of select="concat('../inscriptions/',$ins-id,'.html')"/></xsl:attribute><xsl:attribute name="target"><xsl:value-of select="'_blank'"/></xsl:attribute><xsl:apply-templates/></a>
  </xsl:template>
  
  <xsl:template match="tei:div//tei:ref[@type='lit'][@target]">
    <a><xsl:attribute name="href"><xsl:value-of select="concat('fonti_letterarie.html',@target)"/></xsl:attribute><xsl:attribute name="target"><xsl:value-of select="'_blank'"/></xsl:attribute><xsl:apply-templates/></a>
  </xsl:template>
  
  <xsl:template match="tei:div//tei:ref[@type='pap' or @type='lit' or @type='ins'][not(@target)]">
      <xsl:apply-templates/>
    </xsl:template>
  
  <!-- links to institutions and places -->
  <xsl:template match="tei:div//tei:ref[@type='inst'][@target]">
    <a><xsl:attribute name="href"><xsl:value-of select="concat('istituzioni.html',@target)"/></xsl:attribute><xsl:attribute name="target"><xsl:value-of select="'_blank'"/></xsl:attribute><xsl:apply-templates/></a></xsl:template>
  
  <xsl:template match="tei:div//tei:ref[@type='place'][@target]">
    <a><xsl:attribute name="href"><xsl:value-of select="concat('realta_politiche.html',@target)"/></xsl:attribute><xsl:attribute name="target"><xsl:value-of select="'_blank'"/></xsl:attribute><xsl:apply-templates/></a></xsl:template>

  <!-- bibliographic items  -->
  <xsl:template match="tei:listBibl/tei:bibl[@xml:id]">
    <p><xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute><xsl:attribute name="class"><xsl:value-of select="'bibl'"/></xsl:attribute><xsl:apply-templates/></p>
  </xsl:template>
  
  <xsl:template match="tei:bibl[@xml:id]/tei:bibl[@type='ref']">
    <strong><xsl:apply-templates /></strong>:
  </xsl:template>
  <xsl:template match="tei:bibl[@xml:id]/tei:bibl[@type='full']">
    <xsl:apply-templates />.
  </xsl:template>
  
    <xsl:template match="tei:bibl//tei:title">
    <xsl:choose>
      <xsl:when test="@xml:lang='grc'">
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
      <i><xsl:apply-templates/></i>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- dynamic map -->
  <xsl:template match="tei:figure[@xml:id='map']">
    <div id="map" style="height:320px; margin-bottom:4em">
      <link href="https://cdn.rawgit.com/openlayers/openlayers.github.io/master/en/v5.3.0/css/ol.css" rel="stylesheet" type="text/css"/>
      <script src="https://cdn.rawgit.com/openlayers/openlayers.github.io/master/en/v5.3.0/build/ol.js"></script>
      <script type="text/javascript">
        var mapBoxBackground = new ol.Map({
        target: 'map',
        layers: [
        new ol.layer.Tile({
        source: new ol.source.XYZ({
        url: "http://pelagios.org/tilesets/imperium/{z}/{x}/{y}.png"
        })
        })
        ],
        sphericalMercator: true,
        wrapDateLine: true,
        transitionEffect: 'resize',
        buffer: 1,
        numZoomLevels: 13,
        view: new ol.View({
        center: ol.proj.fromLonLat([24.94, 35.25]),
        zoom: 8.64
        })
        });
      </script>
      <p style="text-align:center; font-size:12px; margin-top:1em">Tiles © <a href='http://mapbox.com/'>MapBox</a> 
        | Data © <a href='http://www.openstreetmap.org/'>OpenStreetMap</a> contributors, CC-BY-SA 
        | Tiles and Data © 2013 <a href='http://www.awmc.unc.edu'>AWMC</a> CC-BY-NC 3.0</p>
    </div>
  </xsl:template>
</xsl:stylesheet>
