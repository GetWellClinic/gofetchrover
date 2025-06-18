# Use an official Python runtime as a parent image
FROM python:3.11

# Set the working directory inside the container
WORKDIR /app

# Copy over app
COPY dcare.py /app

COPY logs.sh /usr/local/bin/logs.sh

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
    ca-certificates \
    cron \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Python dependencies using pip
RUN pip install --no-cache-dir requests suds

# Add a cron job for dynacare

# Download lab schedule:
RUN echo "2 8,20 * * * /usr/local/bin/python /app/dcare.py 2>> /volumes/dcare/dcare_error.log" > /etc/cron.d/dcare-cron-jobs && \
    echo "0 2 * * * /usr/local/bin/logs.sh >> /var/log/cron.log 2>&1" >> /etc/cron.d/dcare-cron-jobs && \
    chmod 0644 /etc/cron.d/dcare-cron-jobs && \
    crontab /etc/cron.d/dcare-cron-jobs

# Start the cron service in the background and tail logs to keep the container alive
CMD cron && tail -f /dev/null
