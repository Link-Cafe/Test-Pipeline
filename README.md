
# Test Pipeline

## ONLY FOR DEV AND TEST ENVIRONMENTS

## Overview

Bash script to configure the environment and run the Firebase Local Emulator Suite with Firestore and Auth services enabled.

Use for testing Link Café Platform app in a local environment with data to test the app's functionalities, as well as Firestore security rules.

The script will fetch the most recent snapshot from the production Firestore database, and deploy it to the local emulator. Please, consider that importing users to the local emulator is not supported by the Firebase Local Emulator Suite, so users must be created manually.

However, the script will export after closing the local emulator any changes made in the local emulator back to the machine where the script was executed; reducing user creation to only the first time the script is executed in a new environment.

## Requirements

Ensure you have the following tools installed in your testing environment:

- [Firebase CLI](https://firebase.google.com/docs/cli)
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
- [Python 3.5.xx or 3.11xx](https://www.python.org/downloads/)

## Usage

```bash
./test_pipeline.sh
```