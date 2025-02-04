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
    python3 \
    python3-pip \
    python3-requests \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Define the working directory
WORKDIR /tmp

# Download and install Maven
RUN wget https://downloads.apache.org/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz && \
    tar -xzf apache-maven-3.9.9-bin.tar.gz && \
    mv apache-maven-3.9.9 /opt/maven && \
    ln -s /opt/maven/bin/mvn /usr/bin/mvn && \
    rm -f apache-maven-3.9.9-bin.tar.gz

# Define environment variables for Maven
ENV MAVEN_HOME=/opt/maven
ENV PATH=$MAVEN_HOME/bin:$PATH

# Define the working directory for Java installation
WORKDIR /tmp

# Copy the .deb file into the container
COPY openlogic-openjdk-8u422-b05-linux-x32-deb.deb .

# Install the .deb package using dpkg
RUN dpkg -i openlogic-openjdk-8u422-b05-linux-x32-deb.deb || true && \
    apt-get install -f -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Verify the Java installation
RUN java -version

# Define the working directory for your application
WORKDIR /app

# Copy your application files to the container (if you have any)
COPY . /app

# Clone the Git repository
RUN git clone git://git.code.sf.net/p/oscarmcmaster/hl7_file_management oscarmcmaster-hl7_file_management

# Create the required directories
RUN mkdir -p /app/incomingHL7/lifelabs && \
    mkdir -p /app/oscar-keypairs && \
    mkdir -p /app/errorHL7 && \
    mkdir -p /app/completedHL7 && \
    mkdir -p /app/rover/incomingHL7 && \
    mkdir -p /app/rover/xml

# Copy the Key file into the container
COPY lifelabs-keyPair.key /app/oscar-keypairs

# Copy the Mule config file into the container
COPY LabProperties.properties /app/oscarmcmaster-hl7_file_management/src/main/resources

# Copy the Mule patch file into the container
COPY Uploader.java /app/oscarmcmaster-hl7_file_management/src/main/java/org/mule/custom/

# Define environment variables for Mule and Java
ENV JAVA_HOME=/usr/lib/jvm/openlogic-openjdk-8-hotspot-i386
ENV MULE_HOME=/app/oscarmcmaster-hl7_file_management/mule-1.3.3
ENV PATH=$MULE_HOME/bin:$PATH

# Run the Mule installation script
WORKDIR /app/oscarmcmaster-hl7_file_management/utils

# Define the command to run your application (this can be changed as needed)
CMD ["bash"]
