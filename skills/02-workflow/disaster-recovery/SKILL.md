---
name: disaster-recovery
description: Execute disaster recovery procedures for catastrophic failures. Use when server crashes, data corruption, security breaches, or complete system failures occur. Includes RTO/RPO plans and recovery runbooks.
allowed-tools: Bash, Read, Write
---

# Disaster Recovery Skill

> **🚨 Catastrophic failure recovery procedures**
>
> **Complete disaster recovery runbook and business continuity plan**

---

## 🎯 Purpose

**Problem:**

- No recovery plan for catastrophic failures
- Undefined Recovery Time Objective (RTO)
- Undefined Recovery Point Objective (RPO)
- No tested recovery procedures

**Solution:**

- Complete disaster recovery runbook
- Defined RTO/RPO targets
- Step-by-step recovery procedures
- Regular DR drills and testing

---

## 📋 When to Use

**Use this skill for:**

- 🚨 Server/hardware failure
- 🚨 Data corruption
- 🚨 Security breach/ransomware
- 🚨 Natural disaster
- 🚨 Complete database loss
- 🚨 Application/system crash

**⚠️ CRITICAL:**

- This is for EMERGENCY situations only
- Follow procedures exactly
- Document all actions
- Notify team immediately

---

## 🎯 Recovery Objectives

### RTO (Recovery Time Objective)

**Target:** How quickly must we recover?

- **Critical Systems:** < 4 hours
  - Database server
  - API server
  - Authentication service

- **Important Systems:** < 8 hours
  - Web frontend
  - Background jobs
  - Email service

- **Non-Critical Systems:** < 24 hours
  - Analytics
  - Reporting
  - Developer tools

### RPO (Recovery Point Objective)

**Target:** How much data loss is acceptable?

- **Production Database:** < 1 hour (hourly backups)
- **User Data:** < 15 minutes (transaction logs)
- **Configuration:** 0 (git versioned)
- **Uploads/Files:** < 24 hours (daily backups)

---

## 🚨 Disaster Scenarios

### Scenario 1: Complete Server Failure

**Symptoms:**

- Server won't boot
- Hardware failure
- Cloud instance terminated

**Recovery Time:** 2-4 hours
**Data Loss:** < 1 hour

**Recovery Steps:**

```bash
#!/bin/bash
# Scenario 1: Complete Server Failure Recovery

echo "🚨 DISASTER RECOVERY: Server Failure"
echo "===================================="
echo ""

# Step 1: Provision new server
echo "Step 1: Provision new server"
echo "Options:"
echo "  a) AWS EC2 instance"
echo "  b) DigitalOcean droplet"
echo "  c) On-premise server"
read -p "Select option: " server_option

# Step 2: Install dependencies
echo ""
echo "Step 2: Installing dependencies..."
ssh root@new-server <<'EOF'
  # Update system
  apt-get update
  apt-get upgrade -y

  # Install PostgreSQL
  apt-get install -y postgresql-15

  # Install Node.js
  curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
  apt-get install -y nodejs

  # Install Docker
  apt-get install -y docker.io docker-compose

  # Install Nginx
  apt-get install -y nginx
EOF

# Step 3: Restore database from backup
echo ""
echo "Step 3: Restoring database..."

# Get latest backup from remote storage
aws s3 cp s3://aegisx-backups/latest/full_backup.dump /tmp/

# Create database
ssh root@new-server <<'EOF'
  sudo -u postgres createdb aegisx
EOF

# Restore database
ssh root@new-server <<'EOF'
  sudo -u postgres pg_restore -d aegisx /tmp/full_backup.dump
EOF

# Step 4: Deploy application
echo ""
echo "Step 4: Deploying application..."

# Clone repository
ssh root@new-server <<'EOF'
  git clone https://github.com/org/aegisx-platform.git /app
  cd /app
  git checkout main
EOF

# Install dependencies
ssh root@new-server <<'EOF'
  cd /app
  npm install -g pnpm
  pnpm install
EOF

# Copy environment variables
scp .env.production root@new-server:/app/.env

# Build application
ssh root@new-server <<'EOF'
  cd /app
  pnpm run build
EOF

# Step 5: Start services
echo ""
echo "Step 5: Starting services..."
ssh root@new-server <<'EOF'
  cd /app
  docker-compose -f docker-compose.production.yml up -d
EOF

# Step 6: Update DNS
echo ""
echo "Step 6: Update DNS records"
echo "New server IP: $(ssh root@new-server 'curl -s ifconfig.me')"
echo "Update DNS A record to point to new IP"
read -p "Press enter when DNS updated..."

# Step 7: Verify recovery
echo ""
echo "Step 7: Verifying recovery..."
NEW_IP=$(ssh root@new-server 'curl -s ifconfig.me')
curl -f "http://$NEW_IP/health"

if [ $? -eq 0 ]; then
    echo "✅ Server recovered successfully!"
else
    echo "❌ Health check failed - investigation needed"
    exit 1
fi

echo ""
echo "============================="
echo "✅ RECOVERY COMPLETE"
echo "============================="
echo "Time elapsed: $(date)"
echo "New server IP: $NEW_IP"
echo "Next steps:"
echo "  1. Monitor application logs"
echo "  2. Test critical functionality"
echo "  3. Notify users of brief downtime"
echo "  4. Document incident"
```

