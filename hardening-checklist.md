# 🛡️ Linux Server Hardening Checklist

This document tracks the security implementations performed on the Ubuntu EC2 instance to ensure a hardened production environment.

## Phase 1: Identity & Access Management (IAM)
- [x] **Create Non-Root User**: Created `deployer` user to follow the Principle of Least Privilege.
- [x] **Sudo Configuration**: Added user to the `sudo` group for administrative tasks.
- [x] **SSH Key-Based Auth**: Generated `ED25519` keys locally and disabled password-based entry.
- [x] **Disable Root Login**: Modified `sshd_config` to `PermitRootLogin no` to prevent direct root attacks.
- [x] **SSH Syntax Validation**: Used `sudo sshd -t` to verify config before service restart.

## Phase 2: Network Security & Perimeter
- [x] **UFW Default Policy**: Set to `deny` all incoming and `allow` all outgoing traffic.
- [x] **Port Hardening**: Explicitly allowed only Port `22/tcp` (SSH).
- [x] **Firewall Activation**: Enabled Uncomplicated Firewall (UFW) and verified active status.
- [x] **Fail2ban Deployment**: Installed `fail2ban` to automate IP banning for brute-force attempts.
- [x] **Jail Verification**: Confirmed `sshd` jail is active via `fail2ban-client`.



## Phase 3: Automation & Logging
- [x] **Update Script**: Developed `security-updates.sh` to automate package indexing and patching.
- [x] **Logging Strategy**: Directed script output to `/var/log/update_script.log` for auditing.
- [x] **Script Permissions**: Applied `chmod +x` to ensure script executability.
- [x] **Automated Scheduling**: Configured `crontab` to run security updates weekly (Sunday 02:00).

## Phase 4: Verification & Testing
- [x] **External Port Scan**: Verified with `nmap` that all non-essential ports are filtered.
- [x] **Negative Auth Test**: Confirmed that `root` and password-based logins are rejected.
- [x] **Sudo Validation**: Confirmed `deployer` can execute admin tasks with password prompt.
- [x] **Log Rotation Check**: Verified the update log file is generating timestamps correctly.

---
*Status: All security measures verified and operational.*
