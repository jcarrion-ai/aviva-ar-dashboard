# Aviva AR Delinquency Dashboard

Live weekly AR delinquency monitor for Aviva Senior Living communities. Data sourced from Yardi Voyager every Monday at 7:00 AM local.

**Live site:** `https://<your-github-username>.github.io/aviva-ar-dashboard/`

## Contents

```
index.html          Current-week dashboard (KPIs + Chart.js bars)
history.html        Links page for past weeks
history/YYYY-MM-DD.html   Archived weekly snapshots
data/YYYY-MM-DD.json      Machine-readable data per run
data/Aviva_AR_Delinquency_YYYY-MM-DD.xlsx  Downloadable Excel workbook
```

## How it updates

A Cowork scheduled task (`aviva-weekly-ar-delinquency`, Monday 7:00 AM local) runs `aviva_ar_pipeline.py` which:
1. Opens Yardi Voyager in Claude in Chrome.
2. Runs the `rs_SeniorAgingAccountingPeriod` report across all 14 Aviva community codes with "Exclude zero balances = Yes".
3. Exports to Excel, parses resident-level aging data.
4. Regenerates `index.html` and archives last week to `history/`.
5. Commits and pushes to `main`.

## Delinquency flags

| Flag | Trigger |
|------|---------|
| Credit Balance >$500 | net_due < −$500 |
| $0 Payer | past-due > 0 and current = 0 |
| 30+ Days Past Due | any 30/60/90/120/150+ bucket > 0 |
| Partial Payer | current > 0 AND past-due > 0 |
| High Balance >$3K | net_due > $3,000 |
| Medicaid Pending | name-based heuristic |

## Setup (first time)

1. Create a new public GitHub repo named `aviva-ar-dashboard`.
2. Drop the contents of this folder into the repo root.
3. `git init && git add -A && git commit -m "Initial dashboard" && git branch -M main && git remote add origin https://github.com/<you>/aviva-ar-dashboard.git && git push -u origin main`
4. Repo **Settings → Pages → Source: Deploy from a branch → `main` / `root` → Save**.
5. Wait ~1 minute and visit `https://<you>.github.io/aviva-ar-dashboard/`.

## Manual refresh

```
python3 /sessions/peaceful-lucid-archimedes/aviva_ar_pipeline.py
cd /sessions/peaceful-lucid-archimedes/aviva-ar-dashboard
./deploy.sh "weekly refresh $(date +%Y-%m-%d)"
```

`deploy.sh` stages, commits, and pushes to `origin/main`.
