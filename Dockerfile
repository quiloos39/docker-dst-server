FROM debian:buster-slim

ARG STEAMCMD_URL=https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
ARG DSTLOCATION=dontstarve_togather_dedicated
ARG USER=steam

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV USER ${USER}
ENV DSTLOCATION ${DSTLOCATION}

RUN useradd -m ${USER}

RUN dpkg --add-architecture i386 \
    && apt update \
    && apt install -y \
    lib32gcc1 \
    lib32stdc++6 \
    libcurl4-gnutls-dev:i386 \
    wget \
    locales

RUN wget ${STEAMCMD_URL} -O /tmp/steamcmd_linux.tar.gz \
    && mkdir /opt/steamcmd \
    && tar -xzf /tmp/steamcmd_linux.tar.gz -C /opt/steamcmd \
    && mkdir /home/${USER}/${DSTLOCATION} \
    && /opt/steamcmd/steamcmd.sh +login anonymous +force_install_dir /home/${USER}/${DSTLOCATION} +app_update 343050 validate +quit \
    && chown -R ${USER}:${USER} /home/${USER}/${DSTLOCATION}

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

WORKDIR /home/${USER}/${DSTLOCATION}/bin
EXPOSE 10999-11000/udp 12346-12347/udp

ENTRYPOINT [ "docker-entrypoint.sh" ]

