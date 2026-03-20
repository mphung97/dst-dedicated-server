FROM cm2network/steamcmd:latest

# Set environment variables
ENV STEAM_HOME /home/steam/steamcmd
ENV INSTALL_DIR /home/steam/dontstarvetogether_dedicated_server
ENV DONTSTARVE_DIR /home/steam/.klei/DoNotStarveTogether

USER root

RUN mkdir -p "$INSTALL_DIR" "$DONTSTARVE_DIR" && \
    chown -R steam:steam /home/steam

USER steam

RUN "$STEAM_HOME/steamcmd.sh" \
    +force_install_dir "$INSTALL_DIR" \
    +login anonymous \
    +app_update 343050 validate \
    +quit

RUN mkdir -p /home/steam/.klei/DoNotStarveTogether
RUN chown -R steam:steam /home/steam/.klei

COPY --chown=steam:steam Cluster_1 /home/steam/.klei/DoNotStarveTogether/Cluster_1
COPY --chown=steam:steam run_dedicated_servers.sh /home/steam/run_dedicated_servers.sh

RUN chmod +x /home/steam/run_dedicated_servers.sh
RUN chown -R steam:steam /home/steam/.klei

EXPOSE 10889/udp
EXPOSE 10888/udp

ENTRYPOINT ["run_dedicated_servers.sh"]
CMD []
