import json
import logging
import paramiko
import os
import datetime
import shutil

SFTP_NAME = os.getenv('SFTP_NAME')

script_dir = f"/volumes/{SFTP_NAME}"

log_file = f"/volumes/{SFTP_NAME}/{SFTP_NAME}.log"

sftp_config_file = f"{SFTP_NAME}_config.json"

logging.basicConfig(filename=log_file, level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# Create a logger
logger = logging.getLogger(__name__)

# Construct the path to the configuration file
config_path = os.path.join(script_dir, sftp_config_file)

# Load the configuration file
def load_config(config_file=config_path):
    try:
        with open(config_file, 'r') as file:
            return json.load(file)
    except FileNotFoundError:
        logging.error(f"File not found: {config_file}")
    except json.JSONDecodeError:
        logging.error(f"Error decoding JSON from the file: {config_file}")
    except Exception as e:
        logging.error(f"An unexpected error occurred: {e}")

def save_config(config, filepath=config_path):
    try:
        with open(filepath, "w") as f:
            json.dump(config, f, indent=4)
        logging.info(f"Config saved to {filepath}")
    except Exception as e:
        logging.error(f"Failed to save config: {e}")

# Load the configuration
config = load_config()

# Set SFTP credentials and connection details
hostname = config["hostname"]
port =  config["port"] # Default SFTP port
username = config["username"]
password = config["password"]

last_downloaded_file = config["last_downloaded_file"]

# Set the remote directory to download files from and the local directory to save them
remote_dir = config["remote_dir"]
local_dir = config["local_dir"]
mule_upload_dir = config["mule_upload_dir"]
delete_files = config.get("delete_files", False)
delete_files_older_than = config.get("delete_files_older_than", 1000)

def sftp_gofetch_remover():

    try:
        # Connect using SSHClient
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

        ssh.connect(hostname=hostname, port=port, username=username, password=password)
        sftp = ssh.open_sftp()

        # Calculate the deletion threshold
        delete_threshold = datetime.datetime.now() - datetime.timedelta(days=delete_files_older_than)

        # List remote files and delete the old ones
        remote_files = sftp.listdir_attr(remote_dir)

        for file_attr in remote_files:
            file_mtime = datetime.datetime.fromtimestamp(file_attr.st_mtime)
            if file_mtime < delete_threshold:
                remote_file_path = f"{remote_dir.rstrip('/')}/{file_attr.filename}"
                logger.info(f"Deleting: {file_attr.filename} (Last modified: {file_mtime})")
                try:
                    sftp.remove(remote_file_path)
                except Exception as e:
                    logger.error(f"Failed to delete {remote_file_path}: {e}")

    finally:
        # Clean up
        if 'sftp' in locals():
            sftp.close()
        if 'ssh' in locals():
            ssh.close()

def sftp_gofetch_downloader():
    try:
        # Ensure the local directory exists
        os.makedirs(local_dir, exist_ok=True)
        os.makedirs(mule_upload_dir, exist_ok=True)

        # Create an SSH client
        ssh = paramiko.SSHClient()

        # Automatically accept unknown host keys (no manual prompt)
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

        # Connect to the SSH server
        ssh.connect(hostname=hostname, port=port, username=username, password=password)

        # Open an SFTP session
        sftp = ssh.open_sftp()

        remote_files = sftp.listdir_attr(remote_dir)

        last_downloaded_dt = datetime.datetime.strptime(last_downloaded_file, "%Y-%m-%d %H:%M:%S")

        latest_mtime = last_downloaded_dt  # Keep track of latest timestamp

        # Sort by filename (ascending)
        sorted_files = sorted(remote_files, key=lambda f: f.filename)

        # Sort by modification time (ascending)
        #sorted_files = sorted(remote_files, key=lambda f: f.st_mtime)

        for file_attr in sorted_files:
            # Just file names
            filename = file_attr.filename
            if SFTP_NAME == "alphalab":
                filename = f"alpha_{filename}"
            file_mtime = datetime.datetime.fromtimestamp(file_attr.st_mtime)
            if file_mtime > last_downloaded_dt:

                remote_file_path = os.path.join(remote_dir, file_attr.filename)
                local_file_path = os.path.join(local_dir, filename)
                logger.info(remote_file_path)
                
                # Download the file
                try:
                    sftp.get(remote_file_path, local_file_path)
                    logger.info(f"Downloaded: {remote_file_path} -> {local_file_path}")

                    # Update latest_mtime if this file is newer
                    if file_mtime > latest_mtime:
                        latest_mtime = file_mtime

                    try:
                        # Specify the source file path and the destination file path
                        source = local_file_path
                        destination = mule_upload_dir
                        # Copy the file
                        shutil.copy(source, destination)
                        logger.info(f"File copied from {source} to {destination} (incoming mule folder)")
                    except Exception as e:
                        logger.error(f"Failed to copy file from {source} to {destination} (incoming mule folder): {e}")

                except Exception as download_error:
                    logger.error(f"Error downloading {file_attr.filename}: {download_error}")
                    if latest_mtime != last_downloaded_dt:
                        config["last_downloaded_file"] = latest_mtime.strftime("%Y-%m-%d %H:%M:%S")
                        save_config(config)
                    return

        if latest_mtime != last_downloaded_dt:
            config["last_downloaded_file"] = latest_mtime.strftime("%Y-%m-%d %H:%M:%S")
            save_config(config)

    except paramiko.AuthenticationException:
        logger.error("Authentication failed, please check your username and password.")
    except paramiko.SSHException as ssh_error:
        logger.error(f"SSH error occurred: {ssh_error}")
    except Exception as e:
        logger.error(f"Error: {e}")
    finally:
        # Clean up
        if 'sftp' in locals():
            sftp.close()
        if 'ssh' in locals():
            ssh.close()

def main():
    sftp_gofetch_downloader()
    if delete_files and delete_files_older_than > 15:
        sftp_gofetch_remover()


if __name__ == "__main__":
    main()