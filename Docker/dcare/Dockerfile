# Use an official Python runtime as a parent image
FROM python:3.11

# Set the working directory inside the container
WORKDIR /app

# Copy over app
COPY dcare.py /app

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

# Download labs every 8 hrs:
# RUN echo "2 */8 * * * /usr/local/bin/python /app/dcare.py 2>> /volumes/dcare/dcare_error.log" > /etc/cron.d/dcare-script && \
# Download lab schedule:
RUN echo "2 8,20 * * * /usr/local/bin/python /app/dcare.py 2>> /volumes/dcare/dcare_error.log" > /etc/cron.d/dcare-script && \
    chmod 0644 /etc/cron.d/dcare-script && \
    crontab /etc/cron.d/dcare-script

# Start the cron service in the background and tail logs to keep the container alive
CMD cron && tail -f /dev/null
