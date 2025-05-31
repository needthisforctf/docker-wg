FROM debian:bookworm

RUN apt update && apt install -y --no-install-recommends \
    software-properties-common \
    iptables \
    curl \
    iproute2 \
    ifupdown \
    iputils-ping \
    wireguard \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ENV SCRIPT_VERSION=1.0.4
# This can be overrided in
# docker-compose file
# and systemd service file
ENV WG_INT_NAME=wg0
ENV WG_INT_PORT=51820

COPY scripts/* /usr/local/bin
ENTRYPOINT ["/usr/local/bin/wg-run.sh"]
CMD []
