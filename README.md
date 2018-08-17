# Jmeter HTML Report by XSL

## 1. Install [Jmeter](http://jmeter.apache.org/) and [xsltproc](http://xmlsoft.org/XSLT/xsltproc2.html) 
## 2. Run your jmeter case
## 3. Usage
    xsltproc /xsl/jmeter-results-report-apitest.xsl JMETER_TC.jtl > JMETER_TC.html

![JMeter HTML Report](./xsl/report/s1.png "HTML Report")

    xsltproc /xsl/jmeter-results-report-loadtest.xsl JMETER_TC.jtl > JMETER_TC.html

![JMeter HTML Report](./xsl/report/s2.png "HTML Report")


    xsltproc /xsl/JMeterLogParser.xsl JMETER_TC.jtl > JMETER_TC.html

![JMeter HTML Report](./xsl/report/s3.png "HTML Report")




