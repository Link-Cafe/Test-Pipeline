
#!/bin/bash

# Configuration
PROJECT_ID="your_project_id"
BUCKET_NAME="gs://$PROJECT_ID.appspot.com"
EMULATOR_DATA_DIR="./emulator_data"
PRIVATE_KEY_PATH="path/to/serviceAccountKey.json"
FIREBASE_SDK_ADMIN_KEY_DIR="./secrets/$PRIVATE_KEY_PATH"

# Force gsutil to use specific Python version. Should be 3.5.xx or 3.11.xx
export CLOUDSDK_PYTHON="path/to/python35xx-311xx.exe"

# Step 1: Export Firestore data to Google Cloud
if gsutil ls -b "$BUCKET_NAME" > /dev/null 2>&1; then
    echo "The bucket $BUCKET_NAME already exists. Overwriting with most recent data."
    gsutil -m rm -r "$BUCKET_NAME/firestore"
else
    echo "Creating bucket and exporting data..."
    gsutil mb "$BUCKET_NAME"
fi

gcloud firestore export "$BUCKET_NAME/firestore" --project="$PROJECT_ID"

# Step 2: Download exported data and store it in "./emulator_data"
echo "Downloading Firestore data from Google Cloud Storage to $EMULATOR_DATA_DIR..."
mkdir -p "$EMULATOR_DATA_DIR"
gsutil -m cp -r "$BUCKET_NAME/firestore" "$EMULATOR_DATA_DIR"

# Step 3: Starts Firebase Local Emulator Suite
echo "Starts Firebase Local Emulator Suite..."
firebase emulators:start --import "$EMULATOR_DATA_DIR" --project="$PROJECT_ID" --export-on-exit="$EMULATOR_DATA_DIR"
