# 🏭 JHT Machine Data Extraction Automation

> An automated pipeline to extract daily production data logs from a JHT pick-and-place machine and transfer them to an office PC for analysis in Power BI.

---

## 📋 Project Overview

This project automates the manual process of transferring CSV data logs from a **JHT pick-and-place machine** to an **office PC** across different network subnets. The data is then used for production analysis and reporting in **Power BI**.

### Problem
- The JHT machine and office PC are on the **same server but different subnets**
- Data logs were being **manually transferred** using FileZilla
- No automated reporting or analysis pipeline existed

### Solution
- Automated extraction and transfer using **BAT scripts + VBScript + Windows Task Scheduler**
- VBScript runs BAT files silently without showing a command prompt window
- Data flows nightly from the JHT machine → FileZilla Server → Office PC
- Power BI connects to the local CSV for reporting and dashboards

---

## 🏗️ Architecture

```
┌─────────────────────┐
│   JHT Machine       │  (Subnet A)
│                     │
│  run_extract.vbs    │ ← Task Scheduler triggers @ 23:59 daily
│  extract.bat        │ ← Extracts CSV & uploads to FTP (runs silently)
└────────┬────────────┘
         │ uploads via FileZilla
         ▼
┌─────────────────────┐
│  FileZilla Server   │  (Shared Server - bridges both subnets)
│  Stores CSV log     │
└────────┬────────────┘
         │ downloads via FileZilla
         ▼
┌─────────────────────┐
│   Office PC         │  (Subnet B)
│                     │
│  run_download.vbs   │ ← Task Scheduler triggers @ 02:00 daily
│  download.bat       │ ← Downloads CSV to local folder (runs silently)
│                     │
│  Power BI Desktop   │ ← Reads CSV for reporting
└─────────────────────┘
```

---

## 📁 Repository Structure

```
📁 jht-data-pipeline/
│
├── 📁 scripts/
│   ├── extract.bat          # Runs on JHT machine — extracts & uploads CSV
│   ├── run_extract.vbs      # Runs extract.bat silently (no popup window)
│   ├── download.bat         # Runs on Office PC — downloads CSV from FileZilla
│   └── run_download.vbs     # Runs download.bat silently (no popup window)
│
├── 📁 task-scheduler/
│   ├── extract_task.xml     # Task Scheduler config for JHT machine (23:59)
│   └── download_task.xml    # Task Scheduler config for Office PC (02:00)
│
├── 📁 powerbi/
│   └── jht_dashboard.pbix   # Power BI report file
│
├── 📁 docs/
│   ├── setup-guide.md       # Step-by-step setup instructions
│   └── network-diagram.png  # Network/architecture diagram
│
└── README.md
```

---

## ⚙️ How It Works

### Step 1 — Data Extraction (JHT Machine @ 23:59)
`run_extract.vbs` is triggered by Windows Task Scheduler at the end of each production day. It silently runs `extract.bat` which extracts the daily CSV data log from the SQL database and uploads it to the FileZilla server.

### Step 2 — Data Transfer (Office PC @ 02:00)
`run_download.vbs` is triggered 2 hours later, giving the upload time to complete. It silently runs `download.bat` which connects to the FileZilla server and downloads the CSV to a local folder on the office PC.

### Step 3 — Power BI Reporting
Power BI Desktop reads the CSV from the local folder. The report is manually refreshed to load the latest data for analysis.

---

## 🛠️ Tech Stack

| Tool | Purpose |
|------|---------|
| BAT Scripts | Automate extraction and file transfer |
| VBScript | Run BAT files silently without popup windows |
| FileZilla | FTP server bridging two subnets |
| Windows Task Scheduler | Triggers scripts on a nightly schedule |
| SQL Server Express | Database on JHT machine storing production data |
| CSV | Data format output by JHT machine |
| Power BI Desktop | Data visualization and reporting |

---

## 🚀 Setup Guide

### Prerequisites
- FileZilla Server installed and configured on the shared server
- FileZilla Client installed on both JHT machine and Office PC
- Windows Task Scheduler access on both machines
- SQL Server Express running on JHT machine
- Power BI Desktop installed on Office PC

### Installation

1. **Clone this repo**
   ```bash
   git clone https://github.com/FineMan11/jht-data-pipeline.git
   ```

2. **Configure `extract.bat`** on the JHT machine
   - Update `YOUR_FTP_SERVER_IP`, `YOUR_FTP_USERNAME`, `YOUR_FTP_PASSWORD`

3. **Configure `download.bat`** on the Office PC
   - Update `YOUR_FTP_SERVER_IP`, `YOUR_FTP_USERNAME`, `YOUR_FTP_PASSWORD`
   - Update `YOUR_LOCAL_SAVE_PATH` to your destination folder

4. **Configure VBScript files**
   - Update `run_extract.vbs` with the correct path to `extract.bat`
   - Update `run_download.vbs` with the correct path to `download.bat`

5. **Import Task Scheduler tasks**
   - On JHT machine: import `task-scheduler/extract_task.xml`
   - On Office PC: import `task-scheduler/download_task.xml`

6. **Open Power BI**
   - Open `powerbi/jht_dashboard.pbix`
   - Update the CSV file path to match your local folder
   - Click **Refresh** to load data

---

## 📊 Power BI Dashboard

> Currently using **Power BI Desktop** with manual refresh.
> Planned upgrade to **Power BI Service + Gateway** for scheduled auto-refresh.

---

## 🗺️ Roadmap

- [x] Automate data extraction with BAT script
- [x] Automate silent execution with VBScript
- [x] Automate file transfer via FileZilla + Task Scheduler
- [ ] Upload Task Scheduler XML configs
- [ ] Build Power BI dashboard
- [ ] Add PowerShell script for automated Power BI refresh
- [ ] Upgrade to Power BI Service for cloud-based scheduled refresh

---

## 👤 Author

**FineMan11**
- GitHub: [@FineMan11](https://github.com/FineMan11)

---

*Part of my data analytics portfolio — documenting real-world automation and data engineering work.*
