# solo-setup

A bash script for deploying a local **Hiero Solo** network using the Solo CLI.

## Scripts Overview

| Script | Command | Description |
| :--- | :--- | :--- |
| `solo-ctl` |	`check` | Validates system dependencies (Docker, Kind, Node.js, Solo CLI). |
| `solo-ctl` |	`bake` |	Deploys the network and optional components (Mirror, RPC, Explorer). |
| `solo-ctl` |	`purge` |	Destroys the cluster, cleans up data, and kills ghost processes. |

---

## Usage

### 1. System Check

Before deploying, ensure your environment meets the dependencies requirements.
```bash
./solo-ctl check
```

### 2. Deploy (Bake)
You can deploy a minimal consensus node or include additional ecosystem components using flags.

**Standard Deployment (Consensus only):**
```bash
./solo-ctl bake
```

**Full Deployment:**
```bash
./solo-ctl bake --include-all
```

**Custom Deployment:**

Enable specific components and override default versions:

```bash
./solo-ctl bake --mirror true --rpc true --consensus-node-version v0.73.0
```

### 3. Clean Up (Purge)

To completely remove the deployment, reclaim system resources, and stop port-forwarding:
```bash
./solo-ctl purge
```

## Configuration Flags 
| Flag | Argument |	Default |	Description |
| :--- | :--- | :--- | :--- |
| `-a`, `--include-all` |	N/A |	false |	Enables Mirror Node, JSON-RPC, and  Explorer. |
| `-m`, `--mirror` |	true/false |	false |	Deploys the Mirror Node. |
| `-r`, `--rpc` |	true/false |	false |	Deploys the JSON-RPC Relay. |
| `-e`, `--explorer` |	true/false | false | Deploys the Block Explorer. |
| `-cv`, `--consensus-node-version` |	string | v0.73.0 | Sets the Consensus Node release tag. |
| `-mv`, `--mirror-node-version` | string | v0.153.0 | Sets the Mirror Node release tag. |
