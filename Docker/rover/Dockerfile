# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /app

# Copy over app
COPY api_rover.py /app

# Install system dependencies (cron, pip, python3-requests)
RUN apt-get update && \
    apt-get install -y \
    cron \
    python3-pip \
    python3-requests && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Python dependencies using pip
RUN pip3 install --no-cache-dir requests

# Add a cron job for rover
RUN echo "*/5 * * * * python3 /app/api_rover.py" > /etc/cron.d/api_rover-script && \
    chmod 0644 /etc/cron.d/api_rover-script && \
    crontab /etc/cron.d/api_rover-script

# Start the cron service in the background and tail logs to keep the container alive
CMD cron && tail -f /dev/null
