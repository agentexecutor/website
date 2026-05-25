.PHONY: build serve deploy

build:
	hugo

serve:
	hugo server

deploy: build
	firebase deploy
