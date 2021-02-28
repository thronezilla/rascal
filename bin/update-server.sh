#!/bin/bash
set -e

rcon_cmd() {
  rcon \
    -a "${RCON_HOST}:${RCON_PORT}" \
    -p "${RCON_PASSWORD}" \
    "$@"
}

git fetch origin main
git checkout FETCH_HEAD

if [[ "${GAME_SERVER_ENV}" == "development" ]]; then
  local current_map = rcon_cmd "host_map" | grep -Po '\w+(?=.bsp)'
  rcon_cmd "say Server update triggered."
  sleep 1s
  rcon_cmd "changelevel ${current_map}"
fi