---

### Scenario 2: Database Corruption

**Symptoms:**

- PostgreSQL won't start
- Data integrity errors
- Corrupted files

**Recovery Time:** 1-2 hours
**Data Loss:** < 1 hour (from last backup)

**Recovery Steps:**

```bash
#!/bin/bash
# Scenario 2: Database Corruption Recovery

echo "🚨 DISASTER RECOVERY: Database Corruption"
echo "========================================"
echo ""

# Step 1: Stop PostgreSQL
echo "Step 1: Stopping PostgreSQL..."
systemctl stop postgresql
echo "✅ PostgreSQL stopped"

# Step 2: Backup corrupted database (for forensics)
echo ""
echo "Step 2: Backing up corrupted database..."
cp -r /var/lib/postgresql/15/main "/backups/corrupted_db_$(date +%Y%m%d_%H%M%S)"
echo "✅ Corrupted database backed up"

# Step 3: Remove corrupted data
echo ""
echo "Step 3: Removing corrupted data..."
rm -rf /var/lib/postgresql/15/main/*
echo "✅ Corrupted data removed"

# Step 4: Initialize new database cluster
echo ""
echo "Step 4: Initializing new database cluster..."
sudo -u postgres /usr/lib/postgresql/15/bin/initdb \
  -D /var/lib/postgresql/15/main
echo "✅ New cluster initialized"

# Step 5: Start PostgreSQL
echo ""
echo "Step 5: Starting PostgreSQL..."
systemctl start postgresql
sleep 5
echo "✅ PostgreSQL started"

# Step 6: Create database
echo ""
echo "Step 6: Creating database..."
sudo -u postgres createdb aegisx
echo "✅ Database created"

# Step 7: Restore from latest backup
echo ""
echo "Step 7: Restoring from backup..."
LATEST_BACKUP=$(ls -t /backups/full_backup_*.dump | head -1)
echo "Using backup: $LATEST_BACKUP"

sudo -u postgres pg_restore -d aegisx "$LATEST_BACKUP"

if [ $? -eq 0 ]; then
    echo "✅ Database restored"
else
    echo "❌ Restore failed"
    exit 1
fi

# Step 8: Verify data
echo ""
echo "Step 8: Verifying data..."
sudo -u postgres psql aegisx -c "SELECT COUNT(*) FROM users;"
sudo -u postgres psql aegisx -c "SELECT COUNT(*) FROM inventory.drugs;"

# Step 9: Restart application
echo ""
echo "Step 9: Restarting application..."
systemctl restart aegisx-api
systemctl restart aegisx-web

# Step 10: Health check
echo ""
echo "Step 10: Health check..."
sleep 10
curl -f http://localhost:3000/health

echo ""
echo "============================="
echo "✅ RECOVERY COMPLETE"
echo "============================="
```

---

