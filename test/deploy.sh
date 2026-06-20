#!/usr/bin/env bash
set -euo pipefail

APP_DIR="${APP_DIR:-/home/btcfoxman/docker/rsshub}"
APP_USER="${APP_USER:-btcfoxman}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_FILE="${APP_DIR}/docker-compose.yml"

log() {
  printf '[rsshub-deploy] %s\n' "$*"
}

mkdir -p "${APP_DIR}"

log "Syncing deployment compose to ${COMPOSE_FILE}"
cp -f "${SCRIPT_DIR}/docker-compose.yml" "${COMPOSE_FILE}"

if [ ! -f "${APP_DIR}/.env" ]; then
  cp -f "${SCRIPT_DIR}/.env.example" "${APP_DIR}/.env"
  chmod 600 "${APP_DIR}/.env"
fi

chmod 600 "${APP_DIR}/.env"

if id "${APP_USER}" >/dev/null 2>&1; then
  chown -R "${APP_USER}:${APP_USER}" "${APP_DIR}" || true
fi

cd "${APP_DIR}"

log "Validating compose config"
docker compose config >/dev/null

log "Pulling image"
docker compose pull

log "Starting service"
docker compose up -d --remove-orphans

log "Waiting for service health"
for i in $(seq 1 20); do
  if curl -fsS "http://127.0.0.1:1200/" >/dev/null; then
    docker compose ps
    log "Deployment complete"
    exit 0
  fi
  sleep 5
done

log "Health check failed"
docker compose ps || true
docker compose logs --tail=200 rsshub || true
exit 1
