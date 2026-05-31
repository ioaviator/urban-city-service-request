import os
from azure.storage.blob import BlobServiceClient
from dotenv import load_dotenv
from pathlib import Path

location = Path(__file__).resolve().parent
project_root = location.parent

load_dotenv()

ACCOUNT_KEY = os.getenv('ACCOUNT_KEY')
ACCOUNT_NAME = 'urbancitystorageacct'
CONTAINER_NAME = "bronze"
LOCAL_FILE_PATH = project_root / "urban_service_requests.csv"

BLOB_NAME = "urban_service_requests.csv"

def upload_data():
    try:
        blob_service_client = BlobServiceClient(
            account_url=f"https://{ACCOUNT_NAME}.blob.core.windows.net",
            credential=ACCOUNT_KEY
        )
       
        blob_client = blob_service_client.get_blob_client(container=CONTAINER_NAME, blob=BLOB_NAME)

        print(f" Starting upload: {LOCAL_FILE_PATH}...")

        with open(LOCAL_FILE_PATH, "rb") as data:
            blob_client.upload_blob(
                data,
                overwrite=True,
                # Adjust max_concurrency for even more speed 
                # (uses multiple threads to upload chunks)
                max_concurrency=4 
            )

        print(f"Upload complete! File is now in container: {CONTAINER_NAME}")

    except Exception as e:
        print(f"Failed to upload: {e}")

    return None