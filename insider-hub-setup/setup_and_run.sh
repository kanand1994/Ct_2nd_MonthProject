#!/usr/bin/env bash
set -euo pipefail

echo "Pulling images from Docker Hub (kanand1994)..."
docker pull kanand1994/insider_es:latest
docker pull kanand1994/insider_kibana:latest
docker pull kanand1994/insider_trainer:latest
docker pull kanand1994/insider_detector:latest

echo "Bringing up services with docker compose..."
docker compose up -d

echo "Waiting a few seconds for services to start..."
sleep 8

echo "Listing running containers:"
docker compose ps

echo ""
echo "To train model (if trainer image supports it) run:"
echo "  docker compose run --rm trainer python train.py"
echo ""
echo "To view detector health:"
echo "  curl -s http://localhost:5000/health | jq || curl -s http://localhost:5000/health"
echo ""
echo "Open Kibana at: http://localhost:5601"
echo "Open Detector dashboard (if available) at: http://localhost:5000/static/index.html"
