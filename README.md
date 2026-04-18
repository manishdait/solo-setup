# solo-setup

A bash script for deploying a local **Hiero Solo** network using the Solo CLI.

## Scripts Overview

| Script | Description |
| :--- | :--- |
| `setup.sh` | Initializes the Kind cluster, deploys the consensus node, and configures the mirror node with custom resource overrides. |
| `purge.sh` | Destroys the mirror node, stops the network, and deletes the Kind cluster to reclaim system resources. |

---

## Usage

### 1. Initialize the Network
Run the setup script to pull the necessary Docker images and start the Hiero solo.
```bash
chmod +x setup.sh
./setup.sh
```

### 2. Clean Up / Reset

To completely remove the deployment and free up space on machine:
```bash
chmod +x purge.sh
./purge.sh
```
