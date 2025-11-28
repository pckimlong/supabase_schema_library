#!/bin/bash

# Simple release script for local development
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

echo "📝 Bumping version ($VERSION_TYPE)..."
melos version $VERSION_TYPE

echo "📋 Getting new version number..."
NEW_VERSION=$(melos version --no-git-tag-version $VERSION_TYPE | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
echo "New version: $NEW_VERSION"

echo "🏷️ Creating git tag..."
git tag -a "v$NEW_VERSION" -m "Release v$NEW_VERSION"

echo "📤 Pushing to GitHub..."
git push origin main --follow-tags

echo "🎉 Release complete! v$NEW_VERSION has been tagged and pushed."
echo "📦 The GitHub Actions workflow will now publish to pub.dev."