### Scenario 3: Security Breach / Ransomware

**Symptoms:**

- Unauthorized access detected
- Files encrypted
- Data exfiltration suspected

**Recovery Time:** 4-8 hours
**Data Loss:** 0 (isolated system before damage)

**Recovery Steps:**

```bash
#!/bin/bash
# Scenario 3: Security Breach Recovery

echo "🚨 DISASTER RECOVERY: Security Breach"
echo "====================================="
echo ""
echo "⚠️  CRITICAL: Follow these steps EXACTLY"
echo ""

# Step 1: ISOLATE IMMEDIATELY
echo "Step 1: ISOLATE compromised system"
echo "Actions:"
echo "  1. Disconnect from internet"
echo "  2. Disable all network interfaces"
echo "  3. Stop all services"
read -p "System isolated? (yes): " isolated

if [ "$isolated" != "yes" ]; then
    echo "❌ STOP! Isolate system first!"
    exit 1
fi

# Step 2: Document breach
echo ""
echo "Step 2: Document breach details"
echo "Record the following:"
echo "  - Time breach detected: $(date)"
echo "  - Symptoms observed:"
read -p "Enter symptoms: " symptoms
echo "  - Affected systems:"
read -p "Enter affected systems: " systems
echo "  - Data at risk:"
read -p "Enter data at risk: " data_risk

# Save incident report
cat > "/tmp/incident_report_$(date +%Y%m%d_%H%M%S).txt" <<EOF
SECURITY BREACH INCIDENT REPORT
===============================
Time Detected: $(date)
Symptoms: $symptoms
Affected Systems: $systems
Data at Risk: $data_risk
Actions Taken: [to be filled during recovery]
EOF

# Step 3: Assess damage
echo ""
echo "Step 3: Assess damage"
echo "Check for:"
echo "  - Encrypted files (*.encrypted, *.locked)"
echo "  - Modified system files"
echo "  - Unauthorized user accounts"
echo "  - Suspicious processes"

# Step 4: Notify stakeholders
echo ""
echo "Step 4: Notify stakeholders"
echo "MANDATORY notifications:"
echo "  - Management team"
echo "  - IT security team"
echo "  - Legal department (if data breach)"
echo "  - Customers (if PII exposed)"
read -p "Notifications sent? (yes): " notified

# Step 5: Preserve evidence
echo ""
echo "Step 5: Preserve evidence (CRITICAL for forensics)"
# Create forensic image
dd if=/dev/sda of="/forensics/disk_image_$(date +%Y%m%d).img" bs=4M

# Capture memory dump
cat /proc/kcore > "/forensics/memory_dump_$(date +%Y%m%d).bin"

# Capture network connections
netstat -antp > "/forensics/network_connections_$(date +%Y%m%d).txt"

# Capture running processes
ps aux > "/forensics/processes_$(date +%Y%m%d).txt"

echo "✅ Evidence preserved"

# Step 6: Clean rebuild
echo ""
echo "Step 6: Clean system rebuild"
echo "⚠️  DO NOT restore from compromised backups!"
echo ""
echo "Actions:"
echo "  1. Provision NEW clean server"
echo "  2. Install OS from verified source"
echo "  3. Update ALL software"
echo "  4. Change ALL passwords and secrets"
echo "  5. Regenerate ALL encryption keys"
echo "  6. Review ALL access permissions"

# Step 7: Restore data from VERIFIED clean backup
echo ""
echo "Step 7: Restore data"
echo "Use backup from BEFORE breach occurred"

# Find backup from before breach
echo "Available backups:"
ls -lh /backups/full_backup_*.dump | tail -10

read -p "Enter backup file path (BEFORE breach): " clean_backup

# Restore to NEW clean system
echo "Restoring to clean system..."
# [Follow server provisioning from Scenario 1]

# Step 8: Security hardening
echo ""
echo "Step 8: Security hardening"
echo "MANDATORY steps:"
echo "  1. Install and configure firewall"
echo "  2. Enable intrusion detection (fail2ban)"
echo "  3. Enable audit logging"
echo "  4. Disable unnecessary services"
echo "  5. Apply security patches"
echo "  6. Implement WAF (Web Application Firewall)"

# Step 9: Change all credentials
echo ""
echo "Step 9: Rotate ALL credentials"
echo "Change:"
echo "  - Database passwords"
echo "  - JWT secrets"
echo "  - API keys"
echo "  - SSH keys"
echo "  - SSL certificates"
echo "  - Admin passwords"

# Step 10: Post-incident review
echo ""
echo "Step 10: Post-incident review"
echo "Schedule:"
echo "  - Forensic analysis"
echo "  - Root cause analysis"
echo "  - Security improvements"
echo "  - Staff training"

echo ""
echo "============================="
echo "⚠️  RECOVERY IN PROGRESS"
echo "============================="
echo "Next: Complete forensic analysis"
```

