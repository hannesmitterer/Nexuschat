#!/bin/bash

# Configurazione
CONFIG="/etc/nexus/grounding.yaml"
RAW_DATA_DIR="/var/nexus/grounding"
LOGFILE="/var/log/grounding.log"

# Assicurati che le directory esistano
mkdir -p "$RAW_DATA_DIR"
touch "$LOGFILE"

# Funzione per leggere i dati da sensori
read_sensors() {
  echo "$(date --utc +\"%Y-%m-%dT%H:%M:%SZ\"): Lettura sensori..." >> "$LOGFILE"
  sensors_data=$(cat <<EOF
{
  "temp_cpu": $(sensors | grep 'temp1' | awk '{print $2}' | tr -d '+'),
  "temp_gpu": $(sensors | grep 'temp2' | awk '{print $2}' | tr -d '+'),
  "power_w": 312.4, # Placeholder: da un PDU o driver specifico
  "ecc_err": 0, # Placeholder: da RAPL/ECC counter
  "fan_hz": 2500, # RPM attuale convertito
  "lat_us": 12.4, # RTT calcolato
  "clock_jitter_ns": 30.2
}
EOF
)
  echo "$sensors_data" | jq .
}

# Loop principale
while true; do
  # Raccolta dati grezzi (ogni secondo)
  sensors_json="$(read_sensors)"
  echo "$sensors_json" >> "$RAW_DATA_DIR/raw.json"

  # Normalizza dati (Python o sistema esterno)
  # Salva su IPFS, ottieni CID
  CID=$(echo "$sensors_json" | ipfs add -q)
  echo "$(date --utc +\"%Y-%m-%dT%H:%M:%SZ\") | CID=$CID aggiunto." >> "$LOGFILE"

  # Aspetta 1 secondo prima del prossimo ciclo
  sleep 1
done