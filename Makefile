#### vendor_config-example
####
#### Written by Stephan Wendel aka KwadFan <me@stephanwe.de>
#### Copyright 2023
#### https://github.com/KwadFan/vendor_config-example
####
#### This File is distributed under GPLv3
####

#### Self-Documenting Makefile
#### This is based on https://gellardo.github.io/blog/posts/2021-06-10-self-documenting-makefile/

.DEFAULT_GOAL := help
.PHONY: help

help: ## Shows this help
	@printf "crowsnest - A webcam Service for multiple Cams and Stream Services.\n"
	@printf "Usage:\n\n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
