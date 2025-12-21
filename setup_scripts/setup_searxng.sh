#!/bin/bash

# --- 1. Install System Dependencies ---
echo "Pulling searxng latest docker image"
docker pull docker.io/searxng/searxng:latest

echo "Creating directories for configuration and persistent data"
mkdir -p ~/.searxng/config ~/.searxng/data

echo "Starting up docker container"
docker run --name searxng -d -p 8888:8080 -v "${HOME}/.searxng/config/:/etc/searxng/" -v "${HOME}/.searxng/data/:/var/cache/searxng/" docker.io/searxng/searxng:latest
