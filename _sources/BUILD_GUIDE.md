# Documentation Build Guide

This guide explains how to update the documentation website.

## Two Ways to Update Documentation

### Method 1: Automatic (Recommended) 🚀

**One-time setup:**
1. Make sure GitHub Actions is enabled in your repository settings
2. The workflow will automatically run when you push changes to the `documentation/` folder

**To update documentation:**
1. Edit files in the `documentation/` folder (`.md`, `.rst`, etc.)
2. Commit and push your changes:
   ```bash
   git add documentation/
   git commit -m "Update documentation: [describe your changes]"
   git push origin main
   ```
3. The GitHub Actions workflow will automatically:
   - Build the documentation
   - Deploy it to the root directory
   - Commit and push the built files
4. Your website will be updated within a few minutes!

**Note:** The workflow only runs when files in `documentation/` change, so it won't create infinite loops.

### Method 2: Manual Build 🔧

If you prefer to build locally or the automatic workflow isn't working:

1. Run the build script:
   ```bash
   ./build_docs.sh
   ```

2. Review and commit the changes:
   ```bash
   git add .
   git commit -m "Update documentation"
   git push origin main
   ```

## What Gets Built?

- Source files: `documentation/` folder (Markdown, RST, images, etc.)
- Built files: Root directory (HTML, CSS, JS - these are what GitHub Pages serves)

## Troubleshooting

### Build script fails
- Make sure Python 3.8+ is installed
- Check that you're in the repository root directory
- Try: `cd documentation && python3 -m venv venv && source venv/bin/activate && pip install -r requirements.txt`

### GitHub Actions not running
- Check the "Actions" tab in your GitHub repository
- Make sure GitHub Actions is enabled in repository settings
- Verify the workflow file exists at `.github/workflows/deploy-docs.yml`

### Website not updating
- Wait a few minutes for GitHub Pages to rebuild
- Check the GitHub Actions logs for errors
- Verify GitHub Pages is enabled and set to serve from the root directory

