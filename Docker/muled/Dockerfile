# Use a base image
FROM ubuntu:24.04

# Enable i386 architecture and install necessary packages including xz-utils
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y \
    wget \
    dpkg \
    git \
    libasound2:i386 \
    libc6:i386 \
    libfreetype6:i386 \
    libfontconfig1:i386 \
    libx11-6:i386 \
    libxext6:i386 \
    libxi6:i386 \
    libxrender1:i386 \
    libxtst6:i386 \
    zlib1g:i386 \
    fonts-dejavu \
    java-common \
    xz-utils \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY ./jre/openlogic-openjdk-jre-8u422-b05-linux-x32.deb /tmp/openlogic-openjdk-jre.deb

COPY ./app/app-start.sh /app/app-start.sh

# Install the .deb package using dpkg
RUN dpkg -i /tmp/openlogic-openjdk-jre.deb && \
    apt-get install -f -y && \
    rm -f /tmp/openlogic-openjdk.deb && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Verify the Java installation
RUN java -version

# Define environment variables for Mule and Java
ENV JAVA_HOME=/usr/lib/jvm/openlogic-openjdk-8-hotspot-jre-i386
ENV MULE_HOME=/mule/mule-1.3.3
ENV PATH=$MULE_HOME/bin:$PATH

CMD ["/app/app-start.sh"]
