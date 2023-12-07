#!/bin/bash

# Instructions: Before running this script, export AWS credentials:
# export AWS_ACCESS_KEY_ID="your-access-key-id"
# export AWS_SECRET_ACCESS_KEY="your-secret-access-key"
# export AWS_DEFAULT_REGION="your-default-region"

RUN_MODE="restore"
BACKUP_PATH=${BACKUP_PATH:-./backup.tar.gz}

IS_MIGRATE=${IS_MIGRATE:-false}
PORT_CLIENT_ID=${PORT_CLIENT_ID:-}

# S3 bucket name and region (modify accordingly)
S3_BUCKET_NAME="your-s3-bucket-name"
S3_BUCKET_REGION="your-s3-bucket-region"

if [ $IS_MIGRATE != true ] ; then
    # Download the backup tar file from S3
    aws s3 cp s3://$S3_BUCKET_NAME/$BACKUP_PATH . --region $S3_BUCKET_REGION
    tar -xvzf ${BACKUP_PATH} ./bk*
fi

export PORT_NEW_CLIENT_ID=${PORT_CLIENT_ID}
export PORT_NEW_CLIENT_SECRET=${PORT_CLIENT_SECRET}
export RUN_MODE=$RUN_MODE
python3 main.py

if [ $IS_MIGRATE != true ] ; then
    rm -rf ./bk*
fi
