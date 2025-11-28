# Release Process

This document describes how to release new versions of the supabase_schema packages to pub.dev.

## Automated Release (Recommended)

### Using GitHub Actions

1. Go to the **Actions** tab in your GitHub repository
2. Select the **Release** workflow from the sidebar
3. Click **Run workflow**
4. Choose the version bump type:
   - `patch` (default): 0.0.2 → 0.0.3
   - `minor`: 0.0.2 → 0.1.0  
   - `major`: 0.0.2 → 1.0.0
5. Toggle **Create GitHub release** if you want a GitHub release created
6. Click **Run workflow**

The workflow will:
- Run tests and analysis
- Bump versions in all packages
- Create and push a git tag
- Optionally create a GitHub release
- Publish packages to pub.dev

### Using Local Script

1. Make sure you're on the `main` branch
2. Ensure your working directory is clean (no uncommitted changes)
3. Run the release script:

```bash
# Patch release (default)
./scripts/release.sh

# Or specify version type
./scripts/release.sh patch
./scripts/release.sh minor
./scripts/release.sh major
```

The script will:
- Check prerequisites (main branch, clean working directory)
- Run tests and analysis
- Bump versions using Melos
- Create and push a git tag
- Trigger the GitHub Actions workflow to publish to pub.dev

## Manual Release

If you prefer to release manually:

1. Update versions in each package's `pubspec.yaml`
2. Update CHANGELOG files
3. Commit changes
4. Create a git tag: `git tag v1.0.0`
5. Push tag: `git push origin v1.0.0`
6. Run the publish workflow or use the existing publish workflow

## Tag-based Publishing

The existing `publish.yaml` workflow also triggers on git tags:

```bash
git tag v1.0.0
git push origin v1.0.0
```

This will automatically publish all packages to pub.dev.

## Version Bumping with Melos

Melos handles version bumping across all packages automatically:

```bash
# Bump patch version
melos version patch

# Bump minor version  
melos version minor

# Bump major version
melos version major
```

This will:
- Update versions in all package pubspec.yaml files
- Update CHANGELOG files
- Create a commit with the version changes
- Create a git tag

## Publishing Requirements

- You must have appropriate permissions on the repository
- The workflow uses OIDC authentication for pub.dev (no tokens needed)
- Packages must pass analysis and tests before publishing
- Only packages without `publish_to: none` will be published

## Troubleshooting

### Publishing Fails
- Check that all packages pass `melos analyze`
- Ensure package names are available on pub.dev
- Verify pub.dev credentials are properly configured

### Version Conflicts
- Make sure all packages have compatible version constraints
- Check that dependency versions are valid

### Workflow Permissions
- Ensure the repository has OIDC enabled for pub.dev publishing
- Check that the workflow has the necessary permissions (id-token, contents)