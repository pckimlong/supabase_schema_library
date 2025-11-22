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
    This command links local packages and installs dependencies.

## Common Commands

-   **Analyze all packages:**
    ```bash
    melos run analyze
    ```

-   **Run tests in all packages:**
    ```bash
    melos run test
    ```

-   **Format all code:**
    ```bash
    melos run format
    ```

## Publishing

Publishing is automated via GitHub Actions.

1.  **Manual Trigger:**
    -   Go to the "Actions" tab in GitHub.
    -   Select "Publish to Pub.dev".
    -   Click "Run workflow".

2.  **Tag Trigger:**
    -   Push a tag starting with `v` (e.g., `v1.0.0`) to trigger the publish workflow.
