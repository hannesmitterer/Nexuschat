#!/bin/bash

# Configurazione
RAW_DATA_DIR="/var/nexus/grounding"
MERKLE_TREE_DIR="/var/nexus/merkle"
LOGFILE="/var/log/anchor_publish.log"

# Assicurati che le directory esistano
mkdir -p "$MERKLE_TREE_DIR"
touch "$LOGFILE"

# Funzione per calcolare la SHA-256
calculate_hash() {
  file=$1
  sha256sum "$file" | awk '{print $1}'
}

# Raccolta hash e pubblicazione
for file in "$RAW_DATA_DIR"/*.json; do
  HASH=$(calculate_hash "$file")
  CID=$(ipfs add -q "$file")

  echo "$(date --utc +\"%Y-%m-%dT%H:%M:%SZ\") | File=$file | SHA256=$HASH | CID=$CID" >> "$LOGFILE"
  echo "$CID" > "$MERKLE_TREE_DIR/$(basename "$file" .json).cid"
done