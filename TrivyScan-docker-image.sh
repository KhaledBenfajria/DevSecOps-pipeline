#!/bin/bash

dockerImageName=$(awk '/^FROM.* AS build/ {image=$2} /^FROM/ && !/ AS / {image=$2} END {print image}' Dockerfile)
echo "$dockerImageName"

docker run --rm -v "$WORKSPACE":/"$USER"/.cache/ aquasec/trivy:0.37.3 -q image --exit-code 1 --severity HIGH --light "$dockerImageName"
docker run --rm -v "$WORKSPACE":/"$USER"/.cache/ aquasec/trivy:0.37.3 -q image --exit-code 1 --severity CRITICAL --light "$dockerImageName"

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