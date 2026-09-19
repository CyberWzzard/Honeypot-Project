# Honeypot Project — Design & Requirements
 
## Design
 
- Cowrie honeypot runs on a VPS, in Docker, with all outbound traffic blocked except the connection to the backend.
- MongoDB Atlas (free tier) stores all data.
- FastAPI backend (Snapdeploy) handles ingestion, login, and dashboard queries.
- React dashboard (Firebase Hosting) is the only thing that talks to the backend API.
- Flow: Cowrie → MongoDB → FastAPI → Dashboard.

## Requirements
 
**Honeypot**
- Believable fake filesystem (fake credentials, configs, users, notes).
- Some logins succeed so real activity gets captured, not just failed attempts.
- SFTP/SCP disabled — no real file transfer in or out for security.
- No default/stock Cowrie values left in place (hostname, usernames, banner).
**Database**
- Collections: sessions, auth_attempts, commands, ip_intel, daily_stats, admin.
- Indexed on IP and timestamp for fast lookups.
**Backend**
- Single admin account only, no public signup.
- Log ingestion endpoint secured separately from admin login.
**Dashboard**
- Login page.
- Overview stats (counts, success rate, trend chart).
- Sessions list with drill-down into commands.
- Per-IP attacker view.
