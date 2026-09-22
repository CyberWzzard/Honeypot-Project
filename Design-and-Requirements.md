# Honeypot Project — Design & Requirements
 
## Design
 
- Cowrie honeypot runs on a VPS, in Docker, with all outbound traffic blocked except the connection to the backend.
- MongoDB Atlas (free tier) stores all data.
- FastAPI backend (Snapdeploy,Render, or FastAPI Cloud) handles log ingestion from cowrie, and front end login, and dashboard queries.
- React dashboard (Firebase Hosting) - serves as Dashboard for analyst to monitor honeypot stats.
- Flow: Cowrie Honeypot → FastAPI → MongoDB → FastAPI → Dashboard.

## Requirements
 
**Honeypot**
- Cowrie honeypot runs in docker container for isolation.
- Believable fake filesystem (fake credentials, configs, users, notes).
- Log failed and successful logins along with all commands on emulated linux shell (Cowrie handles this)
- SFTP/SCP disabled — no real file transfer in or out for security.
- No default/stock Cowrie values left in place (hostname, usernames, banner).
- Forwards logs to FastAPI
  
**Database**
- Collections: sessions, auth_attempts, commands, ip_intel, daily_stats, admin.
- Indexed on IP and sessions for fast lookups.

**Backend**
- Single admin account only, no public signup.
- Log ingestion endpoint secured separately from admin login.
  
**Dashboard**
- Login page.
- Main Overview stats (unique IP count, session count, command count, login success rate, unique usernames and passwords guessed).
- Sessions list with drill-down into commands with timestamps.
- Per-IP attacker view (sessions involved, commands typed).
