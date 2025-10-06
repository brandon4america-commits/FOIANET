# FOIA Nexus Automation Toolkit

This repository packages the FOIA Nexus hybrid automation assets, including a machine-readable workflow graph, a force-directed visualization shell, and starter code snippets for Google Colab and Google Apps Script (GAS) automation. It is designed to help teams orchestrate the full request lifecycle from intake through compliance reporting.

## Contents

| File | Purpose |
| --- | --- |
| `foia_nexus_workflow.json` | Machine-readable map of all Nexus subsystems with dependency metadata. |
| `workflow_visualization.html` | D3-powered force-directed viewer that renders the workflow graph. |
| `push_to_github.sh` | Helper script for initializing and pushing the repository to GitHub. |
| `.gitignore` | Sensible defaults for Node, Python, and platform artefacts. |

## Quick Start

1. Host `workflow_visualization.html` and `foia_nexus_workflow.json` together (GitHub Pages, Cloud Storage, etc.).
2. Open the HTML file in your browser.
3. Explore node importance (size) and automation confidence (link width) to spot opportunities for optimization.

> **Tip:** If you serve the files from different locations, edit the `fetch("foia_nexus_workflow.json")` line in `workflow_visualization.html` to point to the JSON's absolute URL.

## Automation Blueprint

The workflow graph aligns with the two primary execution surfaces described below:

### Google Apps Script (V8) – Nightly Sync Trigger

```javascript
/**
 * FOIA Nexus Sync Trigger
 * Runs nightly; fetches reconciled dataset from Drive, updates Sheet, and emails PDF report.
 */

function syncFOIAMaster() {
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  const sheet = ss.getSheetByName('FOIA_Master');

  const data = sheet.getDataRange().getValues();
  const header = data.shift();
  const rows = data.map((row) => processRow(row, header));

  sheet.getRange(2, 1, rows.length, header.length).setValues(rows);

  const hidden = ss.getSheets().filter((s) => s.getName() !== 'FOIA_Report');
  hidden.forEach((s) => s.hideSheet());
  const pdf = DriveApp.getFileById(ss.getId()).getAs('application/pdf');

  MailApp.sendEmail({
    to: 'foia.ops@agency.gov',
    subject: 'FOIA Nexus Daily Report',
    body: 'Attached: latest reconciled FOIA master snapshot.',
    attachments: [pdf],
  });

  hidden.forEach((s) => s.showSheet());
}

function processRow(row, header) {
  const getIndex = (name) => header.indexOf(name);
  const received = new Date(row[getIndex('received_date')]);
  const closed = new Date(row[getIndex('closed_date')]);
  const days = (closed - received) / (1000 * 60 * 60 * 24);
  row[getIndex('response_time_days')] = days;
  if (days > 20 && row[getIndex('status')] !== 'Closed') {
    row[getIndex('status')] = 'Delayed';
  }
  return row;
}
```

* Uses installable triggers for authorized Gmail access.
* Performs a single `setValues()` call to stay quota-friendly.
* Hides non-report tabs before PDF generation to meet output integrity requirements.

### Google Colab Integrator – Data Normalization Pass

```python
import pandas as pd
from difflib import SequenceMatcher
from google.colab import userdata

OPENAI_KEY = userdata.get('OPENAI_API_KEY')
FOIA_SECRET = userdata.get('FOIA_API_SECRET')

master = pd.read_csv('/content/drive/MyDrive/FOIA_Master_Reconciled_2025.csv')
agencies = pd.read_csv('/content/drive/MyDrive/us-federal-agencies-extended-2025-10.csv')

def match(a, b):
    return SequenceMatcher(None, a, b).ratio()

master['agency_normalized'] = master['agency'].apply(
    lambda x: max(agencies['agency_name'], key=lambda y: match(str(x), str(y)))
)

summary = master.groupby('agency_normalized')['response_time_days'].median().reset_index()
summary.columns = ['agency', 'median_response_time']
summary.to_csv('/content/drive/MyDrive/FOIA_Daily_Summary.csv', index=False)
print('✅ FOIA Nexus integration complete.')
```

* Pulls secrets securely with `google.colab.userdata`.
* Normalizes agency names locally for downstream automation.
* Emits a compact CSV summary for GAS ingestion or archival.

## Deployment Notes

- To publish the visualization on GitHub Pages, push the repository and enable **Settings → Pages → Deploy from a branch** targeting `main`.
- The included `push_to_github.sh` script initializes the repo, renames the branch to `main`, and pushes to the pre-configured remote. Update the remote URL if you fork this template.
- Consider pairing the visualization with the FOIA Transparency Dashboard to give stakeholders both real-time and structural context.

## License

This project is provided under the MIT License. See `LICENSE` (to be added by downstream consumers) for details.
