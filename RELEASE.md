# Release Process

This document describes how to release new versions of the supabase_schema packages to pub.dev.

## CI Layout

The repository uses three workflow layers:

- `CI` runs on pull requests and pushes to `main`. It bootstraps the workspace, runs analysis, and runs tests.
- `Release Tags` runs on pushes to `main`. It validates publishable packages with `dart pub publish --dry-run` and creates package-specific release tags when package versions change.
- `Publish supabase_schema` and `Publish supabase_schema_generator` run on package tags and publish to pub.dev using OIDC.

## One-Time Setup

### 1. Add a release tag token

Create a repository secret named `RELEASE_TAG_TOKEN`.

Use either:

- a fine-grained PAT with `Contents: Read and write` for this repository, or
- a classic PAT with `repo`

This token is used only for pushing release tags. Tags pushed with `GITHUB_TOKEN` usually do not trigger downstream tag workflows.

### 2. Configure pub.dev automation

For each package, enable automated publishing from this GitHub repository in pub.dev Admin.

Use these tag patterns:

- `supabase_schema-v{{version}}`
- `supabase_schema_generator-v{{version}}`

## Automated Release (Recommended)

1. Make sure you're on the `main` branch
2. Ensure your working directory is clean (no uncommitted changes)
3. Bump versions and changelogs:

```bash
melos version patch
```

Or use the helper script:

```bash
./scripts/release.sh patch
./scripts/release.sh minor
./scripts/release.sh major
```

4. Review the generated `pubspec.yaml` and `CHANGELOG.md` changes
5. Push the release commit to `main`

```bash
git push origin main
```

The workflows will then:

- Validate each changed publishable package with `dart pub publish --dry-run`
- Fail if a package changed without a version bump
- Create package tags such as `supabase_schema-v0.0.4`
- Create GitHub releases for the new tags
- Trigger the tag-based publish workflows for pub.dev

## Manual Release

If you prefer to release manually:

1. Update package versions and changelogs
2. Commit and push to `main`
3. Create the package-specific tag you want to publish:

```bash
git tag supabase_schema-v1.0.0
git push origin supabase_schema-v1.0.0
```

## Tag-based Publishing

Each package has its own publish workflow and pub.dev tag pattern:

```bash
git tag supabase_schema-v0.0.4
git push origin supabase_schema-v0.0.4
```

and:

```bash
git tag supabase_schema_generator-v0.0.6
git push origin supabase_schema_generator-v0.0.6
```

These tags trigger the matching publish workflows.

## Version Bumping with Melos

Melos handles version bumping across all packages automatically:

```bash
melos version patch
```

This will:
- Update versions in package `pubspec.yaml` files
- Update package changelogs
- Prepare a release commit that can be pushed to `main`

## Publishing Requirements

- You must have appropriate permissions on the repository
- The publish workflows use OIDC authentication for pub.dev
- The release workflow requires a repository secret named `RELEASE_TAG_TOKEN`
- Packages must pass `dart pub publish --dry-run` before tags are created
- Only packages without `publish_to: none` will be published
- Each package must be published manually once before pub.dev automation can be enabled
- Each package needs its own pub.dev Admin tag pattern:
  - `supabase_schema-v{{version}}`
  - `supabase_schema_generator-v{{version}}`

## Troubleshooting

### Publishing Fails
- Check that the package passes `dart pub publish --dry-run` locally
- Verify pub.dev Admin automated publishing is enabled for each package
- Verify the tag-triggered publish workflow matches the pub.dev tag pattern
- Ensure the package already exists on pub.dev before enabling automation

### Version Conflicts
- Make sure all packages have compatible version constraints
- Check that dependency versions are valid

### Workflow Permissions
- Ensure the publish workflows have `id-token: write`
- Ensure `RELEASE_TAG_TOKEN` can push tags
- Do not use `GITHUB_TOKEN` to push release tags if tag-push workflows must trigger
