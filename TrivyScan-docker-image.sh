#!/bin/bash

dockerImageName=$(awk '/^FROM/ {print $2}' Dockerfile)
echo "$dockerImageName"

sudo docker run --rm -v "$WORKSPACE":/root/.cache/ aquasec/trivy:0.18.3 -q image --exit-code 1 --severity HIGH --light "$dockerImageName"
sudo docker run --rm -v "$WORKSPACE":/root/.cache/ aquasec/trivy:0.18.3 -q image --exit-code 1 --severity CRITICAL --light "$dockerImageName"

    # Trivy scan result processing
    exit_code=$?
    echo "Exit Code : '$exit_code'"

    # Check scan results
    if [[ "${exit_code}" == 1 ]]; then
        echo "Image scanning failed. Vulnerabilities found"
        exit 1;
    else
        echo "Image scanning passed. No CRITICAL vulnerabilities found"
    fi;