# Copyright 2024 HAMi Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in IS" BASIS,
# WITHOUT or implied.
# See the License# Personal settings
REGISTRY    ?= ghcr.io/mynIMAGE_NAME  ?= hami
VERSIO --tags --always --dirty 2nIMAGE_TAG   REGISTRY)/$(IMAGE_NAME):$(BINARY_NAME ?= hami
CMD_DIR     ?= ./cmd
OUTPUT_DIR  ?= ./bin
GO          ?= go
GOFLAGS     := -trimpath
LD_FLAGS    ?= 

# Tools
GOLINT      := golangci-lint

.PHONY: all
all: build

## build: Build all binaries
.PHONY: build
build:
	@echo ">> Building $(BINARY_NAME) version=$(VERSION)"
	@mkdir -p $(OUTPUT_DIR)
	$(GO) build $(GOFLAGS) $(LD_FLAGS) -o $(OUTPUT_DIR)/$(BINARY_NAME) $(CMD_DIR)/...

## test: Run unit tests
.PHONY: test
test:
	@echo ">> Running unit tests"
	$(GO) test ./... -v -race -coverprofile=coverage.out

## test-coverage: Generate test coverage report
.PHONY: test-coverage
test-coverage: test
	$(GO) tool cover -html=coverage.out -o coverage.html
	@echo ">> Coverage report generated at coverage.html"

## lint: Run linter
.PHONY: lint
lint:
	@echo ">> Running linter"
	$(GOLINT) run ./...

## fmt: Format Go source code
.PHONY: fmt
fmt:
	@echo ">> Formatting source code"
	$(GO) fmt ./...

## vet: Run go vet
.PHONY: vet
vet:
	@echo ">> Running go vet"
	$(GO) vet ./...

## docker-build: Build the Docker image
.PHONY: docker-build
docker-build:
	@echo ">> Building Docker image $(IMAGE_TAG)"
	docker build -t $(IMAGE_TAG) .

## docker-push: Push the Docker image
.PHONY: docker-push
docker-push:
	@echo ">> Pushing Docker image $(IMAGE_TAG)"
	docker push $(IMAGE_TAG)

## clean: Remove build artifacts
.PHONY: clean
clean:
	@echo ">> Cleaning build artifacts"
	@rm -rf $(OUTPUT_DIR)
	@rm -f coverage.out coverage.html

## generate: Run code generation
.PHONY: generate
generate:
	@echo ">> Running code generation"
	$(GO) generate ./...

## mod-tidy: Tidy go modules
.PHONY: mod-tidy
mod-tidy:
	@echo ">> Tidying go modules"
	$(GO) mod tidy

## help: Display available make targets
.PHONY: help
help:
	@echo "Usage: make <target>"
	@echo ""
	@grep -E '^## ' $(MAKEFILE_LIST) | sed 's/## /  /' | column -t -s ':'
