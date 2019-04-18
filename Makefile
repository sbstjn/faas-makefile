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
 
help: ## Show help
	@ echo "\n$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s :)"

clean: ## Remove ./dist folder
	@ rm -rf ./dist

configure: ## Create S3 Bucket for artifacts
	@ aws s3api create-bucket \
		--profile $(AWS_PROFILE) \
		--bucket $(AWS_BUCKET_NAME) \
		--region $(AWS_REGION) \
		--create-bucket-configuration LocationConstraint=$(AWS_REGION) \
		|| echo "S3 Bucket $(AWS_BUCKET_NAME) was not created."

package: ## Pack CloudFormation template
	@ mkdir -p dist
	@ aws cloudformation package \
		--profile $(AWS_PROFILE) \
		--template-file $(FILE_TEMPLATE) \
		--s3-bucket $(AWS_BUCKET_NAME) \
		--region $(AWS_REGION) \
		--output-template-file $(FILE_PACKAGE)

deploy: ## Deploy CloudFormation Stack
	@ aws cloudformation deploy \
		--profile $(AWS_PROFILE) \
		--template-file $(FILE_PACKAGE) \
		--region $(AWS_REGION) \
		--capabilities CAPABILITY_NAMED_IAM CAPABILITY_IAM CAPABILITY_AUTO_EXPAND \
		--stack-name $(AWS_STACK_NAME) \
		--no-fail-on-empty-changeset \
		--parameter-overrides \
			$(shell if [ -f $(FILE_PARAMETERS) ]; then cat $(FILE_PARAMETERS); fi) \
			ParamProjectID=$(PROJECT_ID) \
			ParamProjectScope=$(PROJECT_SCOPE) \
			ParamProjectName=$(PROJECT_NAME) \
			ParamENV=$(ENV)

destroy: ## Delete CloudFormation Stack
	@ aws cloudformation delete-stack \
		--profile $(AWS_PROFILE) \
		--region $(AWS_REGION) \
		--stack-name $(AWS_STACK_NAME)

describe: ## Show description of CloudFormation Stack
	@ aws cloudformation describe-stacks \
		--profile $(AWS_PROFILE) \
		--region $(AWS_REGION) \
		--stack-name $(AWS_STACK_NAME) \
		$(if $(value QUERY), --query '$(QUERY)',) \
		$(if $(value FORMAT), --output '$(FORMAT)',)

outputs: ## List Outputs of CloudFormation Stack
	@ QUERY=Stacks[0].Outputs $(MAKE) describe

variables: ## List Outputs of CloudFormation Stack as bash variables
	@ FORMAT=text $(MAKE) outputs | awk 'BEGIN {FS="\t"}; {print $$2 "=" $$3}'

.PHONY: clean configure package deploy destroy describe outputs variables
