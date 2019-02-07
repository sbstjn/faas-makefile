# Makefile for AWS::Serverless CloudFormation

> Reusable Makefile to bootstrap AWS::Serverless CloudFormation projects

# Configuration

The `Makefile` assumes a basic magic configuration. This can easily be changed, or overwritten.

```makefile
PROJECT_SCOPE ?= faas
PROJECT_NAME ?= makefile
ENV ?= stable
PROJECT_ID ?= $(PROJECT_SCOPE)-$(PROJECT_NAME)-$(ENV)

AWS_BUCKET_NAME ?= $(PROJECT_SCOPE)-artifacts
AWS_STACK_NAME ?= $(PROJECT_ID)
AWS_REGION ?= eu-west-1

FILE_TEMPLATE = infrastructure.yml
FILE_PACKAGE = ./dist/stack.yml
```

# Commands

Run `make configure package deplout outputs` and you're down. Tooling should be easy and not a barrier. 😍

## Configure

```bash
# Create S3 Bucket to store artifacts

$ > make configure
```

## Package

```bash
# Create deployable CloudFormation file in ./dist/stack.yml

$ > make package
```

## Deploy

```bash
# Deploy CloudFormation stack from ./dist/stack.yml

$ > make deploy
```

## Destroy

```bash
# Delete CloudFormation stack

$ > make destroy
```

## Outputs

```bash
# Show CloudFormation Outputs

$ > make outputs
```
