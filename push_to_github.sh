#!/bin/bash
# Push to GitHub helper script

# Initialize git repository if it doesn't exist
if [ ! -d .git ]; then
  git init
  echo "Initialized empty Git repository"
fi

# Add all files and commit
git add .
git commit -m "Initial commit"

# Rename current branch to main (if not already)
git branch -M main

# Add remote (replace placeholders with your GitHub username and repo)
git remote add origin git@github.com:Brandon4america-Global/FOIANET.git 2>/dev/null \
  || git remote set-url origin git@github.com:Brandon4america-Global/FOIANET.git

# (Optional) Create GitHub repository via GitHub CLI (uncomment if needed)
# gh repo create Brandon4america-Global/FOIANET --public --source=. --push

# Push to GitHub
git push -u origin main

echo "Pushed to GitHub repository https://github.com/Brandon4america-Global/FOIANET.git"
