import hashlib
import time
import json
import ipfshttpclient

# Collegamento ad IPFS
client = ipfshttpclient.connect()

# Definizione del Master Anchor per il protocollo
MASTER_ANCHOR_FREQUENCIES = {
    "primary_frequency": 0.432,  # Hz
    "secondary_frequency": 216,  # Hz
    "synchronization_ratio": 2.0  # Rapporto armonico chiave
}

def notarize_data(data):
    """Calcola hash del dato e lo registra in IPFS."""
    data_json = json.dumps(data, ensure_ascii=False, indent=2)
    data_hash = hashlib.sha256(data_json.encode('utf-8')).hexdigest()

    # Upload in IPFS
    ipfs_result = client.add_bytes(data_json.encode('utf-8'))

    return {
        "data_hash": data_hash,
        "ipfs_cid": ipfs_result,
    }

def main():
    """Procedura principale del sistema."""
    timestamp = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
    anchor_record = {
        "frequencies": MASTER_ANCHOR_FREQUENCIES,
        "generated_at": timestamp,
        "signature": "LEX_AMORIS_LOCKED_X"
    }

    notarization_result = notarize_data(anchor_record)

    print("Master Anchor Notarizzato ✅")
    print(f"Frequenze: {MASTER_ANCHOR_FREQUENCIES}")
    print(f"Hash Dati: {notarization_result['data_hash']}")
    print(f"Stato IPFS CID: {notarization_result['ipfs_cid']}")

if __name__ == "__main__":
    main()