---

### Scenario 4: Data Center Failure

**Symptoms:**

- Entire data center unavailable
- Natural disaster
- Power outage

**Recovery Time:** 2-6 hours
**Data Loss:** < 1 hour

**Recovery Steps:**

```bash
#!/bin/bash
# Scenario 4: Data Center Failure Recovery

echo "🚨 DISASTER RECOVERY: Data Center Failure"
echo "========================================"
echo ""

# Step 1: Activate DR site
echo "Step 1: Activating disaster recovery site"
echo "DR Site Options:"
echo "  1. AWS (us-east-1)"
echo "  2. AWS (eu-west-1)"
echo "  3. Google Cloud"
echo "  4. Azure"
read -p "Select DR site: " dr_site

# Step 2: Restore database from geo-replicated backup
echo ""
echo "Step 2: Restoring database from geo-backup..."

# Get backup from remote region
case $dr_site in
  1)
    aws s3 cp s3://aegisx-dr-us-east/latest/backup.dump /tmp/ --region us-east-1
    ;;
  2)
    aws s3 cp s3://aegisx-dr-eu-west/latest/backup.dump /tmp/ --region eu-west-1
    ;;
esac

# Step 3: Deploy application to DR site
echo ""
echo "Step 3: Deploying to DR site..."
# [Follow server provisioning]

# Step 4: Update DNS to DR site
echo ""
echo "Step 4: Update DNS to DR site"
echo "Update Route53/CloudFlare DNS:"
echo "  - A record: point to DR site IP"
echo "  - TTL: set to 60 seconds"
read -p "DNS updated? (yes): " dns_updated

# Step 5: Verify DR site operational
echo ""
echo "Step 5: Verifying DR site..."
curl -f "https://app.aegisx.com/health"

echo ""
echo "============================="
echo "✅ DR SITE ACTIVATED"
echo "============================="
```

---

## 📋 Disaster Recovery Checklist

```markdown
# Disaster Recovery Checklist

**Incident:** [description]
**Date:** [YYYY-MM-DD HH:MM]
**Severity:** Critical / High / Medium

## Immediate Response (First 30 min)

- [ ] Incident detected and confirmed
- [ ] Incident commander assigned
- [ ] Team assembled and notified
- [ ] Affected systems identified
- [ ] Users notified (if applicable)
- [ ] Isolated compromised systems (if security breach)

## Assessment (30 min - 1 hour)

- [ ] Extent of damage assessed
- [ ] RTO/RPO targets identified
- [ ] Recovery plan selected
- [ ] Resources allocated
- [ ] Evidence preserved (if applicable)

## Recovery (1-8 hours)

- [ ] Backup integrity verified
- [ ] New/clean infrastructure provisioned
- [ ] Database restored
- [ ] Application deployed
- [ ] Configuration verified
- [ ] Services started

## Verification (30 min - 1 hour)

- [ ] Health checks passed
- [ ] Critical functionality tested
- [ ] Data integrity verified
- [ ] Performance acceptable
- [ ] Security verified (if breach)

## Restoration (30 min)

- [ ] DNS updated
- [ ] SSL certificates valid
- [ ] Users notified of resolution
- [ ] Monitoring active
- [ ] Normal operations resumed

## Post-Incident (1-2 days)

- [ ] Incident report completed
- [ ] Root cause analysis done
- [ ] Improvements identified
- [ ] DR plan updated
- [ ] Team debriefing conducted

---

**Total Recovery Time:** [X hours]
**Data Loss:** [X minutes/hours]
**Lessons Learned:** [summary]
```

