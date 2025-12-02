# CTF Platform (Docker Hub images)

This repository contains helper files to run a CTF platform using pre-built Docker Hub images:
- `kanand1994/ctf_db:latest`  — Postgres DB image for the CTF
- `kanand1994/ctf_web:latest` — Flask web application image
- `kanand1994/ctf_nginx:latest`— Nginx reverse-proxy image

> This project assumes those images are public on Docker Hub and ready to run. The compose file maps the web app to port `8000` and nginx to port `80`.

## Files included
- `docker-compose.yml` — starts `db`, `web`, and `nginx` services from Docker Hub images
- `.env.example` — environment variables to copy to `.env`
- `run.ps1` — PowerShell script to pull images and start stack (Windows)
- `run.sh` — Bash script to pull images and start stack (Linux/macOS)
- `challenges/` — place challenge files here if desired (optional)
- `README.md` — this file

## Quick start (Linux / macOS)

1. Copy `.env.example` to `.env` and edit if you want:
   ```bash
   cp .env.example .env
   ```

2. Pull images from Docker Hub (optional — `docker compose up` will pull automatically):
   ```bash
   docker pull kanand1994/ctf_db:latest
   docker pull kanand1994/ctf_web:latest
   docker pull kanand1994/ctf_nginx:latest
   ```

3. Start the stack:
   ```bash
   docker compose up -d
   ```

4. (Optional) Seed the database. If the `ctf_web` image contains a `scripts/seed_db.py` script (common), run:
   ```bash
   docker compose run --rm web python -m scripts.seed_db
   ```
   - If the image exposes a different seeding path, adapt the command accordingly.
   - If you used `docker compose up` and the `web` container already ran, you can run the seed command the same way — it will connect to the running `db` container.

5. Open the site in your browser:
   - Nginx at: http://localhost/
   - Direct web app at: http://localhost:8000/

6. To stop and remove containers:
   ```bash
   docker compose down -v
   ```

## Quick start (Windows PowerShell)

Open PowerShell (as a regular user or admin) in this folder and run:

```powershell
# copy env example to .env
Copy-Item .env.example -Destination .env -Force

# optionally pull images
docker pull kanand1994/ctf_db:latest
docker pull kanand1994/ctf_web:latest
docker pull kanand1994/ctf_nginx:latest

# start services
docker compose up -d

# run DB seed (if image contains seed script)
docker compose run --rm web python -m scripts.seed_db

# open http://localhost/ in your browser
```

## Troubleshooting tips

- If containers fail to start: check logs:
  ```bash
  docker compose logs --tail=200 --follow
  ```
- If `web` fails with Python import errors, rebuild or inspect installed packages:
  ```bash
  docker compose run --rm web python -c "import sys, pkgutil; print(sys.version); print([m.name for m in pkgutil.iter_modules()])"
  ```
- If `psycopg2` errors appear during runtime, the DB image must provide `libpq` and `pg_config`. Use `psycopg2-binary` in development or install system deps in the web image.

## Notes

- This helper repo only wires together three Docker Hub images. If you need the full app source (to edit templates, change flags, or add challenges), use the original source code repository and build the web image locally.
- Place challenge files (forensics files, binaries) in `./challenges/` locally — the `docker-compose.yml` maps them into `/app/challenges` in the `web` container (read-only).

If you want, I can also:
- Add an `docker-compose.override.yml` for local development using your local `web/` folder instead of the Hub image.
- Create a healthcheck for the `web` service to let nginx wait until the app is ready.
