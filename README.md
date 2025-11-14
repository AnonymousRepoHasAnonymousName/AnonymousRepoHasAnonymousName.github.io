# Documentation Website

Page: https://anonymousrepohasanonymousname.github.io/

Local live:
```shell
# Terminal 1: Start live preview
cd documentation
source venv/bin/activate
make livehtml
```
----

This repository contains the documentation website for the project, built with Sphinx and deployed to GitHub Pages.

## Quick Start

### Option 1: Manual Build (Local)

To rebuild the documentation after making changes:

```bash
./build_docs.sh
```

Then commit and push:
```bash
git add .
git commit -m "Update documentation"
git push origin main
```

### Option 2: Automatic Deployment (Recommended)

The repository includes a GitHub Actions workflow that automatically builds and deploys the documentation whenever you push changes to the `documentation/` folder.

**Setup (one-time):**
1. Go to your repository settings on GitHub
2. Navigate to "Pages" in the left sidebar
3. Under "Source", select "GitHub Actions" (not "Deploy from a branch")
4. The workflow will automatically deploy when you push changes

**Usage:**
- Simply push your changes to the `documentation/` folder
- The workflow will automatically build and deploy to GitHub Pages
- You can also manually trigger it from the "Actions" tab

## Project Structure

- `documentation/` - Source files for the documentation (Markdown, RST, etc.)
- `documentation/_build/` - Build output (ignored by git)
- Root directory - Contains the built HTML files for GitHub Pages

## Building Documentation Locally

If you want to build and preview locally:

```bash
cd documentation
source venv/bin/activate  # or: python3 -m venv venv && source venv/bin/activate
pip install -r requirements.txt
make current-docs
# Open documentation/_build/current/index.html in your browser
```

## Requirements

- Python 3.8+
- Sphinx and related packages (see `documentation/requirements.txt`)
