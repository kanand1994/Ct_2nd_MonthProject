#!/usr/bin/env bash
set -euo pipefail
echo "Pulling images from Docker Hub..."
docker pull kanand1994/ctf_db:latest
docker pull kanand1994/ctf_web:latest
docker pull kanand1994/ctf_nginx:latest

echo "Starting services with docker compose..."
docker compose up -d

echo
echo "If the web container requires DB seeding, run:"
echo "  docker compose run --rm web python -m scripts.seed_db"
