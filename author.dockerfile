FROM aem-base
MAINTAINER Mayara Gouveia

# AEM VERSION, e.g., 6.4
ARG version

# Copies required build media
COPY AEM_6.4_Quickstart.jar /aem/AEM_6.4_Quickstart.jar
COPY license.properties /aem/license.properties
COPY aem-author/postInstallHook.py /aem/postInstallHook.py

# Extracts AEM
WORKDIR /aem
RUN java -XX:MaxPermSize=256m -Xmx2048M -jar AEM_6.4_Quickstart.jar -unpack -r nosamplecontent

# Add customised log file, to print the logging to standard out.
COPY aem-author/org.apache.sling.commons.log.LogManager.config /aem/crx-quickstart/install/

# Installs AEM
WORKDIR /
RUN chmod +x /aem/aemInstaller.py
RUN python /aem/aemInstaller.py -i /aem/AEM_6.4_Quickstart.jar -r author -p 4502

EXPOSE 4502 8000
ENTRYPOINT ["/aem/crx-quickstart/bin/quickstart"]