---

## 🎯 DR Testing Schedule

### Monthly DR Drills

**Test:** Database restore
**Duration:** 1 hour
**Procedure:**

1. Restore latest backup to test environment
2. Verify data integrity
3. Document time taken
4. Update procedures if needed

### Quarterly DR Drills

**Test:** Complete failover to DR site
**Duration:** 4 hours
**Procedure:**

1. Simulate primary site failure
2. Activate DR site
3. Verify application functionality
4. Test user access
5. Document lessons learned

### Annual DR Drills

**Test:** Full disaster simulation
**Duration:** 8 hours
**Procedure:**

1. Simulate catastrophic failure
2. Execute complete recovery
3. Test all recovery scenarios
4. Involve all stakeholders
5. Update DR plan based on findings

---

## 📚 Contact Information

### Emergency Contacts

```markdown
# Emergency Contact List

## Technical Team

- **Incident Commander:** [Name] - [Phone] - [Email]
- **Database Admin:** [Name] - [Phone] - [Email]
- **DevOps Lead:** [Name] - [Phone] - [Email]
- **Security Lead:** [Name] - [Phone] - [Email]

## Management

- **CTO:** [Name] - [Phone] - [Email]
- **CEO:** [Name] - [Phone] - [Email]

## Vendors

- **Cloud Provider Support:** [Phone] - [Portal]
- **Database Vendor:** [Phone] - [Support Portal]
- **Security Consultant:** [Phone] - [Email]

## External

- **Legal:** [Firm Name] - [Phone]
- **PR/Communications:** [Firm Name] - [Phone]
- **Insurance:** [Provider] - [Policy#] - [Phone]

---

**Last Updated:** [Date]
**Next Review:** [Date]
```

---

## 🎯 Quick Reference

### Recovery Priority

1. **Critical (< 4h):**
   - Database
   - Authentication
   - API server

2. **Important (< 8h):**
   - Web frontend
   - Email service

3. **Non-Critical (< 24h):**
   - Analytics
   - Reporting

### Backup Locations

```bash
# Local backups
/backups/

# Remote backups (S3)
s3://aegisx-backups/

# DR site backups
s3://aegisx-dr-us-east/
s3://aegisx-dr-eu-west/

# Verify backup locations
aws s3 ls s3://aegisx-backups/latest/
```

---

## 📝 Incident Report Template

```markdown
# Incident Report: [Title]

**Date:** [YYYY-MM-DD]
**Severity:** Critical / High / Medium / Low
**Status:** Resolved / In Progress / Monitoring

---

## Summary

[1-2 sentence summary of incident]

## Timeline

| Time  | Event                |
| ----- | -------------------- |
| 14:30 | Incident detected    |
| 14:35 | Team notified        |
| 14:40 | Recovery initiated   |
| 16:00 | Services restored    |
| 16:30 | Verified operational |

## Impact

- **Users Affected:** [number]
- **Duration:** [X hours Y minutes]
- **Data Loss:** [Yes/No - amount]
- **Revenue Impact:** [$amount]

## Root Cause

[Detailed explanation of what caused the incident]

## Recovery Actions

1. [Action 1]
2. [Action 2]
3. [Action 3]

## Lessons Learned

### What Went Well

- [Item 1]
- [Item 2]

### What Needs Improvement

- [Item 1]
- [Item 2]

## Action Items

- [ ] [Improvement 1] - Owner: [Name] - Due: [Date]
- [ ] [Improvement 2] - Owner: [Name] - Due: [Date]

---

**Report By:** [Name]
**Reviewed By:** [Name]
**Date:** [YYYY-MM-DD]
```

---

**Version**: 1.0.0
**Priority**: CRITICAL
**Last DR Drill:** [Schedule first drill]
**Next DR Drill:** [Plan quarterly drill]
