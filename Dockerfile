FROM tomcat:11.0.6-jdk21

ADD https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/1.0.1/jmx_prometheus_javaagent-1.0.1.jar /opt/jmx_exporter/jmx_exporter.jar

RUN mkdir -p /opt/jmx_exporter/config
COPY <<EOF /opt/jmx_exporter/config/config.yml
rules:
- pattern: ".*"
EOF

# Baixa jolokia WAR agent
ADD https://repo1.maven.org/maven2/org/jolokia/jolokia-agent-war-unsecured/2.2.9/jolokia-agent-war-unsecured-2.2.9.war /usr/local/tomcat/webapps/jolokia.war

# Baixa jenkins WAR agent
ADD https://get.jenkins.io/war-stable/2.504.1/jenkins.war /usr/local/tomcat/webapps/jenkins.war

ENV CATALINA_OPTS="-javaagent:/opt/jmx_exporter/jmx_exporter.jar=9400:/opt/jmx_exporter/config/config.yml"

# Expose Tomcat porta
EXPOSE 8080 9400

CMD ["catalina.sh", "run"]
