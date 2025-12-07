# Makefile for BrainRush iOS App

.PHONY: help install test build clean lint format archive

help:
	@echo "Available commands:"
	@echo "  make install    - Install dependencies"
	@echo "  make test       - Run tests"
	@echo "  make build      - Build the app"
	@echo "  make clean      - Clean build artifacts"
	@echo "  make lint       - Run SwiftLint"
	@echo "  make format     - Format code with SwiftFormat"
	@echo "  make archive    - Create archive for distribution"

install:
	@echo "Installing dependencies..."
	@if [ -f "Podfile" ]; then pod install; fi
	@echo "Dependencies installed"

test:
	@echo "Running tests..."
	xcodebuild test \
		-project BrainRush/BrainRush.xcodeproj \
		-scheme BrainRush \
		-destination 'platform=iOS Simulator,name=iPhone 15 Pro,OS=latest' \
		-only-testing:BrainRushTests

build:
	@echo "Building app..."
	xcodebuild build \
		-project BrainRush/BrainRush.xcodeproj \
		-scheme BrainRush \
		-configuration Debug \
		-destination 'platform=iOS Simulator,name=iPhone 15 Pro,OS=latest'

clean:
	@echo "Cleaning build artifacts..."
	rm -rf ~/Library/Developer/Xcode/DerivedData/*
	rm -rf build/
	xcodebuild clean \
		-project BrainRush/BrainRush.xcodeproj \
		-scheme BrainRush

lint:
	@echo "Running SwiftLint..."
	@if command -v swiftlint > /dev/null; then \
		swiftlint lint; \
	else \
		echo "SwiftLint not installed. Install with: brew install swiftlint"; \
	fi

format:
	@echo "Formatting code..."
	@if command -v swiftformat > /dev/null; then \
		swiftformat BrainRush/; \
	else \
		echo "SwiftFormat not installed. Install with: brew install swiftformat"; \
	fi

archive:
	@echo "Creating archive..."
	xcodebuild archive \
		-project BrainRush/BrainRush.xcodeproj \
		-scheme BrainRush \
		-archivePath ./build/BrainRush.xcarchive \
		-configuration Release
