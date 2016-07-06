<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<!--
   Licensed to the Apache Software Foundation (ASF) under one or more
   contributor license agreements.  See the NOTICE file distributed with
   this work for additional information regarding copyright ownership.
   The ASF licenses this file to You under the Apache License, Version 2.0
   (the "License"); you may not use this file except in compliance with
   the License.  You may obtain a copy of the License at
 
       http://www.apache.org/licenses/LICENSE-2.0
 
   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
-->

<!-- 
    Stylesheet for processing 2.1 output format test result files 
    To uses this directly in a browser, add the following to the JTL file as line 2:
    <? xml-stylesheet type="text/xsl" href="../extras/jmeter-results-report_21.xsl" ?>
    and you can then view the JTL in a browser
-->
    
<xsl:output method="html" indent="yes" encoding="UTF-8" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" />

<xsl:param name="titleReport" select="'API Test Results'"/>
<!-- <xsl:param name="dateReport" select="'date not defined'"/ > -->

<xsl:template match="testResults">
    <html>
        <head>
            <title><xsl:value-of select="$titleReport" /></title>
            <style type="text/css">
                body { font:normal 68% verdana,arial,helvetica; color:#000000; }
                table tr td, table tr th { font-size: 68%; }
                table.details tr th { color: #ffffff; font-weight: bold; text-align:center; background:#2674a6; white-space: pre-wrap; }
                table.details tr td { background:#eeeee0; white-space: pre-wrap; }
                h1 { margin: 0px 0px 5px; font: 165% verdana,arial,helvetica }
                h2 { margin-top: 1em; margin-bottom: 0.5em; font: bold 125% verdana,arial,helvetica }
                h3 { margin-bottom: 0.5em; font: bold 115% verdana,arial,helvetica }
                .Failure { font-weight:bold; color:red; }
                img { border-width: 0px; }
                .expand_link { position: absolute; right: 0px; width: 27px; top: 1px; height: 27px; }
                .page_details { display: none; } 
                .page_details_expanded { display: block; display/* hide this definition from  IE5/6 */: table-row; }
                .key { min-width: 108px; width: 15%; }
                .detail, #tdetail { display: none; }
            </style>
            <script language="JavaScript"><![CDATA[
                function toggle_detail(detail_id) {
                	var expand_img = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAAZiS0dEALQADQANam36RQAAAAlwSFlzAAALEwAACxMBAJqcGAAAAAd0SU1FB9wDDQ0hOymuu20AAAL5dEVYdENvbW1lbnQATGljZW5zZWQgdG8gdGhlIEFwYWNoZSBTb2Z0d2FyZSBGb3VuZGF0aW9uIChBU0YpIHVuZGVyIG9uZSBvciBtb3JlCmNvbnRyaWJ1dG9yIGxpY2Vuc2UgYWdyZWVtZW50cy4gIFNlZSB0aGUgTk9USUNFIGZpbGUgZGlzdHJpYnV0ZWQgd2l0aAp0aGlzIHdvcmsgZm9yIGFkZGl0aW9uYWwgaW5mb3JtYXRpb24gcmVnYXJkaW5nIGNvcHlyaWdodCBvd25lcnNoaXAuClRoZSBBU0YgbGljZW5zZXMgdGhpcyBmaWxlIHRvIFlvdSB1bmRlciB0aGUgQXBhY2hlIExpY2Vuc2UsIFZlcnNpb24gMi4wCih0aGUgIkxpY2Vuc2UiKTsgeW91IG1heSBub3QgdXNlIHRoaXMgZmlsZSBleGNlcHQgaW4gY29tcGxpYW5jZSB3aXRoCnRoZSBMaWNlbnNlLiAgWW91IG1heSBvYnRhaW4gYSBjb3B5IG9mIHRoZSBMaWNlbnNlIGF0CgogICBodHRwOi8vd3d3LmFwYWNoZS5vcmcvbGljZW5zZXMvTElDRU5TRS0yLjAKClVubGVzcyByZXF1aXJlZCBieSBhcHBsaWNhYmxlIGxhdyBvciBhZ3JlZWQgdG8gaW4gd3JpdGluZywgc29mdHdhcmUKZGlzdHJpYnV0ZWQgdW5kZXIgdGhlIExpY2Vuc2UgaXMgZGlzdHJpYnV0ZWQgb24gYW4gIkFTIElTIiBCQVNJUywKV0lUSE9VVCBXQVJSQU5USUVTIE9SIENPTkRJVElPTlMgT0YgQU5ZIEtJTkQsIGVpdGhlciBleHByZXNzIG9yIGltcGxpZWQuClNlZSB0aGUgTGljZW5zZSBmb3IgdGhlIHNwZWNpZmljIGxhbmd1YWdlIGdvdmVybmluZyBwZXJtaXNzaW9ucyBhbmQKbGltaXRhdGlvbnMgdW5kZXIgdGhlIExpY2Vuc2UuhUUAtwAAAC1JREFUOMtjVCtZ9p+BAsDEQCEYNYAKBrAgc252RxKlSb10OfVcwDiakIaDAQDXcQefpMw+jAAAAABJRU5ErkJggg==";
                	var collapse_img = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAAZiS0dEALQADQANam36RQAAAAlwSFlzAAALEwAACxMBAJqcGAAAAAd0SU1FB9wDDQ0cLbeSRoIAAAL5dEVYdENvbW1lbnQATGljZW5zZWQgdG8gdGhlIEFwYWNoZSBTb2Z0d2FyZSBGb3VuZGF0aW9uIChBU0YpIHVuZGVyIG9uZSBvciBtb3JlCmNvbnRyaWJ1dG9yIGxpY2Vuc2UgYWdyZWVtZW50cy4gIFNlZSB0aGUgTk9USUNFIGZpbGUgZGlzdHJpYnV0ZWQgd2l0aAp0aGlzIHdvcmsgZm9yIGFkZGl0aW9uYWwgaW5mb3JtYXRpb24gcmVnYXJkaW5nIGNvcHlyaWdodCBvd25lcnNoaXAuClRoZSBBU0YgbGljZW5zZXMgdGhpcyBmaWxlIHRvIFlvdSB1bmRlciB0aGUgQXBhY2hlIExpY2Vuc2UsIFZlcnNpb24gMi4wCih0aGUgIkxpY2Vuc2UiKTsgeW91IG1heSBub3QgdXNlIHRoaXMgZmlsZSBleGNlcHQgaW4gY29tcGxpYW5jZSB3aXRoCnRoZSBMaWNlbnNlLiAgWW91IG1heSBvYnRhaW4gYSBjb3B5IG9mIHRoZSBMaWNlbnNlIGF0CgogICBodHRwOi8vd3d3LmFwYWNoZS5vcmcvbGljZW5zZXMvTElDRU5TRS0yLjAKClVubGVzcyByZXF1aXJlZCBieSBhcHBsaWNhYmxlIGxhdyBvciBhZ3JlZWQgdG8gaW4gd3JpdGluZywgc29mdHdhcmUKZGlzdHJpYnV0ZWQgdW5kZXIgdGhlIExpY2Vuc2UgaXMgZGlzdHJpYnV0ZWQgb24gYW4gIkFTIElTIiBCQVNJUywKV0lUSE9VVCBXQVJSQU5USUVTIE9SIENPTkRJVElPTlMgT0YgQU5ZIEtJTkQsIGVpdGhlciBleHByZXNzIG9yIGltcGxpZWQuClNlZSB0aGUgTGljZW5zZSBmb3IgdGhlIHNwZWNpZmljIGxhbmd1YWdlIGdvdmVybmluZyBwZXJtaXNzaW9ucyBhbmQKbGltaXRhdGlvbnMgdW5kZXIgdGhlIExpY2Vuc2UuhUUAtwAAADtJREFUOMtjVCtZ9p+BAsDEQCGgrQE3uyMZbnZHDmUvEAMYkaORkH9hQL10OY1cgC0W0G0c7rEwNL0AAJeCEpM4iWKGAAAAAElFTkSuQmCC";
                
                	var arrImg = document.getElementsByClassName("detail_image")
                	for (var i=0; i<arrImg.length; i++) {
                		var objImg = arrImg[i];
                		if (objImg.id == detail_id+"_image") {
                			if (objImg.alt == "collapse") {
		                        objImg.src = expand_img;
		                        objImg.alt = "expand";
		                    } else {
		                        objImg.src = collapse_img;
		                        objImg.alt = "collapse";
		                    }
		                 } else {
		                 	objImg.src = collapse_img;
		                    objImg.alt = "collapse";
		                 }
                	}
                	
                    var objTitle = document.getElementById("tdetail");
                    var arrTable = document.getElementsByClassName("detail");
                    for (var i=0; i<arrTable.length; i++) {
                        var table = arrTable[i];
                        if (table.id != detail_id) {
                            table.style.display = "none";
                        } else {
                            if (table.style.display == "none" || table.style.display == "") {
                                table.style.display = "table";
                                objTitle.style.display = "block";
                            } else {
                                table.style.display = "none";
                                objTitle.style.display = "none";
                            }
                        }
                    }
                };
            ]]></script>
        </head>
        <body>
        
            <xsl:call-template name="pageHeader" />
            
            <xsl:call-template name="summary" />
            <hr size="1" width="95%" align="center" />
            
            <xsl:call-template name="pagelist" />
            <hr size="1" width="95%" align="center" />
            
            <xsl:call-template name="detail" />

        </body>
    </html>
</xsl:template>

<xsl:template name="pageHeader">
    <h1><xsl:value-of select="$titleReport" /></h1>
    <!-- <table width="100%">
        <tr>
            <td align="left">Date report: <xsl:value-of select="$dateReport" /></td>
            <td align="right">Designed for use with <a href="http://jmeter.apache.org/">JMeter</a> and <a href="http://ant.apache.org">Ant</a>.</td>
        </tr>
    </table> -->
    <hr size="1" />
</xsl:template>

<xsl:template name="summary">
    <h2>Summary</h2>
    <table align="center" class="details" border="0" cellpadding="5" cellspacing="2" width="95%">
        <tr valign="top">
            <th># Step</th>
            <th>Failures</th>
            <th>Success</th>
            <th>Success Rate</th>
            <th>Average Time</th>
            <th>Min Time</th>
            <th>Max Time</th>
        </tr>
        <tr valign="top">
            <xsl:variable name="allCount" select="count(/testResults/*)" />
            <xsl:variable name="allFailureCount" select="count(/testResults/*[attribute::s='false'])" />
            <xsl:variable name="allSuccessCount" select="count(/testResults/*[attribute::s='true'])" />
            <xsl:variable name="allSuccessPercent" select="$allSuccessCount div $allCount" />
            <xsl:variable name="allTotalTime" select="sum(/testResults/*/@t)" />
            <xsl:variable name="allAverageTime" select="$allTotalTime div $allCount" />
            <xsl:variable name="allMinTime">
                <xsl:call-template name="min">
                    <xsl:with-param name="nodes" select="/testResults/*/@t" />
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="allMaxTime">
                <xsl:call-template name="max">
                    <xsl:with-param name="nodes" select="/testResults/*/@t" />
                </xsl:call-template>
            </xsl:variable>
            <xsl:attribute name="class">
                <xsl:choose>
                    <xsl:when test="$allFailureCount &gt; 0">Failure</xsl:when>
                </xsl:choose>
            </xsl:attribute>
            <td align="center">
                <xsl:value-of select="$allCount" />
            </td>
            <td align="center">
                <xsl:value-of select="$allFailureCount" />
            </td>
            <td align="center">
                <xsl:value-of select="$allSuccessCount" />
            </td>
            <td align="center">
                <xsl:call-template name="display-percent">
                    <xsl:with-param name="value" select="$allSuccessPercent" />
                </xsl:call-template>
            </td>
            <td align="center">
                <xsl:call-template name="display-time">
                    <xsl:with-param name="value" select="$allAverageTime" />
                </xsl:call-template>
            </td>
            <td align="center">
                <xsl:call-template name="display-time">
                    <xsl:with-param name="value" select="$allMinTime" />
                </xsl:call-template>
            </td>
            <td align="center">
                <xsl:call-template name="display-time">
                    <xsl:with-param name="value" select="$allMaxTime" />
                </xsl:call-template>
            </td>
        </tr>
    </table>
</xsl:template>

<xsl:template name="pagelist">
    <h2>Pages</h2>
    <table align="center" class="details" border="0" cellpadding="5" cellspacing="2" width="95%">
        <tr valign="top">
            <th>Step</th>
            <!-- <th>Test</th> -->
            <!-- <th>Failures</th> -->
            <!-- <th>Success</th> -->
            <!-- <th>Success Rate</th> -->
            <th>Average Time</th>
            <th>Min Time</th>
            <th>Max Time</th>
            <th>Response</th>
            <th>Result</th>
            <th></th>
        </tr>
        <xsl:for-each select="/testResults/*[not(@lb = preceding::*/@lb)]">
            <xsl:variable name="label" select="@lb" />
            <xsl:variable name="count" select="count(../*[@lb = current()/@lb])" />
            <xsl:variable name="failureCount" select="count(../*[@lb = current()/@lb][attribute::s='false'])" />
            <xsl:variable name="successCount" select="count(../*[@lb = current()/@lb][attribute::s='true'])" />
            <xsl:variable name="successPercent" select="$successCount div $count" />
            <xsl:variable name="totalTime" select="sum(../*[@lb = current()/@lb]/@t)" />
            <xsl:variable name="averageTime" select="$totalTime div $count" />
            <xsl:variable name="minTime">
                <xsl:call-template name="min">
                    <xsl:with-param name="nodes" select="../*[@lb = current()/@lb]/@t" />
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="maxTime">
                <xsl:call-template name="max">
                    <xsl:with-param name="nodes" select="../*[@lb = current()/@lb]/@t" />
                </xsl:call-template>
            </xsl:variable>
            <tr valign="top">
                <xsl:attribute name="class">
                    <xsl:choose>
                        <xsl:when test="$failureCount &gt; 0">Failure</xsl:when>
                    </xsl:choose>
                </xsl:attribute>
                <td>
                    <xsl:value-of select="method"/><xsl:text> </xsl:text><xsl:value-of select="$label" />
                </td>
                <!-- <td align="center">
                    <xsl:value-of select="$count" />
                </td> -->
                <!-- <td align="center">
                    <xsl:value-of select="$failureCount" />
                </td> -->
                <!-- <td align="center">
                    <xsl:value-of select="$successCount" />
                </td> -->
                <!-- <td align="center">
                    <xsl:call-template name="display-percent">
                        <xsl:with-param name="value" select="$successPercent" />
                    </xsl:call-template>
                </td> -->
                <td align="center">
                    <xsl:call-template name="display-time">
                        <xsl:with-param name="value" select="$averageTime" />
                    </xsl:call-template>
                </td>
                <td align="center">
                    <xsl:call-template name="display-time">
                        <xsl:with-param name="value" select="$minTime" />
                    </xsl:call-template>
                </td>
                <td align="center">
                    <xsl:call-template name="display-time">
                        <xsl:with-param name="value" select="$maxTime" />
                    </xsl:call-template>
                </td>
                <td align="center">
                    <xsl:value-of select="@rc"/><xsl:text> - </xsl:text><xsl:value-of select="@rm" />
                </td>
                <td align="center">
                   	<xsl:choose>
                   		<xsl:when test="$failureCount &gt; 0">Fail</xsl:when>
                   		<xsl:otherwise>Pass</xsl:otherwise>
                   	</xsl:choose>
                </td>
                <td align="center">
                   <a href="">
                      <xsl:attribute name="href"><xsl:text/>javascript:toggle_detail('<xsl:text/><xsl:value-of select="@lb" />_detail')</xsl:attribute>
                      <img class="detail_image" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAAZiS0dEALQADQANam36RQAAAAlwSFlzAAALEwAACxMBAJqcGAAAAAd0SU1FB9wDDQ0cLbeSRoIAAAL5dEVYdENvbW1lbnQATGljZW5zZWQgdG8gdGhlIEFwYWNoZSBTb2Z0d2FyZSBGb3VuZGF0aW9uIChBU0YpIHVuZGVyIG9uZSBvciBtb3JlCmNvbnRyaWJ1dG9yIGxpY2Vuc2UgYWdyZWVtZW50cy4gIFNlZSB0aGUgTk9USUNFIGZpbGUgZGlzdHJpYnV0ZWQgd2l0aAp0aGlzIHdvcmsgZm9yIGFkZGl0aW9uYWwgaW5mb3JtYXRpb24gcmVnYXJkaW5nIGNvcHlyaWdodCBvd25lcnNoaXAuClRoZSBBU0YgbGljZW5zZXMgdGhpcyBmaWxlIHRvIFlvdSB1bmRlciB0aGUgQXBhY2hlIExpY2Vuc2UsIFZlcnNpb24gMi4wCih0aGUgIkxpY2Vuc2UiKTsgeW91IG1heSBub3QgdXNlIHRoaXMgZmlsZSBleGNlcHQgaW4gY29tcGxpYW5jZSB3aXRoCnRoZSBMaWNlbnNlLiAgWW91IG1heSBvYnRhaW4gYSBjb3B5IG9mIHRoZSBMaWNlbnNlIGF0CgogICBodHRwOi8vd3d3LmFwYWNoZS5vcmcvbGljZW5zZXMvTElDRU5TRS0yLjAKClVubGVzcyByZXF1aXJlZCBieSBhcHBsaWNhYmxlIGxhdyBvciBhZ3JlZWQgdG8gaW4gd3JpdGluZywgc29mdHdhcmUKZGlzdHJpYnV0ZWQgdW5kZXIgdGhlIExpY2Vuc2UgaXMgZGlzdHJpYnV0ZWQgb24gYW4gIkFTIElTIiBCQVNJUywKV0lUSE9VVCBXQVJSQU5USUVTIE9SIENPTkRJVElPTlMgT0YgQU5ZIEtJTkQsIGVpdGhlciBleHByZXNzIG9yIGltcGxpZWQuClNlZSB0aGUgTGljZW5zZSBmb3IgdGhlIHNwZWNpZmljIGxhbmd1YWdlIGdvdmVybmluZyBwZXJtaXNzaW9ucyBhbmQKbGltaXRhdGlvbnMgdW5kZXIgdGhlIExpY2Vuc2UuhUUAtwAAADtJREFUOMtjVCtZ9p+BAsDEQCGgrQE3uyMZbnZHDmUvEAMYkaORkH9hQL10OY1cgC0W0G0c7rEwNL0AAJeCEpM4iWKGAAAAAElFTkSuQmCC" alt="collapse"><xsl:attribute name="id"><xsl:text/><xsl:value-of select="@lb" />_detail_image</xsl:attribute></img>                      
                   </a>
                </td>
            </tr>
        </xsl:for-each>
    </table>
</xsl:template>

<xsl:template name="detail">
    <h2 id="tdetail">Details</h2>
    <xsl:for-each select="/testResults/*[not(@lb = preceding::*/@lb)]">
        <xsl:for-each select="/testResults/*[@lb = current()/@lb]">
            <table align="center" class="details detail" border="0" cellpadding="5" cellspacing="2" width="95%">
                <xsl:attribute name="id"><xsl:text/><xsl:value-of select="@lb" />_detail</xsl:attribute>
                   <tr valign="top"><th colspan="2"><xsl:value-of select="@lb" /></th></tr>
                   <tr><td class="key">Time</td><td><xsl:call-template name="display-time"><xsl:with-param name="value" select="@t" /></xsl:call-template></td></tr>
                   <tr><td class="key">Latency</td><td><xsl:call-template name="display-time"><xsl:with-param name="value" select="@lt"/></xsl:call-template></td></tr>
                   <tr><td class="key">Bytes</td><td><xsl:value-of select="@by"/></td></tr>
                   <tr><td class="key">Sample Count</td><td><xsl:value-of select="@sc"/></td></tr>
                   <tr><td class="key">Error Count</td><td><xsl:value-of select="@ec"/></td></tr>
                   <tr><td class="key">Response Code</td><td><xsl:value-of select="@rc"/></td></tr>
                   <tr><td class="key">Response Message</td><td><xsl:value-of select="@rm"/></td></tr>
                   <tr><td class="key">Failure Message</td><td><xsl:value-of select="assertionResult/failureMessage"/></td></tr>
                   <tr><td class="key">Method/Url</td><td><xsl:value-of select="method"/><xsl:text> </xsl:text><xsl:value-of select="java.net.URL"/></td></tr>
                   <tr><td class="key">Query String</td><td><xsl:value-of select="queryString"/></td></tr>
                   <tr><td class="key">Cookies</td><td><xsl:value-of select="cookies"/></td></tr>
                   <tr><td class="key">Request Headers</td><td><xsl:value-of select="requestHeader"/></td></tr>
                   <tr><td class="key">Response Headers</td><td><xsl:value-of select="responseHeader"/></td></tr>
                   <tr><td class="key">Response Data</td><td><xsl:value-of select="responseData"/></td></tr>
                   <tr><td class="key">Response File</td><td><xsl:value-of select="responseFile"/></td></tr>
            </table>
        </xsl:for-each>          
    </xsl:for-each>
</xsl:template>

<xsl:template name="min">
    <xsl:param name="nodes" select="/.." />
    <xsl:choose>
        <xsl:when test="not($nodes)">NaN</xsl:when>
        <xsl:otherwise>
            <xsl:for-each select="$nodes">
                <xsl:sort data-type="number" />
                <xsl:if test="position() = 1">
                    <xsl:value-of select="number(.)" />
                </xsl:if>
            </xsl:for-each>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="max">
    <xsl:param name="nodes" select="/.." />
    <xsl:choose>
        <xsl:when test="not($nodes)">NaN</xsl:when>
        <xsl:otherwise>
            <xsl:for-each select="$nodes">
                <xsl:sort data-type="number" order="descending" />
                <xsl:if test="position() = 1">
                    <xsl:value-of select="number(.)" />
                </xsl:if>
            </xsl:for-each>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="display-percent">
    <xsl:param name="value" />
    <xsl:value-of select="format-number($value,'0.00%')" />
</xsl:template>

<xsl:template name="display-time">
    <xsl:param name="value" />
    <xsl:value-of select="format-number($value,'0 ms')" />
</xsl:template>
    
</xsl:stylesheet>