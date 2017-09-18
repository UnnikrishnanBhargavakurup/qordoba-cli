#!/bin/bash

###########
# 
# start_container.sh
# 
# Script that runs the string-extractor docker container.
# 
# Output is a list of strings and their locations within the given input files
# 
###########

PROJECT=qordoba-devel
IMAGE_NAME=string-extractor
IMAGE_VERSION=0.0.2

INPUT_PATH=$1
INPUT_FILE=.
WORK_DIR=/work_dir
OUTPUT_PATH=$2
OUTPUT_FILE=string-literals.csv

#echo the variables

echo inputpath: $INPUT_PATH
echo outputpath: $OUTPUT_PATH

# Pull latest image
gcloud docker -- pull gcr.io/${PROJECT}/${IMAGE_NAME}:${IMAGE_VERSION}

# Create a container, but don't start it
docker create -t --name ${IMAGE_NAME} gcr.io/${PROJECT}/${IMAGE_NAME}:${IMAGE_VERSION} -d ${WORK_DIR}/${INPUT_FILE} -o ${WORK_DIR}/${OUTPUT_FILE}

# Copy the input files into the container
docker cp ${INPUT_PATH} ${IMAGE_NAME}:${WORK_DIR}

# Run the container
docker start -i ${IMAGE_NAME}

# Get outfile
docker cp ${IMAGE_NAME}:${WORK_DIR}/${OUTPUT_FILE} ${OUTPUT_PATH}

# Remove the container
docker rm ${IMAGE_NAME}
