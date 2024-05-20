FROM jenkins/jenkins:latest

USER root

# Update package repository and install sudo
RUN apt-get update && apt-get install -y sudo wget && rm -rf /var/lib/apt/lists/*

# Manually download and install tini
RUN wget -q https://github.com/krallin/tini/releases/download/v0.19.0/tini-static-amd64 -O /sbin/tini && \
    chmod +x /sbin/tini

# Remove existing jenkins user, create a new one with sudo privileges
RUN userdel jenkins && \
    useradd -m -s /bin/bash jenkins && \
    echo "jenkins ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/jenkins

USER jenkins

# Set the entrypoint to start Jenkins using Tini
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/jenkins.sh"]
