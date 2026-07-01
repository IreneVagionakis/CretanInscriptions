FROM eclipse-temurin:8-jdk-jammy

ENV APP_HOME=/CretanInscriptions \
    JAVA_XMS=256m \
    JAVA_XMX=2560m \
    JAVA_MAX_METASPACE=384m \
    ANT_OPTS_EXTRA="-XX:+UseContainerSupport -Djava.awt.headless=true -Dfile.encoding=UTF-8"

WORKDIR ${APP_HOME}

RUN groupadd --system cretan \
    && useradd --system --gid cretan --home-dir ${APP_HOME} --shell /usr/sbin/nologin cretan

COPY --chown=cretan:cretan . ${APP_HOME}

RUN sed -i 's/\r$//' build.sh sw/ant/bin/ant sw/ant/bin/antRun \
    && chmod +x build.sh sw/ant/bin/ant sw/ant/bin/antRun \
    && mkdir -p sw/jetty/logs sw/jetty/temp webapps/openrdf-sesame/app_dir webapps/ROOT/WEB-INF/logs \
    && chown -R cretan:cretan sw/jetty/logs sw/jetty/temp webapps/openrdf-sesame/app_dir webapps/ROOT/WEB-INF/logs

USER cretan

EXPOSE 9999

HEALTHCHECK --interval=30s --timeout=5s --start-period=90s --retries=3 \
    CMD bash -c '</dev/tcp/127.0.0.1/9999'

CMD ["./build.sh"]