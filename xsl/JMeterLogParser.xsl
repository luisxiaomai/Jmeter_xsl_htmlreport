<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" method="html" version="1.0" omit-xml-declaration="no"/>
  <xsl:output method='html' version='1.0' encoding='UTF-8' indent='yes'/>

  <xsl:template match="/">
    <html>
      <head>
        <script type="text/javascript">
          function getNextSibling(n)
          {
          var x = n.nextSibling;
          var temp = n;
          if ((x == null)||(x.nodeType == 3))
          {
          if(x != null)
          {
          x=x.nextSibling;
          }
          while (x == null)
          {
          x=temp.parentNode.nextSibling;
          temp = temp.parentNode;
          }
          }
          return x;
          }

          function getAddIcon(oSource)
          {
          var addIcon = oSource.firstChild.firstChild;
          if (addIcon.nodeType == 3) //for Chrome and Safari
          {
          addIcon = addIcon.nextSibling;
          }
          return addIcon;
          }

          function clickItem(oSource,iconAdd, iconRemove)
          {
          <!--getNextSibling(oSource).style.display = getNextSibling(oSource).style.display != "" ? "" : "none";-->
          if (getNextSibling(oSource).style.display != "") {
          getAddIcon(oSource).style.display = "none";
          getAddIcon(oSource).nextSibling.style.display = "";
          getNextSibling(oSource).style.display = "";
          }
          else {
          getAddIcon(oSource).style.display = "";
          getAddIcon(oSource).nextSibling.style.display = "none";
          getNextSibling(oSource).style.display = "none";
          }
          }
          function mouseOver(oSource)
          {
          oSource.style.textDecorationUnderline = true;
          }
          function mouseOut(oSource)
          {
          oSource.style.textDecorationUnderline = false;
          }
        </script>
        <style type="text/css">
          .arial_font {font-family:Arial}
          .expandable_title:hover { cursor: pointer; text-decoration: underline; }
          .table_section {border:0; width:90%; cellspacing:0; font-family:Arial}
          .label {background-color:#ffff99;font-family:Arial}
          .memo-title { width:10%; font-size:15px; font-family:Times}
          .memo-content { font-size:14px; font-family:Times; word-break:break-all;padding:5px}
          .memo-content .hint{padding:0px 10px 0px 10px;}
          .memo-content .msg{padding:0px 10px 10px 10px;}
          .customtable td { border-right: 1px solid #B7B7B7; border-bottom: 1px solid #B7B7B7; padding: 6px 6px 6px 12px; }
          .customtable tr th, .customtable tr td { overflow: hidden; text-overflow: ellipsis; word-break:break-all; }
        </style>
      </head>
      <body>
        <h2 class="arial_font">
          Test Result:
          <xsl:if test="count(//httpSample[@s='false']) &gt; 0 or count(//sample[@s='false']) &gt; 0">
            <font color="red">
              Failed
            </font>
            <a href="#fistFailedStep" class="memo-content">Go to the first failed step</a>
          </xsl:if>
          <xsl:if test="count(//httpSample[@s='false']) = 0 and count(//sample[@s='false']) = 0">
            <font color="green">
              Success
            </font>
          </xsl:if>
        </h2>

        <xsl:apply-templates select="testResults"/>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="testResults">
    <xsl:apply-templates select="*"/>
  </xsl:template>

  <xsl:template match="*">
    <table border="0" class="table_section">
      <tr>
        <xsl:attribute name="class">expandable_title</xsl:attribute>
        <xsl:attribute name="onmouseover">mouseOver(this);</xsl:attribute>
        <xsl:attribute name="onmouseout">mouseOut(this);</xsl:attribute>
        <xsl:attribute name="onclick">clickItem(this);</xsl:attribute>

        <td width="400px" >
          <img id="iconAdd" style="display:" src="http://10.58.137.207:8089/sapanw/xsl/images/add.gif" />
          <img id="iconRemove" style="display:none" src="http://10.58.137.207:8089/sapanw/xsl/images/remove.gif" />
          <xsl:choose>
            <xsl:when test="@s='true'">
              <img height="11px" width="11px" hspace="3" src="http://10.58.137.207:8089/sapanw/xsl/images/pass.gif"/>
            </xsl:when>
            <xsl:when test="@s='false'">
              <a>
                <xsl:attribute name="name">fistFailedStep</xsl:attribute>
              </a>
              <img height="11px" width="11px" hspace="3" src="http://10.58.137.207:8089/sapanw/xsl/images/error.gif"/>
            </xsl:when>
          </xsl:choose>
          <xsl:value-of select="@lb"/>
		            <xsl:if test="contains(assertionResult, 'response time is too long')">
            : <xsl:value-of select="@lt"/> ms
          </xsl:if>
        </td>
      </tr>
      <xsl:call-template name="DrawMemo"/>
    </table>
  </xsl:template>

  <xsl:template name="DrawMemo">
    <table style="border-left:1px solid #B7B7B7; border-top:1px solid #B7B7B7; display:none;" class="customtable" cellpadding="0" cellspacing="0" width="100%">
      <tr>
        <td class ="memo-title">
          Request:
        </td>
        <td class ="memo-content">
          <div class="msg">
            <span style="padding-right:5px">
              <xsl:value-of select="method"/>
            </span>
            <span>
              <xsl:value-of select="java.net.URL"/>
            </span>
          </div>
          <div class="hint">
            <xsl:value-of select="method"/> Data:
          </div>
          <div class='msg'>
            <xsl:value-of select="queryString"/>
          </div>
          <div class="hint">RequestHeader:</div>
          <div class='msg'>
            <xsl:value-of select="requestHeader"/>
          </div>
          <div class="msg">
            Time:
            <xsl:variable name="stamp" select="substring(@ts,0,11)+28800"/>
            <xsl:variable name="leapdays" select="31 * 4 * 7 + 30 * 4 * 4 + 28 * 4 + 1"/>
            <!-- Enter loop -->
            <xsl:variable name="days" select="round($stamp div 86400 - 0.5)"/>
            <xsl:variable name="leaps" select="round(($days) div $leapdays + - 0.5)"/>
            <xsl:variable name="dayofleap" select="$days - $leaps * $leapdays - 29"/>
            <xsl:variable name="tmp" select="0 +
                        ($dayofleap &gt; 31) * 31745 +
                        ($dayofleap &gt; 61) * 30721 +
                        ($dayofleap &gt; 92) * 31745 +
                        ($dayofleap &gt; 122) * 30721 +
                        ($dayofleap &gt; 153) * 31745 +
                        ($dayofleap &gt; 184) * 31745 +
                        ($dayofleap &gt; 214) * 30721 +
                        ($dayofleap &gt; 245) * 31745 +
                        ($dayofleap &gt; 275) * 30721 +
                        ($dayofleap &gt; 306) * 31745 +
                        ($dayofleap &gt; 337) * 31745 +
                        ($dayofleap &gt; 365) * 28673 +
                        ($dayofleap &gt; 396) * 31745 +
                        ($dayofleap &gt; 426) * 30721 +
                        ($dayofleap &gt; 457) * 31745 +
                        ($dayofleap &gt; 487) * 30721 +
                        ($dayofleap &gt; 518) * 31745 +
                        ($dayofleap &gt; 549) * 31745 +
                        ($dayofleap &gt; 579) * 30721 +
                        ($dayofleap &gt; 610) * 31745 +
                        ($dayofleap &gt; 640) * 30721 +
                        ($dayofleap &gt; 671) * 31745 +
                        ($dayofleap &gt; 702) * 31745 +
                        ($dayofleap &gt; 730) * 28673 +
                        ($dayofleap &gt; 761) * 31745 +
                        ($dayofleap &gt; 791) * 30721 +
                        ($dayofleap &gt; 822) * 31745 +
                        ($dayofleap &gt; 852) * 30721 +
                        ($dayofleap &gt; 883) * 31745 +
                        ($dayofleap &gt; 914) * 31745 +
                        ($dayofleap &gt; 944) * 30721 +
                        ($dayofleap &gt; 975) * 31745 +
                        ($dayofleap &gt; 1005) * 30721 +
                        ($dayofleap &gt; 1036) * 31745 +
                        ($dayofleap &gt; 1067) * 31745 +
                        ($dayofleap &gt; 1095) * 28673 +
                        ($dayofleap &gt; 1126) * 31745 +
                        ($dayofleap &gt; 1156) * 30721 +
                        ($dayofleap &gt; 1187) * 31745 +
                        ($dayofleap &gt; 1217) * 30721 +
                        ($dayofleap &gt; 1248) * 31745 +
                        ($dayofleap &gt; 1279) * 31745 +
                        ($dayofleap &gt; 1309) * 30721 +
                        ($dayofleap &gt; 1340) * 31745 +
                        ($dayofleap &gt; 1370) * 30721 +
                        ($dayofleap &gt; 1401) * 31745 +
                        ($dayofleap &gt; 1432) * 31745 +
                        ($dayofleap &gt; 1461) * 29697"/>
            <xsl:variable name="monthofleap" select="($tmp mod 1024) + 2"/>
            <xsl:variable name="day" select="$dayofleap - round($tmp div 1024 - 0.5)"/>
            <xsl:variable name="yearofleap" select="round($monthofleap div 12 - 0.5)"/>
            <xsl:variable name="years" select="$leaps * 4 + $yearofleap"/>
            <xsl:variable name="month" select="$monthofleap mod 12"/>
            <xsl:value-of select="$years + 1970"/>-<xsl:value-of select="format-number($month, '00')"/>-<xsl:value-of select="format-number($day, '00')"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="format-number(round($stamp div 3600 - 0.5) mod 24, '00')"/>:<xsl:value-of select="format-number(round($stamp div 60 - 0.5) mod 60, '00')"/>:<xsl:value-of select="format-number($stamp mod 60, '00')"/>.<xsl:value-of select="substring(@ts,11,3)"/>
          </div>
        </td>
      </tr>
      <tr>
        <td class ="memo-title">
          Response:
        </td>
        <td class="memo-content">
          <div class="msg">
            ResponseCode:
            <xsl:choose>
              <xsl:when test="@s='true'">
                <xsl:value-of select="@rc"/>
              </xsl:when>
              <xsl:when test="@s='false'">
                <font color="red">
                  <xsl:value-of select="@rc"/>
                </font>
              </xsl:when>
            </xsl:choose>
          </div>
          <div class="msg">
            ResponseMessage:<xsl:value-of select="@rm"/>
          </div>
          <div class="hint">ResponseData:</div>
          <div class='msg'>
            <xsl:value-of select="responseData"/>
          </div>
        </td>
      </tr>
      <tr>
        <td class ="memo-title">
          SamplerData:
        </td>
        <td class="memo-content">
          <div class='msg'>
            <xsl:value-of select="samplerData"/>
          </div>
        </td>
      </tr>
    </table>
  </xsl:template>
  </xsl:transform>