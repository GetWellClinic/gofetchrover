# Credit: Original script by Dr. Dr. Ian Pun, adapted for Rover System Downloader
import json
import ssl
import os
import logging
from suds.client import Client

def load_config(config_file):
    with open(config_file, 'r') as f:
        return json.load(f)

def main():
    # Load config
    config_file = "/volumes/dcare/dynacare_config.json"
    config = load_config(config_file)

    # Set up logging
    logging.basicConfig(filename="/volumes/dcare/dcare.log", level=logging.INFO,
                        format='%(asctime)s - %(levelname)s - %(message)s')
    # Create a logger
    logger = logging.getLogger(__name__)

    logger.info("Script is running")

    # Handle SSL certificate verification error
    if hasattr(ssl, '_create_unverified_context'):
        ssl._create_default_https_context = ssl._create_unverified_context

    # Extract URLs and credentials from config
    authURL = config['authURL']
    batchURL = config['batchURL']
    user = config['user']
    pw = config['pw']
    save_dir = config['save_dir']

    # Ensure the save directory exists
    if not os.path.exists(save_dir):
        os.makedirs(save_dir)

    # Log in to GDML Webservice
    logging.info("Logging into GDML Webservice ----")
    try:
        authClient = Client(authURL)
        logOnSuccess = authClient.service.Login(username=user, password=pw)

        if logOnSuccess:
            logging.info("Login successful!")
            batchClient = Client(batchURL)
            batchClient.options.transport.cookiejar = authClient.options.transport.cookiejar
            batchFiles = batchClient.service.FetchAvailableBatchFiles()

            if len(batchFiles.BatchInfo) > 0:
                logging.info(f"{len(batchFiles.BatchInfo)} new file{'s' if len(batchFiles.BatchInfo) > 1 else ''} to download!")
                for batchInfo in batchFiles.BatchInfo:
                    try:
                        logging.info(f"Downloading {batchInfo.BatchName}...")
                        thisFile = batchClient.service.FetchBatchFile(batchInfo.Id)

                        # Save the file in binary mode
                        with open(os.path.join(save_dir, str(batchInfo.BatchName)), "wb") as f:
                            f.write(thisFile)

                        batchClient.service.AcknowledgeDownloadedBatchFile(batchInfo.Id, True)
                        logging.info(f"Successfully downloaded {batchInfo.BatchName}")

                    except IOError as e:
                        logging.error(f"Failed (IOError): {e}")
                        batchClient.service.AcknowledgeDownloadedBatchFile(batchInfo.Id, False)
                    except Exception as e:
                        logging.error(f"Failed (General Error): {e}")
                        batchClient.service.AcknowledgeDownloadedBatchFile(batchInfo.Id, False)
            else:
                logging.info("No new files.")

            try:
                authClient.service.Logout()
                logging.info("Logged out successfully.")
            except Exception as e:
                logging.error(f"Error during logout: {e}")
                
        else:
            logging.error("Login failed.")
    except Exception as e:
        logging.error(f"Error during login or fetching batches: {e}")

    logging.info("End of script")

if __name__ == "__main__":
    main()
