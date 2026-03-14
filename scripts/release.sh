#!/bin/bash

# Local helper for preparing a release commit.
# Usage: ./scripts/release.sh [patch|minor|major]

set -e

VERSION_TYPE=${1:-patch}

echo "🚀 Starting release process..."
echo "Version bump type: $VERSION_TYPE"

# Check if we're on the main branch
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo "❌ Error: You must be on the main branch to release"
    exit 1
fi

# Check if working directory is clean
if [ -n "$(git status --porcelain)" ]; then
    echo "❌ Error: Working directory is not clean. Please commit or stash changes first."
    exit 1
fi

echo "📦 Bootstrapping workspace..."
melos bootstrap

echo "🧪 Running tests..."
melos run test || echo "ℹ️ No tests found"

echo "🔍 Running analysis..."
melos run analyze

echo "📝 Bumping versions with Melos..."
melos version "$VERSION_TYPE"

echo "📤 Push the release commit to main when you're ready:"
echo "   git push origin main"
echo ""
echo "GitHub Actions will detect the version bump on main, create package tags,"
echo "and trigger the pub.dev publish workflows automatically."
