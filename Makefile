lint: ## Lint before doing anything else.
	@npm run lint

test: ## Run tests and upload coverage reports to codecov.
	@npm run test
	@bash -c 'bash <(curl -s https://codecov.io/bash)'

build: ## Compile the code, build files
	@npm run build

upload-assets: ## Upload assets to CDN Bucket
	@aws s3 sync ./.next s3://$(CDN_BUCKET)/_next
	@aws s3 sync ./static s3://$(CDN_BUCKET)/public

zip-file: ## Zip files
	@zip -r $(DEPLOY_PKG_NAME) . -x **/.git/**/*

upload-zip-file: ## Upload zip file to S3
	@aws s3 cp $(DEPLOY_PKG_NAME) s3://$(APP_S3_BUCKET)

create-app-version: ## Create Beanstalk Application Version Staging
	@aws elasticbeanstalk create-application-version \
	--application-name $(EB_APPLICATION_NAME) \
	--source-bundle S3Bucket=$(APP_S3_BUCKET),S3Key="$(S3_KEY)" \
	--version-label $(DEPLOY_PKG_NAME) \
	--description $(DEPLOY_PKG_NAME)

deploy: # Deploy new App Version to Beanstalk
	@aws elasticbeanstalk update-environment --environment-name $(EB_ENV_NAME) --version-label "$(DEPLOY_PKG_NAME)"

help: ## Display this help screen
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
