# PowerShell helper to pull images and start the CTF stack
Write-Host "Pulling images from Docker Hub..."
docker pull kanand1994/ctf_db:latest
docker pull kanand1994/ctf_web:latest
docker pull kanand1994/ctf_nginx:latest

Write-Host "Starting services with docker compose..."
docker compose up -d

Write-Host "If the web container requires DB seeding, run:"
Write-Host "docker compose run --rm web python -m scripts.seed_db"
