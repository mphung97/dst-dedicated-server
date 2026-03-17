FROM cm2network/steamcmd:latest

# Set environment variables
ENV STEAM_HOME /home/steam/steamcmd
ENV APP_ID 343050
ENV INSTALL_DIR /app/server
ENV CONFIG_DIR /app/config

# Create directory structure
RUN mkdir -p "$INSTALL_DIR" && \
    chown -R steam:steam /app

# Switch to steam user for security
USER steam:steam

# Install DST server
RUN "$STEAM_HOME/steamcmd.sh" \
    +force_install_dir "$INSTALL_DIR" \
    +login anonymous \
    +app_update "$APP_ID" validate \
    +quit

# Switch back to root for setup
USER root:root

# Copy startup script
COPY --chown=steam:steam docker/container-start.sh /app/container-start.sh
RUN chmod +x /app/container-start.sh

# Copy config helper script
COPY --chown=steam:steam docker/config-helper.sh /app/config-helper.sh
RUN chmod +x /app/config-helper.sh

# Switch to steam user for runtime
USER steam:steam

# Set working directory
WORKDIR /app

# Expose ports
EXPOSE 10999/udp 8765/tcp

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD pgrep -f "dontstarve_dedicated_server" > /dev/null || exit 1

# Entrypoint
ENTRYPOINT ["/app/container-start.sh"]
CMD []
