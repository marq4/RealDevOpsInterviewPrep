FROM ubuntu:22.04

# Set default shell with strict error handling flags:
SHELL ["/bin/bash", "-euo", "pipefail", "-c"]

WORKDIR /root/

# Install basic tools:
RUN apt-get update && apt-get install -y \
    vim curl wget ncdu htop && \
    rm -rf /var/lib/apt/lists/*

COPY fill_disk.sh .
RUN chmod +x fill_disk.sh

ENTRYPOINT ["/bin/bash", "-c", "/root/fill_disk.sh && exec bash"]
