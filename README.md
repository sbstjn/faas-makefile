# Makefile for AWS::Serverless CloudFormation

[![MIT License](https://badgen.now.sh/badge/License/MIT/blue)](https://github.com/sbstjn/faas-makefile/blob/master/LICENSE.md)
[![FaaS.club](https://badgen.now.sh/badge/FaaS/CLUB/00C387)](https://faas.club)
[![FaaS Makefile](https://badgen.now.sh/badge/FaaS/Makefile/purple)](https://github.com/sbstjn/faas-makefile)

> Reusable Makefile to bootstrap AWS::Serverless CloudFormation projects

# Examples

- [AWS Serverless Application Model w/ Go](https://github.com/sbstjn/faas-sam-lambda-go)
- [AWS Serverless Application Model w/ Python](https://github.com/sbstjn/faas-sam-lambda-python)
- [AWS Serverless Application Model w/ TypeScript](https://github.com/sbstjn/faas-sam-lambda-typescript)

# Usage

```bash
# Download latest Makefile
$ > curl https://raw.githubusercontent.com/sbstjn/faas-makefile/master/Makefile -o .faas

# Create custom Makefile
$ > touch Makefile

# Configure Project Name
$ > echo "PROJECT_NAME = example" >> Makefile

# Include FAAS Makefile
$ > echo "\ninclude .faas" >> Makefile

# Add Example target
$ > echo "\nfoo:\n\t@ echo \"Done.\"" >> Makefile

# Run Example target
$ > make foo

Done.

# Run FAAS targets
$ > make configure package deploy

[…]
```

# Configuration

The `Makefile` assumes a basic magic configuration. Everything can easily be changed, or overwritten.

```bash
PROJECT_NAME ?= undefined
PROJECT_SCOPE ?= faas
ENV ?= stable
PROJECT_ID ?= $(PROJECT_SCOPE)-$(PROJECT_NAME)-$(ENV)

AWS_BUCKET_NAME ?= $(PROJECT_SCOPE)-artifacts
AWS_STACK_NAME ?= $(PROJECT_ID)
AWS_REGION ?= eu-west-1
AWS_PROFILE ?= default 

FILE_TEMPLATE ?= infrastructure.yml
FILE_PACKAGE ?= ./dist/stack.yml
FILE_PARAMETERS ?= .parameters
```

## CloudFormation Parameters

Per default, the content of a `.parameters` file is passed to the CloudFormation Stack as [Parameters](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/parameters-section-structure.html). The content of the file must be a valid environment variable configuration:

```bash
Foo=Bar
Baz=Qux
```

## CloudFormation Outputs

With `make variables` you can convert a Stack's [Output](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/outputs-section-structure.html) into bash variables. This can be helpful when using multiple CloudFormation Stacks.

```bash
$ > make variables

OutputName=value
```

# Targets

Run `make configure package deploy outputs` and you're done.

Tooling should make things easier and not be a barrier. 😍

```bash
$ > make help

help         Show help
clean        Remove ./dist folder
configure    Create S3 Bucket for artifacts
package      Pack CloudFormation template
deploy       Deploy CloudFormation Stack
destroy      Delete CloudFormation Stack
describe     Show description of CloudFormation Stack
parameters   Show Parameters for CloudFormation Stack
outputs      List Outputs of CloudFormation Stack
variables    List Outputs of CloudFormation Stack as bash variables
```

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

## License

Feel free to use the code, it's released using the [MIT license](LICENSE.md).

## Contribution

You are welcome to contribute to this project! 😘 

To make sure you have a pleasant experience, please read the [code of conduct](CODE_OF_CONDUCT.md). It outlines core values and beliefs and will make working together a happier experience.
