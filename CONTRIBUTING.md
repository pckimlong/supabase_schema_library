# Contributing to Supabase Schema Library

This repository uses [Melos](https://melos.invertase.dev/) to manage the monorepo.

## Getting Started

1.  **Install Melos Globally:**
    ```bash
    dart pub global activate melos
    ```

2.  **Bootstrap the Workspace:**
    ```bash
    melos bootstrap
    ```

## Development Workflow

### 1. Make Changes
Make your code changes in the respective packages.

### 2. Commit with Conventional Commits
We use **Conventional Commits** to automate versioning. Your commit messages determine the next version number.

**Format:** `<type>(<scope>): <description>`

-   **`fix: ...`** -> **Patch** release (0.0.x). Use for bug fixes.
-   **`feat: ...`** -> **Minor** release (0.x.0). Use for new features.
-   **`feat!: ...`** or **`BREAKING CHANGE:`** -> **Major** release (x.0.0). Use for breaking changes.
-   **`chore: ...`**, **`docs: ...`**, **`test: ...`** -> No release (usually).

**Examples:**
-   `feat(schema): add support for jsonb types`
-   `fix(generator): fix crash on null fields`
-   `docs: update readme`

### 3. Verify
Run checks before pushing:
```bash
melos run analyze
melos run test
```

## Releasing & Publishing

1.  **Generate New Version:**
    Run this command to calculate the next version, update changelogs, and create a git tag.
    ```bash
    melos version
    ```
    *Note: This will modify `pubspec.yaml` and `CHANGELOG.md` files.*

2.  **Push Changes:**
    Push the changes and the tags to GitHub.
    ```bash
    git push --follow-tags
    ```

3.  **Automated Publishing:**
    The push will trigger the GitHub Action to publish the new versions to pub.dev automatically.
