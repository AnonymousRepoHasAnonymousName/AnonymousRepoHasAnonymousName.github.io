#!/bin/bash
# Script to rebuild and update documentation for GitHub Pages

set -e  # Exit on error

echo "🔨 Building documentation..."

# Navigate to documentation directory
cd "$(dirname "$0")/documentation"

# Activate virtual environment if it exists, otherwise create it
if [ ! -d "venv" ]; then
    echo "📦 Creating virtual environment..."
    python3 -m venv venv
fi

echo "📦 Activating virtual environment..."
source venv/bin/activate

# Install/update dependencies
echo "📥 Installing dependencies..."
pip install -q -r requirements.txt

# Clean and build documentation
echo "🔨 Building documentation..."
rm -rf _build
make current-docs

# Go back to root
cd ..

# Copy built files to root
echo "📋 Copying built files to root directory..."
rm -rf _images _sources _sphinx_design_static _static source *.html *.js objects.inv 2>/dev/null || true
cp -r documentation/_build/current/* .

# Ensure .nojekyll exists
touch .nojekyll

echo "✅ Documentation build complete!"
echo ""
echo "📝 Next steps:"
echo "   1. Review the changes: git status"
echo "   2. Commit: git add . && git commit -m 'Update documentation'"
echo "   3. Push: git push origin main"
echo ""

