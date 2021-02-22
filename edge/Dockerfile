ARG BUILD_FROM
FROM ${BUILD_FROM}

# Base env settings
ENV \
    LANG="en_US.utf8" \
    THINGENGINE_HOME="/data/almond-server" \
    THINGENGINE_HOST_BASED_AUTHENTICATION="local-ip"

WORKDIR /opt/almond
ARG ALMOND_VERSION

RUN adduser --disabled-password almond && \
   chown almond:almond /opt/almond
WORKDIR /opt/almond

RUN \
    set -x \
    && apk add --no-cache \
        nodejs \
        npm \
        yarn \
        nginx \
        unzip \
        blas \
        sqlite \
        coreutils \
        libcanberra \
        libpulse \
        pulseaudio \
        gettext \
        zip \
        sudo \
    && apk add --no-cache --virtual .build-dependencies \
        build-base \
        blas-dev \
        libcanberra-dev \
        pulseaudio-dev \
        git \
        linux-headers \
        sqlite-dev \
        pkgconf \
        python2 \
    \
    && npm config set unsafe-perm \
    \
    && sudo -u almond git clone -b "${ALMOND_VERSION}" --depth 1 \
        "https://github.com/stanford-oval/almond-server" . && \
    sudo -u almond npm ci && \
    sudo -u almond npm install --no-package-lock --ignore-scripts snowboy && \
    cd node_modules/snowboy/ && \
    sudo -u almond PYTHON=python2 npx node-pre-gyp clean configure && \
    sudo -u almond make -C build/ && \
    rm -fr /home/almond/.cache && \
    rm -fr /home/almond/.npm && \
    mkdir /home/almond/.cache \
    && apk del --no-cache \
        .build-dependencies \
    \
    && rm -rf \
        /opt/almond/.[!.]* \
        /root/.cache \
        /root/.config \
        /tmp/.[!.]* \
        /tmp/* \
        /usr/local/share/.cache \
        /usr/local/share/.config

COPY rootfs /
