FROM ubuntu:latest

# Use secrets to authenticate
RUN --mount=type=secret,id=tusername --mount=type=secret,id=tpassword \
    echo Connection string: Username=$(cat /run/secrets/tusername) Password=$(cat /run/secrets/tpassword)



# Install necessary packages
RUN apt-get update && \
    apt-get install -y build-essential cmake gdb openssh-server && \
    rm -rf /var/lib/apt/lists/*

# Create a user for SSH
RUN useradd -m -s /bin/bash dockeruser && \
    echo 'dockeruser:dockeruser' | chpasswd && \
    mkdir /home/dockeruser/.ssh && \
    chown dockeruser:dockeruser /home/dockeruser/.ssh && \
    chmod 700 /home/dockeruser/.ssh

# Setup SSH
RUN mkdir /var/run/sshd && \
    sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config && \
    echo 'dockeruser ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# Expose SSH port
EXPOSE 22

# Start SSH service
CMD ["/usr/sbin/sshd", "-D"]
