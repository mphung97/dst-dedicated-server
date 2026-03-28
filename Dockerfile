FROM cm2network/steamcmd:latest

# Set environment variables
ENV STEAM_HOME=/home/steam/steamcmd \
    INSTALL_DIR=/home/steam/dontstarvetogether_dedicated_server \
    DONTSTARVE_DIR=/home/steam/.klei/DoNotStarveTogether

USER root

# Install dependencies, create directories, and set permissions
RUN apt-get update && apt-get install -y --no-install-recommends libcurl4-gnutls-dev && \
    mkdir -p "$INSTALL_DIR" "$DONTSTARVE_DIR" && \
    chown -R steam:steam /home/steam && \
    rm -rf /var/lib/apt/lists/*

USER steam

RUN "$STEAM_HOME/steamcmd.sh" \
    +@ShutdownOnFailedCommand 1 \
    +@NoPromptForPassword 1 \
    +force_install_dir "$INSTALL_DIR" \
    +login anonymous \
    +app_update 343050 validate \
    +quit

COPY --chown=steam:steam run_dedicated_servers.sh /home/steam/run_dedicated_servers.sh

RUN chmod +x /home/steam/run_dedicated_servers.sh

EXPOSE 10889/udp 10888/udp

ENTRYPOINT ["/home/steam/run_dedicated_servers.sh"]
CMD []
