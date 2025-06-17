# Use an official Python runtime as a parent image
FROM python:3.11

# Set the working directory inside the container
WORKDIR /app

# Copy over app
COPY sftp_gofetch.py /app

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
    cron \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Python dependencies using pip
RUN pip install --no-cache-dir paramiko

ARG SFTP_NAME

ENV SFTP_NAME=${SFTP_NAME}

# Add a cron job for sftp gofetch
RUN echo "SFTP_NAME=${SFTP_NAME}" >> /etc/environment && \
    echo "1 8,20 * * * /usr/local/bin/python /app/sftp_gofetch.py 2>> /volumes/${SFTP_NAME}/sftp_gofetch_error.log" > /etc/cron.d/sftp_gofetch-script && \
        chmod 0644 /etc/cron.d/sftp_gofetch-script && \
    crontab /etc/cron.d/sftp_gofetch-script

# Start the cron service in the background and tail logs to keep the container alive
CMD cron && tail -f /dev/null
