# FOIA Portal Submitter

[![Open in Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/Brandon4america-Global/FOIANET/blob/main/FOIA_Portal_Submitter.ipynb)

This project provides a front-end interface to submit FOIA requests via a Google Colab notebook.

## Strategic Expansion Roadmap

The repository now includes a high-level blueprint for evolving the reconciled FOIA dataset into an automated, auditable intelligence stack. Review the following resources:

* [`docs/foia_intelligence_strategy.md`](docs/foia_intelligence_strategy.md) — narrative plan covering phases, architecture, automation, and compliance controls.
* [`docs/foia_intelligence_workflow.json`](docs/foia_intelligence_workflow.json) — machine-readable nodes/edges graph for visualization and orchestration tooling.

## Push to GitHub
- Ensure you have [Git](https://git-scm.com/) installed.
- Replace the `your-username` and `your-repo` placeholders in the `push_to_github.sh` script with your GitHub username and repository name.
- Make the script executable and run it:
  ```
  chmod +x push_to_github.sh
  ./push_to_github.sh
  ```
  This will initialize the repository (if needed), commit all files, and push to the `main` branch on GitHub.

## GitHub Pages
- To publish this app via GitHub Pages, go to **Settings → Pages** in your repository.
- Under **Build and deployment**, select "Deploy from a branch".
- Choose the `main` branch (root) as the source and click **Save**.
- Your site will be available at `https://your-username.github.io/your-repo/`.

## Launch in Colab
- Click the **Open in Colab** badge at the top of this README to open the notebook in Google Colaboratory.
