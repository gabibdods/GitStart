# GitStart

# PowerShell Script to Automate GitHub Repository Creation and Hardening

### Description

- RepoForge is a PowerShell-based automation tool that streamlines the process of creating new GitHub repositories using a template, initializing Git configuration, and enforcing essential security settings.
- Built using Windows PowerShell ISE, this script integrates Git commands and GitHub’s REST API to establish a secured, ready-to-develop repository that aligns with best practices..

---

## NOTICE

- Please read through this `README.md` to better understand the project's source code and setup instructions.
- Also, make sure to review the contents of the `License/` directory.
- Your attention to these details is appreciated — enjoy exploring the project!

---

## Problem Statement

- Setting up new repositories manually through GitHub and configuring security features is repetitive and error-prone.
- Developers often forget to disable unwanted features or enforce commit-signing policies, leaving new repositories exposed or misconfigured.

---

## Project Goals

### Automate Repository Creation

- Use PowerShell to clone a predefined repository template, clean it up, and push to a newly created GitHub repository with Git tracking and origin binding.

### Enforce Security Best Practices

- Apply repository hardening through GitHub's REST API, including disabling wikis, issues, and discussions, and enforcing signed commits and branch protections.

---

## Tools, Materials & Resources

### PowerShell ISE

- Used for authoring and debugging the PowerShell script in a Windows environment.

### GitHub API

- Enables programmatic creation of repositories, modification of settings, and application of branch protection rules.

### Git for Windows

- Required to run local Git commands (`git init`, `git add`, `git push`, etc.).

---

## Design Decision

### Use of GitHub Personal Access Token

- Authentication is handled securely via the `GITHUB_PAT` environment variable, ensuring no token is stored in plain text.

### Modular Repository Setup

- Starts from a template repository to promote uniformity, then deletes residual files like .git and example files to create a clean slate.

### Full Automation from Template to Security

- Combines Git and GitHub API operations into a single script that covers repository creation, population, and configuration.

---

## Features

### Repository Initialization

- Clones a GitHub template, removes unnecessary files, and reinitializes Git with fresh commit history.

### API-Based Security Hardening

- Disables unneeded GitHub features, enables branch protection, and enforces signed commits using GitHub's REST API.

### Developer Prompts & Feedback

- Uses colored PowerShell prompts and messages to guide the developer through manual configuration steps for maximum clarity.

---

## Block Diagram

```plaintext
                               ┌────────────────────────────┐
                               │           ghs.ps1          │
                               └─────────────┬──────────────┘
                                             ↓
                       ┌─────────────────────────────────────────────┐
                       │ Prompt for repository name and GITHUB_PAT   │
                       └─────────────┬───────────────────────────────┘
                                     ↓
                   ┌───────────────────────────────────────┐
                   │ Clone and clean template repository   │
                   └─────────────┬─────────────────────────┘
                                 ↓
               ┌────────────────────────────────────────────────┐
               │ Initialize Git, commit, and push to GitHub     │
               └─────────────┬──────────────────────────────────┘
                             ↓
           ┌──────────────────────────────────────────────────────┐
           │ Use GitHub API to apply configuration and protection │
           └──────────────────────────────────────────────────────┘


```

---

## Functional Overview

- Prompts for the new repository name and uses a predefined GitHub template to scaffold the directory.
- Pushes the new repository to GitHub under the user's account and configures the remote.
- Disables unnecessary features like wikis, issues, and discussions.
- Enforces secure development policies such as signed commits and branch locking.

---

## Challenges & Solutions

### API Header Authorization

- Ensured compatibility with GitHub's REST API v3 using appropriate bearer tokens and content-type headers.

### Directory Path Handling

- Used environment variables to maintain compatibility across different user machines on Windows.

---

## Lessons Learned

### Leveraging GitHub’s API

- The GitHub REST API provides fine-grained control over repository features and settings, removing the need for post-creation manual steps.

### PowerShell Is Highly Capable

- PowerShell is an excellent scripting language for integrating system commands, HTTP requests, and user prompts in a unified workflow.

---

## Future Enhancements

- Add error handling for failed API requests and Git commands.
- Integrate GUI prompts using Windows Forms or WPF for improved UX.
- Add support for organization-level repositories and automatic README/license injection.
- Log the setup process to a local file for audit purposes.
