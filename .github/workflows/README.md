# GitHub Actions Workflows

This directory contains CI/CD workflows for the BrainRush iOS app.

## Workflows

### `ci.yml` - Continuous Integration
Runs on every push and pull request to `main` and `develop` branches.

**Jobs:**
- **build-and-test**: Builds the app and runs unit tests on multiple iOS simulators
- **lint**: Runs SwiftLint for code quality checks
- **ui-tests**: Runs UI tests on iPhone 15 Pro simulator

**Triggers:**
- Push to `main` or `develop`
- Pull requests to `main` or `develop`

### `release.yml` - Release Build
Creates production builds and uploads to TestFlight/App Store.

**Jobs:**
- **build-and-archive**: Creates an archive and exports IPA
- **testflight**: Uploads to TestFlight (if on main branch or tag)

**Triggers:**
- Tags matching `v*.*.*` (e.g., `v1.0.0`)
- Manual workflow dispatch

**Required Secrets:**
- `APPSTORE_ISSUER_ID`: App Store Connect API Issuer ID
- `APPSTORE_API_KEY_ID`: App Store Connect API Key ID
- `APPSTORE_API_PRIVATE_KEY`: App Store Connect API Private Key (PEM format)

### `codeql.yml` - Security Analysis
Runs CodeQL security analysis on Swift code.

**Triggers:**
- Push to `main` or `develop`
- Pull requests
- Weekly schedule (Sundays)

### `dependency-review.yml` - Dependency Review
Reviews dependencies in pull requests for security vulnerabilities.

**Triggers:**
- Pull requests to `main` or `develop`

## Setup Instructions

### 1. Configure App Store Connect API

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Navigate to Users and Access → Keys
3. Create a new API key with App Manager role
4. Download the `.p8` key file
5. Add secrets to GitHub repository:
   - Settings → Secrets and variables → Actions
   - Add `APPSTORE_ISSUER_ID`
   - Add `APPSTORE_API_KEY_ID`
   - Add `APPSTORE_API_PRIVATE_KEY` (contents of `.p8` file)

### 2. Update ExportOptions.plist

Edit `.github/ExportOptions.plist`:
- Replace `$TEAM_ID` with your Apple Developer Team ID
- Replace `$PROVISIONING_PROFILE_NAME` with your provisioning profile name

### 3. Update Fastfile

Edit `fastlane/Appfile`:
- Update `apple_id` with your Apple ID
- Update `team_id` with your Team ID

## Usage

### Manual Release

1. Create a tag:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

2. Or use workflow dispatch:
   - Go to Actions → Release
   - Click "Run workflow"
   - Enter version number

### Local Testing

Run workflows locally using [act](https://github.com/nektos/act):
```bash
act -j build-and-test
```

## Troubleshooting

### Build Failures
- Check Xcode version compatibility
- Verify all dependencies are available
- Check simulator availability

### Test Failures
- Review test logs in Actions tab
- Run tests locally to reproduce
- Check for flaky tests

### Code Signing Issues
- Verify certificates and provisioning profiles
- Check Team ID configuration
- Ensure App Store Connect API keys are valid
