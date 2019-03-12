
FROM adoptopenjdk/openjdk8:x86_64-alpine-jdk8u202-b08

ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME

ENV TOMCAT_MAJOR 9
ENV TOMCAT_VERSION 9.0.13
ENV TOMCAT_SHA512 88fee51bf96bcac7b12c4a49a022b788c6b9668645b2354e9ddcb7405feb3ca18cbcb1a69a349e67ca17d6de11c1b292943ba90b51c949b83d259e98f87ee132



RUN set -eux; \
        wget -O tomcat.tar.gz http://archive.apache.org/dist/tomcat/tomcat-9/v9.0.13/bin/apache-tomcat-9.0.13.tar.gz; \
        tar -xvf tomcat.tar.gz --strip-components=1; \
        rm bin/*.bat; \
        rm tomcat.tar.gz*; \
# https://github.com/docker-library/tomcat/issues/35
        chmod -R +rX .; \
        chmod 777 logs work ;\
# delete tomcat's default contents
        rm -rf /usr/local/tomcat/webapps/manager ; \
        rm -rf /usr/local/tomcat/webapps/docs ; \
        rm -rf /usr/local/tomcat/webapps/examples ; \
        rm -rf /usr/local/tomcat/webapps/host-manager ; \
        rm -rf /usr/local/tomcat/webapps/ROOT/* ; \
        mkdir /var/log/acanthus ; \
        sed -i /usr/local/tomcat/conf/server.xml -e 's/<Connector port="8009" protocol="AJP\/1.3" redirectPort="8443" \/>/<!-- <Connector port="8009" protocol="AJP\/1.3" redirectPort="8443" \/> -->/'


# add application
RUN rm -f /opt/java/openjdk/src.zip

# switch execute user
RUN addgroup acnsuser
RUN adduser -G acnsuser -D acnsuser
RUN echo 'acnsuser:acns_pass' | chpasswd
USER acnsuser


EXPOSE 8080
CMD ["sh","bin/catalina.sh run"]
