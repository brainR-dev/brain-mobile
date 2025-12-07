# Contributing to BrainRush

Thank you for your interest in contributing to BrainRush! This document provides guidelines and instructions for contributing.

## Getting Started

1. **Fork the repository**
2. **Clone your fork**
   ```bash
   git clone https://github.com/your-username/brain-mobile.git
   cd brain-mobile
   ```
3. **Open in Xcode**
   ```bash
   open BrainRush/BrainRush.xcodeproj
   ```

## Development Setup

1. **Install dependencies** (if using CocoaPods)
   ```bash
   cd BrainRush
   pod install
   ```

2. **Configure environment**
   - Copy `.env.example` to `.env` (if exists)
   - Update API keys and configuration

3. **Run tests**
   ```bash
   make test
   ```

## Code Style

- Follow Swift API Design Guidelines
- Use SwiftLint for code quality
- Write self-documenting code
- Add comments for complex logic

## Commit Messages

Follow conventional commits:
- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `style:` Code style changes
- `refactor:` Code refactoring
- `test:` Adding tests
- `chore:` Maintenance tasks

Example:
```
feat: Add language selection to settings
```

## Pull Request Process

1. Create a feature branch from `develop`
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes

3. Run tests and linting
   ```bash
   make test
   make lint
   ```

4. Commit your changes
   ```bash
   git commit -m "feat: Add your feature"
   ```

5. Push to your fork
   ```bash
   git push origin feature/your-feature-name
   ```

6. Create a Pull Request

## Testing

- Write unit tests for new features
- Ensure all tests pass before submitting PR
- Add UI tests for user-facing features

## Questions?

Open an issue or contact the maintainers.
