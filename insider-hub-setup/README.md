# Insider Threat — Docker Hub Compose Setup

This repository provides a minimal setup to run the Insider Threat Detection stack using pre-built images
hosted at Docker Hub under `kanand1994/*`.

Included files:
- `docker-compose.yml` — composes 4 services: `elasticsearch`, `kibana`, `trainer`, `detector`.
- `setup_and_run.sh` — helper script to pull images and start the stack.
- `data/` — local folder (created at runtime) to share model/artifacts between trainer and detector.

## Prerequisites
- Docker Engine (20.x+) and Docker Compose plugin.
- Recommended: 4+ GB RAM available for Elasticsearch/Kibana.
- (Optional) `jq` for pretty JSON in the terminal.

## Quick start (Linux / macOS / WSL)
1. Unzip or clone this folder and `cd` into it.
2. Make script executable (if not already):
   ```bash
   chmod +x setup_and_run.sh
   ```
3. Run the helper script:
   ```bash
   ./setup_and_run.sh
   ```

This will:
- `docker pull` the four `kanand1994/*` images,
- start the stack with `docker compose up -d`,
- print helpful follow-ups.

## Quick start (Windows PowerShell)
Open PowerShell as Administrator and run:

```powershell
# pull images
docker pull kanand1994/insider_es:latest
docker pull kanand1994/insider_kibana:latest
docker pull kanand1994/insider_trainer:latest
docker pull kanand1994/insider_detector:latest

# start compose
docker compose up -d

# check containers
docker compose ps
```

To train the model (if trainer supports it):
```powershell
docker compose run --rm trainer python train.py
```

To test the detector using PowerShell:
```powershell
Invoke-RestMethod -Method Post http://localhost:5000/event `
  -Headers @{ "Content-Type"="application/json" } `
  -Body '{"user_id":10,"hour":14,"dst_bytes":2000,"file_write_count":5,"access_count":10}'
```

## What to expect
- Elasticsearch will be reachable at `http://localhost:9200`.
- Kibana UI at `http://localhost:5601`.
- Detector API at `http://localhost:5000` (health endpoint at `/health`, event endpoint at `/event`).
- Trainer can be run manually to build a model into `./data/model.joblib` (if the trainer image exposes a `train.py`).

## Troubleshooting
- **Elasticsearch fails to start**: increase memory, or tune `ES_JAVA_OPTS` in `docker-compose.yml`. Verify Docker has enough resources.
- **Model not loaded in detector**: ensure `./data/model.joblib` exists on host and volume mapping `./data:/app/data` is present in compose. Run trainer to create it:
  ```bash
  docker compose run --rm trainer python train.py
  docker compose restart detector
  docker compose logs -f detector
  ```
- **PowerShell curl issues**: Use `Invoke-RestMethod` as shown above.
- **Kibana "no index pattern"**: create an index pattern for `insider-events` or `insider-synthetic` in Kibana Management → Stack Management → Index Patterns.

## Notes
- These images appear to be published by `kanand1994` (as shown in your screenshot). This compose file pulls `:latest` tags. If you prefer specific tags/digests, edit `docker-compose.yml`.
- For production use secure Elasticsearch (TLS + auth), persist ES data to durable volume and tune JVM heap sizes.
