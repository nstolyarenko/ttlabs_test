

# TT Labs Infrastructure Automation

This repository contains **Ansible playbooks** and **Docker Compose configurations** for deploying a secure VPN network, database, Redis, and monitoring stack (Prometheus + Grafana). It also includes **CI/CD automation via GitHub Actions**.

---

## Features

* **WireGuard VPN** setup for secure host-to-host communication.
* **PostgreSQL** and **Redis** services with Docker Compose.
* **Prometheus & Grafana** for monitoring database and Redis metrics.
* **Automated firewall rules** with iptables.
* **CI/CD pipeline** with GitHub Actions to run playbooks and deploy/update services.

---

## Repository Structure

```
ttlabs_ansible/
├─ roles/
│  ├─ wireguard/         # Setup WireGuard VPN
│  ├─ firewall/          # Deploy iptables rules
│  ├─ database/          # PostgreSQL and Redis Docker services
│  ├─ monitoring/        # Prometheus & Grafana Docker services
├─ inventory.yml          # Ansible inventory
├─ site.yml               # Main Ansible playbook
├─ docker-compose.yml     # Database Docker Compose
├─ docker-compose-monitoring.yml  # Monitoring Docker Compose
├─ prometheus.yml         # Prometheus configuration
├─ keys/                  # WireGuard keys (gitignored)
└─ .github/workflows/
   └─ deploy.yml          # GitHub Actions CI/CD workflow
```

---

## Prerequisites

* GitHub repository with the following **Secrets** configured:

  * `SSH_PRIVATE_KEY` — Private key for `terraform` user.
  * `KNOWN_HOSTS` — Optional, host fingerprints for target servers (use `ssh-keyscan -H <host>`).

* Target hosts:

  * `vpn`, `db`, `mon` configured in `inventory.yml`.
  * Open SSH port (default `2222`) and WireGuard port (`51820`) allowed.

* Local machine with GitHub Actions runner (handled automatically).

---

## Deployment

### Manual Deployment

1. Clone the repository:

```bash
git clone <repo_url>
cd ttlabs_ansible
```

2. Run the main playbook:

```bash
ansible-playbook -i inventory.yml site.yml --ssh-extra-args="-o StrictHostKeyChecking=no"
```

This will:

* Install Docker and Docker Compose.
* Deploy PostgreSQL, Redis, Prometheus, Grafana.
* Configure WireGuard VPN.
* Apply iptables firewall rules.

---

### GitHub Actions CI/CD

The repository includes a workflow `.github/workflows/deploy.yml` which automatically:

1. Installs Python and Ansible.
2. Loads SSH keys from GitHub Secrets.
3. Runs Ansible playbooks.
4. Deploys or updates services on target hosts.
5. Optionally tests service accessibility.

#### Triggering the workflow

* On push to the `main` branch.
* Manually via **Actions → Deploy via CI/CD → Run workflow**.

#### Secrets Required

| Secret Name       | Description                                             |
| ----------------- | ------------------------------------------------------- |
| `SSH_PRIVATE_KEY` | Private key for `terraform` user on target hosts.       |
| `KNOWN_HOSTS`     | Optional: host fingerprints (`ssh-keyscan -H <hosts>`). |

---

### Testing Services

After deployment, you can test services:

```bash
# From monitoring host
curl http://10.0.0.11:9187/metrics   # PostgreSQL exporter
curl http://10.0.0.11:9121/metrics   # Redis exporter
curl http://127.0.0.1:3000           # Grafana web UI
curl http://127.0.0.1:9090           # Prometheus web UI
```

---

### Notes

* Ensure the **iptables rules** allow access from the monitoring host to exporters.
* Use **Docker Compose with `network_mode: host`** for simplified networking if required.
* WireGuard VPN ensures secure communication between hosts.

---

### Contributing

* Fork the repository.
* Make changes in a feature branch.
* Open a pull request with details of your changes.

---
