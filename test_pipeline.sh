
#!/bin/bash

# Configuration
PROJECT_ID="your_project_id"
BUCKET_NAME="gs://$PROJECT_ID.appspot.com"
EMULATOR_DATA_DIR="./emulator_data"
PRIVATE_KEY_PATH="path/to/serviceAccountKey.json"
FIREBASE_SDK_ADMIN_KEY_DIR="./secrets/$PRIVATE_KEY_PATH"

# Force gsutil to use specific Python version. Should be 3.5.xx or 3.11.xx
export CLOUDSDK_PYTHON="path/to/python35xx-311xx.exe"

# Step 0: Verifying authentication
echo "Verifying authentication..."
gcloud auth list
if [ $? -ne 0 ]; then
    echo "Error: Authentication failed"
    exit 1
fi

# Step 1: Export Firestore data to Google Cloud
echo "Checking bucket access..."
if gsutil ls -b "$BUCKET_NAME" > /dev/null 2>&1; then
    echo "The bucket $BUCKET_NAME exists. Clearing old data..."
    gsutil -m rm -r "$BUCKET_NAME/firestore" || echo "No old data to remove"
else
    echo "Creating bucket..."
    gsutil mb "$BUCKET_NAME" || { echo "Error creating bucket"; exit 1; }
fi

echo "Exporting Firestore data..."
EXPORT_PATH="$BUCKET_NAME/firestore/$(date +%Y%m%d_%H%M%S)"
gcloud firestore export "$EXPORT_PATH" --project="$PROJECT_ID" || { echo "Error exporting Firestore data"; exit 1; }

# Step 2: Download exported data
echo "Creating local directory..."
rm -rf "$EMULATOR_DATA_DIR"
mkdir -p "$EMULATOR_DATA_DIR"

echo "Downloading Firestore data from $EXPORT_PATH..."
gsutil -m cp -r "$EXPORT_PATH/*" "$EMULATOR_DATA_DIR" || { echo "Error downloading data"; exit 1; }

# Verify downloaded data
echo "Verifying downloaded data..."
if [ -z "$(ls -A $EMULATOR_DATA_DIR)" ]; then
    echo "Error: No data downloaded"
    exit 1
else
    echo "Downloaded files:"
fi

# Step 3: Start Firebase Emulators
echo "Starting Firebase Emulators..."
firebase emulators:start --import="$EMULATOR_DATA_DIR" --project="$PROJECT_ID"
