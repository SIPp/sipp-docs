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

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">

<xsl:import href="../../../common/xslt/fo/document2fo.xsl"/>

<xsl:template match="section">
    <!-- ================================================================ -->
    <xsl:if test="($proto-target='all' and (contains(@apply_to, 'mbi') or contains(@apply_to, 'diameter') or not(@apply_to))) or
                  ($proto-target='mbi' and (contains(@apply_to, 'mbi') or not(@apply_to))) or
                  ($proto-target='diameter' and (contains(@apply_to, 'diameter') or not(@apply_to)))">   
    <!-- ================================================================ -->
    <xsl:apply-imports/>
   </xsl:if>
  </xsl:template>  
  
  <xsl:template match="li">
    <!-- ================================================================ -->
    <xsl:if test="($proto-target='all' and (contains(@apply_to, 'mbi') or contains(@apply_to, 'diameter') or not(@apply_to))) or
                  ($proto-target='mbi' and (contains(@apply_to, 'mbi') or not(@apply_to))) or
                  ($proto-target='diameter' and (contains(@apply_to, 'diameter') or not(@apply_to)))">   
    <!-- ================================================================ -->
    <xsl:apply-imports/>
   </xsl:if>
  </xsl:template>  

    <xsl:template match="note">
    <!-- ================================================================ -->
    <xsl:if test="($proto-target='all' and (contains(@apply_to, 'mbi') or contains(@apply_to, 'diameter') or not(@apply_to))) or
                  ($proto-target='mbi' and (contains(@apply_to, 'mbi') or not(@apply_to))) or
                  ($proto-target='diameter' and (contains(@apply_to, 'diameter') or not(@apply_to)))">   
    <!-- ================================================================ -->
    <xsl:apply-imports/>
   </xsl:if>
  </xsl:template>  

    <xsl:template match="source">
    <!-- ================================================================ -->
    <xsl:if test="($proto-target='all' and (contains(@apply_to, 'mbi') or contains(@apply_to, 'diameter') or not(@apply_to))) or
                  ($proto-target='mbi' and (contains(@apply_to, 'mbi') or not(@apply_to))) or
                  ($proto-target='diameter' and (contains(@apply_to, 'diameter') or not(@apply_to)))">   
    <!-- ================================================================ -->
    <xsl:apply-imports/>
   </xsl:if>
  </xsl:template>  

    <xsl:template match="figure">
    <!-- ================================================================ -->
    <xsl:if test="($proto-target='all' and (contains(@apply_to, 'mbi') or contains(@apply_to, 'diameter') or not(@apply_to))) or
                  ($proto-target='mbi' and (contains(@apply_to, 'mbi') or not(@apply_to))) or
                  ($proto-target='diameter' and (contains(@apply_to, 'diameter') or not(@apply_to)))">   
    <!-- ================================================================ -->
    <xsl:apply-imports/>
   </xsl:if>
  </xsl:template>  

</xsl:stylesheet>


