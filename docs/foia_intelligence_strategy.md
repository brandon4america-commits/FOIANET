# FOIA Intelligence Framework Blueprint

## Strategic Vision

Build an automated, auditable intelligence layer on top of the reconciled FOIA dataset that continuously surfaces request activity, agency performance, and compliance posture. The framework is organized across five reinforcing pillars: data ingestion, automation, compliance, intelligence, and experience.

## Phase Roadmap

1. **PDF + Text Fusion (Phase 2)**  
   * Extract machine-readable text from historical PDF releases and attach to each request record.  
   * Tag source PDFs with checksum + storage URI to maintain provenance.  
   * Output: `request_pdf_text.jsonl`, redaction maps for compliance review.

2. **Nexus Intelligence Graph (Phase 3)**  
   * Feed reconciled records into an entity-resolution module (requesters, agencies, topics).  
   * Publish nightly `foia_graph.json` for use in D3/Observable force-directed visualizations.  
   * Highlight per-agency metrics: `median_response_days`, `appeal_rate`, `exemption_usage_rate`.

3. **Workflow Automation Fabric (Phase 4)**  
   * Installable Google Apps Script trigger calls Colab notebook entry point.  
   * Colab orchestrates ingestion, quality checks, metric recomputation, and packaging of PDF dashboards.  
   * Gmail API distributes delta summaries; Slack webhook posts compliance alerts.

4. **Transparency Dashboard Launch (Phase 5)**  
   * React or Streamlit front end renders response-time tracker, appeal success map, exemption heatmap, and AI summary widget.  
   * All data served from static JSON endpoints (no raw PII).  
   * Embed “Data last refreshed” timestamps sourced from automation metadata.

5. **Predictive Analytics Expansion (Phase 6)**  
   * Train scikit-learn models for response-time regression and appeal-likelihood classification.  
   * Publish explainability artifacts (SHAP) alongside forecasts to support governance.  
   * Integrate outputs into dashboard modules and stakeholder briefings.

## Layered Architecture

The workflow graph (`docs/foia_intelligence_workflow.json`) captures the interactions between data, automation, compliance, intelligence, and experience layers. Key components include:

* **FOIA Sources Registry → Canonical Ingestion:** nightly trigger-driven pipeline that normalizes API, CSV, and PDF inputs.  
* **Entity Resolution & QA:** combines deterministic dedupe with LLM-assisted alias reconciliation, storing confidence scores and sampled QA sets.  
* **Compliance Monitor & Audit Data Vault:** enforces trigger scope reviews, PII redaction checks, and seven-year retention of manifests, exemption tags, and redaction maps.  
* **FOIA Nexus Graph & Predictive Models:** derive insights for visualizations and forecast modules.  
* **Transparency Dashboard & Notification Hub:** regenerate static assets, email PDFs, and deliver Slack updates, ensuring stakeholders receive consistent intelligence outputs.

## Automation & Governance Highlights

* **Apps Script + Colab Orchestration:** V8 runtime batches sheet updates, hides admin tabs before PDF export, and restores visibility post-export.  
* **Secrets Management:** Leverage Colab Secrets API for OpenAI/LangChain keys; enforce quarterly rotation.  
* **Auditability:** Each pipeline run logs a manifest, trigger scope verification, and checksum of generated artifacts to the Audit Data Vault.  
* **Compliance AI:** LLM-based exemption tagger flags sensitive content with structured labels (`FOIA-EXEMPTION: <code>`), enabling chord and Sankey analysis of exemption pathways.  
* **Stakeholder Cadence:** Daily deltas via email/Slack; monthly compliance digest; quarterly model governance review.

## Next Actions

1. Stand up Colab notebook skeleton with modular pipeline functions (ingest, enrich, output, notify).  
2. Prototype entity resolution confidence scoring and QA sampling.  
3. Define schema for compliance manifests and audit logs.  
4. Backfill historical PDFs to populate redaction map and exemption training dataset.  
5. Develop MVP dashboard wiring static JSONs to initial React components.
