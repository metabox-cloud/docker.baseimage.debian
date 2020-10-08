#metaBox Base Image - Debian Jessie
#https://www.github.com/metabox-cloud
FROM bitnami/minideb:jessie
LABEL maintainer="metaBox <contact@metabox.cloud>"
LABEL build="1.0:Jessie"

ENV DEBIAN_FRONTEND="noninteractive" PS1="$(whoami)@$(hostname):$(pwd)$ " CUID=1001 CGID=1001

COPY root/ /

RUN install_packages bash \
                     curl \
					 htop \
					 iftop \
					 wget \
					 nano \
    && curl -Lk -o /tmp/s6-overlay.tar.gz https://github.com/just-containers/s6-overlay/releases/download/v1.21.2.0/s6-overlay-amd64.tar.gz \
    && tar xvfz /tmp/s6-overlay.tar.gz -C / \
    && rm -rf /tmp/s6-overlay.tar.gz \
    && groupadd --system \
             --non-unique \
             --gid ${CGID} \
             app \
    && useradd --system \
            --no-create-home \
            --non-unique \
            --comment "" \
            --uid ${CUID} \
            --home-dir /config \
            --shell /bin/bash \
            -g app \
            app \
    && apt-get purge -qq -y curl \
    && chmod +x /cleanup; sync \
    && /cleanup

ENTRYPOINT ["/init"]
