<?xml version="1.0"?>
<!--
  Copyright 2002-2004 The Apache Software Foundation

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->
<!--
site2xhtml.xsl is the final stage in HTML page production.  It merges HTML from
document2html.xsl, tab2menu.xsl and book2menu.xsl, and adds the site header,
footer, searchbar, css etc.  As input, it takes XML of the form:

<site>
  <div class="menu">
    ...
  </div>
  <div class="tab">
    ...
  </div>
  <div class="content">
    ...
  </div>
</site>

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:variable name="config" select="//skinconfig"/>
  <!-- If true, a PDF link for this page will not be generated -->
  <xsl:variable name="disable-pdf-link" select="//skinconfig/disable-pdf-link"/>
  <!-- If true, a "print" link for this page will not be generated -->
  <xsl:variable name="disable-print-link" select="//skinconfig/disable-print-link"/>
  <!-- If true, an XML link for this page will not be generated -->
  <xsl:variable name="disable-xml-link" select="//skinconfig/disable-xml-link"/>
  <!-- If true, a POD link for this page will not be generated -->
  <xsl:variable name="disable-pod-link" select="//skinconfig/disable-pod-link"/>
  <!-- Get the location where to generate the minitoc -->
  <xsl:variable name="minitoc-location" select="//skinconfig/toc/@location"/>

  <xsl:param name="path"/>

  <xsl:include href="dotdots.xsl"/>
  <xsl:include href="pathutils.xsl"/>
  <xsl:include href="renderlogo.xsl"/>

  <!-- Path (..'s) to the root directory -->
  <xsl:variable name="root">
    <xsl:call-template name="dotdots">
      <xsl:with-param name="path" select="$path"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- Source filename (eg 'foo.xml') of current page -->
  <xsl:variable name="filename">
    <xsl:call-template name="filename">
      <xsl:with-param name="path" select="$path"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- Path of Lucene search results page (relative to $root) -->
  <xsl:param name="lucene-search" select="'lucene-search.html'"/>

  <xsl:variable name="filename-noext">
    <xsl:call-template name="filename-noext">
      <xsl:with-param name="path" select="$path"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- Whether to obfuscate email links -->
  <xsl:variable name="obfuscate-mail-links" select="//skinconfig/obfuscate-mail-links"/>
 <!-- If true, the font size script will not be rendered -->  
  <xsl:variable name="disable-font-script" select="//skinconfig/disable-font-script"/>
  <!-- If true, an the images on all external links will not be added -->
  <xsl:variable name="disable-external-link-image" select="//skinconfig/disable-external-link-image"/>  
  <xsl:variable name="skin-img-dir" select="concat(string($root), 'skin/images')"/>
  <xsl:variable name="spacer" select="concat($root, 'skin/images/spacer.gif')"/>

  <xsl:template name="breadcrumbs">
    <xsl:if test="(//skinconfig/trail/link1/@name)and(//skinconfig/trail/link1/@name!='')"><a href="{//skinconfig/trail/link1/@href}"><xsl:value-of select="//skinconfig/trail/link1/@name"/></a></xsl:if>
    <xsl:if test="(//skinconfig/trail/link2/@name)and(//skinconfig/trail/link2/@name!='')"> &gt; <a href="{//skinconfig/trail/link2/@href}">  <xsl:value-of select="//skinconfig/trail/link2/@name"/></a> </xsl:if>
    <xsl:if test="(//skinconfig/trail/link3/@name)and(//skinconfig/trail/link3/@name!='')"> &gt; <a href="{//skinconfig/trail/link3/@href}">  <xsl:value-of select="//skinconfig/trail/link3/@name"/></a> </xsl:if>
    <script type="text/javascript" language="JavaScript" src="{$root}skin/breadcrumbs.js"/>
  </xsl:template>
  
  <xsl:template match="site">
    <html>
      <head>
        <title><xsl:value-of select="div[@class='content']/table/tr/td/h1"/></title>
        <xsl:if test="//skinconfig/favicon-url">
          <link rel="shortcut icon">
            <xsl:attribute name="href">
              <xsl:value-of select="concat($root,//skinconfig/favicon-url)"/>
            </xsl:attribute>
          </link>
        </xsl:if>
      </head>
      <body>
        <xsl:if test="//skinconfig/group-url">
          <xsl:call-template name="renderlogo">
            <xsl:with-param name="name" select="//skinconfig/group-name"/>
            <xsl:with-param name="url" select="//skinconfig/group-url"/>
            <xsl:with-param name="logo" select="//skinconfig/group-logo"/>
            <xsl:with-param name="root" select="$root"/>
            <xsl:with-param name="description" select="//skinconfig/group-description"/>
          </xsl:call-template>
        </xsl:if>
        <xsl:call-template name="renderlogo">
          <xsl:with-param name="name" select="//skinconfig/project-name"/>
          <xsl:with-param name="url" select="//skinconfig/project-url"/>
          <xsl:with-param name="logo" select="//skinconfig/project-logo"/>
          <xsl:with-param name="root" select="$root"/>
          <xsl:with-param name="description" select="//skinconfig/project-description"/>
        </xsl:call-template>
        <xsl:comment>================= start Tabs ==================</xsl:comment>
        <xsl:apply-templates select="div[@class='tab']"/>
        <xsl:comment>================= end Tabs ==================</xsl:comment>
        <xsl:comment>================= start Menu items ==================</xsl:comment>
        <xsl:apply-templates select="div[@class='menu']"/>
        <xsl:comment>================= end Menu items ==================</xsl:comment>
        <xsl:comment>================= start Content==================</xsl:comment>
        <xsl:apply-templates select="div[@class='content']"/>
        <xsl:comment>================= end Content==================</xsl:comment>

        <xsl:comment>================= start Footer ==================</xsl:comment>
        <xsl:choose>
          <xsl:when test="$config/copyright-link">
            <a>
              <xsl:attribute name="href">
                <xsl:value-of select="$config/copyright-link"/>
              </xsl:attribute>
            Copyright &#169; <xsl:value-of select="$config/year"/>&#160;
            <xsl:value-of select="$config/vendor"/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            Copyright &#169; <xsl:value-of select="$config/year"/>&#160;
            <xsl:value-of select="$config/vendor"/>
          </xsl:otherwise>
        </xsl:choose>
        All rights reserved.
        <script language="JavaScript" type="text/javascript"><![CDATA[<!--
          document.write(" - "+"Last Published: " + document.lastModified);
          //  -->]]></script>
        <xsl:if test="//skinconfig/host-logo and not(//skinconfig/host-logo = '')">
          <a href="{//skinconfig/host-url}">
            <xsl:call-template name="renderlogo">
              <xsl:with-param name="name" select="//skinconfig/host-name"/>
              <xsl:with-param name="url" select="//skinconfig/host-url"/>
              <xsl:with-param name="logo" select="//skinconfig/host-logo"/>
              <xsl:with-param name="root" select="$root"/>
            </xsl:call-template>
          </a>
        </xsl:if>
        <xsl:if test="$filename = 'index.html' and //skinconfig/credits">
          <xsl:for-each select="//skinconfig/credits/credit[not(@role='pdf')]">
            <xsl:call-template name="renderlogo">
              <xsl:with-param name="name" select="name"/>
              <xsl:with-param name="url" select="url"/>
              <xsl:with-param name="logo" select="image"/>
              <xsl:with-param name="root" select="$root"/>
              <xsl:with-param name="width" select="width"/>
              <xsl:with-param name="height" select="height"/>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:if>
        <a href="http://validator.w3.org/check/referer"><img class="skin" border="0"
            src="http://www.w3.org/Icons/valid-html401"
            alt="Valid HTML 4.01!" height="31" width="88"/></a>
      </body>
    </html>
  </xsl:template>

  <!-- Add links to any standards-compliance logos -->
  <xsl:template name="compliancy-logos">
    <xsl:if test="$filename = 'index.html' and //skinconfig/disable-compliance-links = 'false'">
      <a href="http://validator.w3.org/check/referer"><img class="logoImage" 
          src="{$skin-img-dir}/valid-html401.png"
          alt="Valid HTML 4.01!" title="Valid HTML 4.01!" height="31" width="88" border="0"/></a>
          
      <a href="http://jigsaw.w3.org/css-validator/"><img class="logoImage" 
          src="{$skin-img-dir}/vcss.png" 
          alt="Valid CSS!" title="Valid CSS!" height="31" width="88" border="0"/></a>
    </xsl:if>
  </xsl:template>

  <!-- Generates the PDF link -->
  <xsl:template match="div[@id='skinconf-pdflink']">
    <xsl:if test="not($config/disable-pdf-link) or $disable-pdf-link = 'false'"> 
      <td align="center" width="40" nowrap="nowrap"><a href="{$filename-noext}.pdf" class="dida">
        <img class="skin" src="{$skin-img-dir}/pdfdoc.gif" alt="PDF"/><br/>
        PDF</a>
      </td>
    </xsl:if>
  </xsl:template>

  <!-- Generates the POD link -->
  <xsl:template match="div[@id='skinconf-podlink']">
    <xsl:if test="$disable-pod-link = 'false'">
      <td align="center" width="40" nowrap="nowrap"><a href="{$filename-noext}.pod" class="dida">
        <img class="skin" src="{$skin-img-dir}/poddoc.png" alt="POD"/><br/>
        POD</a>
      </td>
    </xsl:if>
  </xsl:template>
  
  <!-- Generates the XML link -->
  <xsl:template match="div[@id='skinconf-xmllink']">
    <xsl:if test="$disable-xml-link = 'false'">
      <td align="center" width="40" nowrap="nowrap"><a href="{$filename-noext}.xml" class="dida">
        <img class="skin" src="{$skin-img-dir}/xmldoc.gif" alt="xml"/><br/>
        xml</a>
      </td>
    </xsl:if>
  </xsl:template>

  <!-- Generates the "printer friendly version" link -->
  <xsl:template match="div[@id='skinconf-printlink']">
    <xsl:if test="$disable-print-link = 'false'"> 
<script type="text/javascript" language="Javascript">
function printit() {
  if (window.print) {
    window.focus();
    window.print();
  }
}
</script>

<script type="text/javascript" language="Javascript">
var NS = (navigator.appName == "Netscape");
var VERSION = parseInt(navigator.appVersion);
if (VERSION > 3) {
    document.write('<td align="center" width="40" nowrap="nowrap">');
    document.write('  <a href="javascript:printit()" class="dida">');
    document.write('    <img class="skin" src="{$skin-img-dir}/printer.gif" alt="Print this Page"/><br />');
    document.write('  print</a>');
    document.write('</td>');
}
</script>

    </xsl:if>
  </xsl:template>

  <!-- handle all obfuscating mail links and disabling external link images -->
  <xsl:template match="a">
    <xsl:choose>
      <xsl:when test="$obfuscate-mail-links='true' and starts-with(@href, 'mailto:') and contains(@href, '@')">
        <xsl:variable name="mailto-1" select="substring-before(@href,'@')"/>
        <xsl:variable name="mailto-2" select="substring-after(@href,'@')"/>
        <xsl:variable name="obfuscation" select="normalize-space(//skinconfig/obfuscate-mail-value)"/>
          <a href="{$mailto-1}{$obfuscation}{$mailto-2}">
            <xsl:apply-templates/>
          </a>
       </xsl:when>
       <xsl:when test="not($disable-external-link-image='true') and contains(@href, ':') and not(contains(@href, //skinconfig/group-url)) and not(contains(@href, //skinconfig/project-url))">
          <a href="{@href}" class="external">
            <xsl:apply-templates/>
          </a>
       </xsl:when>       
       <xsl:otherwise>
        <!-- xsl:copy-of makes sure we copy <a href> as well as <a name>
             or any other <a ...> forms -->
        <xsl:copy-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="div[@id='skinconf-toc-page']">
    <xsl:if test="$config/toc">
      <xsl:if test="contains($minitoc-location,'page')">
        <xsl:if test="count(//tocitems/tocitem) >= $config/toc/@min-sections">
          <xsl:call-template name="minitoc">
            <xsl:with-param name="tocroot" select="//tocitems"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template name="minitoc">  
    <xsl:param name="tocroot"/>
    <xsl:if test="count($tocroot/tocitem) >= $config/toc/@min-sections">
    <xsl:if test="contains($config/toc/@location,'page')"> 
      <ul class="minitoc">
        <xsl:for-each select="$tocroot/tocitem">
          <li>
            <a href="{@href}">
              <xsl:if test="contains($config/toc/@with-numbers,'true')">
                <xsl:number count="tocitem" format="1.1.1.1.1.1.1" level="multiple" />
              </xsl:if>
              <xsl:value-of select="@title"/>
            </a>
            <xsl:if test="@level&lt;//skinconfig/toc/@max-depth+1">
              <xsl:call-template name="minitoc">
                <xsl:with-param name="tocroot" select="."/>
              </xsl:call-template>
            </xsl:if>
          </li>
        </xsl:for-each>
      </ul>
    </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template name="html-meta">  
    <meta name="Generator" content="Apache Forrest"/>
    <meta>
      <xsl:attribute name="name">Forrest-version</xsl:attribute>
      <xsl:attribute name="content">
        <xsl:value-of select="//info/forrest-version"/>
      </xsl:attribute>
    </meta>
    <meta>
      <xsl:attribute name="name">Forrest-skin-name</xsl:attribute>
      <xsl:attribute name="content">
        <xsl:value-of select="//info/project-skin"/>
      </xsl:attribute>
    </meta>
  </xsl:template>

  <xsl:template name="feedback">  
    <div id="feedback">
      <xsl:value-of select="$config/feedback"/>
      <xsl:choose>
        <xsl:when test="$config/feedback/@href and not($config/feedback/@href='')">
          <a id="feedbackto">
            <xsl:attribute name="href">
              <xsl:value-of select="$config/feedback/@href"/>
              <xsl:value-of select="$path"/>
            </xsl:attribute>
            <xsl:value-of select="$config/feedback/@to"/>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$config/feedback/@to"/>
        </xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>

  <xsl:template match="node()|@*" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
