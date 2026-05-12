# solo-setup-tool

A bash script for deploying a local **Hiero Solo** network using the Solo CLI.

## Scripts Overview

| Script | Command | Description |
| :--- | :--- | :--- |
| `solo-ctl` |	`check` | Validates system dependencies (Docker, Kind, Kubectl, Solo CLI). |
| `solo-ctl` |	`bake` |	Deploys the network and other components (Mirror, RPC, Explorer). |
| `solo-ctl` |	`purge` |	Destroys the cluster, cleans up data, and other ghost processes. |

---

## Usage

### 1. System Check

Before deploying, ensure your environment meets the dependencies requirements.

```bash
./solo-ctl check
```

### 2. Deploy (Bake)
You can deploy a minimal consensus node or include additional ecosystem components using flags.

**Full Stack Deployment:**
```bash
./solo-ctl bake
```

**Core/Light Deployment (Consensus only):**
```bash
./solo-ctl bake --core
```

**Custom Deployment:**

Enable specific components and override default versions:

```bash
./solo-ctl bake --mirror false --explorer false --node-tag v0.72.0
```

### 3. Clean Up (Purge)

To completely remove the deployment, reclaim system resources, and stop port-forwarding:
```bash
./solo-ctl purge
```

## Configuration Flags 
| Flag | Argument |	Default |	Description |
| :--- | :--- | :--- | :--- |
| `-c`, `--core` |	N/A |	`false` |	Minimal mode runs only the Consensus Node. |
| `-m`, `--mirror` |	`true/false` |	`true` |	Deploys the Mirror Node. |
| `-r`, `--rpc` |	`true/false` |	`true` |	Deploys the JSON-RPC Relay. |
| `-e`, `--explorer` |	`true`/`false` | `true` | Deploys the Block Explorer. |
| `-nt`, `--node-tag` |	`string` | `v0.73.0` | Sets the Consensus Node release tag. |
| `-mt`, `--mirror-tag` | `string` | `v0.153.0` | Sets the Mirror Node release tag. |


## Output Artifacts

After a successful `bake`, the tool generates a `out/` directory with below details:
- `solo.txt`: Environment variables for your SDK (Account ID, Keys).
- `account-output.txt`: Detailed JSON logs from the ledger account creation.

## Port Forwarding
The script automatically handles background port-forwards for Hiero services.

- **GRPC:** 50211
- **Mirror REST:** 5551
- **Mirror Java REST:** 8084
- **Mirror Node Explorer:** 38080