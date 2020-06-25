FROM debian:buster-slim

ARG STEAMCMD_URL=https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
ARG DSTLOCATION=dontstarve_togather_dedicated
ARG USER=steam
ARG CLUSTER_TOKEN

RUN useradd -m ${USER}
RUN dpkg --add-architecture i386 \
    && apt update \
    && apt install lib32gcc1 lib32stdc++6 libcurl4-gnutls-dev:i386 wget tmux vim -y

RUN wget ${STEAMCMD_URL} -O /tmp/steamcmd_linux.tar.gz \
    && mkdir ~/steamcmd \
    && tar -xzf /tmp/steamcmd_linux.tar.gz -C ~/steamcmd \
    && mkdir ~/${DSTLOCATION} \
    && ~/steamcmd/steamcmd.sh +login anonymous +force_install_dir ~/${DSTLOCATION} +app_update 343050 validate +quit \
    && chown -R steam:steam /home/steam

EXPOSE 10999-11000/udp 12346-12347/udp

ENV DSTLOCATION=${DSTLOCATION}
ENV USER=${USER}

CMD chown -R steam:steam /home/${USER}/.klei \
    && chmod -R 755 /home/${USER}/.klei \
    && ls -la /home/steam \
    && cd ~/${DSTLOCATION}/bin \
    && tmux -S socket new-session -d -s dst -n Master \
    && tmux -S socket new-window -t dst -n Caves \
    && tmux -S socket send-keys -t dst:Master "./dontstarve_dedicated_server_nullrenderer -console -shard Master" Enter \
    && tmux -S socket send-keys -t dst:Caves "./dontstarve_dedicated_server_nullrenderer -console -shard Caves" Enter \
    && tmux -S socket attach -t dst:Master

