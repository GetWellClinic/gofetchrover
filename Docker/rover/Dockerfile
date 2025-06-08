# Use an official Python runtime as a parent image
FROM python:3.11

# Set the working directory inside the container
WORKDIR /app

# Copy over app
COPY api_rover.py /app

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
    ca-certificates \
    cron \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Python dependencies using pip
RUN pip install --no-cache-dir requests

# Add a cron job for rover

# Download labs every 5 minutes:
# RUN echo "*/5 * * * * /usr/local/bin/python /app/api_rover.py 2>> /volumes/rover/rover_error.log" > /etc/cron.d/api_rover-script && \
# Download labs every 8 hrs:
RUN echo "* */8 * * * /usr/local/bin/python /app/api_rover.py 2>> /volumes/rover/rover_error.log" > /etc/cron.d/api_rover-script && \
    chmod 0644 /etc/cron.d/api_rover-script && \
    crontab /etc/cron.d/api_rover-script

# Start the cron service in the background and tail logs to keep the container alive
CMD cron && tail -f /dev/null
