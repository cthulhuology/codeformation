
.PHONY: delete deploy lint

STACKNAME ?= TestCode
BUCKET ?= goehd

all: deploy

lint: cloudformation.yaml
	cfn-lint -t cloudformation.yaml

delete:
	aws cloudformation delete-stack --stack-name $(STACKNAME)

cloudformation.pkg: cloudformation.yaml lint
	aws cloudformation package --template-file cloudformation.yaml  --s3-bucket $(BUCKET) > cloudformation.pkg

deploy: cloudformation.pkg
	aws cloudformation deploy --template-file cloudformation.pkg --capabilities CAPABILITY_IAM --stack-name $(STACKNAME)

