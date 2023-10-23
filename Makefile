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


btt-skrpico-v1.0: ## Compiles Firmware for BTT SKR pico V1.0
	@printf "This will take a while ... Please be patient!"

linux-host-mcu: ## Compiles and installs new linux-host-mcu
	@printf "This will take a while ... Please be patient!"

update: ## Tries to pull latest updates from repository
	@git fetch && git pull

help: ## Shows this help
	@printf "vendor_config helper\n"
	@printf "Usage:\n\n"
	@grep -E '^[0-9a-zA-Z._-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
